---
--- Created by yixing.
--- DateTime: 2021/12/30 20:55
---冠军对决-押注记录请求
local ChampionBattleBetRecordMessage = BaseClass("ChampionBattleBetRecordMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
    base.OnCreate(self)
end

local function HandleMessage(self, message)
    base.HandleMessage(self, message)
    if message.errorCode ~= nil then
        UIUtil.ShowTipsId(message.errorCode)
        return
    end
    EventManager:GetInstance():Broadcast(EventId.ChampionBattleBetRecordBack , message)
end

ChampionBattleBetRecordMessage.OnCreate = OnCreate
ChampionBattleBetRecordMessage.HandleMessage = HandleMessage

return ChampionBattleBetRecordMessage