---------------------------------------------------------------------
-- dr_client (C) CompanyName, All Rights Reserved
-- Created by: AuthorName
-- Date: 2024-03-22 13:30:25
---------------------------------------------------------------------

-- To edit this template in: Data/Config/Template.lua
-- To disable this template, check off menuitem: Options-Enable Template File

---class UIHeroEquipMake
local UIHeroEquipMake = BaseClass("UIHeroEquipMake", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

local UICommonItem = require "UI.UICommonItem.UICommonItem"
local UIHeroEquipInfoAttrCell2 = require "UI.UIHeroEquip.Component.UIHeroEquipInfoAttrCell2"
local UIHeroEquipSelectCell = require "UI.UIHeroEquip.Component.UIHeroEquipSelectCell"

local equip_name_text_path = "EquipName"
local equip_power_text_path = "EffectNode/Power/Power"
local equip_img_path = "Image"
local equip_effect_scroll_view_path = "EffectNode/EffectScrollView"
local material_num_text_path = "MaterialNode/MaterialNum"
local material_go_path = "MaterialNode"
local material_scroll_view_path = "MaterialNode/MaterialScrollView"
local equip_scroll_view_path = "EquipListNode/EquipListScrollView"
local slider_path = "Slider"
local slider_text_path = "Slider/SliderTimeText"
local equip_toggle_path = "EquipListNode/ToggleGroup/Toggle%s"
local make_go_path = "Btn/Make"
local make_btn_path = "Btn/Make/MakeBtn"
local make_text_path = "Btn/Make/MakeBtn/GameObject/MakeBtnText"
local make_time_text_path = "Btn/Make/TimeText"
local not_make_go_path = "Btn/NotMake"
local not_make_btn_path = "Btn/NotMake/NotMakeBtn"
local not_make_text_path = "Btn/NotMake/NotMakeBtn/NotMakeBtnText"
local unlock_text_path = "Btn/NotMake/UnlockText"
local speed_up_go_path = "Btn/SpeedUp"
local speed_up_btn_path = "Btn/SpeedUp/SpeedUpBtn"
local speed_up_text_path = "Btn/SpeedUp/SpeedUpBtn/SpeedUpBtnText"
local collect_go_path = "Btn/Collect"
local collect_btn_path = "Btn/Collect/CollectBtn"
local collect_text_path = "Btn/Collect/CollectBtn/CollectBtnText"
local make_res_image_path = "Btn/Make/MakeBtn/GameObject/Res/ResIcon"
local make_res_text_path = "Btn/Make/MakeBtn/GameObject/ResText"

local SliderLength = 242

local BtnName =
{
	[HeroEquipConst.Position.Equip_Position_1] = GameDialogDefine.HERO_EQUIP1,
	[HeroEquipConst.Position.Equip_Position_2] = GameDialogDefine.HERO_EQUIP2,
	[HeroEquipConst.Position.Equip_Position_3] = GameDialogDefine.HERO_EQUIP3,
	[HeroEquipConst.Position.Equip_Position_4] = GameDialogDefine.HERO_EQUIP4,
}

local BtnState =
{
	Make = 1,
	NoteMake = 2,
	SpeedUp = 3,
	Making = 4,
	Lock = 5,
}

function UIHeroEquipMake:OnCreate()
	base.OnCreate(self)
	self:DataDefine()
	self:ComponentDefine()
end

function UIHeroEquipMake:OnDestroy()
	self:DeleteTimer()
	self:ComponentDestroy()
	self:DataDestroy()
	base.OnDestroy(self)
end

function UIHeroEquipMake:DataDefine()
	self.curType = HeroEquipConst.Position.Equip_Position_1
	self.selectIndex = 1
	self.lastChangeImageDeltaTime = 0
	self.lastChangeTextDeltaTime = 0
	self.toggle = {}
	self.materialList = {}
	self.equipList = {}
end

function UIHeroEquipMake:DataDestroy()
	self.curType = 0
	self.selectIndex = 0
	self.lastChangeImageDeltaTime = 0
	self.lastChangeTextDeltaTime = 0
	self.toggle = {}
	self.materialList = {}
	self.equipList = {}
end

function UIHeroEquipMake:ComponentDefine()
	self:DefineEquip()
	self:DefineEquipEffectList()
	self:DefineEquipTime()
	self:DefineMaterialList()
	self:DefineEquipList()
	self:DefineEquipListToggle()
	self:DefineBtn()

	self.makeResIcon = self:AddComponent(UIImage, make_res_image_path)
	self.makeResText = self:AddComponent(UITextMeshProUGUIEx, make_res_text_path)
	self.makeTimeText = self:AddComponent(UITextMeshProUGUIEx, make_time_text_path)
	self.unlockText = self:AddComponent(UITextMeshProUGUIEx, unlock_text_path)
	self.materialNum = self:AddComponent(UITextMeshProUGUIEx, material_num_text_path)
	self.materialNode = self:AddComponent(UITextMeshProUGUIEx, material_go_path)
	self.timerAction = function(temp)
		self:UpdateSlider()
	end
end

function UIHeroEquipMake:ComponentDestroy()

end

function UIHeroEquipMake:OnEnable()
	base.OnEnable(self)

	self:ReInit()
end

function UIHeroEquipMake:OnDisable()
	base.OnDisable(self)
end

function UIHeroEquipMake:OnAddListener()
	base.OnAddListener(self)
	self:AddUIListener(EventId.HeroEquipStartProduct, self.OnRefresh)
	self:AddUIListener(EventId.AddSpeedSuccess, self.OnRefresh)
	self:AddUIListener(EventId.HeroEquipQueueFinish, self.OnRefresh)

	self:AddUIListener(EventId.OnSelectMakePartEquip, self.RefreshSelectState)
end

function UIHeroEquipMake:OnRemoveListener()
	base.OnRemoveListener(self)
	self:RemoveUIListener(EventId.HeroEquipStartProduct, self.OnRefresh)
	self:RemoveUIListener(EventId.AddSpeedSuccess, self.OnRefresh)
	self:RemoveUIListener(EventId.HeroEquipQueueFinish, self.OnRefresh)

	self:RemoveUIListener(EventId.OnSelectMakePartEquip, self.RefreshSelectState)
end

function UIHeroEquipMake:RefreshSelectState(index)
	if self.equipList ~= nil then
		if 0 < index and index <= #self.equipList then
			self.selectIndex = index
			self.selectEquipId = self.equipList[index]
			self:RefreshEquip(self.selectEquipId)
			self:RefreshEquipEffectScrollView(self.selectEquipId)
			self:RefreshMaterialScrollView(self.selectEquipId)
			self:RefreshBtn(self.selectEquipId)
		end
	end
end

function UIHeroEquipMake:ReInit()
	self:RefreshToggleComplete()
	self:ToggleControlBorS(self.curType)
end

function UIHeroEquipMake:OnRefresh(queueType)
	if queueType == nil or queueType == NewQueueType.ProductEquip then
		self:RefreshToggleComplete()
		self:RefreshSelectState(self.selectIndex)
	end
end

function UIHeroEquipMake:RefreshToggleComplete()
	for k,v in pairs(HeroEquipConst.Position) do
		self.toggle[v].complete:SetActive(false)
	end
	
	local queue = DataCenter.QueueDataManager:GetQueueByType(NewQueueType.ProductEquip)
	if queue ~= nil then
		local queueState = queue:GetQueueState()
		if queueState == NewQueueState.Work or queueState == NewQueueState.Finish then
			local itemId = tonumber(queue.itemId)
			local template = DataCenter.HeroEquipTemplateManager:GetTemplate(itemId)
			if template ~= nil then
				self.toggle[template.slot].complete:SetActive(true)
			end
		end
	end
end

function UIHeroEquipMake:DefineEquip()
	self.equipName = self:AddComponent(UITextMeshProUGUIEx, equip_name_text_path)
	self.equipPower = self:AddComponent(UITextMeshProUGUIEx, equip_power_text_path)
	self.equipImage = self:AddComponent(UIImage, equip_img_path)
end

function UIHeroEquipMake:DefineEquipTime()
	self.slider = self:AddComponent(UISlider, slider_path)
	self.sliderText = self:AddComponent(UITextMeshProUGUIEx, slider_text_path)
end

function UIHeroEquipMake:DefineEquipListToggle()
	for k,v in pairs(HeroEquipConst.Position) do
		local toggle = self:AddComponent(UIToggle, string.format(equip_toggle_path, v))
		if toggle ~= nil then
			toggle:SetOnValueChanged(function(tf)
				if tf then
					SoundUtil.PlayEffect(SoundAssets.Music_Effect_change_toggle)
					self:ToggleControlBorS(v)
				end
			end)
			toggle.choose = toggle:AddComponent(UIBaseContainer, "Background/Checkmark")
			toggle.complete = toggle:AddComponent(UIImage, "Common_duihao")
			toggle.complete:SetActive(false)
			self.toggle[v] = toggle
		end
	end
end

function UIHeroEquipMake:ToggleControlBorS(index)
	self.curType = index

	for k,v in pairs(self.toggle) do
		if k == index then
			v.choose:SetActive(true)
			v:SetIsOn(true)
		else
			v.choose:SetActive(false)
			v:SetIsOn(false)
		end
	end

	self:RefreshEquipScrollView()
	EventManager:GetInstance():Broadcast(EventId.OnSelectMakePartEquip, 1)
end

function UIHeroEquipMake:DefineBtn()
	self.makeNode = self:AddComponent(UIBaseContainer, make_go_path)
	self.makeBtn = self:AddComponent(UIButton, make_btn_path)
	self.makeBtn:SetOnClick(function()
		SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
		self:OnMakeBtnClick()
	end)
	self.makeBtnText = self:AddComponent(UITextMeshProUGUIEx, make_text_path)
	self.makeBtnText:SetLocalText(GameDialogDefine.HERO_EQUIP1)
	
	self.notMakeNode = self:AddComponent(UIBaseContainer, not_make_go_path)
	self.notMakeBtn = self:AddComponent(UIButton, not_make_btn_path)
	self.notMakeBtn:SetOnClick(function()
		SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
		self:OnNotMakeBtnClick()
	end)
	self.notMakeBtnText = self:AddComponent(UITextMeshProUGUIEx, not_make_text_path)
	self.notMakeBtnText:SetLocalText(GameDialogDefine.HERO_EQUIP1)

	self.speedUpNode = self:AddComponent(UIBaseContainer, speed_up_go_path)
	self.speedUpBtn = self:AddComponent(UIButton, speed_up_btn_path)
	self.speedUpBtn:SetOnClick(function()
		SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
		self:OnSpeedUpBtnClick()
	end)
	self.speedUpBtnText = self:AddComponent(UITextMeshProUGUIEx, speed_up_text_path)
	self.speedUpBtnText:SetLocalText(GameDialogDefine.ADD_SPEED)

	self.collectNode = self:AddComponent(UIBaseContainer, collect_go_path)
	self.collectBtn = self:AddComponent(UIButton, collect_btn_path)
	self.collectBtn:SetOnClick(function()
		SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
		self:OnCollectBtnClick()
	end)
	self.collectBtnText = self:AddComponent(UITextMeshProUGUIEx, collect_text_path)
	self.collectBtnText:SetLocalText(GameDialogDefine.HERO_EQUIP39)
end

function UIHeroEquipMake:RefreshEquip(selectEquipId)
	if selectEquipId ~= nil then
		local template = DataCenter.HeroEquipTemplateManager:GetTemplate(selectEquipId)
		if template ~= nil then
			self.equipName:SetLocalText(template.name)
			self.equipImage:LoadSprite(HeroEquipUtil:GetEquipmentIcon(selectEquipId))
			self.makeTimeText:SetText(UITimeManager:GetInstance():SecondToFmtString(template.time))
			local power = DataCenter.HeroEquipTemplateManager:GetEquipmentPower(selectEquipId, 0, 0);
			self.equipPower:SetText(string.GetFormattedSeperatorNum(power))
			if template.resource ~= nil then
				for resType, resCost in pairs(template.resource) do
					local resIcon = DataCenter.ResourceManager:GetResourceIconByType(resType)
					self.makeResIcon:LoadSprite(resIcon)
					self.makeResText:SetText(resCost)
					break
				end
			end
		end
	end
end

function UIHeroEquipMake:DefineEquipEffectList()
	self.equipEffectScrollView = self:AddComponent(UIScrollView, equip_effect_scroll_view_path)
	self.equipEffectScrollView:SetOnItemMoveIn(function(itemObj, index)
		self:OnEquipEffectMoveIn(itemObj, index)
	end)
	self.equipEffectScrollView:SetOnItemMoveOut(function(itemObj, index)
		self:OnEquipEffectMoveOut(itemObj, index)
	end)
end

function UIHeroEquipMake:RefreshEquipEffectScrollView(selectEquipId)
	if selectEquipId ~= nil then
		self:ClearEquipEffectScrollView()
		
		local list = {}
		local base = DataCenter.HeroEquipTemplateManager:GetEquipmentBaseAttr(selectEquipId, 0, 0) or {}
		local baseCount = #base
		local fillCount = baseCount
		if baseCount % 2 ~= 0 then
			fillCount = baseCount + 1
		end
		for i = 1, fillCount do
			if i <= baseCount then
				table.insert(list, base[i])
			else
				table.insert(list, {})
			end
		end
		local addition = DataCenter.HeroEquipTemplateManager:GetEquipmentAdditionAttr(selectEquipId, 0, 0) or {}
		local additionCount = #addition
		for i = 1, additionCount do
			table.insert(list, addition[i])
		end
		
		self.effectsList = list
		local count = #self.effectsList
		if count > 0 then
			self.equipEffectScrollView:SetTotalCount(count)
			self.equipEffectScrollView:RefillCells()
		end
	end
end

function UIHeroEquipMake:ClearEquipEffectScrollView()
	self.equipEffectScrollView:ClearCells()
	self.equipEffectScrollView:RemoveComponents(UIHeroEquipInfoAttrCell2)
end

function UIHeroEquipMake:OnEquipEffectMoveIn(itemObj, index)
	itemObj.name = tostring(index)
	local cellItem = self.equipEffectScrollView:AddComponent(UIHeroEquipInfoAttrCell2, itemObj)
	cellItem:SetData(self.effectsList[index], index)
	self.equipEffectScrollView[index] = cellItem
end

function UIHeroEquipMake:OnEquipEffectMoveOut(itemObj, index)
	self.equipEffectScrollView:RemoveComponent(itemObj.name, UIHeroEquipInfoAttrCell2)
end

function UIHeroEquipMake:DefineMaterialList()
	self.materialScrollView = self:AddComponent(UIScrollView, material_scroll_view_path)
	self.materialScrollView:SetOnItemMoveIn(function(itemObj, index)
		self:OnMaterialMoveIn(itemObj, index)
	end)
	self.materialScrollView:SetOnItemMoveOut(function(itemObj, index)
		self:OnMaterialMoveOut(itemObj, index)
	end)
end

function UIHeroEquipMake:RefreshMaterialScrollView(selectEquipId)
	if selectEquipId ~= nil then
		self:ClearMaterialScrollView()
		self.materialList = DataCenter.HeroEquipTemplateManager:GetCraftMaterialsByEquipId(selectEquipId) or {}
		local count = #self.materialList
		if count > 0 then
			self.materialScrollView:SetTotalCount(count)
			self.materialScrollView:RefillCells()
		end
	end
end

function UIHeroEquipMake:ClearMaterialScrollView()
	self.materialScrollView:ClearCells()
	self.materialScrollView:RemoveComponents(UICommonItem)
end

function UIHeroEquipMake:OnMaterialMoveIn(itemObj, index)
	itemObj.name = tostring(index)
	local cellItem = self.materialScrollView:AddComponent(UICommonItem, itemObj)
	local costItem = self.materialList[index]
	cellItem:ReInit(costItem)
	cellItem:SetItemCountActive(false)
	self.materialScrollView[index] = cellItem
	
	local curItem = DataCenter.ItemData:GetItemById(costItem.itemId)
	if curItem == nil then
		self.materialNum:SetText(string.format('<color=%s>0</color>/%s', TextColorRed, costItem.count))
	else
		if curItem.count < costItem.count then
			self.materialNum:SetText(string.format("<color=%s>%s</color>/%s", TextColorRed, curItem.count, costItem.count))
		else
			self.materialNum:SetText(string.format("%s/%s", curItem.count, costItem.count))
		end
	end
end

function UIHeroEquipMake:OnMaterialMoveOut(itemObj, index)
	self.materialScrollView:RemoveComponent(itemObj.name, UICommonItem)
end

function UIHeroEquipMake:DeleteTimer()
	if self.timer ~= nil then
		self.timer:Stop()
		self.timer = nil
	end
end

function UIHeroEquipMake:AddTimer()
	self:DeleteTimer()
	if self.timer == nil then
		self.timer = TimerManager:GetInstance():GetTimer(1, self.timerAction, self, false,false,false)
	end

	self.timer:Start()
end

function UIHeroEquipMake:UpdateSlider()
	local curTime = UITimeManager:GetInstance():GetServerTime()
	local deltaTime = self.endTime - curTime
	local maxTime = 0
	if deltaTime > 0 then
		maxTime = self.endTime - self.startTime
		if TimeBarUtil.CheckIsNeedChangeBar(deltaTime, self.lastChangeImageDeltaTime, maxTime, SliderLength) then
			self.lastChangeImageDeltaTime = deltaTime
			local tempValue = 1 - deltaTime / maxTime
			self.slider:SetValue(tempValue)
		end

		if TimeBarUtil.CheckIsNeedChangeText(deltaTime, self.lastChangeTextDeltaTime) then
			self.lastChangeTextDeltaTime = deltaTime
			self.sliderText:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime))
		end
	else
		self.endTime = 0
	end
