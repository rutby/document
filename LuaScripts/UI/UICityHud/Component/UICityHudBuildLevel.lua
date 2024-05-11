---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2023/11/29 14:29
---

local base = require "UI.UICityHud.Component.UICityHudBase"
local UICityHudBuildLevel = BaseClass("UICityHudBuildLevel", base)

local this_path = ""
local text_path = "Root/Bg/GameObject/Text"
local level_bg_path = "Root/Bg/level_bg"
local level_text_path = "Root/Bg/level_bg/level_text"
local can_upgrade_go_path = "Root/Bg/GameObject/can_upgrade_go"

local function ComponentDefine(self)
    base.ComponentDefine(self)
    self.text = self:AddComponent(UITextMeshProUGUIEx, text_path)
    self.anim = self:AddComponent(UIAnimator, this_path)
    self.level_text = self:AddComponent(UITextMeshProUGUIEx, level_text_path)
    self.level_bg = self:AddComponent(UIBaseContainer, level_bg_path)
    self.can_upgrade_go = self:AddComponent(UIBaseContainer, can_upgrade_go_path)
end

local function SetParam(self, param)
    base.SetParam(self, param)
    self.root_go.transform.localPosition = param.offset or Vector3.zero
    if param.level == nil then
        self.level_bg:SetActive(false)
    else
        self.level_bg:SetActive(true)
        self.level_text:SetText(param.level)
    end
    self.text:SetText(param.text)
    if self.isInView then
        if DataCenter.CityLabelManager:CanShow() then
            self.anim:Play(CityHubAnimName.DefaultShow, 0, 0)
        else
            self.anim:Play(CityHubAnimName.DefaultHide, 0, 0)
        end
    end
    self:RefreshCanUpgradeArrow()
end

function UICityHudBuildLevel:SetRootActive(active)
    if self.isInView then
        if active then
            self.anim:Play(CityHubAnimName.HideToShow, 0, 0)
            self:RefreshCanUpgradeArrow()
        else
            self.anim:Play(CityHubAnimName.ShowToHide, 0, 0)
        end
    end
end

function UICityHudBuildLevel:RefreshCanUpgradeArrow()
    if self.param.level ~= nil then
        local data = DataCenter.BuildCityBuildManager:GetCityBuildDataByBuildId(self.param.buildId)
        if data ~= nil then
            if data:CanBuildUpgrade() then
                self.can_upgrade_go:SetActive(true)
            else
                self.can_upgrade_go:SetActive(false)
            end
        end
    else
        self.can_upgrade_go:SetActive(false)
    end
end

function UICityHudBuildLevel:SetInView(isInView)
    if self.isInView == isInView then
        return
    end
    self.isInView = isInView
    self:SetActive(isInView)
    if isInView then
        if DataCenter.CityLabelManager:CanShow() then
            self.anim:Play(CityHubAnimName.DefaultShow, 0, 0)
        else
            self.anim:Play(CityHubAnimName.DefaultHide, 0, 0)
        end
    end
end

UICityHudBuildLevel.ComponentDefine = ComponentDefine
UICityHudBuildLevel.SetParam = SetParam

return UICityHudBuildLevel