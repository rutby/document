---
--- Created by shimin.
--- DateTime: 2020/8/18 20:45
---
local AllianceCompeteWeekResultMessage = BaseClass("AllianceCompeteWeekResultMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
    base.OnCreate(self)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    DataCenter.AllianceCompeteDataManager:RefreshWeekResultVS(t)
end

AllianceCompeteWeekResultMessage.OnCreate = OnCreate
AllianceCompeteWeekResultMessage.HandleMessage = HandleMessage

return AllianceCompeteWeekResultMessage