end

function UIHeroEquipMake:DefineEquipList()
	self.equipScrollView = self:AddComponent(UIScrollView, equip_scroll_view_path)
	self.equipScrollView:SetOnItemMoveIn(function(itemObj, index)
		self:OnEquipMoveIn(itemObj, index)
	end)
	self.equipScrollView:SetOnItemMoveOut(function(itemObj, index)
		self:OnEquipMoveOut(itemObj, index)
	end)
end

function UIHeroEquipMake:RefreshEquipScrollView()
	self:ClearEquipScrollView()
	self.equipList = DataCenter.HeroEquipTemplateManager:GetTemplateListBySlot(self.curType) or {}
	local count = #self.equipList
	if count > 0 then
		self.equipScrollView:SetTotalCount(count)
		self.equipScrollView:RefillCells()
	end
end

function UIHeroEquipMake:ClearEquipScrollView()
	self.equipScrollView:ClearCells()
	self.equipScrollView:RemoveComponents(UIHeroEquipSelectCell)
end

function UIHeroEquipMake:OnEquipMoveIn(itemObj, index)
	itemObj.name = tostring(index)
	local cellItem = self.equipScrollView:AddComponent(UIHeroEquipSelectCell, itemObj)
	cellItem:SetConfigData(self.equipList[index], index, "UIHeroEquipMake")
