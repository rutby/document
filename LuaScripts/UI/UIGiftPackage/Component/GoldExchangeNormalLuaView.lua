--[[
    礼包
--]]

local GoldExchangeNormalLuaView = BaseClass("GoldExchangeNormalLuaView", UIBaseContainer)
local base = UIBaseContainer
local UICommonItem = require "UI.UICommonItem.UICommonItem"
local UIGiftPackagePoint = require "UI.UIGiftPackage.Component.UIGiftPackagePoint"
local picPathName1 = "Assets/Main/TextureEx/GiftPackage/%s/%s_beijing1"
local UIGray = CS.UIGray

local bg_path = "Bg"
local title_path = "Title"
local hot_path = "Hot"
local time_path = "Time"
local desc_path = "Desc"
local discount_bg_path = "DiscountBg"
local discount_path = "DiscountBg/Discount"
local diamond_path = "Diamond"
local scroll_view_path = "ScrollView"
local btn_path = "layout/Button"
local price_path = "layout/Button/Hori/Price"
local limit_path = "layout/Limit"
local id_path = "Id"
local point_path = "layout/Button/UIGiftPackagePoint"
local ad_icon_path = "layout/Button/Hori/AdIcon"
local ad_red_path = "layout/Button/AdRed"

local DescColor =
{
	["giftshop_board_00"] = "#FAE5AC",
	["giftshop_board_01"] = "#A9D9F4",
	["giftshop_board_02"] = "#E1A6FF",
	["giftshop_board_03"] = "#CDC1FF",
	["Default"] = "#FFFFFF",
}

local function OnCreate(self)
	base.OnCreate(self)
	self:ComponentDefine()
	self:DataDefine()
end

local function OnDestroy(self)
	self:ClearScroll()
	self:ComponentDestroy()
	self:DataDestroy()
	base.OnDestroy(self)
end

local function ComponentDefine(self)
	self.bg_image = self:AddComponent(UIImage, bg_path)
	self.title_text = self:AddComponent(UITextMeshProUGUIEx, title_path)
	self.hot_go = self:AddComponent(UIBaseContainer, hot_path)
	self.time_text = self:AddComponent(UITextMeshProUGUIEx, time_path)
	self.desc_text = self:AddComponent(UITextMeshProUGUIEx, desc_path)
	self.discount_bg_go = self:AddComponent(UIBaseContainer, discount_bg_path)
	self.discount_text = self:AddComponent(UITextMeshProUGUIEx, discount_path)
	self.diamond_text = self:AddComponent(UITextMeshProUGUIEx, diamond_path)
	self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
	self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
		self:OnCreateCell(itemObj, index)
	end)
	self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
		self:OnDeleteCell(itemObj, index)
	end)
	self.btn = self:AddComponent(UIButton, btn_path)
	self.btn:SetOnClick(function()
		self:OnClick()
	end)
	self.price_text = self:AddComponent(UITextMeshProUGUIEx, price_path)
	self.limit_text = self:AddComponent(UITextMeshProUGUIEx, limit_path)
	self.id_text = self:AddComponent(UITextMeshProUGUIEx, id_path)
	self.point_rect = self:AddComponent(UIGiftPackagePoint,point_path)
	self.ad_icon_go = self:AddComponent(UIBaseContainer, ad_icon_path)
	self.ad_red_go = self:AddComponent(UIBaseContainer, ad_red_path)
end

local function ComponentDestroy(self)
	
end

local function DataDefine(self)
	self.param = nil
	self.dataList = {}
	self.isAd = false
	self.adInited = false
end

local function DataDestroy(self)
	
end

local function TimerAction(self)
	if self.param == nil then
		return
	end
	local pack = self.param.info
	if pack:getTimeType() == PackTimeType.AlwaysHideTime then
		self.time_text:SetText("")
		self.btn:SetInteractable(true)
		return
	end

	local curTime = UITimeManager:GetInstance():GetServerTime()
	local leftTime = math.floor(pack:getEndTime() - curTime)
	if leftTime >= 0 then
		self.time_text:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(leftTime))
		self.btn:SetInteractable(true)
	else
		self.time_text:SetLocalText(120077)
		self.btn:SetInteractable(false)
	end
