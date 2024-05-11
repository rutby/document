---------------------------------------------------------------------
-- dr_client (C) CompanyName, All Rights Reserved
-- Created by: AuthorName
-- Date: 2024-03-22 14:27:40
---------------------------------------------------------------------

-- To edit this template in: Data/Config/Template.lua
-- To disable this template, check off menuitem: Options-Enable Template File

---@class UIHeroEquipMaterialCompose
local UIHeroEquipMaterialCompose = BaseClass("UIHeroEquipMaterialCompose", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

local UICommonItem = require "UI.UICommonItem.UICommonItem"
local UIHeroEquipMaterialSelectCell = require "UI.UIHeroEquip.Component.UIHeroEquipMaterialSelectCell"

local line_path = "EquipList/Line"
local tip_text_path = "EquipList/TipText"
local origin_go_path = "EquipList/Origin"
local target_go_path = "EquipList/Target"
local slot_go_path = "EquipList/UIHeroEquipMaterialSlot"
local slot_list_go_path = "EquipList/Slot"
local origin_item_path = "EquipList/Origin/UICommonItemSize%s"
local target_item_path = "EquipList/Target/UICommonItemSize"
local origin_item_name_text_path = "EquipList/Origin/OriginText"
local target_item_name_text_path = "EquipList/Target/TargetText"
local material_title_text_path = "MaterialList/MaterialTitleText"
local material_scroll_view_path = "MaterialList/ScrollView"
local compose_btn_path = "Btn/ComposeBtn"
local compose_text_path = "Btn/ComposeBtn/ComposeBtnText"
local compose_all_bg_path = "Btn/ComposeAllBg"
local compose_all_btn_path = "Btn/ComposeAllBg/ComposeAllBtn"
local compose_all_text_path = "Btn/ComposeAllBg/ComposeAllBtn/ComposeAllBtnText"
local material_list_empty_text_path = "MaterialList/MaterialListEmpty"

function UIHeroEquipMaterialCompose:OnCreate()
	base.OnCreate(self)
	self:ComponentDefine()
	self:DataDefine()
end

function UIHeroEquipMaterialCompose:OnDestroy()
	self:ComponentDestroy()
	self:DataDestroy()
	base.OnDestroy(self)
end

function UIHeroEquipMaterialCompose:ComponentDefine()
	self.line = self:AddComponent(UIImage, line_path)
	self.originNode = self:AddComponent(UIBaseContainer, origin_go_path)
	self.targetNode = self:AddComponent(UIBaseContainer, target_go_path)
	self.slotNode = self:AddComponent(UIBaseContainer, slot_go_path)
	self.slotList = self:AddComponent(UIBaseContainer, slot_list_go_path)
	self.tip = self:AddComponent(UITextMeshProUGUIEx, tip_text_path)
	self.tip:SetLocalText(GameDialogDefine.HERO_EQUIP14)
	self.originItemName = self:AddComponent(UITextMeshProUGUIEx, origin_item_name_text_path)
	self.targetItemName = self:AddComponent(UITextMeshProUGUIEx, target_item_name_text_path)
	self.materialTitle = self:AddComponent(UITextMeshProUGUIEx, material_title_text_path)
	self.materialTitle:SetLocalText(GameDialogDefine.HERO_EQUIP7)
	self.materialListEmptyText = self:AddComponent(UITextMeshProUGUIEx, material_list_empty_text_path)
	self.materialListEmptyText:SetLocalText(GameDialogDefine.HERO_EQUIP15)
	
	self.originItem = {}
	for i = 1, 4 do
		self.originItem[i] = self:AddComponent(UICommonItem, string.format(origin_item_path, i))
	end
	self.targetItem = self:AddComponent(UICommonItem, target_item_path)

	self:DefineBtn()
	self:DefineMaterialList()
end

function UIHeroEquipMaterialCompose:ComponentDestroy()

end

function UIHeroEquipMaterialCompose:DefineBtn()
	self.composeBtn = self:AddComponent(UIButton, compose_btn_path)
	self.composeBtn:SetOnClick(function()
		SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
		self:OnComposeBtnClick()
	end)
	self.composeBtn:SetInteractable(false)
	self.composeBtnText = self:AddComponent(UITextMeshProUGUIEx, compose_text_path)
	self.composeBtnText:SetLocalText(GameDialogDefine.HERO_EQUIP3)

	self.composeAllBg = self:AddComponent(UIBaseContainer, compose_all_bg_path)
	self.composeAllBtn = self:AddComponent(UIButton, compose_all_btn_path)
	self.composeAllBtn:SetOnClick(function()
		SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
		self:OnComposeAllBtnClick()
	end)
	self.composeAllBtnText = self:AddComponent(UITextMeshProUGUIEx, compose_all_text_path)
	self.composeAllBg:SetActive(false)
end

function UIHeroEquipMaterialCompose:DataDefine()
	self.selectIndex = 0
	self.costId = 0
	self.exchangeNum = 0
end

function UIHeroEquipMaterialCompose:DataDestroy()
	self.selectIndex = 0 
	self.costId = 0
	self.exchangeNum = 0
end

function UIHeroEquipMaterialCompose:OnEnable()
	base.OnEnable(self)

	self:ReInit()
end

function UIHeroEquipMaterialCompose:OnDisable()
	base.OnDisable(self)
end

function UIHeroEquipMaterialCompose:OnAddListener()
	base.OnAddListener(self)
	self:AddUIListener(EventId.HeroEquipMaterialCompose, self.OnEquipMaterialCompose)

	self:AddUIListener(EventId.OnSelectEquipMaterialCompose, self.RefreshSelectState)
end

function UIHeroEquipMaterialCompose:OnRemoveListener()
	base.OnRemoveListener(self)
	self:RemoveUIListener(EventId.HeroEquipMaterialCompose, self.OnEquipMaterialCompose)

	self:RemoveUIListener(EventId.OnSelectEquipMaterialCompose, self.RefreshSelectState)
end

function UIHeroEquipMaterialCompose:RefreshSelectState(index)
	if self.materialList ~= nil then
		if 0 < index and index <= #self.materialList then
			self.selectIndex = index
			local selectItem = self.materialList[index]
			self:RefreshItem(selectItem.itemId, 1)
		else
			self:SetEmpty()
		end
	else
		self:SetEmpty()
	end
end

function UIHeroEquipMaterialCompose:RefreshItem(selectItemId, exchangeNum)
	self.composeBtn:SetInteractable(false)
	self.tip:SetActive(false)
	if self.costId ~= selectItemId then
		self.composeAllBg:SetActive(false)
	end

	if selectItemId == nil or selectItemId == 0 then
		self:SetEmpty()
	else
		self.originNode:SetActive(true)

		self.costId = selectItemId
		local costItem = DataCenter.ItemTemplateManager:GetItemTemplate(selectItemId)
		if costItem ~= nil then
			for i = 1, table.count(self.originItem) do
				local param = {}
				param.rewardType = RewardType.GOODS
				param.itemId = tonumber(costItem.id)
				param.count = exchangeNum
				self.originItem[i]:ReInit(param)
			end
			self.originItemName:SetLocalText(costItem.name)
		end

		local targetId = DataCenter.HeroEquipMaterialConfigManager:GetComposeTarget(selectItemId)
		if targetId ~= nil then
			self.line:SetActive(true)
			self.originNode:SetActive(true)
			self.targetNode:SetActive(true)
			self.slotNode:SetActive(false)
			self.slotList:SetActive(false)
			self.composeBtn:SetInteractable(true)
			local targetItem = DataCenter.ItemTemplateManager:GetItemTemplate(targetId)
			if targetItem ~= nil then
				local param = {}
				param.rewardType = RewardType.GOODS
				param.itemId = tonumber(targetItem.id)
				self.exchangeNum = exchangeNum
				param.count = exchangeNum
				self.targetItem:ReInit(param)
			end

			self.targetItemName:SetLocalText(targetItem.name)
		else
			self.tip:SetActive(true)
			self.tip:SetLocalPosition(Vector3.New(0, -160, 0))
			self.line:SetActive(false)
			self.originNode:SetActive(true)
			self.targetNode:SetActive(false)
			self.slotNode:SetActive(false)
			self.slotList:SetActive(false)
			self.tip:SetLocalText(GameDialogDefine.HERO_EQUIP16)
		end
	end
end

function UIHeroEquipMaterialCompose:SetEmpty()
	self.tip:SetActive(true)
	self.tip:SetLocalPosition(Vector3.New(0, -16, 0))
	self.originNode:SetActive(false)
	self.targetNode:SetActive(false)
	self.slotNode:SetActive(true)
	self.slotList:SetActive(true)
end

function UIHeroEquipMaterialCompose:ReInit()
	self:RefreshMaterialScrollView()

	EventManager:GetInstance():Broadcast(EventId.OnSelectEquipMaterialCompose, self.selectIndex)
end

function UIHeroEquipMaterialCompose:DefineMaterialList()
	self.materialScrollView = self:AddComponent(UIScrollView, material_scroll_view_path)
	self.materialScrollView:SetOnItemMoveIn(function(itemObj, index)
		self:OnMaterialMoveIn(itemObj, index)
	end)
	self.materialScrollView:SetOnItemMoveOut(function(itemObj, index)
		self:OnMaterialMoveOut(itemObj, index)
	end)
end

function UIHeroEquipMaterialCompose:RefreshMaterialScrollView()
	self:ClearMaterialScrollView()
	self.materialList = DataCenter.HeroEquipMaterialConfigManager:GetAllTemplateItems() or {}
	local count = #self.materialList
	if count > 0 then
		self.materialScrollView:SetTotalCount(count)
		self.materialScrollView:RefillCells()
		self.materialListEmptyText:SetActive(false)
	else
		self.materialListEmptyText:SetActive(true)
	end
end

function UIHeroEquipMaterialCompose:ClearMaterialScrollView()
	self.materialScrollView:ClearCells()
	self.materialScrollView:RemoveComponents(UIHeroEquipMaterialSelectCell)
end

function UIHeroEquipMaterialCompose:OnMaterialMoveIn(itemObj, index)
	itemObj.name = tostring(index)
	local cellItem = self.materialScrollView:AddComponent(UIHeroEquipMaterialSelectCell, itemObj)
	cellItem:SetData(self.materialList[index], index, 'UIHeroEquipMaterialCompose', function()
		self:CheckCanCompose()
	end)
	self.materialScrollView[index] = cellItem
end

function UIHeroEquipMaterialCompose:OnMaterialMoveOut(itemObj, index)
	self.materialScrollView:RemoveComponent(itemObj.name, UIHeroEquipMaterialSelectCell)
end

function UIHeroEquipMaterialCompose:OnComposeBtnClick()
	DataCenter.HeroEquipManager:HeroEquipMaterialCompose(self.costId, self.exchangeNum);
end

function UIHeroEquipMaterialCompose:GetMaxExchangeNum()
	local costItem = DataCenter.ItemData:GetItemById(self.costId)
	local costItemTemplate = DataCenter.HeroEquipMaterialConfigManager:GetTemplate(self.costId)
	if costItem ~= nil and costItemTemplate ~= nil then
		return math.floor(costItem.count / costItemTemplate.combineNum)
	end
end

function UIHeroEquipMaterialCompose:OnComposeAllBtnClick()
	local maxNum = self:GetMaxExchangeNum()
	self:RefreshItem(self.costId, maxNum)
	DataCenter.HeroEquipManager:HeroEquipMaterialCompose(self.costId, maxNum);
end

function UIHeroEquipMaterialCompose:OnEquipMaterialCompose()
	local costItem = DataCenter.ItemData:GetItemById(self.costId)
	if costItem ~= nil and costItem.count > 0 then
		self.composeAllBg:SetActive(true)
		self:RefreshMaterialScrollView()
		
		local count = #self.materialList
		for i = 1, count do
			if self.materialList[i].itemId == self.costId then
				self.selectIndex = i
				break
			end
		end
		
		EventManager:GetInstance():Broadcast(EventId.OnSelectEquipMaterialCompose, self.selectIndex)
	else
		self.composeAllBg:SetActive(false)
		self.costId = 0
		self:ReInit()
	end
end

return UIHeroEquipMaterialCompose