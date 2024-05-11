---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2024/4/29 18:38
---

local UIBuildOpenFireHeroPanel = BaseClass("UIBuildOpenFireHeroPanel", UIBaseContainer)
local base = UIBaseContainer
local UIBuildOpenFireHero = require "UI.UIBuildOpenFire.Component.UIBuildOpenFireHero"

local arrow_path = "ConsumeBg/Arrow"
local left_path = "ConsumeBg/Left"
local left_icon_path = "ConsumeBg/Left/LeftIcon"
local left_desc_path = "ConsumeBg/Left/LeftDesc"
local left_count_path = "ConsumeBg/Left/LeftCount"
local right_path = "ConsumeBg/Right"
local right_icon_path = "ConsumeBg/Right/RightIcon"
local right_desc_path = "ConsumeBg/Right/RightDesc"
local right_count_path = "ConsumeBg/Right/RightCount"
local hero_desc_path = "HeroDesc"
local hero_path = "HeroScroll/Viewport/Content/Hero%s"

local HeroCount = 3

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
    self.arrow_go = self:AddComponent(UIBaseContainer, arrow_path)
    self.left_go = self:AddComponent(UIBaseContainer, left_path)
    self.left_icon_image = self:AddComponent(UIImage, left_icon_path)
    self.left_desc_text = self:AddComponent(UITextMeshProUGUIEx, left_desc_path)
    self.left_desc_text:SetLocalText(100040)
    self.left_count_text = self:AddComponent(UITextMeshProUGUIEx, left_count_path)
    self.right_go = self:AddComponent(UIBaseContainer, right_path)
    self.right_icon_image = self:AddComponent(UIImage, right_icon_path)
    self.right_desc_text = self:AddComponent(UITextMeshProUGUIEx, right_desc_path)
    self.right_desc_text:SetLocalText(100040)
    self.right_count_text = self:AddComponent(UITextMeshProUGUIEx, right_count_path)
    self.hero_desc_text = self:AddComponent(UITextMeshProUGUIEx, hero_desc_path)
    self.hero_desc_text:SetLocalText(100275)
    self.heroes = {}
    for i = 1, HeroCount do
        self.heroes[i] = self:AddComponent(UIBuildOpenFireHero, string.format(hero_path, i))
    end
end

local function ComponentDestroy(self)
    
end

local function DataDefine(self)
    
end

local function DataDestroy(self)

end

local function OnAddListener(self)
    base.OnAddListener(self)
end

local function OnRemoveListener(self)
    base.OnRemoveListener(self)
end

local function Refresh(self)
    self:RefreshConsume()
    self:RefreshHero()
end

local function RefreshConsume(self)
    local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_MAIN)
    local state = DataCenter.VitaManager:GetFurnaceState()
    
    local curTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildData.itemId, buildData.level)
    if curTemplate then
        local strs = string.split(curTemplate.para7, "|")
        local openSpls = string.split(strs[1], ";")
        local openResType = tonumber(openSpls[1])
        local openCount = tonumber(openSpls[2]) * 60
        local boostSpls = string.split(strs[2], ";")
        local boostResType = tonumber(boostSpls[1])
        local boostCount = tonumber(boostSpls[2]) * 60
        local resType, count
        if state == VitaDefines.FurnaceState.OpenWithBooster then
            resType = boostResType
            count = boostCount
        else
            resType = openResType
            count = openCount
        end
        self.left_icon_image:LoadSprite(DataCenter.ResourceManager:GetResourceIconByType(resType))
        self.left_count_text:SetText(count .. "/M")
    end
    
    local nextTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildData.itemId, buildData.level + 1)
    if nextTemplate then
        local strs = string.split(nextTemplate.para7, "|")
        local openSpls = string.split(strs[1], ";")
        local openResType = tonumber(openSpls[1])
        local openCount = tonumber(openSpls[2]) * 60
        local boostSpls = string.split(strs[2], ";")
        local boostResType = tonumber(boostSpls[1])
        local boostCount = tonumber(boostSpls[2]) * 60
        local resType, count
        if state == VitaDefines.FurnaceState.OpenWithBooster then
            resType = boostResType
            count = boostCount
        else
            resType = openResType
            count = openCount
        end
        self.right_icon_image:LoadSprite(DataCenter.ResourceManager:GetResourceIconByType(resType))
        self.right_count_text:SetText(count .. "/M")
        self.right_go:SetActive(true)
        self.arrow_go:SetActive(true)
    else
        self.right_go:SetActive(false)
        self.arrow_go:SetActive(false)
    end
end

local function RefreshHero(self)
    local selectedUuids = DataCenter.CityResidentManager:GetSelectedHeroUuids()
    for i = 1, HeroCount do
        local data = {}
        data.uuid = CityResidentDefines.HeroConfig[i].uuid
        data.isOn = table.hasvalue(selectedUuids, data.uuid)
        data.unlocked = DataCenter.CityResidentManager:IsHeroUnlocked(i)
        self.heroes[i]:SetData(data)
        self.heroes[i]:SetOnClick(function()
            self:OnHeroClick(data)
        end)
    end
end

local function OnHeroClick(self, data)
    DataCenter.CityResidentManager:SetHeroOn(data.uuid, not data.isOn)
    self:RefreshHero()
end

UIBuildOpenFireHeroPanel.OnCreate = OnCreate
UIBuildOpenFireHeroPanel.OnDestroy = OnDestroy
UIBuildOpenFireHeroPanel.OnEnable = OnEnable
UIBuildOpenFireHeroPanel.OnDisable = OnDisable
UIBuildOpenFireHeroPanel.ComponentDefine = ComponentDefine
UIBuildOpenFireHeroPanel.ComponentDestroy = ComponentDestroy
UIBuildOpenFireHeroPanel.DataDefine = DataDefine
UIBuildOpenFireHeroPanel.DataDestroy = DataDestroy
UIBuildOpenFireHeroPanel.OnAddListener = OnAddListener
UIBuildOpenFireHeroPanel.OnRemoveListener = OnRemoveListener

UIBuildOpenFireHeroPanel.Refresh = Refresh
UIBuildOpenFireHeroPanel.RefreshConsume = RefreshConsume
UIBuildOpenFireHeroPanel.RefreshHero = RefreshHero

UIBuildOpenFireHeroPanel.OnHeroClick = OnHeroClick

return UIBuildOpenFireHeroPanel