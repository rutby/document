--[[
	付费管理器
]]

local PayManager = BaseClass("PayManager")
local Timer = CS.GameEntry.Timer
local GlobalData = CS.GameEntry.GlobalData
local CommonUtils = CS.CommonUtils
local Localization = CS.GameEntry.Localization
local Setting = CS.GameEntry.Setting
local Sdk = CS.GameEntry.Sdk
local AnalyticsEvent = CS.UnityGameFramework.SDK.AnalyticsEvent
local SDKManager = CS.SDKManager
local rapidjson = require "rapidjson"

local PaymentPriceCNY =
{
	["4.99"] = "30",
	["9.99"] = "68",
	["19.99"] = "128",
	["49.99"] = "328",
	["99.99"] = "648",
	["24.99"] = "163",
	["999.99"] = "6498",
	["0.99"] = "6",
}


function PayPrint(fmt, ...)
	local arg= {...}
	if #arg == 0 then
		print("[pay]" .. tostring(fmt))
		return
	end

	print("[pay]" .. string.format(fmt, ...))
	return
end

--** 漏单信息的分割符 
local COK_PURCHASE_DELIMITER_DATA = "|#|"    --不同字段中间的分隔符
local COK_PURCHASE_DELIMITER_ORDERS = "|*|"  --不同订单中间的分隔符
local regex = "[0-9.,]"

local tab = {}
function PayManager:LogToServer( msg )
	xpcall(function ()
		if (tab[msg] ~= nil) then
			return
		end
		CS.PostEventLog.Record(msg)
		tab[msg] = 1
	end, function()

	end)
end

function PayManager:__init()
	self.payState = 0
	self.packageInfo = nil
	self.fromView = nil
	self.chooseItem = nil
	self.productId = ""
	self.historyPurchaseChecked = false  --历史订单每次开游戏只检查一次
	self.historyPurchaseList = {}
	self.donateUID = nil
	self.itemId = nil --selfOrderId
	self.purchaseSelfOrderId = {}
	self.param = {}
	self.firstPayStatus = -1--0未充值，1可领取，2已领取
	self.firstPayRewards = {}
	self.needAutoPopup = true

	-- 货币和付费相关
	self.goldPriceList = {}
	self.localCurrencyCode = ""
	self.BillingClientVersion = 0
	self.m_SkuDetails = {}
	self.isSymbolAtRight = false
	self.exchangeRate = 0
	self.localCurrencySymbol = ""
	self.steamCurrency = ""
	self.steamSymbol = ""
	Sdk:SetPayMangerCallback(
		function (key, data)
			self:__SdkCallback(key, data)
		end)
	if CS.SDKManager.IS_UNITY_EDITOR() ==false and CS.SDKManager.IS_UNITY_PC~=nil and CS.SDKManager.IS_UNITY_PC()==true then
		print("SteamPayInit--- start")
		xpcall(function()
			if CS.SteamManager~=nil and CS.SteamManager.Instance ~= nil then
				if CS.SteamManager.Instance.SetCallBack~=nil then
					print("SteamPayInit --- setCallBack begin")
					CS.SteamManager.Instance:SetCallBack(
							function (appId, orderId)
								self:__SteamCallback(appId, orderId)
							end)
					print("SteamPayInit --- setCallBack finish")
				end
			end
		end, debug.traceback)

	end


end

function PayManager:__delete()
	self.packageInfo = nil
	self.fromView = nil
	self.chooseItem = nil
	self.productId = nil
	self.historyPurchaseList = nil
	self.payState = nil
	self.donateUID = nil
	self.itemId = nil
	self.purchaseSelfOrderId = nil
	self.param = nil
	self.goldPriceList = nil
	self.firstPayStatus = nil
	self.firstPayRewards = nil
end

function PayManager:InitData(message)
	if message["firstPayInfo"] then
		self.firstPayStatus = message["firstPayInfo"].state
		self.firstPayRewards = message["firstPayInfo"].reward
		EventManager:GetInstance():Broadcast(EventId.FirstPayStatusChange)
		self.needAutoPopup = self.firstPayStatus == 0
	end

	-- 加入金币价格
	self.goldPriceList = {}
	if message["goldprices"] then
		for k,v in ipairs(message["goldprices"]) do
			local price = GoldPrices.New()
			price:Parse(v)
			table.insert(self.goldPriceList, price)
		end
	end
	if CS.SDKManager.IS_UNITY_EDITOR() ==false and CS.SDKManager.IS_UNITY_PC~=nil and CS.SDKManager.IS_UNITY_PC()==true then
		if CS.SteamManager.Instance.GetSteamId~=nil and CS.SteamManager.Instance.GetCurrentGameLanguage ~=nil then
			local steamId = CS.SteamManager.Instance:GetSteamId()
			local steamLanguage = CS.SteamManager.Instance:GetCurrentGameLanguage()
			local lang = SteamLanguageToPay[steamLanguage]
			SFSNetwork.SendMessage(MsgDefines.GetSteamCurrency,steamId,lang)
		end
	end
	
end

function PayManager:SetSteamCurrency(message)
	if message == nil then
		return
	end
	local currency = message["currency"]
	local symbol = message["symbol"]
	if currency~=nil and currency~="" and symbol~=nil and symbol~="" then
		self.steamCurrency = currency
		self.steamSymbol = symbol
	end
end

--点击支付（精简一些，没用的就去掉了）
--packageInfo:礼包数据
--fromView：不知道具体干嘛，这个不敢删
--chooseItem：组合礼包选择的item
function PayManager:CallPayment(packageInfo,fromView,chooseItem)
	if packageInfo ~= nil then
		--用户点击行为统计
		SFSNetwork.SendMessage(MsgDefines.PayRecord, packageInfo:getID(),GlobalData.analyticID)
		--身份认证: 中国用户没有认证的不能发起支付
		if LuaEntry.DataConfig:CheckSwitch("certification_pay") and LuaEntry.GlobalData:IsChina() and (not LuaEntry.GlobalData:GetIsAuthenticate()) then
			return
		end

		self.packageInfo = packageInfo
		self.fromView = fromView
		self.chooseItem = chooseItem
		
		local countryCode = self:__GetLocalCurrencyCode()
		if LuaEntry.Player.gmFlag == 1 or LuaEntry.Player.gmFlag == 10 then
			SFSNetwork.SendMessage(MsgDefines.PayBeforeCheck, packageInfo:getID(), countryCode, chooseItem, 0)
		else
			if CS.SDKManager.IS_UNITY_EDITOR() ==false and CS.SDKManager.IS_UNITY_PC~=nil and CS.SDKManager.IS_UNITY_PC()==true then
				print("SteamPayCallPayment--- start")
				xpcall(function()
					if CS.SteamManager.Instance.GetSteamId~=nil and CS.SteamManager.Instance.GetCurrentGameLanguage~=nil then
						local steamId = CS.SteamManager.Instance:GetSteamId()
						print("SteamPayCallPayment--- getSteamId:"..steamId)
						local steamLanguage = CS.SteamManager.Instance:GetCurrentGameLanguage()
						print("SteamPayCallPayment--- getSteamLanguage:"..steamLanguage)
						local lang = SteamLanguageToPay[steamLanguage]
						print("SteamPayCallPayment--- getGameLang:"..lang)
						print("SteamPayCallPayment--- getPackageID:"..packageInfo:getID())
						SFSNetwork.SendMessage(MsgDefines.PayBeforeCheck, packageInfo:getID(), countryCode, chooseItem, 0,steamId,lang)
					end
				end, debug.traceback)

			else
				SFSNetwork.SendMessage(MsgDefines.PayBeforeCheck, packageInfo:getID(), countryCode, chooseItem, 0)
			end
		end
		
		
	end
