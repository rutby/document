---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2022/4/6 10:50
---

local UITroopSkillList = BaseClass("UITroopSkillList", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local Resource = CS.GameEntry.Resource
local UITroopSkillItem = require "UI.UIMainNew.Comp.UIMainLeftPart.TroopList.UITroopSkillItem"

local this_path = ""

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
    self.this_go = self:AddComponent(UIBaseContainer, this_path)
end

local function ComponentDestroy(self)
    self.this_go = nil
end

local function DataDefine(self)
    self.itemDict = {}
    self.reqDict = {}
    self.active = false
end

local function DataDestroy(self)
    self.itemDict = nil
    self.reqDict = nil
    self.active = nil
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
 
local function ReInit(self)
    if self.active then
        return
    end
    
    self:Hide()
end

local function ClearItems(self)
    if not table.IsNullOrEmpty(self.reqDict) then
        self.this_go:RemoveComponents(UITroopSkillItem)
        for _, req in pairs(self.reqDict) do
            req:Destroy()
        end
        self.itemDict = {}
        self.reqDict = {}
    end
end

local function Show(self)
    self:SetActive(true)
    self.active = true
end

local function Hide(self)
    self:ClearItems()
    self:SetActive(false)
    self.active = false
end

UITroopSkillList.OnCreate = OnCreate
UITroopSkillList.OnDestroy = OnDestroy
UITroopSkillList.ComponentDefine = ComponentDefine
UITroopSkillList.ComponentDestroy = ComponentDestroy
UITroopSkillList.DataDefine = DataDefine
UITroopSkillList.DataDestroy = DataDestroy
UITroopSkillList.OnAddListener = OnAddListener
UITroopSkillList.OnRemoveListener = OnRemoveListener
UITroopSkillList.OnEnable = OnEnable
UITroopSkillList.OnDisable = OnDisable

UITroopSkillList.ReInit = ReInit
UITroopSkillList.ClearItems = ClearItems
UITroopSkillList.Show = Show
UITroopSkillList.Hide = Hide

return UITroopSkillList