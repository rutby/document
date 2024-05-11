---------------------------------------------------------------------
-- dr_client (C) CompanyName, All Rights Reserved
-- Created by: AuthorName
-- Date: 2024-03-22 14:33:39
---------------------------------------------------------------------

-- To edit this template in: Data/Config/Template.lua
-- To disable this template, check off menuitem: Options-Enable Template File

---@class UIHeroEquipPromotionView
local UIHeroEquipPromotionView = BaseClass("UIHeroEquipPromotionView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

local UIHeroEquipCell = require "UI.UIHeroEquip.Component.UIHeroEquipCell"
local UIHeroEquipInfoAttrCell3 = require "UI.UIHeroEquip.Component.UIHeroEquipInfoAttrCell3"
local UIHeroEquipUpgradeAttrCell = require "UI.UIHeroEquip.Component.UIHeroEquipUpgradeAttrCell"
local UIHeroEtoile = require "UI.UIHero2.Common.UIHeroEtoile"
local UICommonResItem = require "UI.UICommonResItem.UICommonResItem"

local detail_btn_path = "Bg/DetailBtn"
local close_btn_path = "UICommonFullTop/CloseBtn"
local equip_path = "UIHeroEquipCell"
local equip_name_path = "EquipName"
local slider_path = "Progress"
local slider_text_path = "Progress/ProgressText"
local etoile_path = "Progress/Etoile"
local base_title_text_path = "attributeBg/BaseAttr/BaseTitle"
local extra_title_text_path = "attributeBg/ExtraAttr/ExtraTitle"
local base_attr_scroll_view_path = "attributeBg/BaseAttr/BaseScrollView"
local extra_attr_scroll_view_path = "attributeBg/ExtraAttr/ExtraScrollView"
local res_path = "CostRes"
local promotion_btn_path = "PromotionBtn"
local promotion_text_path = "PromotionBtn/PromotionBtnText"
local red_path = "PromotionBtn/PromotionRed"

function UIHeroEquipPromotionView:OnCreate()
	base.OnCreate(self)
	self:DataDefine()
	self:ComponentDefine()
	self:ReInit()
end
-- 销毁
function UIHeroEquipPromotionView:OnDestroy()
	self:ComponentDestroy()
	self:DataDestroy()
	base.OnDestroy(self)
end

function UIHeroEquipPromotionView:ComponentDefine()
	self.equipName = self:AddComponent(UITextMeshProUGUIEx, equip_name_path)
	self.equipCell = self:AddComponent(UIHeroEquipCell, equip_path)
	self.etoile = self:AddComponent(UIHeroEtoile, etoile_path)
	self.slider = self:AddComponent(UISlider, slider_path)
	self.sliderText = self:AddComponent(UITextMeshProUGUIEx, slider_text_path)
	self.baseTitle = self:AddComponent(UITextMeshProUGUIEx, base_title_text_path)
	self.baseTitle:SetLocalText(GameDialogDefine.HERO_EQUIP35)
	self.extraTitle = self:AddComponent(UITextMeshProUGUIEx, extra_title_text_path)
	self.extraTitle:SetLocalText(GameDialogDefine.HERO_EQUIP36)
	self.resNode = self:AddComponent(UIBaseContainer, res_path)

	self:DefineBaseAttrList()
	self:DefineExtraAttrList()
	self:DefineBtn()
end

function UIHeroEquipPromotionView:ComponentDestroy()

end

function UIHeroEquipPromotionView:DataDefine()
	self.equipUuid = ''
	self.wearEquip = {}
	self.resItem = {}
end

function UIHeroEquipPromotionView:DataDestroy()
	self.equipUuid = ''
	self.wearEquip = {}
	self.resItem = {}
end

function UIHeroEquipPromotionView:OnEnable()
	base.OnEnable(self)
end

function UIHeroEquipPromotionView:OnDisable()
	base.OnDisable(self)
end

function UIHeroEquipPromotionView:OnAddListener()
	base.OnAddListener(self)
	self:AddUIListener(EventId.HeroEquipPromotion, self.OnEquipPromotion)
end

function UIHeroEquipPromotionView:OnRemoveListener()
	base.OnRemoveListener(self)
	self:RemoveUIListener(EventId.HeroEquipPromotion, self.OnEquipPromotion)
end

function UIHeroEquipPromotionView:OnEquipPromotion()
	self:Refresh()
end

function UIHeroEquipPromotionView:ReInit()
	self.equipUuid = self:GetUserData()

	self.wearEquip = DataCenter.HeroEquipManager:GetEquipByUuid(self.equipUuid)
	if self.wearEquip ~= nil then
		local equipTemplate = DataCenter.HeroEquipTemplateManager:GetTemplate(self.wearEquip.equipId)
		if equipTemplate ~= nil then
			self.equipName:SetText(Localization:GetString(equipTemplate.name))
		end

		self:Refresh()
	end 
end

function UIHeroEquipPromotionView:Refresh()
	self:RefreshEquip()
	self:RefreshSlider()
	self:RefreshBaseAttrList()
	self:RefreshExtraAttrList()
	self:RefreshRes()
	self:RefreshBtn()
	self.red:SetActive(DataCenter.HeroEquipManager:IsEquipCanPromote(self.equipUuid))
end

function UIHeroEquipPromotionView:RefreshEquip()
	if self.wearEquip == nil then
		return
	end

	self.equipCell:SetData(self.wearEquip, nil, true)
end

function UIHeroEquipPromotionView:RefreshSlider()
	if self.wearEquip == nil then
		return
	end
	local stage = self.wearEquip:GetPromoteStage()
	self.etoile:SetCornerCount(stage)
	self.slider:SetValue(self.wearEquip:GetPromoteStageRate())
	local text = string.format('%s/%s', stage, HeroEquipConst.EquipPromoteStage)
	self.sliderText:SetText(text)
end

function UIHeroEquipPromotionView:DefineBaseAttrList()
	self.baseAttrScrollView = self:AddComponent(UIScrollView, base_attr_scroll_view_path)
	self.baseAttrScrollView:SetOnItemMoveIn(function(itemObj, index)
		self:OnBaseAttrMoveIn(itemObj, index)
	end)
	self.baseAttrScrollView:SetOnItemMoveOut(function(itemObj, index)
		self:OnBaseAttrMoveOut(itemObj, index)
	end)
end

function UIHeroEquipPromotionView:RefreshBaseAttrList()
	if self.wearEquip == nil then
		return
	end
	
	self:ClearBaseAttrList()
	self.baseEffectsList = DataCenter.HeroEquipTemplateManager:GetEquipmentBaseAttr(self.wearEquip.equipId, self.wearEquip.level, self.wearEquip.promote) or {}
	local count = #self.baseEffectsList
	if count > 0 then
		self.baseAttrScrollView:SetTotalCount(count)
		self.baseAttrScrollView:RefillCells()
	end
end

function UIHeroEquipPromotionView:ClearBaseAttrList()
	self.baseAttrScrollView:ClearCells()
	self.baseAttrScrollView:RemoveComponents(UIHeroEquipUpgradeAttrCell)
end

function UIHeroEquipPromotionView:OnBaseAttrMoveIn(itemObj, index)
	itemObj.name = tostring(index)
	local cellItem = self.baseAttrScrollView:AddComponent(UIHeroEquipUpgradeAttrCell, itemObj)
	cellItem:SetData(self.baseEffectsList[index], index)
	self.baseAttrScrollView[index] = cellItem
end

function UIHeroEquipPromotionView:OnBaseAttrMoveOut(itemObj, index)
	self.baseAttrScrollView:RemoveComponent(itemObj.name, UIHeroEquipUpgradeAttrCell)
end

function UIHeroEquipPromotionView:DefineExtraAttrList()
	self.extraAttrScrollView = self:AddComponent(UIScrollView, extra_attr_scroll_view_path)
	self.extraAttrScrollView:SetOnItemMoveIn(function(itemObj, index)
		self:OnExtraAttrMoveIn(itemObj, index)
	end)
	self.extraAttrScrollView:SetOnItemMoveOut(function(itemObj, index)
		self:OnExtraAttrMoveOut(itemObj, index)
	end)
end

function UIHeroEquipPromotionView:RefreshExtraAttrList()
	if self.wearEquip == nil then
		return
	end
	
	self:ClearExtraAttrList()
	self.additionEffectsList = DataCenter.HeroEquipTemplateManager:GetEquipmentAdditionAttr(self.wearEquip.equipId, self.wearEquip.level, self.wearEquip.promote) or {}
	local count = #self.additionEffectsList
	if count > 0 then
		self.extraAttrScrollView:SetTotalCount(count)
		self.extraAttrScrollView:RefillCells()
	end
end

function UIHeroEquipPromotionView:ClearExtraAttrList()
	self.extraAttrScrollView:ClearCells()
	self.extraAttrScrollView:RemoveComponents(UIHeroEquipInfoAttrCell3)
end

function UIHeroEquipPromotionView:OnExtraAttrMoveIn(itemObj, index)
	itemObj.name = tostring(index)
	local cellItem = self.extraAttrScrollView:AddComponent(UIHeroEquipInfoAttrCell3, itemObj)
	cellItem:SetData(self.additionEffectsList[index], index)
	self.extraAttrScrollView[index] = cellItem
end

function UIHeroEquipPromotionView:OnExtraAttrMoveOut(itemObj, index)
	self.extraAttrScrollView:RemoveComponent(itemObj.name, UIHeroEquipInfoAttrCell3)
end

function UIHeroEquipPromotionView:DefineBtn()
	self.closeBtn = self:AddComponent(UIButton, close_btn_path)
	self.closeBtn:SetOnClick(function()
		SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
		self.ctrl:CloseSelf()
	end)

	self.promotionBtn = self:AddComponent(UIButton, promotion_btn_path)
	self.promotionBtn:SetOnClick(function()
		SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
		self:OnPromotionBtnClick()
	end)
	self.promotionBtnText = self:AddComponent(UITextMeshProUGUIEx, promotion_text_path)
	self.promotionBtnText:SetLocalText(GameDialogDefine.HERO_EQUIP38)
	self.red = self:AddComponent(UIBaseContainer, red_path)
end

function UIHeroEquipPromotionView:RefreshRes()
	local resCost = DataCenter.HeroEquipPromoteTemplateManager:GetCostRes(self.wearEquip.promote)
	if resCost ~= nil then
		local count = #resCost
		for i = 1, count do
			if self.resItem[i] == nil then
				self:GameObjectInstantiateAsync(UIAssets.NeedResourceCell, function(request)
					if request.isError then
						return
					end
					local go = request.gameObject
					local nameStr = tostring(i)
					go.name = nameStr
					go.transform:SetParent(self.resNode.transform)
					self.resItem[i] = self.resNode:AddComponent(UICommonResItem, nameStr)
					self.resItem[i]:SetData(resCost[i])
				end)
			else
				self.resItem[i]:SetData(resCost[i])
			end
		end
	end
end

function UIHeroEquipPromotionView:RefreshBtn()
	if self.wearEquip ~= nil then
		local isMaxPromote = self.wearEquip:IsMaxPromote()
		self.promotionBtn:SetInteractable(not isMaxPromote)
	end
end

function UIHeroEquipPromotionView:OnPromotionBtnClick()
	if self.wearEquip ~= nil then
		if self.wearEquip:IsMaxPromote() then
			UIUtil.ShowTipsId(GameDialogDefine.REACH_MAX_LEVEL)
			return
		end
		DataCenter.HeroEquipManager:HeroEquipPromote(self.equipUuid);
	end
end


return UIHeroEquipPromotionView