---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zzl.
--- DateTime: 

local PushDailyKillBossNumberMessage = BaseClass("PushDailyKillBossNumberMessage", SFSBaseMessage)
-- 基类，用来调用基类方法
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization
local function OnCreate(self)
    base.OnCreate(self)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    local errCode =  t["errorCode"]
    if errCode ~= nil then
        UIUtil.ShowTipsId(errCode) 
    else
        DataCenter.MonsterManager:UpdateKillBossNum(t)
    end
end

PushDailyKillBossNumberMessage.OnCreate = OnCreate
PushDailyKillBossNumberMessage.HandleMessage = HandleMessage

return PushDailyKillBossNumberMessage