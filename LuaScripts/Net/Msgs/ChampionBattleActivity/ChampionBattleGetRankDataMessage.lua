---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2022/3/8 16:03
---
local ChampionBattleGetRankDataMessage = BaseClass("ChampionBattleGetRankDataMessage", SFSBaseMessage)
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
    EventManager:GetInstance():Broadcast(EventId.ChampionBattleRankDataBack , message)
end

ChampionBattleGetRankDataMessage.OnCreate = OnCreate
ChampionBattleGetRankDataMessage.HandleMessage = HandleMessage

return ChampionBattleGetRankDataMessage