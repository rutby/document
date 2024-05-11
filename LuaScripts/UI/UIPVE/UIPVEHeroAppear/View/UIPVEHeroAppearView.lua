---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 24224.
--- DateTime: 2022/5/24 21:14
---
local UIPVEHeroAppearView = BaseClass("UIPVEHeroAppearView",UIBaseView)
local base = UIBaseView
local anim_path = "V_ui_pve_anim"
local hero_head_path = "V_ui_pve_anim/npc"
local skill_img_path = "V_ui_pve_anim/skill"
local Localization = CS.GameEntry.Localization
local function OnCreate(self)
    base.OnCreate(self)
    local heroId,skillId = self:GetUserData()
    self.heroId = tonumber(heroId)
    self.skillId = tonumber(skillId)
    self.hero_head = self:AddComponent(UIImage, hero_head_path)
    self.skill_img = self:AddComponent(UIImage, skill_img_path)
    self.anim = self:AddComponent(UIAnimator, anim_path)
    self.anim:SetSpeed(1.0 * PveActorMgr:GetInstance():GetSpeedOffset())
end

local function OnDestroy(self)
    base.OnDestroy(self)
end


local function OnEnable(self)
    base.OnEnable(self)
    self:RefreshData()
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function RefreshData(self)
    local defaultHead = "Assets/Main/TextureEx/UIHeroAppear/UIPVEHeroAppear_img_1003.png"
    local skill_pic = GetTableData(HeroUtils.GetHeroXmlName(), tonumber(self.heroId), "pve_skill_pic")
    if skill_pic==nil or skill_pic=="" then
        skill_pic = "UIPVEHeroAppear_img_1003"
    end
    local heroHeadStr = "Assets/Main/TextureEx/UIHeroAppear/"..skill_pic
    self.hero_head:LoadSprite(heroHeadStr,defaultHead)
    local skill_icon = GetTableData(TableName.SkillTab, self.skillId, "icon")
    self.skill_img:LoadSprite(LoadPath.SkillIconsPath ..skill_icon)
end
UIPVEHeroAppearView.OnCreate= OnCreate
UIPVEHeroAppearView.OnDestroy = OnDestroy
UIPVEHeroAppearView.OnEnable= OnEnable
UIPVEHeroAppearView.OnDisable = OnDisable
UIPVEHeroAppearView.RefreshData = RefreshData
return UIPVEHeroAppearView