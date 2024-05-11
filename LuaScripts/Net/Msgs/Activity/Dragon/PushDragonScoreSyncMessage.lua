---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2023/6/8 16:55
---
local PushDragonScoreSyncMessage = BaseClass("PushDragonScoreSyncMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
    base.OnCreate(self)

end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    local errCode =  t["errorCode"]
    if errCode ~= nil then
        UIUtil.ShowTipsId(errCode)
    else
        DataCenter.ActDragonManager:OnHandleBattleScore(t)
    end
end

PushDragonScoreSyncMessage.OnCreate = OnCreate
PushDragonScoreSyncMessage.HandleMessage = HandleMessage

return PushDragonScoreSyncMessage