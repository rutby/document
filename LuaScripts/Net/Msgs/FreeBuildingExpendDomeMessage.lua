---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by guq.
--- DateTime: 2021/5/7 18:42
---
local FreeBuildingExpendDomeMessage = BaseClass("FreeBuildingExpendDomeMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
    base.OnCreate(self)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    DataCenter.BuildManager:FreeBuildingExpendDomeHandle(t)
end

FreeBuildingExpendDomeMessage.OnCreate = OnCreate
FreeBuildingExpendDomeMessage.HandleMessage = HandleMessage

return FreeBuildingExpendDomeMessage