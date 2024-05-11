---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1020.
--- DateTime: 2023/5/24 14:51
---

local ScratchOffGameActivityInfoMessage = BaseClass("ScratchOffGameLotteryMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, activityId)
    base.OnCreate(self)
    self.sfsObj:PutInt("activityId", tostring(activityId))
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    local errCode =  t["errorCode"]
    if errCode ~= nil then
        UIUtil.ShowTipsId(errCode)
    else
        DataCenter.ScratchOffGameManager:OnRecvActivityParamInfo(t)
    end
end

ScratchOffGameActivityInfoMessage.OnCreate = OnCreate
ScratchOffGameActivityInfoMessage.HandleMessage = HandleMessage

return ScratchOffGameActivityInfoMessage