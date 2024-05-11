---
--- Created by yixing.
--- DateTime: 2021/12/30 20:55
--- 冠军对决-押注界面数据请求
local ChampionBattleBetViewMessage = BaseClass("ChampionBattleBetViewMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, phase,location)
    base.OnCreate(self)
    self.sfsObj:PutLong("phase",phase)
    self.sfsObj:PutLong("location",location)
end

local function HandleMessage(self, message)
    base.HandleMessage(self, message)
    if message.errorCode ~= nil then
        UIUtil.ShowTipsId(message.errorCode)
        return
    end
    EventManager:GetInstance():Broadcast(EventId.ChampionBattleBetViewBack , message)--, message.leftOdds,message.rightOdds, message.leftTotalBet, message.rightTotalBet, message.betTimes)
end

ChampionBattleBetViewMessage.OnCreate = OnCreate
ChampionBattleBetViewMessage.HandleMessage = HandleMessage

return ChampionBattleBetViewMessage