end

function PayManager:OnCallPaymentBeforeCheckCallback(message)
	
	local Player = LuaEntry.Player
	local selfOrderId = message["selfOrderId"]
	local analyticID = GlobalData.analyticID
	if analyticID == "mycard" then
		local payCount = ""
		--local list = Data.GoldPrices.goldPricesList
		local list = self.goldPriceList
		if list ~= nil then
			local product_id = self.packageInfo:getProductID()
			for k,v in pairs(list) do
				if product_id == v.product_id then
					payCount = v.mycard
				end
			end
		end

		local ptGold = Player.ptGold
		local nPayCount = 0
		if payCount ~= nil and payCount ~= "" then
			nPayCount = tonumber(payCount)
		end

		if payCount ~= nil and payCount ~= "" and ptGold > 0 and ptGold >= nPayCount then
			UIUtil.ShowMessage(Localization:GetString("120030"),2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
				self:__callPtGoldPayment(selfOrderId,self.packageInfo:getID())
			end)
			return
		else
			UIUtil.ShowMessage(Localization:GetString("170013"),2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
				self:CallOnlinePayment()
			end)
			return
		end
	elseif analyticID == "amazon" then
		if SDKManager.IS_UNITY_ANDROID() then
			self:CallOnlinePaymentNotive(selfOrderId)
		end
		return
	end
	--if DataCenter.VIPManager:IsVipPack(message["productId"]) then
	--	DataCenter.VIPManager:OnVipPackPurchase(message["productId"])
	--end
	if CommonUtils.IsDebug() then
		self:__callPaymentTest(self.packageInfo:getID(), selfOrderId)
		return
	end
	-- 如果是gm，会有个配额，配额不足走正常支付流程
	if Player.gmFlag == 1 or Player.gmFlag == 10 then
		--有配额
		local dollar = 0
		if self.packageInfo:getPrice() ~= nil and self.packageInfo:getPrice() ~= "" then
			dollar = tonumber(self.packageInfo:getPrice())
		end

		if Player.gmGoldLimit > 0 and (Player.gmGold + dollar <= Player.gmGoldLimit) then -- 限额大于0
			self:__callPaymentTest(self.packageInfo:getID(), selfOrderId)
		else
			--没有配额走正常支付流程
		self:CallOnlinePaymentNotive(selfOrderId)
		end
	else
		if CS.SDKManager.IS_UNITY_EDITOR()==false and CS.SDKManager.IS_UNITY_PC~=nil and CS.SDKManager.IS_UNITY_PC() then
			print("SteamBeforePay callBack")
			return
		end
		self:CallOnlinePaymentNotive(selfOrderId)
	end
	
end

function PayManager:CancelPay()
	self.packageInfo = nil
	self.fromView = nil
	self.chooseItem = nil
end

