--- Created by shimin.
--- DateTime: 2024/1/19 10:26
--- 加速界面礼包cell

local UISpeedGiftCell = BaseClass("UISpeedGiftCell", UIBaseContainer)
local base = UIBaseContainer
local UICommonItem = require "UI.UICommonItem.UICommonItem"

local gift_btn_path = "gift_btn"
local gift_btn_text_path = "gift_btn/gift_btn_text"
local gift_text_path = "gift_text"
local gift_scroll_view_path = "gift_scroll_view"
local discount_text_path = "discount_bg/discount_text"

local SpeedGiftType =
{
	Normal = 1,
	Build = 2,
	Science = 3,
	Solider = 4,
	Hospital = 5,
}

function UISpeedGiftCell:OnCreate()
	base.OnCreate(self)
	self:ComponentDefine()
	self:DataDefine()
end

function UISpeedGiftCell:OnDestroy()
	self:ComponentDestroy()
	self:DataDestroy()
	base.OnDestroy(self)
end

function UISpeedGiftCell:OnEnable()
	base.OnEnable(self)
end

function UISpeedGiftCell:OnDisable()
	base.OnDisable(self)
end

function UISpeedGiftCell:ComponentDefine()
	self.gift_btn = self:AddComponent(UIButton, gift_btn_path)
	self.gift_btn:SetOnClick(function()
		SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
		self:OnGiftBtnClick()
	end)
	self.gift_btn_text = self:AddComponent(UITextMeshProUGUIEx, gift_btn_text_path)
	self.gift_text = self:AddComponent(UITextMeshProUGUIEx, gift_text_path)
	self.gift_scroll_view = self:AddComponent(UIScrollView, gift_scroll_view_path)
	self.gift_scroll_view:SetOnItemMoveIn(function(itemObj, index)
		self:OnGiftCellMoveIn(itemObj, index)
	end)
	self.gift_scroll_view:SetOnItemMoveOut(function(itemObj, index)
		self:OnGiftCellMoveOut(itemObj, index)
	end)
	self.discount_text = self:AddComponent(UITextMeshProUGUIEx, discount_text_path)
end

function UISpeedGiftCell:ComponentDestroy()
end

function UISpeedGiftCell:DataDefine()
	self.param = {}
	self.packageInfo = nil
	self.gift_list = {}
end

function UISpeedGiftCell:DataDestroy()
end

function UISpeedGiftCell:ReInit(packageInfo)
	self.packageInfo = packageInfo
	if self.packageInfo ~= nil then
		self:SetActive(true)
		self.gift_text:SetLocalText(self.packageInfo:getName())
		local price = DataCenter.PayManager:GetDollarText(self.packageInfo:getPrice(), self.packageInfo:getProductID())
		self.gift_btn_text:SetText(price)
		if self.packageInfo:hasPercent() then
			self.discount_text:SetText(self.packageInfo:getPercent() .. "%")
		end
		self:ShowGiftCells()
	else
		self:SetActive(false)
	end
end

function UISpeedGiftCell:GetGiftDataList()
	self.gift_list = DataCenter.RewardManager:ParsePackReward(self.packageInfo) or {}
end

function UISpeedGiftCell:ShowGiftCells()
	self:ClearGiftScroll()
	self:GetGiftDataList()
	local count = table.count(self.gift_list)
	if count > 0 then
		self.gift_scroll_view:SetTotalCount(count)
		self.gift_scroll_view:RefillCells()
	end
end

function UISpeedGiftCell:ClearGiftScroll()
	self.gift_scroll_view:ClearCells()--清循环列表数据
	self.gift_scroll_view:RemoveComponents(UICommonItem)--清循环列表gameObject
end

function UISpeedGiftCell:OnGiftCellMoveIn(itemObj, index)
	itemObj.name = tostring(index)
	local item = self.gift_scroll_view:AddComponent(UICommonItem, itemObj)
	item:ReInit(self.gift_list[index])
end

function UISpeedGiftCell:OnGiftCellMoveOut(itemObj, index)
	self.gift_scroll_view:RemoveComponent(itemObj.name, UICommonItem)
end

function UISpeedGiftCell:OnGiftBtnClick()
	DataCenter.PayManager:CallPayment(self.packageInfo, UIWindowNames.UIResourceBag)
end

return UISpeedGiftCell