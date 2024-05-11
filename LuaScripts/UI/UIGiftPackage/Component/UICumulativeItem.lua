--[[
    礼包
--]]

local UIGiftItem = require "UI.UIGiftPackage.Component.UICumulativeRewardItem"
local UICumulativeItem = BaseClass("UICumulativeItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

local txt_score_path = "Txt_Score"
local img_actTypeIcon_path = "Img_ActTypeIcon"
local event_trigger_path = "CellScroll/Viewport/CellScrollEventTrigger"
local scroll_view_path = "CellScroll"
local btn_reward_path = "Btn_Reward"
local mask_img_path = "Img_Mask"
local receiveTxt_path = "receivedText"
local rewardText_path = "Btn_Reward/rewardText"
local processBg_path = "processBg"
local imgUp_path = "imgUp"
local imgDown_path = "imgDown"

--创建
local function OnCreate(self)
	base.OnCreate(self)
	self:ComponentDefine()
	self:DataDefine()
end

-- 销毁
local function OnDestroy(self)
	self:ClearScroll()
	self:ComponentDestroy()
	self:DataDestroy()
	base.OnDestroy(self)
end


--控件的定义
local function ComponentDefine(self)
	self._score_txt = self:AddComponent(UITextMeshProUGUIEx,txt_score_path)
	self._actTypeIcon_img = self:AddComponent(UIImage,img_actTypeIcon_path)
	self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
	self.event_trigger = self:AddComponent(UIEventTrigger, event_trigger_path)
	self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
		self:OnCreateCell(itemObj, index)
	end)
	self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
		self:OnDeleteCell(itemObj, index)
	end)
	
	self.event_trigger:OnDrag(function(eventData)
		self:OnDrag(eventData)
	end)
	self.event_trigger:OnBeginDrag(function(eventData)
		self:OnBeginDrag(eventData)
	end)
	self.event_trigger:OnEndDrag(function(eventData)
		self:OnEndDrag(eventData)
	end)
	
	self._reward_btn = self:AddComponent(UIButton,btn_reward_path)
	self._reward_btn:SetOnClick(function()
		self:OnClickReward()
	end)
	self.rewardText = self:AddComponent(UITextMeshProUGUIEx, rewardText_path)
	self.rewardText:SetLocalText(470063)
	
	self._mask_img = self:AddComponent(UIImage,mask_img_path)
	self.receiveTxt = self:AddComponent(UITextMeshProUGUIEx, receiveTxt_path)
	self.receiveTxt:SetLocalText(110461)
	
	self.processBg = self:AddComponent(UIImage, processBg_path)
	self.imgUp = self:AddComponent(UIImage, imgUp_path)
	self.imgDown = self:AddComponent(UIImage, imgDown_path)
end

--控件的销毁
local function ComponentDestroy(self)
	self.image = nil
	self.title_name = nil
	self.time = nil
	self.desc = nil
	self.money = nil
	self.cur_price = nil
	self.last_price = nil
	self.buy_btn = nil
	self.scroll_view = nil
	self.event_trigger = nil
	self.img_desc = nil
	self._mask_img = nil
end

--变量的定义
local function DataDefine(self)
	self.param = {}
	self.listParam = {}
	self.position = nil
	self.needTrans = nil
	self.cell = {}
	self.itemList = {}
end

--变量的销毁
local function DataDestroy(self)
	self.param = nil
	self.listParam = nil
	self.position = nil
	self.needTrans = nil
	self.cell = nil
	if self.delayTime ~= nil then
		self.delayTime:Stop()
		self.delayTime = nil
	end
end