function PayManager:PayParseData(message,itemId)

	local Player = LuaEntry.Player
	local status = message["status"]
	local orderId = message["orderId"]
	if status == 0 then
		-- 打点统计
		local itemId = message["itemId"] or ""
		local cost = message["cost"] or ""
		--if itemId ~= "220713001" and LuaEntry.Player:GetRegDeltaTime() <= 7 then
		--	Sdk:SetAppsFlyerPurchase(cost, itemId)
		--	if self.packageInfo ~= nil then
		--		local dollarTotal = Player.payDollerTotal
		--		local price = self.packageInfo:getPrice()
		--		if LuaEntry.Player:GetRegDeltaTime() < 1 then
		--			CS.GameEntry.Sdk:LogEvent("purchase_1day", LuaEntry.Player.uid, price)
		--			if CS.GameEntry.Sdk.Send_FireBase_LogCustomEvent ~= nil then
		--				local str = string.format("purchase_1day|currency,string,USD|value,float,%s|uid,string,%s", price, LuaEntry.Player.uid)
		--				CS.GameEntry.Sdk:Send_FireBase_LogCustomEvent(str)
		--			end
		--		end
		--		if dollarTotal~=nil and dollarTotal>0.99 then
		--			CS.GameEntry.Sdk:LogEvent("purchase_7day_no1", LuaEntry.Player.uid, price)
		--			if CS.GameEntry.Sdk.Send_FireBase_LogCustomEvent~=nil then
		--				local str = string.format("purchase_7day_no1|currency,string,USD|value,float,%s|uid,string,%s",price,LuaEntry.Player.uid)
		--				CS.GameEntry.Sdk:Send_FireBase_LogCustomEvent(str)
		--			end
		--		end
		--		if dollarTotal~=nil and dollarTotal>4.99 then
		--			CS.GameEntry.Sdk:LogEvent("purchase_7day_no5", LuaEntry.Player.uid, price)
		--			if CS.GameEntry.Sdk.Send_FireBase_LogCustomEvent~=nil then
		--				local str = string.format("purchase_7day_no5|currency,string,USD|value,float,%s|uid,string,%s",price,LuaEntry.Player.uid)
		--				CS.GameEntry.Sdk:Send_FireBase_LogCustomEvent(str)
		--			end
		--		end
		--		if dollarTotal~=nil and dollarTotal>9.99 then
		--			CS.GameEntry.Sdk:LogEvent("purchase_7day_no10", LuaEntry.Player.uid, price)
		--			if CS.GameEntry.Sdk.Send_FireBase_LogCustomEvent~=nil then
		--				local str = string.format("purchase_7day_no10|currency,string,USD|value,float,%s|uid,string,%s",price,LuaEntry.Player.uid)
		--				CS.GameEntry.Sdk:Send_FireBase_LogCustomEvent(str)
		--			end
		--		end
		--		if dollarTotal~=nil and dollarTotal>49.99 then
		--			CS.GameEntry.Sdk:LogEvent("purchase_7day_no50", LuaEntry.Player.uid, price)
		--			if CS.GameEntry.Sdk.Send_FireBase_LogCustomEvent~=nil then
		--				local str = string.format("purchase_7day_no50|currency,string,USD|value,float,%s|uid,string,%s",price,LuaEntry.Player.uid)
		--				CS.GameEntry.Sdk:Send_FireBase_LogCustomEvent(str)
		--			end
		--		end
		--		if dollarTotal~=nil and dollarTotal>99.99 then
		--			CS.GameEntry.Sdk:LogEvent("purchase_7day_no100", LuaEntry.Player.uid, price)
		--			if CS.GameEntry.Sdk.Send_FireBase_LogCustomEvent~=nil then
		--				local str = string.format("purchase_7day_no100|currency,string,USD|value,float,%s|uid,string,%s",price,LuaEntry.Player.uid)
		--				CS.GameEntry.Sdk:Send_FireBase_LogCustomEvent(str)
		--			end
		--		end
		--		CS.GameEntry.Sdk:LogEvent("purchase_7day", LuaEntry.Player.uid, price)
		--		if CS.GameEntry.Sdk.Send_FireBase_LogCustomEvent~=nil then
		--			local str = string.format("purchase_7day|currency,string,USD|value,float,%s|uid,string,%s",price,LuaEntry.Player.uid)
		--			CS.GameEntry.Sdk:Send_FireBase_LogCustomEvent(str)
		--		end
		--	end
		--end
		
		--PAY_SUCCESS
		--移除订单
		self:__removeOrderCache(orderId)

		local gold = message["gold"]
		if gold ~= nil then
			Player.sm_addGoldCount = Player.gold
			Player.gold = gold
		end
		Player.payTotal = message["payTotal"]
		Player.payDollerTotal = message["payDollerTotal"]
		--更新GM的限额
		if message["gmGoldLimit"] ~= nil then
			Player.gmGoldLimit = message["gmGoldLimit"]
		end
		
		if message["gmGold"] ~= nil then
			Player.gmGold = message["gmGold"]
		end
		
		local key = message["itemId"]
		local sendGift = false
		if message["exchangegift"] then
			sendGift = true
		end
		local itemName = ""
		local item = GiftPackageData.get(key)
		if item ~= nil then
			--暂时把红包支付成功写在这里
			if item.type == "1" and item:GetIsShowType() ~= 0 then
				local vec = string.split(item.show_type,";")
				if vec ~= nil and #vec == 2 and vec[1] == "12" then
					EventManager:GetInstance():Broadcast(EventId.REDPACK_BUY_GP_SUCCESS,key)
				end
			end

			itemName = item:getName()
			if not sendGift then
				item.bought = true
			end

			local isSubsOrder = false
			if message["isSubscribe"] then
				isSubsOrder = true
			end

			local reward = message["reward"]
			if reward ~= nil then
				if ExchangeDefine.MONTH_CARD_ID == key then
					--买完月卡要做的处理在这里
					EventManager:GetInstance():Broadcast(EventId.BuyMonthCardSucess)
					EventManager:GetInstance():Broadcast(EventId.CLICK_WELFARE_CELL)
				else
					--新月卡不弹出界面
					if message["random_hero"] ~= nil then
					elseif LuaEntry.DataConfig:CheckSwitch("red_packet_switch") then
					else
						if table.count(reward) > 0 then
							isSubsOrder = false
						else
							--在支付成功之后，回调 可以发事件
							EventManager:GetInstance():Broadcast(EventId.PaySuccess, itemId)
						end
					end
				end

				local showWindow = true

				-- 弹出提示
				if self.fromView == UIWindowNames.UIFirstPay then--如果直接在首充界面购买礼包，需要把礼包和首充奖励合并显示
					self.cacheRewardsFromMsg = message
					self.fromView = nil
					SFSNetwork.SendMessage(MsgDefines.ClaimFirstPayReward)
					showWindow = false
				else
					if self.needAutoPopup and self:CheckIfFirstPayOpen() then
						DataCenter.UIPopWindowManager:Push(UIWindowNames.UIFirstPay)
						self.needAutoPopup = false
					end
				end

				if itemId == tostring(DataCenter.HeroEvolveActivityManager:GetExchangeId()) then
					showWindow = false
				end
				if showWindow then
					DataCenter.RewardManager:ShowGiftReward(message)
				end

				for k,v in pairs(reward) do
					DataCenter.RewardManager:AddOneReward(v)
				end

			end

			--如果存在isSubscribe字段，则表示为订阅，但是如果存在奖励弹出FreeList界面，则不弹下面的提示
			if isSubsOrder and itemId ~= CExchangeDefine.SUB_MONTH_CARD_ID then
				UIUtil.ShowTipsId(120133)
			end

			if message["exchange"] ~= nil then
				GiftPackageData.pushPack(message)
			end
			EventManager:GetInstance():Broadcast(EventId.GOLDEXCHANGE_LIST_CHANGE)
		elseif message["reward"] ~= nil then
			--为随机礼包特殊处理
			-- 弹出提示
			DataCenter.RewardManager:ShowGiftReward(message)
			for k,v in pairs(message["reward"]) do
				DataCenter.RewardManager:AddOneReward(v)
			end
		end

		local showSuccess = (message["google_code"] == nil and message["reward"] == nil)
		local pack = GiftPackManager.get(itemId)
		if pack then
			if pack:isGrowthPlanPack() then
				-- 成长计划
				showSuccess = false
			elseif pack:isPiggyBankPack() then
				-- 存钱罐
				DataCenter.RewardManager:ShowGiftReward(message)
				showSuccess = false
			elseif pack:isEnergyBankPack() then
				-- 体力存钱罐
				message["getEnergy"] = message["getMoney"]
				message["getMoney"] = nil
				DataCenter.RewardManager:ShowGiftReward(message)
				showSuccess = false
			elseif pack:isHeroMonthCardPack() then
				-- 英雄养成计划
				if not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIGiftPackage) then
					GoToUtil.CloseAllWindows()
					GoToUtil.GotoGiftPackView(pack)
				end
			elseif DataCenter.ChainPayManager:GetDataByPackId(pack:getID()) ~= nil then
				showSuccess = false
			end
		end

		--AnalyticsEvent.TriggerEventPurchase(message["cost"], key, orderId, Player.uid)
		--if message["first_pay"] ~= NIL then
		--	AnalyticsEvent.SendAdjustTrack("first_pay")
		--end
		--if message["first_pay_today"] ~= NIL then
		--	AnalyticsEvent.SendAdjustTrack("first_pay_today")
		--end
		if sendGift then
			if itemName ~= nil and itemName ~= "" and message["exchangeto"] ~= nil then
				local exchangeTo = message["exchangeto"]
				if exchangeTo["receiverName"] ~= nil then
					local content = Localization:GetString("120010", itemName)
					local toName = exchangeTo["receiverName"]
					CS.MailManager.Instance:reqSendMailMessage(toName, "", content, "", "", "", false, CS.MailType.MAIL_SELF_SEND, "", "", false)
				end
			end
			UIUtil.ShowMessage(Localization:GetString("120009"))
		else
			if showSuccess then
				UIUtil.ShowMessage(Localization:GetString("E100076"),1, "110006", "", function()

				end)
				--UIUtil.ShowMessage(Localization:GetString("E100076"))--支付成功
			end
		end
		--在支付成功之后，回调 可以发事件
		EventManager:GetInstance():Broadcast(EventId.PaySuccess, itemId)
		-- 刷新下资源显示
		EventManager:GetInstance():Broadcast(EventId.UpdateGold)

	elseif status == 1 then
		--CHECK_FAIL
		--移除订单
		self:__removeOrderCache(orderId)
		--pay check fail
		UIUtil.ShowMessage(Localization:GetString("E100042"), 1, GameDialogDefine.CONFIRM)
	elseif status == 2 then
		--ORDER_EXIST
		self:__addToPurchaseIdList(orderId)
	elseif status == 3 then
		--PLATFORM_CONNECT_ERROR
	elseif status == 6 then
		--ORDER_TRANSFER
		self:__removeOrderCache(orderId)
	elseif status == 7 then
		--ORDER_NEED_CHOOSE
	else
		return false
	end
	return true
