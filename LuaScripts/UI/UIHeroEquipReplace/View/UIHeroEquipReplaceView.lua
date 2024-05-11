---------------------------------------------------------------------
-- dr_client (C) CompanyName, All Rights Reserved
-- Created by: AuthorName
-- Date: 2024-03-22 14:32:47
---------------------------------------------------------------------

-- To edit this template in: Data/Config/Template.lua
-- To disable this template, check off menuitem: Options-Enable Template File

---@class UIHeroEquipReplaceView
local UIHeroEquipReplaceView = BaseClass("UIHeroEquipReplaceView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

local UIHeroEquipSlot = require "UI.UIHeroEquip.Component.UIHeroEquipSlot"
local UIHeroEquipCell = require "UI.UIHeroEquip.Component.UIHeroEquipCell"
local UIHeroEquipReplaceCell = require "UI.UIHeroEquipReplace.Component.UIHeroEquipReplaceCell"

local title_text_path = "UICommonMidPopUpTitle/bg_mid/TitleText"
local equip_slot_path = "Content/Empty/UIHeroEquipSlot"
local equip_cell_path = "Content/Cur/UIHeroEquipCell"
local name_text_path = "Content/Cur/InfoNode/NameText"
local lv_text_path = "Content/Cur/InfoNode/LvText"
local power_text_path = "Content/Cur/InfoNode/PowerNode/Power"
local cur_go_path = "Content/Cur"
local empty_go_path = "Content/Empty"
local empty_equip_text_path = "Content/Empty/EmptyText"
local empty_list_text_path = "Content/EmptyListText"
local cell_scroll_view_path = "Content/ScrollView"
local down_btn_path = "Content/Cur/DownBtn"
local down_text_path = "Content/Cur/DownBtn/DownBtnText"
local get_equip_btn_path = "Content/GetEquipBtn"
local get_equip_text_path = "Content/GetEquipBtn/GetEquipBtnText"
local close_btn_path = "UICommonMidPopUpTitle/bg_mid/CloseBtn"

function UIHeroEquipReplaceView:OnCreate()
	base.OnCreate(self)
	self:ComponentDefine()
	self:DataDefine()
	self:ReInit()
end

function UIHeroEquipReplaceView:OnDestroy()
	self:ComponentDestroy()
	self:DataDestroy()
	base.OnDestroy(self)
end

function UIHeroEquipReplaceView:ComponentDefine()
	self.textTitle = self:AddComponent(UITextMeshProUGUIEx, title_text_path)
	self.textTitle:SetLocalText(GameDialogDefine.HERO_EQUIP26)
	self.curNode = self:AddComponent(UIBaseContainer, cur_go_path)
	self.emptyNode = self:AddComponent(UIBaseContainer, empty_go_path)
	self.equipSlot = self:AddComponent(UIHeroEquipSlot, equip_slot_path)
	self.equipCell = self:AddComponent(UIHeroEquipCell, equip_cell_path)
	self.equipName = self:AddComponent(UITextMeshProUGUIEx, name_text_path)
	self.lvText = self:AddComponent(UITextMeshProUGUIEx, lv_text_path)
	self.lvText:SetActive(false)
	self.equipPower = self:AddComponent(UITextMeshProUGUIEx, power_text_path)
	self.emptyEquipText = self:AddComponent(UITextMeshProUGUIEx, empty_equip_text_path)
	self.emptyEquipText:SetLocalText(GameDialogDefine.HERO_EQUIP27)
	self.emptyListText = self:AddComponent(UITextMeshProUGUIEx, empty_list_text_path)
	self.emptyListText:SetLocalText(GameDialogDefine.HERO_EQUIP32)
	self:DefineCellList()
	self:DefineBtn()
end

function UIHeroEquipReplaceView:ComponentDestroy()

end

function UIHeroEquipReplaceView:DataDefine()
	self.heroId = 0
	self.slot = 0
	self.wearEquipUuid = ''
end

function UIHeroEquipReplaceView:DataDestroy()
	self.heroId = 0
	self.slot = 0
	self.wearEquipUuid = ''
end

function UIHeroEquipReplaceView:OnEnable()
	base.OnEnable(self)
end

function UIHeroEquipReplaceView:OnDisable()
	base.OnDisable(self)
end

function UIHeroEquipReplaceView:OnAddListener()
	base.OnAddListener(self)
	self:AddUIListener(EventId.HeroEquipModelUpdate, self.OnEquipUpdate)
	--self:AddUIListener(EventId.HeroEquipUninstall, self.OnEquipUninstall)
end

function UIHeroEquipReplaceView:OnRemoveListener()
	base.OnRemoveListener(self)
	self:RemoveUIListener(EventId.HeroEquipModelUpdate, self.OnEquipUpdate)
	--self:RemoveUIListener(EventId.HeroEquipUninstall, self.OnEquipUninstall)
end

function UIHeroEquipReplaceView:ReInit()
	local heroId, slot = self:GetUserData()
	self.heroId = heroId
	self.slot = slot
	self.equipSlot:SetData(heroId, slot) 
	
	local wearEquip = DataCenter.HeroEquipManager:GetEquipByHeroIdAndSlot(heroId, slot)
	self.curNode:SetActive(wearEquip ~= nil)
	self.emptyNode:SetActive(wearEquip == nil)
	if wearEquip ~= nil then
		self.wearEquipUuid = wearEquip.uuid
		self.equipCell:SetData(wearEquip)
		
		local equipTemplate = DataCenter.HeroEquipTemplateManager:GetTemplate(wearEquip.equipId);
		if equipTemplate ~= nil then
			self.equipName:SetText(Localization:GetString(equipTemplate.name))
		end
		
		local power = DataCenter.HeroEquipTemplateManager:GetEquipmentPower(wearEquip.equipId, wearEquip.level, wearEquip.promote);
		self.equipPower:SetText(string.GetFormattedSeperatorNum(power))
	end

	self:RefreshScrollView()
end

function UIHeroEquipReplaceView:OnEquipUpdate()
	self:RefreshScrollView()
end

function UIHeroEquipReplaceView:OnEquipInstall()

end

function UIHeroEquipReplaceView:OnEquipUninstall()

end

function UIHeroEquipReplaceView:DefineCellList()
	self.scrollView = self:AddComponent(UIScrollView, cell_scroll_view_path)
	self.scrollView:SetOnItemMoveIn(function(itemObj, index)
		self:OnCellMoveIn(itemObj, index)
	end)
	self.scrollView:SetOnItemMoveOut(function(itemObj, index)
		self:OnCellMoveOut(itemObj, index)
	end)
end

function UIHeroEquipReplaceView:RefreshScrollView()
	self:ClearScrollView()
	self.equipList = DataCenter.HeroEquipManager:GetOtherEquipListBySlot(self.wearEquipUuid, self.slot) or {}
	local count = #self.equipList
	if count > 0 then
		self.scrollView:SetActive(true)
		self.emptyListText:SetActive(false)
		self.scrollView:SetTotalCount(count)
		self.scrollView:RefillCells()
	else
		self.scrollView:SetActive(false)
		self.emptyListText:SetActive(true)
	end
end

function UIHeroEquipReplaceView:ClearScrollView()
	self.scrollView:ClearCells()
	self.scrollView:RemoveComponents(UIHeroEquipReplaceCell)
end

function UIHeroEquipReplaceView:OnCellMoveIn(itemObj, index)
	itemObj.name = tostring(index)
	local cellItem = self.scrollView:AddComponent(UIHeroEquipReplaceCell, itemObj)
	local equip = self.equipList[index]
	cellItem:SetData(equip, self.heroId, self.wearEquipUuid)
	self.scrollView[index] = cellItem

	if index == 1 then
		if self.wearEquipUuid == '' then
			cellItem:SetRedVisible(true)
		else
			cellItem:SetRedVisible(equip.uuid ~= self.wearEquipUuid)
		end
	end
end

function UIHeroEquipReplaceView:OnCellMoveOut(itemObj, index)
	self.scrollView:RemoveComponent(itemObj.name, UIHeroEquipReplaceCell)
end

function UIHeroEquipReplaceView:DefineBtn()
	self.downBtn = self:AddComponent(UIButton, down_btn_path)
	self.downBtn:SetOnClick(function()
		SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
		self:OnDownBtnClick()
	end)
	self.downBtnText = self:AddComponent(UITextMeshProUGUIEx, down_text_path)
	self.downBtnText:SetLocalText(GameDialogDefine.HERO_EQUIP31)

	self.getEquipBtn = self:AddComponent(UIButton, get_equip_btn_path)
	self.getEquipBtn:SetOnClick(function()
		SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
		self:OnGetEquipBtnClick()
	end)
	self.getEquipText = self:AddComponent(UITextMeshProUGUIEx, get_equip_text_path)
	self.getEquipText:SetLocalText(GameDialogDefine.HERO_EQUIP30)

	self.closeBtn = self:AddComponent(UIButton, close_btn_path)
	self.closeBtn:SetOnClick(function()
		SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
		self.ctrl:CloseSelf()
	end)
end

function UIHeroEquipReplaceView:OnGetEquipBtnClick()
	GoToResLack:GotoHeroEquip()
end 

function UIHeroEquipReplaceView:OnDownBtnClick()
	local equipList = {}
	table.insert(equipList, self.wearEquipUuid)
	DataCenter.HeroEquipManager:HeroEquipUninstall(self.heroId, equipList);
	
	self.view.ctrl.CloseSelf()
end

return UIHeroEquipReplaceView