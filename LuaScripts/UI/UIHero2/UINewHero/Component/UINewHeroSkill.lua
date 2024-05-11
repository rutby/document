---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zhangliheng.
--- DateTime: 8/10/21 5:01 PM
---


local UINewHeroSkill = BaseClass("UINewHeroSkill", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIHeroSkillTipView = require "UI.UIHero2.UIHeroSkillTip.View.UIHeroSkillTipView"
local UIHeroArkTip = require 'UI.UIHero2.UIHeroInfo.Component.UIHeroArkTip'
local UIGray = CS.UIGray
local Screen = CS.UnityEngine.Screen

local SkillSlotMax = 6
local Radius = 125

local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
end

local function OnDestroy(self)
    self:ComponentDestroy()
    base.OnDestroy(self)
end

local function ComponentDefine(self)
    self.btnSkills = {}

    self.textSkill = self:AddComponent(UITextMeshProUGUIEx, 'ImgBgTextSkill/TextTitleSkill')
    self.btnArk = self:AddComponent(UIButton, 'NodeArk')
    self.imgArk = self:AddComponent(UIImage, 'NodeArk')
    self.textArk = self:AddComponent(UITextMeshProUGUIEx, 'NodeArk/TextArk')

    self.btnArk:SetOnClick(BindCallback(self, self.OnBtnArkClick))

    for k=1, SkillSlotMax do
        local nodeBtn = self:AddComponent(UIButton, "SkillContent/Skill" .. k)
        nodeBtn:SetOnClick(function()  
SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
            self:OnBtnSkillClick(k)
        end)

        local imgIcon = self:AddComponent(UIImage, "SkillContent/Skill" .. k .. "/ImgIcon" .. k)
        local textLevel = self:AddComponent(UITextMeshProUGUIEx, "SkillContent/Skill" .. k .. "/TextLv" .. k)
        table.insert(self.btnSkills, {btn = nodeBtn, icon = imgIcon, textLv = textLevel})
    end

    self.arkTipPanel = self:AddComponent(UIHeroArkTip, 'ArkTipPanel')
    self.arkTipPanel:SetActive(false)
    self.textSkill:SetLocalText(150106) 
end

local function ComponentDestroy(self)
    self.btnSkills = nil
    self.textSkill = nil
    self.btnArk = nil
    self.imgArk = nil
    self.textArk = nil
    self.arkTipPanel = nil
end

local function InitData(self, heroUuid)
    self.heroUuid = heroUuid
    local heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
    local heroCfgId = heroData.heroId
    self.heroCfgId = heroCfgId

    self:UpdateView()
end

local function OnBtnSkillClick(self, index)
    local heroData = DataCenter.HeroDataManager:GetHeroByUuid(self.heroUuid)
    local config = heroData.config

    local skillIdList = config['skill']
    if type(skillIdList) ~= 'table' then
        skillIdList = string.split(skillIdList, '|')
    end
    
    local skillId = tonumber(skillIdList[index])
    local level = HeroUtils.SkillLevelLimit     --图鉴默认最大等级
    local unlockQuality = 1
    if heroData ~= nil then
        local skillData = heroData:GetSkillData(skillId)
        if skillData ~= nil then
            level = skillData.level
            unlockQuality = skillData.unlockQuality
        end
    end

    local scaleFactor = UIManager:GetInstance():GetScaleFactor()

    local btn = self.btnSkills[index].btn
    local position = btn.transform.position -- + Vector3.New(0, -50, 0) * scaleFactor

    local screenPos = PosConverse.WorldToScreenPos(position)
    local dir = screenPos.y < (Screen.height/2-80) and UIHeroSkillTipView.Direction.ABOVE or UIHeroSkillTipView.Direction.BELOW


    local param = UIHeroSkillTipView.Param.New()
    param.content = Localization:GetString("150155")
    param.dir = dir
    param.skillId = skillId
    param.skillLevel = level
    param.skillUnlockQuality = unlockQuality
    param.pivot = 0.8--0.45 + index * 0.1
    param.position = position + Vector3.New(0,  dir == UIHeroSkillTipView.Direction.ABOVE and 55 or -50, 0) * scaleFactor

    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroSkillTip, { anim = false }, param)
end

local function UpdateView(self)
    local heroData = DataCenter.HeroDataManager:GetHeroByUuid(self.heroUuid)
    local config = heroData.config

    local skillArray = config['skill']
    if type(skillArray) ~= 'table' then
        skillArray = string.split(skillArray, '|')
    end
    
    local skillCount = #skillArray

    local angle = 360 / skillCount
    local totalLevel = 0
    for k, t in ipairs(self.btnSkills) do
        if k> skillCount then
            t.btn:SetActive(false)
            goto continue
        end

        t.btn:SetActive(true)

        t.btn.rectTransform:Set_localPosition(0, Radius, 0)
        t.btn.rectTransform:RotateAround(self.btnArk.transform.position, Vector3.back, angle * (k-1))
        t.btn.rectTransform.localRotation = Quaternion.Euler(0, 0, 0)

        local skillId = tonumber(skillArray[k])
        t.icon:LoadSprite(HeroUtils.GetSkillIcon(skillId))
        local level = HeroUtils.SkillLevelLimit
        if heroData ~= nil then
            local skillData = heroData:GetSkillData(skillId)
            if skillData ~= nil then
                level = skillData.level
            end
        end

        UIGray.SetGray(t.btn.transform, level <= 0, true)
        totalLevel = totalLevel + level
        t.textLv:SetText(level == 0 and '' or level)

        ::continue::
    end

    self:UpdateArk(totalLevel)
end

local function UpdateArk(self, totalLevel)
    local arkId, arkGrade = HeroUtils.GetArkIdAndGrade(self.heroCfgId, totalLevel)
    self.imgArk:LoadSprite(HeroUtils.GetArkGradeIcon(arkGrade, true))
    self.textArk:SetText(totalLevel)
    UIGray.SetGray(self.btnArk.transform, arkGrade <= 0, true)
end

local function OnBtnArkClick(self)
    self.arkTipPanel:SetData(self.heroCfgId)
    self.arkTipPanel:SetActive(true)
end

UINewHeroSkill.OnCreate = OnCreate
UINewHeroSkill.OnDestroy = OnDestroy
UINewHeroSkill.ComponentDefine = ComponentDefine
UINewHeroSkill.ComponentDestroy = ComponentDestroy

UINewHeroSkill.InitData = InitData
UINewHeroSkill.OnBtnSkillClick = OnBtnSkillClick
UINewHeroSkill.UpdateView = UpdateView
UINewHeroSkill.UpdateArk = UpdateArk
UINewHeroSkill.OnBtnArkClick = OnBtnArkClick

return UINewHeroSkill