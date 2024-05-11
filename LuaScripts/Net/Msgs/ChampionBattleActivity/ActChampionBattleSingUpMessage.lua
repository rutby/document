---
--- Created by yixing.
--- DateTime: 2021/12/02 21:29
--- 冠军对决-报名请求
---
local ActChampionBattleSingUpMessage = BaseClass("ActChampionBattleSingUpMessage", SFSBaseMessage)
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

    DataCenter.ActChampionBattleManager:RefreshChampionBattleInfo(message)
    EventManager:GetInstance():Broadcast(EventId.ChampionBattleSingUpBack)
end

ActChampionBattleSingUpMessage.OnCreate = OnCreate
ActChampionBattleSingUpMessage.HandleMessage = HandleMessage

return ActChampionBattleSingUpMessage