end

function PayManager:CallOnlinePayment()

	local Player = LuaEntry.Player
	if self.packageInfo ~= nil then
		self.donateUID = ""
		self.itemId = tonumber(self.packageInfo:getID())
		Setting:SetString(SettingKeys.CATCH_ITEM_ID, self.itemId)

		if SDKManager.IS_UNITY_IPHONE() then
			self:PayIOS(self.packageInfo:getID(), self.packageInfo:getProductID(), self.packageInfo:getProductID())
		elseif SDKManager.IS_UNITY_ANDROID() then
			if GlobalData:isGoogle() then
				self:PayGoogle(self.packageInfo:getProductID())
			else
				self.productId = self.packageInfo:getID()
				if GlobalData.analyticID == "market_global" then
					self:PayGoogle(self.packageInfo:getProductID())
				elseif GlobalData.analyticID == "mycard" then
				elseif GlobalData.analyticID == "mol" then

				elseif GlobalData:isMiddleEast() then
					self:PayGoogle(self.packageInfo:getProductID())
				elseif GlobalData:isTencent() then
					self:PayTencent(self.packageInfo:getID(), Player.uid, self.packageInfo:getID(), self.packageInfo:getPrice(), self.packageInfo:getDiamond(), self.packageInfo:getName())
				else
					self:PayOther(Player.uid, self.packageInfo:getID(), self.packageInfo:getPrice(), self.packageInfo:getDiamond(), self.packageInfo:getName())
				end
			end
		end
		--CSPayManager:LuaCallOnlinePayment(self.fromView,self.packageInfo:getID(),self.itemId,DataCenter.BuildManager.MainLv,Player.level)
		AnalyticsEvent:GiftPackage(self.fromView,self.packageInfo:getID(),self.itemId,DataCenter.BuildManager.MainLv,Player.level)
	end
end

function PayManager:CallOnlinePaymentNotive(selfOrderId)

	local Player = LuaEntry.Player
	if self.packageInfo ~= nil then
		self.itemId = selfOrderId
		Setting:SetString(SettingKeys.CATCH_ITEM_ID, selfOrderId)
		if SDKManager.IS_UNITY_IPHONE() then
			self:PayIOS(self.packageInfo:getID(), self.packageInfo:getProductID(), self.packageInfo:getProductID())
		elseif SDKManager.IS_UNITY_ANDROID() then
			if GlobalData:isGoogle() then
				self:PayGoogle(self.packageInfo:getProductID())
			else
				self.productId = self.packageInfo:getID()
				if GlobalData.analyticID == "market_global" then
					self:PayGoogle(self.packageInfo:getProductID())
				elseif GlobalData:isMiddleEast() then
					self:PayGoogle(self.packageInfo:getProductID())
				elseif GlobalData:isTencent() then
					self:PayTencent(self.packageInfo:getID(), Player.uid, self.packageInfo:getID(), self.packageInfo:getPrice(), self.packageInfo:getDiamond(), self.packageInfo:getName())
				else
					self:PayOther(Player.uid, self.packageInfo:getID(), self.packageInfo:getPrice(), self.packageInfo:getDiamond(), self.packageInfo:getName())
				end
			end
		end
	end
end



-- 获取货币字符串
function PayManager:GetDollarText(dollar, productId,isPrice)
	local returnString = ""
	if CS.SDKManager.IS_UNITY_EDITOR() ==false and CS.SDKManager.IS_UNITY_PC~=nil and CS.SDKManager.IS_UNITY_PC()==true then
		local temp_dollar = tonumber(dollar)
		local steamStr = DataCenter.SteamPriceTemplateManager:GetPriceText(temp_dollar*100,self.steamCurrency,self.steamSymbol)
		if steamStr ~= "" then
			return steamStr
		end
	end
	if not string.IsNullOrEmpty(productId) then
		returnString = self:GetLocalCurrency(productId)
	else
		local rate = self:GetExchangeRate()
		local symbol = self:GetLocalCurrencySymbol()
		if (rate > 0) then
			local temp_dollar = tonumber(dollar) * rate
			if (self.isSymbolAtRight == true) then
				returnString = temp_dollar--[[.ToString("N")]] .. symbol
			else
				returnString = symbol .. temp_dollar--[[.ToString("N")]]
			end
		else
			if isPrice then
				rate = 1
				local temp_dollar = tonumber(dollar) * rate
				if (self.isSymbolAtRight == true) then
					returnString = temp_dollar.. symbol
				else
					returnString = symbol .. temp_dollar
				end
			end
		end
	end

	if not string.IsNullOrEmpty(returnString) then
		return returnString
	end

	local payCurrency = "US $"
	local temp_dollar = tonumber(dollar)

	if (GlobalData.analyticID == "onestore") then

		payCurrency = "₩"
		local payCount = math.ceil(temp_dollar * 10) * 120
		payCount = string.GetFormattedStr(payCount)
		return payCurrency .. tostring(payCount)

	elseif (GlobalData:isMiddleEast()) then

		payCurrency = "T"
		local payCount = math.ceil(temp_dollar * 40) * 100
		payCount = string.GetFormattedStr(payCount)
		return payCurrency .. tostring(payCount)

	elseif (GlobalData.analyticID == "mycard") then

		payCurrency = "TWD "
		local payCount = ""
		local list = self.goldPricesList
		--foreach (GoldPrices v in list)
		--{

		--}

		if (payCount == "") then
			payCount = (math.ceil(temp_dollar) * 30.865)
			payCount = string.GetFormattedStr(payCount)
			return payCurrency .. payCount
		end

	elseif (GlobalData:isGoogle()) then

		local symbol = self:GetLocalCurrencySymbol()
		local rate = self:GetExchangeRate()
		local _curCode = self:__GetLocalCurrencyCode()
		if (not string.IsNullOrEmpty(symbol) and rate > 0) then
			local payValue = string.format("%.2f", temp_dollar * rate)
			if self.isSymbolAtRight == true then
				payValue = payValue .. symbol
			else
				payValue = symbol .. payValue
			end
			return payValue
		end

	elseif (GlobalData.analyticID == "mol") then

		payCurrency = "THB "
		local payCount = ""
		local list = self.goldPricesList
		--foreach (GoldPrices v in list)
		--{

		--}
		if (not payCount.IsNullOrEmpty()) then
			return payCurrency .. payCount
		end

	elseif (GlobalData:isChina()) then

		payCurrency = ""
		return payCurrency .. self:GetPriceCNY(dollar)

	end

	payCurrency = "US $"
	return payCurrency .. tostring(dollar)
