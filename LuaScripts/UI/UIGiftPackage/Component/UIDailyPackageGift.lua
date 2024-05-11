--[[
    礼包
--]]

local UICommonItem = require "UI.UICommonItem.UICommonItem"
local UIGiftPackagePoint = require "UI.UIGiftPackage.Component.UIGiftPackagePoint"
local UIDailyPackageGift = BaseClass("UIDailyPackageGift", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
--创建
function UIDailyPackageGift:OnCreate()
	base.OnCreate(self)
	self:ComponentDefine()
	self:DataDefine()
end

-- 销毁
function UIDailyPackageGift:OnDestroy()
	self:ClearScroll()
	self:ComponentDestroy()
	self:DataDestroy()
	base.OnDestroy(self)
end


--控件的定义
function UIDailyPackageGift:ComponentDefine()
	self.reward_rect 	= self:AddComponent(UIBaseContainer,"ScrollView/Viewport/Content")

	self._buy_btn		= self:AddComponent(UIButton,"Btn_Buy")
	self._buy_btn:SetOnClick(function()
		self:OnClickReward()
	end)
	
	self._price_txt		= self:AddComponent(UITextMeshProUGUIEx,"Btn_Buy/Txt_Price")
	self._point			= self:AddComponent(UIGiftPackagePoint,"Btn_Buy/UIGiftPackagePoint")
	
	self.discountTxt = self:AddComponent(UITextMeshProUGUIEx, "discountBg/txtDiscount")
	self.diamondTxt = self:AddComponent(UITextMeshProUGUIEx, "txtDiamond")
	self.icon = self:AddComponent(UIImage,"ItemIcon")
	self.num = self:AddComponent(UITextMeshProUGUIEx, "ItemIcon/NumText")
	self.btn = self:AddComponent(UIButton,"ItemIcon")
	self.btn:SetOnClick(function()
		self:OnDetailClick()
	end)
end

--控件的销毁
function UIDailyPackageGift:ComponentDestroy()
	self._buy_btn = nil
	self._price_txt = nil
	self._point = nil
end

--变量的定义
function UIDailyPackageGift:DataDefine()
	self.param = {}
end

--变量的销毁
function UIDailyPackageGift:DataDestroy()

end

function UIDailyPackageGift:ReInit(param,arr,groupBuy)
	self.packageInfo = param
	local goodsId = toInt(arr[1])
	local goodsNum = toInt(arr[2])
	self.goodsId = goodsId
	self.num:SetText(goodsNum)
	local template = DataCenter.ItemTemplateManager:GetItemTemplate(goodsId)
	if template ~= nil then
		self.icon:LoadSprite(string.format(LoadPath.ItemPath,template.icon))
	end
	self._price_txt:SetText(self.packageInfo:getPriceText() )
	self.discountTxt:SetText(self.packageInfo:getPercent().."%")
	self.diamondTxt:SetText("x"..self.packageInfo:getDiamond())
	--积分
	self._point:RefreshPoint(self.packageInfo)

	if self.packageInfo:isBought() or groupBuy then
		CS.UIGray.SetGray(self._buy_btn.transform, true, false)
		self._price_txt:SetText(Localization:GetString("320268"))
	else
		CS.UIGray.SetGray(self._buy_btn.transform, false, true)
	end

	self:RefreshReward()
end

function UIDailyPackageGift:RefreshReward()
	local list = self:GetRewardList()
	self:ClearScroll()
	self.model = {}
	for i = 1, table.length(list) do
		--复制基础prefab，每次循环创建一次
		self.model[i] = self:GameObjectInstantiateAsync(UIAssets.UICommonItemSize, function(request)
			if request.isError then
				return
			end
			local go = request.gameObject;
			go.gameObject:SetActive(true)
			go.transform:SetParent(self.reward_rect.transform)
			go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
			go.name ="item" .. i
			local cell = self.reward_rect:AddComponent(UICommonItem,go.name)
			cell:ReInit(list[i])
			cell.rectTransform.sizeDelta = { x=85,y=85 }
		end)
	end
end

function UIDailyPackageGift:GetRewardList()
	local listParam = self.packageInfo:GetRewardList()
	local arrAlliance = self.packageInfo:getAllianceGift()
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
				table.insert(listParam,param)
			end
		end
	end
	local list = {}
	for i=1,#listParam do
		local item = listParam[i]
		if item.rewardType ~= RewardType.GOLD then
			table.insert(list,item)
		end
	end
	return list
end

function UIDailyPackageGift:ClearScroll()
	self.reward_rect:RemoveComponents(UICommonItem)
	if self.model~=nil then
		for k,v in pairs(self.model) do
			if v ~= nil then
				self:GameObjectDestroy(v)
			end
		end
	end
end

function UIDailyPackageGift:OnClickReward()
	self.view.ctrl:BuyGift(self.packageInfo)
end

function UIDailyPackageGift:OnDetailClick()
	if self.goodsId  ~= nil then
		local param = {}
		param["itemId"] = self.goodsId
		param["alignObject"] = self.btn
		UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips,{anim = true}, param)
		
	end
end
return UIDailyPackageGift