---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zzl
--- DateTime: 
--- 有人请求帮助给盟友推送
local PushCallChallengeActHelpMessage = BaseClass("PushCallChallengeActHelpMessage", SFSBaseMessage)
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
        DataCenter.ActMonsterTowerData:PushCallHelpHandel(t)
    end
end

PushCallChallengeActHelpMessage.OnCreate = OnCreate
PushCallChallengeActHelpMessage.HandleMessage = HandleMessage

return PushCallChallengeActHelpMessage