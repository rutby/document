---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2023/3/25 14:46
---


local HeroEvolveTab = BaseClass("HeroEvolveTab", UIBaseContainer)
local base = UIBaseContainer

local not_has_hero_path = "NotHasHero"
local has_hero_path = "HasHero"

local UIHeroCell = require "UI.UIHero2.Common.UIHeroCellSmall"
local GiftButton = require "UI.UIActivityCenterTable.Component.HeroEvolve.HeroEvolveHeroInfo.Component.CommonGiftButton"
local HeroEvolveGiftPackageInfo = require "UI.UIActivityCenterTable.Component.HeroEvolve.HeroEvolveHeroInfo.Component.HeroEvolveGiftPackageInfo"
local text_path = "text"
local gift_path = not_has_hero_path.."/gift"

local story_path = not_has_hero_path.."/StoryText"
local name_path = not_has_hero_path.."/TextHeroName"
local dec_path = not_has_hero_path.."/TextNickName"
local hero_icon_path = not_has_hero_path.."/heroCell/UIHeroCellSmall"

local gift_1_path = has_hero_path.."/gift1"
local gift_2_path = has_hero_path.."/gift2"

local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
end

local function ComponentDefine(self)
    self.text = self:AddComponent(UIText, text_path)
    self.gift = self:AddComponent(GiftButton, gift_path)
    self.story = self:AddComponent(UIText, story_path)
    self.name = self:AddComponent(UIText, name_path)
    self.dec = self:AddComponent(UIText, dec_path)
    self.heroCell = self:AddComponent(UIHeroCell, hero_icon_path)
    self.not_has_hero = self:AddComponent(UIBaseContainer, not_has_hero_path)
    self.has_hero = self:AddComponent(UIBaseContainer, has_hero_path)
    self.gift_1 = self:AddComponent(HeroEvolveGiftPackageInfo, gift_1_path)
    self.gift_2 = self:AddComponent(HeroEvolveGiftPackageInfo, gift_2_path)
end

local function ComponentDestroy(self)

end

local function OnDestroy(self)
    self:ComponentDestroy()
    base.OnDestroy(self)
end

local function OnEnable(self)
    base.OnEnable(self)
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function OnAddListener(self)
    base.OnAddListener(self)
    self:AddUIListener(EventId.UpdateGiftPackData, self.OnUpdateGiftPackData)
    self:AddUIListener(EventId.HeroEvolveSuccess, self.HeroEvolveSuccessHandler)
end

local function OnRemoveListener(self)
    self:RemoveUIListener(EventId.UpdateGiftPackData, self.OnUpdateGiftPackData)
    self:RemoveUIListener(EventId.HeroEvolveSuccess, self.HeroEvolveSuccessHandler)
    base.OnRemoveListener(self)
end

local function SetData(self)
    self.data = HeroEvolveController:GetInstance():GetHeroEvolveTabInfo()
    self:RefreshView()
end

local function OnUpdateGiftPackData(self)
    TimerManager:GetInstance():DelayInvoke(function()
        DataCenter.HeroEvolveActivityManager:AutoDoHeroEvolve()
    end, 0.2)
    self:SetData()
end

local function HeroEvolveSuccessHandler(self)
    self:SetData()
end

local function RefreshView(self)
    self.text:SetText(self.data.text)
    if self.data.hasHero then
        self.has_hero:SetActive(true)
        self.not_has_hero:SetActive(false)
        self.text:SetActive(false)
        self.gift_1:SetData(self.data.heroPackage, HeroEvolveGiftPackageInfo.CellType.Cell_Type_Hero)
        self.gift_2:SetData(self.data.heroMedalPackage, HeroEvolveGiftPackageInfo.CellType.Cell_Type_Medal)
    else
        self.has_hero:SetActive(false)
        self.text:SetActive(true)
        self.not_has_hero:SetActive(true)
        self.gift:SetActive(self.data.gift ~= nil)
        if self.data.gift ~= nil then
            self.gift:SetData(self.data.gift, 1, BindCallback(self, self.OnGiftClick))
        end
        self.story:SetLocalText(self.data.story)
        self.name:SetText(self.data.name)
        self.dec:SetText(self.data.dec)
        self.heroCell:InitWithConfigId(self.data.heroId)
    end
end

local function OnGiftClick(self, packageInfo)
    HeroEvolveController:GetInstance():BuyGiftPackage(packageInfo)
end

HeroEvolveTab.OnGiftClick = OnGiftClick
HeroEvolveTab.OnCreate = OnCreate
HeroEvolveTab.OnDestroy = OnDestroy
HeroEvolveTab.OnEnable = OnEnable
HeroEvolveTab.OnDisable = OnDisable
HeroEvolveTab.ComponentDefine =ComponentDefine
HeroEvolveTab.ComponentDestroy =ComponentDestroy
HeroEvolveTab.OnAddListener =OnAddListener
HeroEvolveTab.OnRemoveListener =OnRemoveListener
HeroEvolveTab.SetData = SetData
HeroEvolveTab.RefreshView = RefreshView
HeroEvolveTab.OnUpdateGiftPackData = OnUpdateGiftPackData
HeroEvolveTab.HeroEvolveSuccessHandler = HeroEvolveSuccessHandler

return HeroEvolveTab