---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zzl
--- DateTime: 
--- 挑战boss被击杀推送
local PushChallengeBossKilledMessage = BaseClass("PushChallengeBossKilledMessage", SFSBaseMessage)
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
        DataCenter.ActMonsterTowerData:PushBossKilledHandel(t)
    end
end

PushChallengeBossKilledMessage.OnCreate = OnCreate
PushChallengeBossKilledMessage.HandleMessage = HandleMessage

return PushChallengeBossKilledMessage