end

local function ShowScroll(self)
	local count = #self.dataList
	if count > 0 then
		self.scroll_view:SetActive(true)
		self.scroll_view:SetTotalCount(count)
		self.scroll_view:RefillCells()
	else
		self.scroll_view:SetActive(false)
	end
end

local function ClearScroll(self)
	self.scroll_view:ClearCells()
	self.scroll_view:RemoveComponents(UICommonItem)
end

local function OnCreateCell(self, itemObj, index)
	itemObj.name =  tostring(index)
	local cellItem = self.scroll_view:AddComponent(UICommonItem, itemObj)
	cellItem:ReInit(self.dataList[index])
end

local function OnDeleteCell(self, itemObj, index)
	self.scroll_view:RemoveComponent(itemObj.name, UICommonItem)
end

local function ShowAd(self, refresh)
	self.adInited = true
	self.isAd = true
	self.adData = DataCenter.WatchAdManager:GetDataByLocation(WatchAdLocation.GiftPackage)
	local isWatching = DataCenter.WatchAdManager:IsWatching()
	local adTemplate = DataCenter.WatchAdManager:GetTemplate(self.adData.id)
	local watchNum = self.adData:GetWatchNum()
	local restNum = adTemplate.limit_times - watchNum
	local canWatch = not isWatching and restNum > 0
	local diamond = 0
	self.dataList = {}
	local rewards = DataCenter.RewardManager:ReturnRewardParamForView(self.adData.reward)
	for _, reward in ipairs(rewards) do
		if reward.rewardType == RewardType.GOLD then
			diamond = reward.count
		elseif reward.rewardType == RewardType.GOODS then
			local param = {}
			param.rewardType = RewardType.GOODS
			param.itemId = reward.itemId
			param.count = reward.count
			table.insert(self.dataList, param)
		end
	end
	
	self.bg_image:LoadSprite("Assets/Main/TextureEx/UIGiftPackage/ui_advBg_AD_midlle")
	self.title_text:SetLocalText(321308)
	self.hot_go:SetActive(false)
	self.desc_text:SetLocalText(321309)
	self.diamond_text:SetText(string.GetFormattedSeperatorNum(diamond))
	self.price_text:SetLocalText(isWatching and 100231 or 130126)
	self.discount_bg_go:SetActive(false)
	self.limit_text:SetLocalText(140403, restNum)
	self.time_text:SetText("")
	self.id_text:SetText("")
	self.point_rect:SetActive(false)
	self.ad_icon_go:SetActive(not isWatching)
	self.ad_red_go:SetActive(canWatch)
	--self.ad_red_go:SetActive(DataCenter.WatchAdManager:CanShowRed(self.adData.id))
	CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.price_text.transform)
	CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.price_text.transform.parent)
	UIGray.SetGray(self.btn.transform, not canWatch, canWatch)
	self:ShowScroll()
	DataCenter.WatchAdManager:SetRedTime(self.adData.id)
end

local function ReInit(self, param)
	self.isAd = false
	self.param = param
	local pack = self.param.info
	local bgIcon = pack:getPopupImageMini()
	self.bg_image:LoadSprite(string.format(LoadPath.UIGiftPackageEx, bgIcon))
	self.title_text:SetLocalText(pack:getName())
	local discountTips = pack:GetDiscountTips()
	self.hot_go:SetActive(discountTips[2])
	local descColor = DescColor[bgIcon] or DescColor["Default"]
	self.desc_text:SetText(string.format("<color=%s>%s</color>", descColor, pack:getDescText()))
	self.diamond_text:SetText(string.GetFormattedSeperatorNum(tonumber(pack:getDiamond())))
	self.price_text:SetText(DataCenter.PayManager:GetDollarText(pack:getPrice(), pack:getProductID()))
	local discount = pack:hasPercent() and tonumber(pack:getPercent()) or 0
	self.discount_bg_go:SetActive(discount > 0)
	self.discount_text:SetText(string.format("%s%%", discount))
	if not string.IsNullOrEmpty(discountTips[1]) then
		self.limit_text:SetActive(true)
		self.limit_text:SetText(discountTips[1])
	else
		self.limit_text:SetActive(false)
	end
	self.id_text:SetText(LuaEntry.Player:GetGMFlag() > 0 and pack:getID() or "")
	self.point_rect:SetActive(true)
	self.point_rect:RefreshPoint(pack)
	self.ad_icon_go:SetActive(false)
	self.ad_red_go:SetActive(false)
	
	self.dataList = self:GetDataList()
	self:ShowScroll()
	UIGray.SetGray(self.btn.transform, false, true)
	self:TimerAction()
