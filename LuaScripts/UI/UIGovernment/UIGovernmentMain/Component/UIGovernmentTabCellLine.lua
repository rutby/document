---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2023/3/20 11:24
---



local UIGovernmentTabCellLine = BaseClass('UIGovernmentTabCellLine', UIBaseContainer)
local base = UIBaseContainer
local ColMax = 4
local Cell = require("UI.UIGovernment.UIGovernmentMain.Component.UIGovernmentTabCell")

local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
end

local function OnDestroy(self)
    self:ComponentDestroy()
    base.OnDestroy(self)
end

local function ComponentDefine(self)
    self.cellObjList = {}
    for k = 1, ColMax do
        local cell = self:AddComponent(Cell, 'Cell_' .. k)
        table.insert(self.cellObjList, cell)
    end
end

local function ComponentDestroy(self)
    self.cellObjList = nil
end

local function SetData(self, list, clickFunc)
    for k, cell in ipairs(self.cellObjList) do
        local data = list.list[k]
        cell:SetActive(data ~= nil)
        if data ~= nil then
            cell:SetData(data, clickFunc)
        end
    end
end

UIGovernmentTabCellLine.OnCreate= OnCreate
UIGovernmentTabCellLine.OnDestroy = OnDestroy
UIGovernmentTabCellLine.ComponentDefine = ComponentDefine
UIGovernmentTabCellLine.ComponentDestroy = ComponentDestroy
UIGovernmentTabCellLine.SetData = SetData

return UIGovernmentTabCellLine