end

function UIHeroEquipMake:OnEquipMoveOut(itemObj, index)
	self.equipScrollView:RemoveComponent(itemObj.name, UIHeroEquipSelectCell)
end

function UIHeroEquipMake:RefreshBtn(selectEquipId)
	local btnState = BtnState.Make
	local queue = DataCenter.QueueDataManager:GetQueueByType(NewQueueType.ProductEquip)
	if queue ~= nil then
		local unlock, unlockLevel = DataCenter.HeroEquipTemplateManager:IsEquipUnlock(selectEquipId)
		if unlock then
			local select = selectEquipId == tonumber(queue.itemId)
			local queueState = queue:GetQueueState()
			if queueState == NewQueueState.Free then
				btnState = BtnState.Make
			elseif queueState == NewQueueState.Work then
				if select then
					btnState = BtnState.SpeedUp
				else
					btnState = BtnState.Making
				end

				self.startTime = queue.startTime
				self.endTime = queue.endTime
				local curTime = UITimeManager:GetInstance():GetServerTime()
				if curTime < self.endTime then
					self:AddTimer()
					self.timerAction()
				else
					self:DeleteTimer()
				end
			elseif queueState == NewQueueState.Finish then
				if select then
					btnState = BtnState.Collect
					self:DeleteTimer()
					self.slider:SetValue(1)
					self.sliderText:SetLocalText(GameDialogDefine.COMPLETE)
				else
					btnState = BtnState.Making
				end
			end
		else
			self.unlockText:SetLocalText(GameDialogDefine.UNLOCK_LEVEL, unlockLevel)
			btnState = BtnState.Lock
		end
	end

	self:RefreshBtnState(btnState)
