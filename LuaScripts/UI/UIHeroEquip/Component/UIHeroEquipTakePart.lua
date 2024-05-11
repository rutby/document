---------------------------------------------------------------------
-- dr_client (C) CompanyName, All Rights Reserved
-- Created by: AuthorName
-- Date: 2024-03-22 13:59:35
---------------------------------------------------------------------

-- To edit this template in: Data/Config/Template.lua
-- To disable this template, check off menuitem: Options-Enable Template File

---class UIHeroEquipTakePart
local UIHeroEquipTakePart = BaseClass("UIHeroEquipTakePart", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray

local UICommonItem = require "UI.UICommonItem.UICommonItem"
local UIHeroEquipSelectCell = require "UI.UIHeroEquip.Component.UIHeroEquipSelectCell"

local material_name_text_path = "MaterialList/MaterialName"
local material_list_empty_text_path = "MaterialList/MaterialListEmpty"
local material_scroll_view_path = "MaterialList/MaterialScrollView"
local equip_list_name_text_path = "EquipList/EquipListName"
local equip_list_empty_text_path = "EquipList/EquipListEmpty"
local equip_list_scroll_view_path = "EquipList/EquipListScrollView"
local equip_group_btn_path = "EquipList/EquipGroupBg/EquipGroupButton"
local equip_group_btn_text_path = "EquipList/EquipGroupBg/EquipGroupButton/selectText"
local equip_group_go_path = "EquipList/EquipGroupBg/EquipGroupChoose"
local equip_group_toggle_path = "EquipList/EquipGroupBg/EquipGroupChoose/ToggleGroup/Toggle%s"
local arrowUp_path = "EquipList/EquipGroupBg/EquipGroupButton/arrowUp"
local arrowDown_path = "EquipList/EquipGroupBg/EquipGroupButton/arrowDown"
local take_part_btn_path = "TakePartBtn"
local take_part_text_path = "TakePartBtn/Text"

local BtnType =
{
	Green = 2,--绿色
	Blue = 3,--蓝色
	Purple = 4,--紫色
	Orange = 5,--橙色
}
local BtnName =
{
	[BtnType.Green] = GameDialogDefine.HERO_EQUIP10,
	[BtnType.Blue] = GameDialogDefine.HERO_EQUIP11,
	[BtnType.Purple] = GameDialogDefine.HERO_EQUIP12,
}

function UIHeroEquipTakePart:OnCreate()
	base.OnCreate(self)
	self:DataDefine()
	self:ComponentDefine()
end

function UIHeroEquipTakePart:OnDestroy()
	self:ComponentDestroy()
	self:DataDestroy()
	base.OnDestroy(self)
end

function UIHeroEquipTakePart:ComponentDefine()
	self.materialNameText = self:AddComponent(UITextMeshProUGUIEx, material_name_text_path)
	self.materialNameText:SetLocalText(GameDialogDefine.HERO_EQUIP7)
	self.materialListEmptyText = self:AddComponent(UITextMeshProUGUIEx, material_list_empty_text_path)
	self.materialListEmptyText:SetLocalText(GameDialogDefine.HERO_EQUIP6)
	self.equipListNameText = self:AddComponent(UITextMeshProUGUIEx, equip_list_name_text_path)
	self.equipListNameText:SetLocalText(GameDialogDefine.HERO_EQUIP40)
	self.equipListEmptyText = self:AddComponent(UITextMeshProUGUIEx, equip_list_empty_text_path)
	self.equipListEmptyText:SetLocalText(GameDialogDefine.HERO_EQUIP13)
	self.equipGroup = self:AddComponent(UIBaseContainer, equip_group_go_path)
	self.arrowUp = self:AddComponent(UIBaseContainer, arrowUp_path)
	self.arrowDown = self:AddComponent(UIBaseContainer, arrowDown_path)
	self.arrowDown:SetActive(false)
	self.equipGroup:SetActive(false)
	
	self:DefineMaterialList()
	self:DefineEquipList()
	self:DefineBtn()
	self:DefineToggle()
end

function UIHeroEquipTakePart:ComponentDestroy()

end

function UIHeroEquipTakePart:DataDefine()
	self.curQuality = BtnType.Green
	self.showSelect = false
	self.toggle = {}
	self.equipList = {}
	self.materialList = {}
end

function UIHeroEquipTakePart:DataDestroy()
	self.curQuality = BtnType.Green
	self.showSelect = false
	self.toggle = {}
	self.equipList = {}
	self.materialList = {}
end

function UIHeroEquipTakePart:OnEnable()
	base.OnEnable(self)

	self:ReInit()
end

function UIHeroEquipTakePart:OnDisable()
	base.OnDisable(self)
end

function UIHeroEquipTakePart:OnAddListener()
	base.OnAddListener(self)
	self:AddUIListener(EventId.HeroEquipDecompose, self.OnHeroEquipDecompose)

	self:AddUIListener(EventId.OnSelectTakePartEquip, self.RefreshSelectState)
end

function UIHeroEquipTakePart:OnRemoveListener()
	base.OnRemoveListener(self)
	self:RemoveUIListener(EventId.HeroEquipDecompose, self.OnHeroEquipDecompose)

	self:RemoveUIListener(EventId.OnSelectTakePartEquip, self.RefreshSelectState)
end

function UIHeroEquipTakePart:OnHeroEquipDecompose()
	self:ReInit()
end

function UIHeroEquipTakePart:ReInit()
	self:ClearMaterialScrollView()
	self:RefreshEquipScrollView()
end

function UIHeroEquipTakePart:DefineToggle()
	for v = BtnType.Green, BtnType.Purple do
		local toggle = self:AddComponent(UIToggle, string.format(equip_group_toggle_path, v))
		if toggle ~= nil then
			toggle:SetOnValueChanged(function(tf)
				if tf then
					self:ToggleControlBorS(v)
				end
			end)
			toggle.text = toggle:AddComponent(UITextMeshProUGUIEx, 'Text')
			toggle.text:SetLocalText(BtnName[v])
			self.toggle[v] = toggle
		end
	end
end

function UIHeroEquipTakePart:ToggleControlBorS(index)
	self.curQuality = index

	for v = BtnType.Green, BtnType.Purple do
		if v == index then
			self.toggle[v]:SetIsOn(true)
			self:SetSelectState()
		end
	end

	self:OnShowSelectBar()
end

function UIHeroEquipTakePart:SetSelectState()
	local selectList = DataCenter.HeroEquipManager:GetUnEquipListByQuality(self.curQuality)
	local count = #selectList
	local totalCount = #self.equipList
	for i = 1, totalCount do
		self.view.ctrl.takePartMultiSelectList[i] = i <= count
	end
	
	EventManager:GetInstance():Broadcast(EventId.OnSelectTakePartEquip)
end

function UIHeroEquipTakePart:OnShowSelectBar()
	self.showSelect = not self.showSelect
	self.equipGroup:SetActive(self.showSelect)
	self.arrowDown:SetActive(self.showSelect)
	self.arrowUp:SetActive(not self.showSelect)
end

function UIHeroEquipTakePart:DefineMaterialList()
	self.materialScrollView = self:AddComponent(UIScrollView, material_scroll_view_path)
	self.materialScrollView:SetOnItemMoveIn(function(itemObj, index)
		self:OnMaterialMoveIn(itemObj, index)
	end)
	self.materialScrollView:SetOnItemMoveOut(function(itemObj, index)
		self:OnMaterialMoveOut(itemObj, index)
	end)
end

function UIHeroEquipTakePart:RefreshMaterialScrollView()
	local ids = {}
	for index,v in pairs(self.view.ctrl.takePartMultiSelectList) do
		if v then
			table.insert(ids, self.equipList[index].equipId)
		end
	end
	self:ClearMaterialScrollView()
	self.materialList = DataCenter.HeroEquipTemplateManager:GetBreakMaterialsByEquipIds(ids) or {}
	local count = #self.materialList
	if count > 0 then
		self.materialScrollView:SetTotalCount(count)
		self.materialScrollView:RefillCells()
		self.materialListEmptyText:SetActive(false)
		UIGray.SetGray(self.takePartBtn.transform, false, true)
	else
		self.materialListEmptyText:SetActive(true)
		UIGray.SetGray(self.takePartBtn.transform, true, true)
	end
end

function UIHeroEquipTakePart:ClearMaterialScrollView()
	self.materialScrollView:ClearCells()
	self.materialScrollView:RemoveComponents(UICommonItem)
end

function UIHeroEquipTakePart:OnMaterialMoveIn(itemObj, index)
	itemObj.name = tostring(index)
	local cellItem = self.materialScrollView:AddComponent(UICommonItem, itemObj)
	cellItem:ReInit(self.materialList[index], index)
	self.materialScrollView[index] = cellItem
end

function UIHeroEquipTakePart:OnMaterialMoveOut(itemObj, index)
	self.materialScrollView:RemoveComponent(itemObj.name, UICommonItem)
end

function UIHeroEquipTakePart:DefineEquipList()
	self.equipScrollView = self:AddComponent(UIScrollView, equip_list_scroll_view_path)
	self.equipScrollView:SetOnItemMoveIn(function(itemObj, index)
		self:OnEquipMoveIn(itemObj, index)
	end)
	self.equipScrollView:SetOnItemMoveOut(function(itemObj, index)
		self:OnEquipMoveOut(itemObj, index)
	end)
end

function UIHeroEquipTakePart:RefreshEquipScrollView()
	self:ClearEquipScrollView()
	self.equipList = DataCenter.HeroEquipManager:GetUnEquipListByQuality(BtnType.Orange)
	if self.equipList ~= nil and #self.equipList > 0 then
		self.equipScrollView:SetTotalCount(#self.equipList)
		self.equipScrollView:RefillCells()
		self.equipListEmptyText:SetActive(false)

		self:SetSelectState()
	else
		self.equipListEmptyText:SetActive(true)
	end
end

function UIHeroEquipTakePart:ClearEquipScrollView()
	self.view.ctrl.takePartMultiSelectList = {}
	self.equipScrollView:ClearCells()
	self.equipScrollView:RemoveComponents(UIHeroEquipSelectCell)
end

function UIHeroEquipTakePart:OnEquipMoveIn(itemObj, index)
	itemObj.name = tostring(index)
	local cellItem = self.equipScrollView:AddComponent(UIHeroEquipSelectCell, itemObj)
	cellItem:SetData(self.equipList[index], index, "UIHeroEquipTakePart")
	self.equipScrollView[index] = cellItem
end

function UIHeroEquipTakePart:OnEquipMoveOut(itemObj, index)
	self.equipScrollView:RemoveComponent(itemObj.name, UIHeroEquipSelectCell)
end

function UIHeroEquipTakePart:RefreshSelectState()
	self:RefreshMaterialScrollView()
end

function UIHeroEquipTakePart:DefineBtn()
	self.takePartBtn = self:AddComponent(UIButton, take_part_btn_path)
	self.takePartBtn:SetOnClick(function()
		SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
		self:OnTakePartBtnClick()
	end)
	self.takePartBtnText = self:AddComponent(UITextMeshProUGUIEx, take_part_text_path)
	self.takePartBtnText:SetLocalText(GameDialogDefine.HERO_EQUIP2)
	
	self.selectBtn = self:AddComponent(UIButton, equip_group_btn_path)
	self.selectBtn:SetOnClick(function()
		SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
		self:OnShowSelectBar()
	end)
	self.selectBtnText = self:AddComponent(UITextMeshProUGUIEx, equip_group_btn_text_path)
	self.selectBtnText:SetLocalText(GameDialogDefine.HERO_EQUIP9)
end

function UIHeroEquipTakePart:OnTakePartBtnClick()
	local equipList = {}
	for index,v in pairs(self.view.ctrl.takePartMultiSelectList) do
		if v then
			table.insert(equipList, self.equipList[index].uuid)
		end
	end
	DataCenter.HeroEquipManager:HeroEquipDecompose(equipList);
end

return UIHeroEquipTakePart