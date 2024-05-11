---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by guqu.
--- DateTime: 2020/11/5 16:19
---
local StrongestCommandTotalRankMessage = BaseClass("StrongestCommandTotalRankMessage", SFSBaseMessage)
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
        if t["selfRank"]~=nil and  t["selfRank"]~=-1 then
            DataCenter.StrongestCommanderDataManager:ParseTotalRankData(t)
            EventManager:GetInstance():Broadcast(EventId.ZONE_CONTRIBUTE_RANK_UPDATE)
        end
    end
end

StrongestCommandTotalRankMessage.OnCreate = OnCreate
StrongestCommandTotalRankMessage.HandleMessage = HandleMessage

return StrongestCommandTotalRankMessage