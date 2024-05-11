---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2024/2/29 10:41
---

local UIHeroInfoDetailPanel = BaseClass("UIHeroInfoDetailPanel", UIBaseContainer)
local base = UIBaseContainer

local this_path = ""
local close_path = "Close"
local title_path = "TitleBg/Title"
local pve_title_path = "PveTitleBg/PveTitle"
local pve_attack_desc_path = "Pve/PveAttackDesc"
local pve_attack_val_path = "Pve/PveAttackDesc/PveAttackVal"
local pve_defence_desc_path = "Pve/PveDefenceDesc"
local pve_defence_val_path = "Pve/PveDefenceDesc/PveDefenceVal"
local pve_hp_desc_path = "Pve/PveHpDesc"
local pve_hp_val_path = "Pve/PveHpDesc/PveHpVal"
local world_title_path = "WorldTitleBg/WorldTitle"
local world_attack_desc_path = "World/WorldAttackDesc"
local world_attack_val_path = "World/WorldAttackDesc/WorldAttackVal"
local world_defence_desc_path = "World/WorldDefenceDesc"
local world_defence_val_path = "World/WorldDefenceDesc/WorldDefenceVal"
local world_army_desc_path = "World/WorldArmyDesc"
local world_army_val_path = "World/WorldArmyDesc/WorldArmyVal"

local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
end

local function OnDestroy(self)
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

local function OnEnable(self)
    base.OnEnable(self)
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function ComponentDefine(self)
    self.anim = self:AddComponent(UIAnimator, this_path)
    self.close_btn = self:AddComponent(UIButton, close_path)
    self.close_btn:SetOnClick(function()
        self:OnCloseClick()
    end)
    self.title_text = self:AddComponent(UITextMeshProUGUIEx, title_path)
    self.title_text:SetLocalText(310145)
    self.pve_title_text = self:AddComponent(UITextMeshProUGUIEx, pve_title_path)
    self.pve_title_text:SetLocalText(321419)
    self.pve_attack_desc_text = self:AddComponent(UITextMeshProUGUIEx, pve_attack_desc_path)
    self.pve_attack_desc_text:SetLocalText(321421)
    self.pve_attack_val_text = self:AddComponent(UITextMeshProUGUIEx, pve_attack_val_path)
    self.pve_defence_desc_text = self:AddComponent(UITextMeshProUGUIEx, pve_defence_desc_path)
    self.pve_defence_desc_text:SetLocalText(321422)
    self.pve_defence_val_text = self:AddComponent(UITextMeshProUGUIEx, pve_defence_val_path)
    self.pve_hp_desc_text = self:AddComponent(UITextMeshProUGUIEx, pve_hp_desc_path)
    self.pve_hp_desc_text:SetLocalText(321423)
    self.pve_hp_val_text = self:AddComponent(UITextMeshProUGUIEx, pve_hp_val_path)
    self.world_title_text = self:AddComponent(UITextMeshProUGUIEx, world_title_path)
    self.world_title_text:SetLocalText(321420)
    self.world_attack_desc_text = self:AddComponent(UITextMeshProUGUIEx, world_attack_desc_path)
    self.world_attack_desc_text:SetLocalText(129030)
    self.world_attack_val_text = self:AddComponent(UITextMeshProUGUIEx, world_attack_val_path)
    self.world_defence_desc_text = self:AddComponent(UITextMeshProUGUIEx, world_defence_desc_path)
    self.world_defence_desc_text:SetLocalText(220053)
    self.world_defence_val_text = self:AddComponent(UITextMeshProUGUIEx, world_defence_val_path)
    self.world_army_desc_text = self:AddComponent(UITextMeshProUGUIEx, world_army_desc_path)
    self.world_army_desc_text:SetLocalText(150132)
    self.world_army_val_text = self:AddComponent(UITextMeshProUGUIEx, world_army_val_path)
end

local function ComponentDestroy(self)

end

local function DataDefine(self)
    self.onClick = nil
end

local function DataDestroy(self)

end

local function OnAddListener(self)
    base.OnAddListener(self)
end

local function OnRemoveListener(self)
    base.OnRemoveListener(self)
end

local function SetData(self, heroData)
    local curRankId = heroData:GetCurMilitaryRankId()
    
    local pveAttack = PveUtil.GetPveHeroAttack(heroData.heroId, heroData.level, curRankId)
    local pveDefence = PveUtil.GetPveHeroDefence(heroData.heroId, heroData.level, curRankId)
    local pveHp = PveUtil.GetPveHeroHp(heroData.heroId, heroData.level, curRankId)
    self.pve_attack_val_text:SetText(string.GetFormattedSeperatorNum(Mathf.Round(pveAttack)))
    self.pve_defence_val_text:SetText(string.GetFormattedSeperatorNum(Mathf.Round(pveDefence)))
    self.pve_hp_val_text:SetText(string.GetFormattedSeperatorNum(Mathf.Round(pveHp)))
    
    local worldAttack, worldDefence = heroData:GetAttrByQuality(nil, nil, curRankId)
    local worldArmy = HeroUtils.GetArmyLimit(heroData.level, curRankId, heroData.rarity, heroData.heroId, heroData.quality)
    self.world_attack_val_text:SetText(string.format("%.2f%%", worldAttack * 0.01))
    self.world_defence_val_text:SetText(string.format("%.2f%%", worldDefence * 0.01))
    self.world_army_val_text:SetText(string.GetFormattedSeperatorNum(Mathf.Round(worldArmy)))
end

local function Show(self)
    self.anim:SetActive(true)
    self.anim:Play("CommonPopup_movein", 0, 0)
end

local function Hide(self)
    self.anim:SetActive(false)
end

local function OnCloseClick(self)
    self:Hide()
end

UIHeroInfoDetailPanel.OnCreate = OnCreate
UIHeroInfoDetailPanel.OnDestroy = OnDestroy
UIHeroInfoDetailPanel.OnEnable = OnEnable
UIHeroInfoDetailPanel.OnDisable = OnDisable
UIHeroInfoDetailPanel.ComponentDefine = ComponentDefine
UIHeroInfoDetailPanel.ComponentDestroy = ComponentDestroy
UIHeroInfoDetailPanel.DataDefine = DataDefine
UIHeroInfoDetailPanel.DataDestroy = DataDestroy
UIHeroInfoDetailPanel.OnAddListener = OnAddListener
UIHeroInfoDetailPanel.OnRemoveListener = OnRemoveListener

UIHeroInfoDetailPanel.SetData = SetData
UIHeroInfoDetailPanel.Show = Show
UIHeroInfoDetailPanel.Hide = Hide
UIHeroInfoDetailPanel.OnCloseClick = OnCloseClick

return UIHeroInfoDetailPanel