--[[
    礼包
--]]

local UIFirstChargeReward = require "UI.UIGiftPackage.Component.FirstCharge.UIFirstChargeReward"
local UIFirstChargeItem = BaseClass("UIFirstChargeItem", UIBaseContainer)
local base = UIBaseContainer
local ReceiveColor = Color.New(0.5,0.9,0.2,1)
--创建
function UIFirstChargeItem:OnCreate()
	base.OnCreate(self)
	self:ComponentDefine()
	self:DataDefine()
end

-- 销毁
function UIFirstChargeItem:OnDestroy()
	self:ClearScroll()
	self:ComponentDestroy()
	self:DataDestroy()
	base.OnDestroy(self)
end

--控件的定义
function UIFirstChargeItem:ComponentDefine()

	self.scroll_view = self:AddComponent(UIScrollView, "CellScroll")
	self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
		self:OnCreateCell(itemObj, index)
	end)
	self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
		self:OnDeleteCell(itemObj, index)
	end)
	
	self._day_txt = self:AddComponent(UITextMeshProUGUIEx,"Txt_Day")
	
	self._desc1_txt = self:AddComponent(UITextMeshProUGUIEx,"Rect_GiftDesc/Txt_Desc1")
	self._desc2_txt = self:AddComponent(UITextMeshProUGUIEx,"Rect_GiftDesc/Txt_Desc2")
end

--控件的销毁
function UIFirstChargeItem:ComponentDestroy()

end

--变量的定义
function UIFirstChargeItem:DataDefine()
	local list = LuaEntry.DataConfig:TryGetStr("first_pay_choosen", "k5")
	self.itemList = string.split(list,";")
end

--变量的销毁
function UIFirstChargeItem:DataDestroy()

end

---@param day number 第几天
---@param state number 未领取0 已经领取1 
---@param reward table 奖励
function UIFirstChargeItem:ReInit(param)
	self.list = DataCenter.RewardManager:ReturnRewardParamForMessage(param["reward"])
	self.isReceive = param.state == 1
	self:ClearScroll()
	local itemCount = table.count(self.itemList)
	for i = 1, table.count(self.list) do
		if self.list[i].itemId then
			for k = 1, itemCount do
				if self.list[i].itemId == self.itemList[k] then
					self.list[i].vfx = true
				end
			end
		end
	end
	if (#self.list > 0) then
		self.scroll_view:SetTotalCount(#self.list)
		self.scroll_view:RefillCells()
	end
	if self.isReceive then
		self._day_txt:SetLocalText(170003)
		self._day_txt:SetColor(ReceiveColor)
	else
		self._day_txt:SetLocalText(321175,param.day)
		self._day_txt:SetColor(WhiteColor)
	end
end

---@param param string 礼包ID
---@param isReceive boolean 是否已领取
function UIFirstChargeItem:ReInitFirst(param,isReceive)
	self.packageInfo = GiftPackageData.get(param)
	self.isReceive = isReceive
	self.list = self.packageInfo:GetRewardList()
	for i = 1, table.count(self.list) do
		if self.list[i].rewardType == RewardType.GOLD then
			table.remove(self.list,i)
			break
		end
	end
	local itemCount = table.count(self.itemList)
	for i = 1, table.count(self.list) do
		if self.list[i].itemId then
			for k = 1, itemCount do
				if self.list[i].itemId == self.itemList[k] then
					self.list[i].vfx = true
				end
			end
		end
	end
	self.offsetPos = Vector3.New(35,15,0)
	local scaleFactor = UIManager:GetInstance():GetScaleFactor()
	self.offsetPos.x = self.offsetPos.x * scaleFactor
	self.offsetPos.y = self.offsetPos.y * scaleFactor
	self:ClearScroll()
	if (#self.list > 0) then
		self.scroll_view:SetTotalCount(#self.list)
		self.scroll_view:RefillCells()
	end
	if isReceive then
		self._day_txt:SetLocalText(170003)
		self._day_txt:SetColor(ReceiveColor)
	else
		self._day_txt:SetLocalText(321175,1)
		self._day_txt:SetColor(WhiteColor)
	end
end

---@param strList table dialog
function UIFirstChargeItem:RefreshDes(strList)
	self._desc1_txt:SetActive(strList[1])
	self._desc2_txt:SetActive(strList[2])
	if strList[1] then
		self._desc1_txt:SetLocalText(strList[1])
	end
	if strList[2] then
		self._desc2_txt:SetLocalText(strList[2])
	end
end

function UIFirstChargeItem:OnCreateCell(itemObj, index)
	itemObj.name =  tostring(index)
	local cellItem = self.scroll_view:AddComponent(UIFirstChargeReward, itemObj)
	cellItem:ReInit(self.list[index],self.isReceive)
	cellItem:SetCheckActive(self.isReceive)
	
	if self.list[index].rewardType == RewardType.HERO then
		cellItem:SetHeroTypeTipPos(self.offsetPos)
	end
end

function UIFirstChargeItem:OnDeleteCell(itemObj, index)
	self.scroll_view:RemoveComponent(itemObj.name, UIFirstChargeReward)
end

function UIFirstChargeItem:ClearScroll()
	self.scroll_view:ClearCells()--清循环列表数据
	self.scroll_view:RemoveComponents(UIFirstChargeReward)--清循环列表gameObject
end

return UIFirstChargeItem 