---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by E.
--- DateTime: 2022/3/28 19:06
---

local UserGetPVEStageMessage = BaseClass("UserGetPVEStageMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, level)
    base.OnCreate(self) 
    self.sfsObj:PutInt("level", level)
end

local function HandleMessage(self, message)
    base.HandleMessage(self, message)
    DataCenter.BattleLevel:OnGetStageMessage(message)
end

UserGetPVEStageMessage.OnCreate = OnCreate
UserGetPVEStageMessage.HandleMessage = HandleMessage

return UserGetPVEStageMessage