---------------------------------------------------------------------
-- dr_client (C) CompanyName, All Rights Reserved
-- Created by: AuthorName
-- Date: 2024-03-22 14:31:17
---------------------------------------------------------------------

-- To edit this template in: Data/Config/Template.lua
-- To disable this template, check off menuitem: Options-Enable Template File

---@class UIHeroEquipInfoView
local UIHeroEquipInfoView = BaseClass("UIHeroEquipInfoView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray

local UIHeroEquipCell = require "UI.UIHeroEquip.Component.UIHeroEquipCell"
local UIHeroEquipInfoNode = require "UI.UIHeroEquipInfo.Component.UIHeroEquipInfoNode"
local UICommonResItem = require "UI.UICommonResItem.UICommonResItem"

local title_text_path = "UICommonMidPopUpTitle/bg_mid/TitleText"
local equip_name_text_path = "Content/Info/InfoNode/NameText"
local equip_level_text_path = "Content/Info/InfoNode/LvText"
local equip_power_text_path = "Content/Info/InfoNode/PowerNode/Power"
local detail_btn_path = "UICommonMidPopUpTitle/bg_mid/DetailBtn"
local close_btn_path = "UICommonMidPopUpTitle/bg_mid/CloseBtn"
local info_path = "Content/Attr/UIHeroEquipInfoNode"
local res_path = "Content/CostRes"
local replace_btn_path = "Content/Info/ReplaceBtn"
local replace_text_path = "Content/Info/ReplaceBtn/ReplaceBtnText"
local strength_btn_path = "Content/Btns/StrengthBtn"
local strength_text_path = "Content/Btns/StrengthBtn/StrengthBtnText"
local promotion_btn_path = "Content/Btns/PromotionBtn"
local promotion_text_path = "Content/Btns/PromotionBtn/PromotionBtnText"
local down_btn_path = "Content/Info/DownBtn"
local down_text_path = "Content/Info/DownBtn/DownBtnText"
local equip_path = "Content/Info/UIHeroEquipCell"
local strength_red_path = "Content/Btns/StrengthBtn/StrengthRed"
local promotion_red_path = "Content/Btns/PromotionBtn/PromotionRed"

function UIHeroEquipInfoView:OnCreate()
	base.OnCreate(self)
	self:DataDefine()
	self:ComponentDefine()
	self:ReInit()
end

function UIHeroEquipInfoView:OnDestroy()
	self:ComponentDestroy()
	self:DataDestroy()
	base.OnDestroy(self)
end

function UIHeroEquipInfoView:ComponentDefine()
	self.textTitle = self:AddComponent(UITextMeshProUGUIEx, title_text_path)
	self.textTitle:SetLocalText(GameDialogDefine.HERO_EQUIP33)
	self.equipName = self:AddComponent(UITextMeshProUGUIEx, equip_name_text_path)
	self.equipLevel = self:AddComponent(UITextMeshProUGUIEx, equip_level_text_path)
	self.equipPower = self:AddComponent(UITextMeshProUGUIEx, equip_power_text_path)
	self.equipCell = self:AddComponent(UIHeroEquipCell, equip_path)
	self.infoNode = self:AddComponent(UIHeroEquipInfoNode, info_path)
	self.resNode = self:AddComponent(UIBaseContainer, res_path)

	self:DefineBtn()
end

function UIHeroEquipInfoView:DefineBtn()
	self.detailBtn = self:AddComponent(UIButton, detail_btn_path)
	self.detailBtn:SetOnClick(function()
		SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
		self:OnDetailBtnClick()
	end)
	self.detailBtn:SetActive(false)

	self.closeBtn = self:AddComponent(UIButton, close_btn_path)
	self.closeBtn:SetOnClick(function()
		SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
		self.ctrl:CloseSelf()
	end)

	self.replaceBtn = self:AddComponent(UIButton, replace_btn_path)
	self.replaceBtn:SetOnClick(function()
		SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
		self:OnReplaceBtnClick()
	end)
	self.replaceBtnText = self:AddComponent(UITextMeshProUGUIEx, replace_text_path)
	self.replaceBtnText:SetLocalText(GameDialogDefine.HERO_EQUIP26)

	self.strengthBtn = self:AddComponent(UIButton, strength_btn_path)
	self.strengthBtn:SetOnClick(function()
		SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
		self:OnStrengthBtnClick()
	end)
	self.strengthBtnText = self:AddComponent(UITextMeshProUGUIEx, strength_text_path)
	self.strengthBtnText:SetLocalText(GameDialogDefine.HERO_EQUIP37)
	self.strengthRed = self:AddComponent(UIBaseContainer, strength_red_path)

	self.promotionBtn = self:AddComponent(UIButton, promotion_btn_path)
	self.promotionBtn:SetOnClick(function()
		SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
		self:OnPromotionBtnClick()
	end)
	self.promotionBtnText = self:AddComponent(UITextMeshProUGUIEx, promotion_text_path)
	self.promotionBtnText:SetLocalText(GameDialogDefine.HERO_EQUIP38)
	self.promotionRed = self:AddComponent(UIBaseContainer, promotion_red_path)

	self.downBtn = self:AddComponent(UIButton, down_btn_path)
	self.downBtn:SetOnClick(function()
		SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
		self:OnDownBtnClick()
	end)
	self.downBtnText = self:AddComponent(UITextMeshProUGUIEx, down_text_path)
	self.downBtnText:SetLocalText(GameDialogDefine.HERO_EQUIP31)
end

function UIHeroEquipInfoView:ComponentDestroy()

end

function UIHeroEquipInfoView:DataDefine()
	self.slot = 0
	self.quality = 0
	self.maxLevel = 0
	self.resItem = {}
	self.wearEquip = {}
end

function UIHeroEquipInfoView:DataDestroy()
	self.slot = 0
	self.quality = 0
	self.maxLevel = 0
	self.resItem = {}
	self.wearEquip = {}
end

function UIHeroEquipInfoView:OnEnable()
	base.OnEnable(self)
end

function UIHeroEquipInfoView:OnDisable()
	base.OnDisable(self)
end

function UIHeroEquipInfoView:OnAddListener()
	base.OnAddListener(self)
	self:AddUIListener(EventId.HeroEquipInstall, self.OnEquipReplace)
	self:AddUIListener(EventId.HeroEquipUninstall, self.OnEquipReplace)
	self:AddUIListener(EventId.HeroEquipUpgrade, self.OnEquipUpgrade)
	self:AddUIListener(EventId.HeroEquipPromotion, self.OnEquipPromotion)
end

function UIHeroEquipInfoView:OnRemoveListener()
	base.OnRemoveListener(self)
	self:RemoveUIListener(EventId.HeroEquipInstall, self.OnEquipReplace)
	self:RemoveUIListener(EventId.HeroEquipUninstall, self.OnEquipReplace)
	self:RemoveUIListener(EventId.HeroEquipUpgrade, self.OnEquipUpgrade)
	self:RemoveUIListener(EventId.HeroEquipPromotion, self.OnEquipPromotion)
end

function UIHeroEquipInfoView:OnEquipReplace()
	self.view.ctrl:CloseSelf()
end

function UIHeroEquipInfoView:OnEquipUpgrade()
	self:RefreshEquip()
	self:RefreshRes()
	self:RefreshBtn()
end

function UIHeroEquipInfoView:OnEquipPromotion()
	self:RefreshRes()
	self:RefreshBtn()
end

function UIHeroEquipInfoView:ReInit()
	local uuid = self:GetUserData()
	self.wearEquip = DataCenter.HeroEquipManager:GetEquipByUuid(uuid)
	if self.wearEquip ~= nil then
		local equipTemplate = DataCenter.HeroEquipTemplateManager:GetTemplate(self.wearEquip.equipId);
		if equipTemplate ~= nil then
			self.slot = equipTemplate.slot
			self.quality = equipTemplate.quality
			self.equipName:SetText(Localization:GetString(equipTemplate.name))
		end
		local upgradeTemplate = DataCenter.HeroEquipUpgradeTemplateManager:GetTemplateBySlotAndQuality(self.slot, self.quality, self.wearEquip.level)
		if upgradeTemplate ~= nil then
			self.maxLevel = upgradeTemplate.highestLevel
		end
	end
	self:RefreshEquip()
	self.infoNode:SetData(self.wearEquip.uuid)
	self:RefreshBtn()
	self:RefreshRes()
end

function UIHeroEquipInfoView:RefreshEquip()
	if self.wearEquip ~= nil then
		self.equipCell:SetData(self.wearEquip, nil, true)

		if self.maxLevel == 0 then
			self.equipLevel:SetActive(false)
		else
			local level = string.format('%s/%s', self.wearEquip.level, self.maxLevel)
			self.equipLevel:SetText(Localization:GetString(GameDialogDefine.HERO_EQUIP34, level))
		end
		
		local power = DataCenter.HeroEquipTemplateManager:GetEquipmentPower(self.wearEquip.equipId, self.wearEquip.level, self.wearEquip.promote);
		self.equipPower:SetText(string.GetFormattedSeperatorNum(power))
		
		local canUpgrade = DataCenter.HeroEquipManager:IsEquipCanUpgrade(self.equipUuid);
		self.strengthRed:SetActive(canUpgrade)
		
		local canPromote = DataCenter.HeroEquipManager:IsEquipCanPromote(self.equipUuid)
		self.promotionRed:SetActive(canPromote)
	end
end

function UIHeroEquipInfoView:RefreshRes()
	if self.wearEquip ~= nil then
		local isMaxLevel = self.wearEquip:IsMaxLevel()
		if isMaxLevel then
			self.resNode:SetActive(false)
			return
		end
		
		local resCost = DataCenter.HeroEquipUpgradeTemplateManager:GetCostRes(self.slot, self.quality, self.wearEquip.level)
		local count = #resCost
		if count > 0 then
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
			self.resNode:SetActive(true)
		else
			self.resNode:SetActive(false)
		end
	end
end

function UIHeroEquipInfoView:RefreshBtn()
	if self.wearEquip ~= nil then
		local isMaxLevel = self.wearEquip:IsMaxLevel()
		local hasPromote = self.wearEquip:HasPromote()
		local isMaxPromote = self.wearEquip:IsMaxPromote()
		if isMaxLevel then
			if hasPromote then
				if isMaxPromote then
					self.strengthBtn:SetActive(false)
					self.promotionBtn:SetActive(true)
					UIGray.SetGray(self.promotionBtn.transform, true, true)
				else
					self.strengthBtn:SetActive(false)
					self.promotionBtn:SetActive(true)
					UIGray.SetGray(self.promotionBtn.transform, false, true)
				end
			else
				self.strengthBtn:SetActive(true)
				UIGray.SetGray(self.strengthBtn.transform, true, true)
				self.promotionBtn:SetActive(false)
			end
		else
			self.strengthBtn:SetActive(true)
			UIGray.SetGray(self.strengthBtn.transform, false, true)
			self.promotionBtn:SetActive(false)
		end
	end
end

function UIHeroEquipInfoView:OnDetailBtnClick()
	
end

function UIHeroEquipInfoView:OnReplaceBtnClick()
	if self.wearEquip ~= nil then
		UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroEquipReplace,{ anim = true,isBlur = true }, self.wearEquip.heroId, self.slot)
	end
end

function UIHeroEquipInfoView:OnStrengthBtnClick()
	if self.wearEquip ~= nil then
		local isMaxLevel = self.wearEquip:IsMaxLevel()
		if isMaxLevel then
			UIUtil.ShowTipsId(GameDialogDefine.REACH_MAX_LEVEL)
			return
		end
		DataCenter.HeroEquipManager:HeroEquipUpgrade(self.wearEquip.uuid);
	end
end

function UIHeroEquipInfoView:OnPromotionBtnClick()
	if self.wearEquip ~= nil then
		local isMaxPromote = self.wearEquip:IsMaxPromote()
		if isMaxPromote then
			UIUtil.ShowTipsId(GameDialogDefine.REACH_MAX_LEVEL)
			return
		end
		UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroEquipPromotion, { anim = true, hideTop = true,isBlur = true }, self.wearEquip.uuid)
	end
end

function UIHeroEquipInfoView:OnDownBtnClick()
	if self.wearEquip ~= nil then
		local equipList = {}
		table.insert(equipList, self.wearEquip.uuid)
		DataCenter.HeroEquipManager:HeroEquipUninstall(self.wearEquip.heroId, equipList);
	end
	self.view.ctrl.CloseSelf()
end

return UIHeroEquipInfoView