end

function PayManager:GetPriceCNY(dollar)
	local price = dollar
	if (PaymentPriceCNY[price]) then
		return PaymentPriceCNY[price]
	else
		return math.ceil(price * 6.5)--[[.ToString("N");]]
	end
end

function PayManager:__callPtGoldPayment(selfOrderId,packageId)
	self.param = {}
	self.param.itemId = packageId
	self.param.orderId = selfOrderId
	self.param.productId = self.productId

	SFSNetwork.SendMessage(MsgDefines.PayPtGold, self.param)
end

function PayManager:__callPaymentTest(packageId,selfOrderId)
	self.param = {}
	self.param.itemId = packageId
	self.param.orderId = tostring(Timer:GetServerTime())
	self.param.selfOrderId = selfOrderId
	SFSNetwork.SendMessage(MsgDefines.PayTest, self.param)
end

function PayManager:__removeOrderCache(orderId)
	local purshaseInfoList = Setting:GetString(SettingKeys.PURCHASE_KEY, "")
	if purshaseInfoList ~= nil and purshaseInfoList ~= "" then
		local list = string.split(purshaseInfoList,COK_PURCHASE_DELIMITER_ORDERS)
		if list ~= nil then
			for i = #list,1,-1 do
				local subList = string.split(list[i],COK_PURCHASE_DELIMITER_DATA)
				if #subList ~= 10 or orderId == subList[2] then
					table.remove(list,i)
				end
			end

			purshaseInfoList = "";
			for k,v in ipairs(list) do
				if k > 1 then
					purshaseInfoList = purshaseInfoList..COK_PURCHASE_DELIMITER_ORDERS
				end
				purshaseInfoList = purshaseInfoList..v
			end
			Setting:SetString(SettingKeys.PURCHASE_KEY, purshaseInfoList)
		end
	end
end

function PayManager:__addToPurchaseIdList(orderId)
	if orderId ~= nil and orderId ~= "" then
		self:__removeOrderCache(orderId)
		if not self:__checkPurchaseSuccessed(orderId) then
			local idList = Setting:GetString(SettingKeys.PURCHASE_SUCCESSED_KEY, "")
			if idList ~= nil and idList ~= "" then
				idList = idList..COK_PURCHASE_DELIMITER_ORDERS
			end
			idList = idList..orderId
			Setting:SetString(SettingKeys.PURCHASE_SUCCESSED_KEY, idList)
		end
		if not GlobalData:isTencent() then
			self:__checkPurchaseInfoList()
		end
	end
end

--检查是否订单已成功
function PayManager:__checkPurchaseSuccessed(orderId)
	local idList = Setting:GetString(SettingKeys.PURCHASE_SUCCESSED_KEY, "")
	if idList ~= nil and idList ~= "" then
		local subList = string.split(idList,COK_PURCHASE_DELIMITER_ORDERS)
		if subList ~= nil then
			for k,v in ipairs(subList) do
				if v == orderId then
					return true
				end
			end
		end
	end
	return false
end

function PayManager:__checkPurchaseItem(item)
	local foundPurchaseCache = false

	local pf = item[1]
	local orderId = item[2]

	local checkedPurchaseOrderId = self.historyPurchaseList[orderId]
	if checkedPurchaseOrderId == nil then
		foundPurchaseCache = true
		self.historyPurchaseList[orderId] = orderId

		if pf == "AppStore" then
			local sSignedData = item[3]
			local productId = item[4]
			local itemId = item[5]
			if string.contains(itemId,"_") then
				local mVec = string.split(itemId,"_")
				if mVec ~= nil and #mVec > 1 and mVec[1] ~= nil and mVec[1] ~= "" and mVec[2] ~= nil and mVec[2] ~= "" then
					self.param = {}
					self.param.orderId = orderId
					self.param.sSignedData = sSignedData
					self.param.productId = productId
					self.param.itemId = self.productId
					self.param.toUID = mVec[2]
					SFSNetwork.SendMessage(MsgDefines.PayIOS,self.param)
				end
			else
				self.param = {}
				self.param.orderId = orderId
				self.param.sSignedData = sSignedData
				self.param.productId = productId
				self.param.itemId = self.productId
				SFSNetwork.SendMessage(MsgDefines.PayIOS,self.param)
			end

		end


		if SDKManager.IS_UNITY_ANDROID() then
			if pf == "onestore" then
				self.param = {}
				self.param.txid = orderId
				self.param.signdata = subList[3]
				SFSNetwork.SendMessage(MsgDefines.PayTstore,self.param)

			elseif pf == "amazon" then
				local amazonUserId = subList[3]
				local sku = subList[4]
				local itemId = subList[5]
				local productType = subList[6]
				local purchaseTime = subList[7]

				if string.contains(itemId,"_") then
					local mVec = string.split(itemId,"_")
					if mVec ~= nil and #mVec > 1 and mVec[1] ~= nil and mVec[1] ~= "" and mVec[2] ~= nil and mVec[2] ~= "" then
						self.param = {}
						self.param.orderId = orderId
						self.param.productType = productType
						self.param.purchaseTime = purchaseTime
						self.param.sku = sku
						self.param.amazonUserId = amazonUserId
						self.param.itemId = mVec[1]
						self.param.toUID = mVec[2]
						SFSNetwork.SendMessage(MsgDefines.PayAmazon,self.param)
					end
				else
					self.param = {}
					self.param.orderId = orderId
					self.param.productType = productType
					self.param.purchaseTime = purchaseTime
					self.param.sku = sku
					self.param.amazonUserId = amazonUserId
					self.param.itemId = itemId
					SFSNetwork.SendMessage(MsgDefines.PayAmazon,self.param)
				end

			end
		end
	end
