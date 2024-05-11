---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2022/12/9 8:59
---PushAlMineScoreChangeMessage.lua


local PushAlMineScoreChangeMessage = BaseClass("PushAlMineScoreChangeMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization
local function OnCreate(self, uuid)
    base.OnCreate(self)
    self.sfsObj:PutLong("uuid", uuid)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    local errCode =  t["errorCode"]
    if errCode ~= nil then
        UIUtil.ShowTipsId(errCode)
    else
        DataCenter.AllianceMineManager:UpdateAlMineScoreChange(t)
    end
end

PushAlMineScoreChangeMessage.OnCreate = OnCreate
PushAlMineScoreChangeMessage.HandleMessage = HandleMessage

return PushAlMineScoreChangeMessage