end

local function ShowArrow(self)
	local param = {}
	param.position = self.btn.transform.position
	param.arrowType = ArrowType.Normal
	param.positionType = PositionType.Screen
	TimerManager:GetInstance():DelayInvoke(function()
		DataCenter.ArrowManager:ShowArrow(param)
	end, 0.1)
end

local function GetDataList(self)
	local dataList = {}
	local pack = self.param.info
	
	-- 英雄
	local heroStr = pack:getHeroesStr()
	if (not string.IsNullOrEmpty(heroStr)) then
		local arr = string.split(heroStr, ";")
		if (#arr == 2) then
			local param = {}
			param.rewardType = RewardType.HERO
			param.heroId = arr[1]
			param.count = arr[2]
			table.insert(dataList,param)
		end
	end
	
	-- 普通道具
	local str = pack:getItemsStr()
	local _item_use = pack:getItemUse()
	if _item_use ~= nil and _item_use ~= "" then
		str = _item_use .. "|" .. str 
	end
	
	local arrMiddle = string.split(str,"|")
	if arrMiddle ~= nil and #arrMiddle > 0 then
		for k,v in ipairs(arrMiddle) do
			local arr = string.split(v,";")
			if arr[1] ~= "" then
				local param = {}
				param.rewardType = RewardType.GOODS
				param.itemId = arr[1]
				param.count = arr[2]
				table.insert(dataList,param)
			end
		end
	end
	
	--联盟礼物
	local arrAlliance = pack:getAllianceGift()
	if arrAlliance ~= nil and #arrAlliance > 0 then
		for k,v in ipairs(arrAlliance) do
			local arr = string.split(v,";")
			if #arr > 4 then
				local param = {}
				param.rewardType = RewardType.GOODS
				param.iconName = string.format(LoadPath.UIAllianceGift, arr[1])
				param.itemName = arr[2]
				param.itemDesc = arr[3]
				param.count = arr[4]
				param.itemColor = arr[5]
				table.insert(dataList,param)
			end
		end
	end
	
	return dataList
end

local function OnClick(self)
	SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
	if self.isAd then
		DataCenter.WatchAdManager:Watch(self.adData.id)
		self:ShowAd(true)
	else
		self.view.ctrl:BuyGift(self.param.info)
	end
end

local function OnWatchAdReceive(self)
	if self.isAd then
		self:ShowAd(true)
	end
end

GoldExchangeNormalLuaView.OnCreate = OnCreate
GoldExchangeNormalLuaView.OnDestroy = OnDestroy
GoldExchangeNormalLuaView.ComponentDefine = ComponentDefine
GoldExchangeNormalLuaView.ComponentDestroy = ComponentDestroy
GoldExchangeNormalLuaView.DataDefine = DataDefine
GoldExchangeNormalLuaView.DataDestroy = DataDestroy

GoldExchangeNormalLuaView.ShowScroll = ShowScroll
GoldExchangeNormalLuaView.ClearScroll = ClearScroll
GoldExchangeNormalLuaView.OnCreateCell = OnCreateCell
GoldExchangeNormalLuaView.OnDeleteCell = OnDeleteCell

GoldExchangeNormalLuaView.TimerAction = TimerAction
GoldExchangeNormalLuaView.ShowAd = ShowAd
GoldExchangeNormalLuaView.ReInit = ReInit
GoldExchangeNormalLuaView.GetDataList = GetDataList
GoldExchangeNormalLuaView.ShowArrow = ShowArrow

GoldExchangeNormalLuaView.OnClick = OnClick
GoldExchangeNormalLuaView.OnWatchAdReceive = OnWatchAdReceive

return GoldExchangeNormalLuaView 