end


function PayManager:__checkPurchaseInfoList()
	if SDKManager.IS_UNITY_ANDROID() then
		if GlobalData:isTencent() then
			self:__queryHistoryPurchase()
		end
	end

	local foundPurchaseCache = false
	local purshaseInfoList = Setting:GetString(SettingKeys.PURCHASE_KEY, "")
	PayPrint("purshaseInfoList : " .. purshaseInfoList)

	local array = string.string2array_s(purshaseInfoList, COK_PURCHASE_DELIMITER_DATA, COK_PURCHASE_DELIMITER_ORDERS)
	if array then
		for _,v in ipairs(array) do
			if #v > 2 then
				if self:__checkPurchaseItem(v) == true then
					foundPurchaseCache = true
					break
				end
			end
		end
	end

	if foundPurchaseCache == false then
		self:__checkHistoryPurchase()
	end

end

function PayManager:OnCallPaymentServerCallback(status,orderId,gmGoldInfo)
	self.payState = 0
	if self.packageInfo ~= nil then
		--GiftPackageData:GetInstance().goldExchangePurchasedGroup = self.packageInfo:getGroup()
	end

	local Player = LuaEntry.Player
	if SDKManager.IS_UNITY_IPHONE() then
		--[[Setting:SetString(SettingKeys.CATCH_ITEM_ID, "")
		self.donateUID = ""
		if not CommonUtils.IsDebug() then
			-- 加上gm验证
			if (Player.gmFlag == 1 or Player.gmFlag == 10) and Player.gmGoldLimit > 0 then
				if gmGoldInfo ~= nil and gmGoldInfo["error"] ~= nil then
					--校验失败的时候会返回error这个字段
					self:CallPayment(self.packageInfo,self.fromView,self.chooseItem) 
					return
				end
			end
		end

		if self.packageInfo == nil or self.packageInfo:getID() == ExchangeDefine.MONTH_CARD_ID then
			--新月卡不发送消息
			return
		end]]
		Sdk:ConsumeProduct(orderId, status)
	elseif SDKManager.IS_UNITY_ANDROID() then
		Sdk:ConsumeProduct(orderId, status)
	end
	SFSNetwork.SendMessage(MsgDefines.VipInfo)
	SFSNetwork.SendMessage(MsgDefines.ExchangeInfo)
end

function PayManager:__checkHistoryPurchase()
	if self.historyPurchaseChecked == false then
		self.historyPurchaseChecked = true
		--CSPayManager:queryHistoryPurchase()
		self:__queryHistoryPurchase()
	end
end


function PayManager:PayIOS(productId,description,productid3)
	if self.payState == 0 then
		self.productId = productId
		self.payState = 1

		--[[local tempProductId = description
		if LuaEntry.DataConfig:CheckSwitch("ios_exclusive_productid") and productid3 ~= nil and productid3 ~= "" then
			if not string.contains(tempProductId,"lsu_") then
				tempProductId = string.format("lsu_%s", productid3)
			else
				tempProductId = productid3
			end
		end

		local buyItem = self.itemId
		if self.donateUID ~= nil and self.donateUID ~= "" then
			buyItem = buyItem.."_"..self.donateUID
		end
		]]
		local tbl = {}
		tbl["skuId"] = productid3
		tbl["selfOrderId"] = self.itemId
		self:__doPay(tbl)
		--CSPayManager:LuaPayIOS(tempProductId,buyItem)
	end
end

function PayManager:PayGoogle(skuId)
	if self.payState == 0 then
		self.payState = 1

		local tbl = {}
		tbl["skuId"] = skuId
		tbl["itemId"] = self.itemId
		tbl["toUID"] = self.donateUID
		tbl["bRegister"] = false
		tbl["uid"] = LuaEntry.Player:GetUid()
		self:__doPay(tbl)
		--CSPayManager:LuaPayGoogle(skuId,self.itemId,self.donateUID,false,CommonUtils.GetUid())
	end
end

function PayManager:PayTencent(itemId,uid,exchangeId,price,gold,desc)
	if self.payState == 0 then
		self.payState = 1

		local tbl = {}
		tbl["itemId"] = itemId
		tbl["uid"] = uid
		tbl["exchangeId"] = exchangeId
		tbl["price"] = price
		tbl["gold"] = gold
		tbl["desc"] = desc
		tbl["isTencent"] = true
		self:__doPay(tbl)

		--CSPayManager:LuaPayTencent(itemId,uid,exchangeId,price,gold,desc)
	end
end

function PayManager:PayOther(uid, exchangeId, price, gold, desc)
	if self.payState == 0 then
		self.payState = 1

		local tbl = {}
		tbl["uid"] = uid
		tbl["exchangeId"] = exchangeId
		tbl["price"] = price
		tbl["gold"] = gold
		tbl["desc"] = desc
		tbl["isTencent"] = false
		self:__doPay(tbl)

		--CSPayManager:LuaPayOther(itemId,uid,exchangeId,price,gold,desc)
	end
end

function PayManager:__removeSelfOrderId(orderId)
	if self.purchaseSelfOrderId[orderId] ~= nil then
		self.purchaseSelfOrderId[orderId] = {}
	end
end

function PayManager:CallPaymentGoogleSendGoods(Purchase)

	local itemId = self.itemId
	if itemId == nil or itemId == "" then
		itemId = Setting:GetString(SettingKeys.CATCH_ITEM_ID, "")
	end

	local _orderId = Purchase.orderId
	local _signData = Purchase.signData
	local _purchaseTime = Purchase.purchaseTime
	local _signature = Purchase.signature
	local _productId = Purchase.productId

	self:__addOrderCache("googleplay", _orderId, _signData, _productId, itemId)
	self.param = {}
	self.param.orderId = _orderId
	self.param.productId = _productId
	self.param.purchaseTime = _purchaseTime
	self.param.signData = _signData
	self.param.signature = _signature
	self.param.itemId = itemId
	SFSNetwork.SendMessage(MsgDefines.Pay, self.param)
end

