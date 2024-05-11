---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2022/4/6 10:52
---

local UITroopSkillItem = BaseClass("UITroopSkillItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

local this_path = ""
local icon_path = "Icon"
local circle_path = "Icon/Circle"
local time_path = "Time"
local glow_path = "Glow"

local ICON_WIDTH = 70

local function OnCreate(self)
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

local function OnDestroy(self)
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

local function ComponentDefine(self)
    self.btn = self:AddComponent(UIButton, this_path)
    self.btn:SetOnClick(function()
        self:OnClick()
    end)
    self.icon_image = self:AddComponent(UIImage, icon_path)
    self.circle_image = self:AddComponent(UIImage, circle_path)
    self.time_text = self:AddComponent(UIText, time_path)
    self.glow_go = self:AddComponent(UIBaseContainer, glow_path)
end

local function ComponentDestroy(self)
    self.btn = nil
    self.icon_image = nil
    self.circle_image = nil
    self.time_text = nil
    self.glow_go = nil
end

local function DataDefine(self)
    self.state = 0
    self.skill = nil
    self.totalCdTime = 0
    self.isGlowing = false
    self.timer = nil
end

local function DataDestroy(self)
    self.state = nil
    self.skill = nil
    self.totalCdTime = nil
    self.isGlowing = nil
    if self.timer then
        self.timer:Stop()
    end
    self.timer = nil
end

local function OnAddListener(self)
    base.OnAddListener(self)
end

local function OnRemoveListener(self)
    base.OnRemoveListener(self)
end

local function OnEnable(self)
    base.OnEnable(self)
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function SetData(self, skill)
    self.skill = skill
end

local function RefreshTime(self)
    
end

local function ShowGlow(self, show)
    if self.isGlowing ~= show then
        self.glow_go:SetActive(show)
        self.isGlowing = show
    end
end

local function OnClick(self)
    
end

UITroopSkillItem.OnCreate = OnCreate
UITroopSkillItem.OnDestroy = OnDestroy
UITroopSkillItem.ComponentDefine = ComponentDefine
UITroopSkillItem.ComponentDestroy = ComponentDestroy
UITroopSkillItem.DataDefine = DataDefine
UITroopSkillItem.DataDestroy = DataDestroy
UITroopSkillItem.OnAddListener = OnAddListener
UITroopSkillItem.OnRemoveListener = OnRemoveListener
UITroopSkillItem.OnEnable = OnEnable
UITroopSkillItem.OnDisable = OnDisable

UITroopSkillItem.State = State
UITroopSkillItem.SetData = SetData
UITroopSkillItem.RefreshTime = RefreshTime
UITroopSkillItem.ShowGlow = ShowGlow
UITroopSkillItem.OnClick = OnClick

return UITroopSkillItem