local function ReInit(self, param)
    self.param = param
	self._actTypeIcon_img:LoadSprite(string.format(LoadPath.ItemPath, param.imgPath))
	self._score_txt:SetText(self.param.info.needScore)
	if self.param.info.needScore <= self.param.curScore and self.param.info.state == 0 then 	--能够领取
		self._reward_btn:SetActive(true)
		CS.UIGray.SetGray(self._reward_btn.transform, false, true)
		self.receiveTxt:SetActive(false)
		self._mask_img:LoadSprite("Assets/Main/Sprites/UI/UITaskMain/task_bg_di02_2.png")
	elseif self.param.info.state == 1 then	--领取过
		self._reward_btn:SetActive(false)
		self._mask_img:LoadSprite("Assets/Main/Sprites/UI/UITaskMain/task_bg_di02_3.png")
		self.receiveTxt:SetActive(true)
	else									--积分不够
		self._reward_btn:SetActive(true)
		CS.UIGray.SetGray(self._reward_btn.transform, true, false)
		self.receiveTxt:SetActive(false)
		self._mask_img:LoadSprite("Assets/Main/Sprites/UI/UITaskMain/task_bg_di02.png")
	end
	self:RefreshProcess()
	self.listParam = self.param.info.reward
	self:ClearScroll()
	if (#self.listParam > 0) then
		self.scroll_view:SetTotalCount(#self.listParam)
		self.scroll_view:RefillCells()
	end
end

--领奖返回
local function RewardUpdate(self)
	self._reward_btn:SetActive(false)
	self._mask_img:LoadSprite("Assets/Main/Sprites/UI/UITaskMain/task_bg_di02_3.png")
	self.receiveTxt:SetActive(true)
	for i, v in pairs(self.cell) do
		v:SetCheckActive(1)
	end
end

local function OnCreateCell(self,itemObj, index)
	itemObj.name =  tostring(index)
	local cellItem = self.scroll_view:AddComponent(UIGiftItem, itemObj)
	cellItem:ReInit(self.listParam[index],self.param.info.state)
	self.cell[index] = cellItem
end

local function OnDeleteCell(self,itemObj, index)
	self.scroll_view:RemoveComponent(itemObj.name, UIGiftItem)
end

local function ClearScroll(self)
	self.scroll_view:ClearCells()--清循环列表数据
	self.scroll_view:RemoveComponents(UIGiftItem)--清循环列表gameObject
end

local function OnBeginDrag(self,eventData)
	self.needTrans = nil
	self.position = eventData.position
	if self.param.scrollView ~= nil then
		self.param.scrollView:OnBeginDrag(eventData)
	end
	self.scroll_view:OnBeginDrag(eventData)
end

local function OnEndDrag(self,eventData)
	self.needTrans = nil
	if self.param.scrollView ~= nil then
		self.param.scrollView:OnEndDrag(eventData)
	end
	self.scroll_view:OnEndDrag(eventData)
end

local function OnDrag(self,eventData)
	if self.needTrans == nil then
		local X = math.abs(eventData.position.x - self.position.x)
		local Y = math.abs(eventData.position.y - self.position.y)
		if X > Y then
			self.needTrans = false
		elseif X < Y then
			self.needTrans = true
		end
	end
	if self.needTrans ~= nil then
		if self.needTrans then
			if self.param.scrollView ~= nil then
				self.param.scrollView:OnDrag(eventData)
			end
		else
			self.scroll_view:OnDrag(eventData)
		end 
	end
end

local function OnClickReward(self)
	DataCenter.CumulativeRechargeManager:SendReward(self.param.rechargeId,self.param.info.stageId)
end

local function RefreshProcess(self)
	if self.param.isFirst then
		self.processBg:LoadSprite("Assets/Main/Sprites/UI/UICumulativrecharge/torch_bar_a01.png")
		self.imgUp:LoadSprite("Assets/Main/Sprites/UI/UICumulativrecharge/torch_bar_a02.png")
		self.imgDown:LoadSprite("Assets/Main/Sprites/UI/UICumulativrecharge/torch_bar_b02.png")
	elseif self.param.isLast1 then
		self.processBg:LoadSprite("Assets/Main/Sprites/UI/UICumulativrecharge/torch_bar_d01.png")
		self.imgUp:LoadSprite("Assets/Main/Sprites/UI/UICumulativrecharge/torch_bar_b02.png")
		self.imgDown:LoadSprite("Assets/Main/Sprites/UI/UICumulativrecharge/torch_bar_d02.png")
	elseif self.param.isLast2 then
		self.processBg:LoadSprite("Assets/Main/Sprites/UI/UICumulativrecharge/torch_bar_c01.png")
		self.imgUp:LoadSprite("Assets/Main/Sprites/UI/UICumulativrecharge/torch_bar_b02.png")
		self.imgDown:LoadSprite("Assets/Main/Sprites/UI/UICumulativrecharge/torch_bar_b02.png")
	else
		self.processBg:LoadSprite("Assets/Main/Sprites/UI/UICumulativrecharge/torch_bar_b01.png")
		self.imgUp:LoadSprite("Assets/Main/Sprites/UI/UICumulativrecharge/torch_bar_b02.png")
		self.imgDown:LoadSprite("Assets/Main/Sprites/UI/UICumulativrecharge/torch_bar_b02.png")
	end
	self.imgUp:SetActive(self.param.showUp)
	self.imgDown:SetActive(self.param.showDown)
end

UICumulativeItem.OnCreate = OnCreate
UICumulativeItem.OnDestroy = OnDestroy
UICumulativeItem.ReInit = ReInit
UICumulativeItem.ComponentDefine = ComponentDefine
UICumulativeItem.ComponentDestroy = ComponentDestroy
UICumulativeItem.DataDefine = DataDefine
UICumulativeItem.DataDestroy = DataDestroy
UICumulativeItem.OnClickReward = OnClickReward
UICumulativeItem.ClearScroll = ClearScroll
UICumulativeItem.OnCreateCell = OnCreateCell
UICumulativeItem.OnDeleteCell = OnDeleteCell
UICumulativeItem.RewardUpdate = RewardUpdate
UICumulativeItem.OnDrag = OnDrag
UICumulativeItem.OnEndDrag = OnEndDrag
UICumulativeItem.OnBeginDrag = OnBeginDrag
UICumulativeItem.RefreshProcess = RefreshProcess

return UICumulativeItem 