function PayManager:__addOrderCache(pf, orderId, sSignedData, productId, itemId, productType, purchaseTime)
	Logger.Log("---------------add order cache---------------")
	if self:__checkPurchaseSuccessed(orderId) then
		Logger.Log("---------------order already fulfilled---------------")
		return
	end
	local purshaseInfoList = Setting:GetString(SettingKeys.PURCHASE_KEY, "")
	Logger.Log(string.format("------before add order %s", purshaseInfoList))
	local tmpInfo = string.format("%s|#|%s|#|%s|#|%s|#|%s|#|%s|#|%s|#|%s|#|%s|#|%s", pf, orderId, sSignedData, productId, itemId, productType, purchaseTime, "", "", "")
	if purshaseInfoList ~= nil and purshaseInfoList ~= "" then
		tmpInfo = string.format("%s%s%s", tmpInfo, COK_PURCHASE_DELIMITER_ORDERS, purshaseInfoList)
		local array = string.split(purshaseInfoList,COK_PURCHASE_DELIMITER_ORDERS)
		if array ~= nil then
			for k,v in ipairs(array) do
				local subList = string.split(v,COK_PURCHASE_DELIMITER_DATA)
				if subList ~= nil and (#subList ~= 10 or orderId == subList[2]) then
					Logger.Log("info already exist");
					return
				end
			end
		end
	end
	Setting:SetString(SettingKeys.PURCHASE_KEY, tmpInfo)
	Logger.Log("------after add order ", tmpInfo)

end

function PayManager:CallPaymentIOSSendGoods(Purchase)
	local itemId = self.itemId
	if itemId == nil or itemId == "" then
		itemId = Setting:GetString(SettingKeys.CATCH_ITEM_ID, "")
	end

	local orderId = Purchase.transactionIdentifier
	local sSignedData = Purchase.encodedReceipt
	local productId = Purchase.productIdentifier

	self:__addOrderCache("AppStore", orderId, sSignedData, productId, itemId)

	self.param = {}
	self.param.orderId = orderId
	self.param.sSignedData = sSignedData
	self.param.productId = productId
	self.param.itemId = itemId
	SFSNetwork.SendMessage(MsgDefines.PayIOS,self.param)

	--[[
	if string.contains(itemId,"_") then
		local mVet = string.split(itemId,"_")
		if mVet ~= nil and #mVet > 1 then
			itemId = mVet[1]
			self.donateUID = mVet[2]
		end
	else
		if self.donateUID == nil or self.donateUID == "" then
			self.param = {}
			self.param.orderId = orderId
			self.param.sSignedData = sSignedData
			self.param.productId = productId
			self.param.itemId = self.productId
			SFSNetwork.SendMessage(MsgDefines.PayIOS,self.param)
			return
		end
	end


	if self.donateUID ~= nil and self.donateUID ~= "" then
		self.param = {}
		self.param.orderId = orderId
		self.param.sSignedData = sSignedData
		self.param.productId = productId
		self.param.itemId = self.productId
		self.param.toUID = self.donateUID
		SFSNetwork.SendMessage(MsgDefines.PayIOS,self.param)
	end
	]]

end

function PayManager:SetPayState(state)
	self.payState = state
end

function PayManager:GetExchangeRate()
	if (self.exchangeRate > 0) then
		return self.exchangeRate
	else
		return Setting:GetFloat("gp_price_exchange_rate", 1)
	end
end

function PayManager:GetLocalCurrencySymbol()
	if not string.IsNullOrEmpty(self.localCurrencySymbol) then
		return self.localCurrencySymbol
	else
		return Setting:GetString("gp_price_symbole", "$")
	end
end


--接收消息处理
function PayManager:PayMessageHandle(message,withoutLog)
	if message["errorCode"] == nil then
		if message["orderId"] == self.param.orderId then
			if self:PayParseData(message) then
				if ExchangeDefine.MONTH_CARD_ID == self.param.itemId then--新月卡不处理
					EventManager:GetInstance():Broadcast(EventId.MONTHCARD_REFRESH)
				else
					self:OnCallPaymentServerCallback(message["status"],message["orderId"],message["gmGoldInfo"])
				end

				EventManager:GetInstance():Broadcast(EventId.OnPackageInfoUpdated)
			end
		end
	else
		UIUtil.ShowTips(Localization:GetString(message["errorCode"]))
		--即使服务器确认订单失败，比如订单已存在的情况下，也要消耗掉商品，之后如果还有掉单需要经过客服，但至少不会卡住账户状态
		CS.GameEntry.Sdk:ConsumeProduct(self.param.orderId, 2)
	end
end

function PayManager:PayPtGoldMessageHandle(message)

	if message["errorCode"] == nil then
		if self:PayParseData(message) then
			LuaEntry.Player.ptGold = message["ptGold"]
			self:OnCallPaymentServerCallback(message["status"],self.param.orderId)
		end
	else
		UIUtil.ShowTips(Localization:GetString(message["errorCode"]))
		CS.GameEntry.Sdk:ConsumeProduct(self.param.orderId, 2)
	end
end

function PayManager:PayBeforeCheckMessageHandle(message)
	if message["errorCode"] == nil then
		self:OnCallPaymentBeforeCheckCallback(message)
	else
		self:CancelPay()
	end
end

function PayManager:PayTstoreMessageHandle(message)
	if message["errorCode"] == nil then
		if message["orderId"] == self.param.txid then
			if self:PayParseData(message) then
				self:OnCallPaymentServerCallback(message["status"],message["orderId"],message["gmGoldInfo"])
			end
		end
	else
		UIUtil.ShowTips(Localization:GetString(message["errorCode"]))
		--即使服务器确认订单失败，比如订单已存在的情况下，也要消耗掉商品，之后如果还有掉单需要经过客服，但至少不会卡住账户状态
		CS.GameEntry.Sdk:ConsumeProduct(self.param.orderId, 2)
	end
end

function PayManager:__queryHistoryPurchase()
	Sdk:SendDataToNative("Pay_queryHistoryPurchase", "")
end

function PayManager:__doPay(tbl)
	local _payEnv = Sdk:CheckPayEnv()
	if (_payEnv > 0) then
		if (_payEnv == 300) then
			UIUtil.ShowMessage(Localization:GetString("320285"))
		else
			UIUtil.ShowMessage(Localization:GetString("320284"))
		end
		return
	end
	local json = rapidjson.encode(tbl)
	if json then
		Sdk:Pay(json)
	end
end

function PayManager:__GetLocalCurrencyCode()
	if string.IsNullOrEmpty(self.localCurrencyCode) then
		self.localCurrencyCode = Setting:GetString("price_currency_code", "USD")
	end
	if (string.contains(self.localCurrencyCode, "data")) then
		local str = self.localCurrencyCode .. "\"}"
		local jsonStr = rapidjson.decode(str)
		if (jsonStr == nil) then
			self.localCurrencyCode = ""
		else
			self.localCurrencyCode = jsonStr["data"] or ""
		end
	end
	return self.localCurrencyCode
end

function PayManager:GetLocalCurrency(productId)
	-- 如果在该table中不存在表示从google还没有拉取到信息,我们再主动拉取一次
	local _product_price = self.m_SkuDetails[productId]
	if (_product_price) then
		return _product_price;
	else
		local tbl = {}
		tbl["type"] = "inapp"
		tbl["list"] = {productId}
		local json = rapidjson.encode(tbl)
		Sdk:SendDataToNative("Pay_querySkuDetailsAsync", json)
		-- 如果实时价格还没有取到，从缓存中拿之前存的价格，不过也有可能是空，同时再去原生端请求一下实时价格
		return Setting:GetString(productId, "");
	end
end

function PayManager:__SdkCallback(key, data)

	if key == "onGooglePayInitResult" then
		self:__onGooglePayInitResult(data)
	elseif key == "onPurchaseQueried" then
		self:__onPurchaseQueried(data)
	elseif key == "onPurchaseCallback" then
		self:__onPurchaseCallback(data)
	end
end

--[[
	jsonData
		+ int code
		+ string version
]]
function PayManager:__onGooglePayInitResult(jsonData)

	local result = rapidjson.decode(jsonData)
	if result and result.code == 0 then
		LuaEntry.GlobalData.s_isGooglePlayAvailable = true
		self.BillingClientVersion = result.version
		return
	else

	end

end

--[[
	jsonData
		+ int code
		+ string[] array
]]
local test = false
function PayManager:__onPurchaseQueried(data)
	if (string.IsNullOrEmpty(data)) then
		return
	end
	if (test == false) then
		self:LogToServer("gp_pay2_all" .. tostring(data))
		test = true
	end
	self:__setLocalCurrency(data)
end

function PayManager:__setLocalCurrency(data)
	local jsondata = rapidjson.decode(data)
	if (jsondata == nil) then
		return
	end
	data = jsondata["data"] or ""
	-- TWD|apsgp_1:$30.37;apsgp_2:$30.37;apsgp_3:$30.37;apsgp_4:$30.37;
	-- 做字符串拆分
	-- 如果是两个 则第一个是货币符号 第二个是商品列表,如果只有一个则是商品列表

	local function RecordProductPrice( productList )
		for _, v in pairs(productList) do
			local tabV = string._split_ss_array(v, ':')
			if (table.count(tabV) == 2) then
				local product_id = tabV[1]
				local product_price = tabV[2]
				-- 计算汇率
				if (product_id == "apsgp_1") then
					local _price_num = 0
					for k in string.gmatch(product_price, '(%-?%d+%.*%d*)') do
						_price_num = tonumber(k)
					end
					self.exchangeRate = _price_num / 0.99
					self:LogToServer("gp_pay2_gp_price_exchange_rate" .. self.exchangeRate )
					self:LogToServer("gp_pay2_gp_price" .. product_price )
					Setting:SetFloat("gp_price_exchange_rate", self.exchangeRate)
					-- 这个时候获取下币种符号
					if (string.IsNullOrEmpty(self.localCurrencySymbol)) then
						self.localCurrencySymbol = string.gsub(product_price, regex, "");
						if (string.startswith(product_price, self.localCurrencySymbol)) then
							self.isSymbolAtRight = false
						elseif (string.endswith(product_price, self.localCurrencySymbol)) then
							self.isSymbolAtRight = true
						end
						Setting:SetString("gp_price_symbole", self.localCurrencySymbol)
						self:LogToServer("gp_pay2_gp_price_symbole" .. self.localCurrencySymbol )
					end
				end
				Setting:SetString(product_id, product_price)
				self.m_SkuDetails[product_id] = product_price
			end
		end
	end

	local _tabData = string._split_ss_array(data, '|')
	if (table.count(_tabData) == 2) then -- 1货币 2商品
		self.localCurrencyCode = _tabData[1]
		Setting:SetString("price_currency_code", self.localCurrencyCode)
		local _productList = string._split_ss_array(_tabData[2], ';')
		RecordProductPrice(_productList)
	else
		local _productList = string._split_ss_array(data, ';')
		RecordProductPrice(_productList)
	end
end

function PayManager:Startup()

end

--[[
	jsonData
		+ int code
		+ string purchase - json
		+ string sign
]]
function PayManager:__onPurchaseCallback(jsonData)
	local result = rapidjson.decode(jsonData)
	if result == nil then
		return
	end
	local code = tonumber(result.code)
	if code ~= 0 then
		self.payState = 0
		return
	end
	--[[
		Purchase是一个结构
			string orderId;
			string packageName;
			string productId;
			long purchaseTime;
			string token;
			string purchaseToken;
			int purchaseState;
			string developerPayload;
			bool acknowledged;
			bool autoRenewing;
	]]

	-- 根据平台调用
	if SDKManager.IS_UNITY_ANDROID() then
		if GlobalData:isGoogle() then
			self:CallPaymentGoogleSendGoods(result)
		end
	elseif SDKManager.IS_UNITY_IPHONE() then
		self:CallPaymentIOSSendGoods(result)
	end

end

function PayManager:__SteamCallback(appId, orderId)
	print(" payFinish SteamCallback callBack appId:"..appId)
	print(" payFinish SteamCallback callBack orderId:"..orderId)
	self.param = {}
	self.param.orderId = tostring(orderId)
	SFSNetwork.SendMessage(MsgDefines.PaySteam,tostring(orderId))
end


function PayManager:UpdateFirstPayStatus(tempStatus)
	self.firstPayStatus = tempStatus
	EventManager:GetInstance():Broadcast(EventId.FirstPayStatusChange)
end

function PayManager:GetFirstPayRewards()
	return self.firstPayRewards
end

function PayManager:GetFirstPayStatus()
	return self.firstPayStatus
end

function PayManager:GetCacheFirstPayReward()
	local tempMsg = self.cacheRewardsFromMsg
	self.cacheRewardsFromMsg = nil
	return tempMsg
end

function PayManager:CheckIfFirstPayOpen()
	local unlockBtnLockType = DataCenter.UnlockBtnManager:GetShowBtnState(UnlockBtnType.FirstPay)
	if unlockBtnLockType == UnlockBtnLockType.Show then
		local k1 = LuaEntry.DataConfig:TryGetNum("first_pay", "k3")
		local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_MAIN)
		if buildData~=nil and buildData.level >= k1 and (self.firstPayStatus == 0 or self.firstPayStatus == 1) then
			return true
		end
	end
	return false
end

function PayManager:CheckHeroMonthCardTip()
	local list = WelfareController.getShowTagInfos()
	for _, v in pairs(list) do
		if v:getType() == WelfareTagType.HeroMonthCardNew then
			return data ~= nil and data.buy ~= BuyFlag.BUY
		end
	end
	return false
end

function PayManager:BuyGift(info, selectedCombineIndex)
	local vec = string.split(info:getItem2Str(),"@",0,true)
	local combinationData = ""
	if vec ~= nil and selectedCombineIndex ~= nil and selectedCombineIndex < #vec then
		combinationData = vec[self.model.selectedCombineIndex]
	end

	self:CallPayment(info, "", combinationData)
end

return PayManager