end

function UIHeroEquipMake:RefreshBtnState(btnState)
	self.makeNode:SetActive(btnState == BtnState.Make or btnState == BtnState.Making)
	self.notMakeNode:SetActive(btnState == BtnState.Lock)
	self.speedUpNode:SetActive(btnState == BtnState.SpeedUp)
	self.collectNode:SetActive(btnState == BtnState.Collect)

	if btnState == BtnState.SpeedUp or btnState == BtnState.Collect then
		self.slider:SetActive(true)
		self.materialNode:SetActive(false)
	else
		self.slider:SetActive(false)
		self.materialNode:SetActive(true)
	end
end

function UIHeroEquipMake:OnMakeBtnClick()
	local queue = DataCenter.QueueDataManager:GetQueueByType(NewQueueType.ProductEquip)
	if queue ~= nil then
		local queueState = queue:GetQueueState()
		if queueState == NewQueueState.Work then
			UIUtil.ShowTipsId(GameDialogDefine.QUEUE_FULL)
			return
		end
		DataCenter.HeroEquipManager:HeroEquipStartProduct(queue.uuid, self.selectEquipId);
	end
end

function UIHeroEquipMake:OnNotMakeBtnClick()
	
end

function UIHeroEquipMake:OnSpeedUpBtnClick()
	local queue = DataCenter.QueueDataManager:GetQueueByType(NewQueueType.ProductEquip)
	if queue ~= nil then
		UIManager:GetInstance():OpenWindow(UIWindowNames.UISpeed, {anim = true,isBlur = true}, ItemSpdMenu.ItemSpdMenu_HeroEquip, queue.uuid)
	end
end

function UIHeroEquipMake:OnCollectBtnClick()
	local queue = DataCenter.QueueDataManager:GetQueueByType(NewQueueType.ProductEquip)
	if queue ~= nil and queue:GetQueueState() == NewQueueState.Finish then
		DataCenter.HeroEquipManager:HeroEquipCollect(queue.uuid, queue.itemId);
	end
end

return UIHeroEquipMake