---------------------------------------------------------------------
-- dr_client (C) CompanyName, All Rights Reserved
-- Created by: AuthorName
-- Date: 2024-03-22 13:13:44
---------------------------------------------------------------------

-- To edit this template in: Data/Config/Template.lua
-- To disable this template, check off menuitem: Options-Enable Template File

local UIHeroEquipView = BaseClass("UIHeroEquipView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIHeroEquipMake = require "UI.UIHeroEquip.Component.UIHeroEquipMake"
local UIHeroEquipTakePart = require "UI.UIHeroEquip.Component.UIHeroEquipTakePart"
local UIHeroEquipMaterialCompose = require "UI.UIHeroEquip.Component.UIHeroEquipMaterialCompose"
local UIHeroEquipMaterialDecompose = require "UI.UIHeroEquip.Component.UIHeroEquipMaterialDecompose"

local title_path = "fullTop/imgTitle/Common_img_title/titleText"
local toggle_path = "fullTop/Bg2/ToggleGroup/Toggle%s"
local close_btn_path = "fullTop/CloseBtn"
local make_node_path = "fullTop/Bg2/UIHeroEquipMake"
local take_part_node_path = "fullTop/Bg2/UIHeroEquipTakePart"
local compose_node_path = "fullTop/Bg2/UIHeroEquipMaterialCompose"
local decompose_node_path = "fullTop/Bg2/UIHeroEquipMaterialDecompose"

local BtnType =
{
	Make = 1,
	TakePart = 2,
	Compose = 3,
	Decompose = 4,
}
local BtnName =
{
	[BtnType.Make] = GameDialogDefine.HERO_EQUIP1,
	[BtnType.TakePart] = GameDialogDefine.HERO_EQUIP2,
	[BtnType.Compose] = GameDialogDefine.HERO_EQUIP3,
	[BtnType.Decompose] = GameDialogDefine.HERO_EQUIP4,
}

function UIHeroEquipView:OnCreate()
	base.OnCreate(self)
	self:ComponentDefine()
	self:DataDefine()
	self:ReInit()
end

function UIHeroEquipView:OnDestroy()
	self:ComponentDestroy()
	self:DataDestroy()
	base.OnDestroy(self)
end

function UIHeroEquipView:ComponentDefine()
	self.title = self:AddComponent(UITextMeshProUGUIEx, title_path)
	self.makeNode = self:AddComponent(UIHeroEquipMake, make_node_path)
	self.takePartNode = self:AddComponent(UIHeroEquipTakePart, take_part_node_path)
	self.composeNode = self:AddComponent(UIHeroEquipMaterialCompose, compose_node_path)
	self.decomposeNode = self:AddComponent(UIHeroEquipMaterialDecompose, decompose_node_path)
	
	self:DefineBtn()
	self:DefineToggle()
end

function UIHeroEquipView:ComponentDestroy()

end

function UIHeroEquipView:DataDefine()
	self.curType = 1
end

function UIHeroEquipView:DataDestroy()
	self.curType = nil
end

function UIHeroEquipView:OnEnable()
	base.OnEnable(self)

	self:ToggleControlBorS(self.curType)
end

function UIHeroEquipView:OnDisable()
	base.OnDisable(self)
end

function UIHeroEquipView:OnAddListener()
	base.OnAddListener(self)
end

function UIHeroEquipView:OnRemoveListener()
	base.OnRemoveListener(self)
end

function UIHeroEquipView:ReInit()
	--local state = self.ctrl.GetQueueStatus()
	--if state ~= nil and state == NewQueueState.Work then
		
	--end
end

function UIHeroEquipView:DefineBtn()
	self.close_btn = self:AddComponent(UIButton, close_btn_path)
	self.close_btn:SetOnClick(function()
		SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
		self.ctrl:CloseSelf()
	end)
end

function UIHeroEquipView:DefineToggle()
	self.toggle = {}
	for k,v in pairs(BtnType) do
		local toggle = self:AddComponent(UIToggle, string.format(toggle_path, v))
		if toggle ~= nil then
			if v == self.curType then
				toggle:SetIsOn(true)
			else
				toggle:SetIsOn(false)
			end

			toggle:SetOnValueChanged(function(tf)
				if tf then
					self:ToggleControlBorS(v)
				end
			end)
			toggle.choose = toggle:AddComponent(UIBaseContainer, "Background/Checkmark")
			toggle.redPoint = toggle:AddComponent(UIBaseContainer, "RedPointNum")
			toggle.unselectName = toggle:AddComponent(UITextMeshProUGUIEx, "text")
			toggle.selectName = toggle:AddComponent(UITextMeshProUGUIEx, "checkText")
			toggle.unselectName:SetLocalText(BtnName[v])
			toggle.selectName:SetLocalText(BtnName[v])
			self.toggle[v] = toggle
		end
	end
end

function UIHeroEquipView:ToggleControlBorS(index)
	self.curType = index
	self.title:SetLocalText(BtnName[index])
	self.makeNode:SetActive(index == BtnType.Make)
	self.takePartNode:SetActive(index == BtnType.TakePart)
	self.composeNode:SetActive(index == BtnType.Compose)
	self.decomposeNode:SetActive(index == BtnType.Decompose)
	
	for k,v in pairs(self.toggle) do
		if k == index then
			v.choose:SetActive(true)
			v.unselectName:SetActive(false)
			v.selectName:SetActive(true)
			v:SetIsOn(true)
		else
			v.choose:SetActive(false)
			v.unselectName:SetActive(true)
			v.selectName:SetActive(false)
		end
	end
end

return UIHeroEquipView
