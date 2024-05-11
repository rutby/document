---
--- Created by yixing.
--- DateTime: 2021/12/04 11:40
--- 冠军对决-宝箱领取
---
local ActChampionBattleRewardMessage = BaseClass("ActChampionBattleRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, boxIndex)
    base.OnCreate(self)
    self.sfsObj:PutLong("boxIndex", boxIndex)
end

local function HandleMessage(self, message)
    base.HandleMessage(self, message)
    if message.errorCode ~= nil then
        UIUtil.ShowTipsId(message.errorCode)
        return
    end
    local rewardInfo = message["reward"]
    if rewardInfo ~= nil then
        --if self.callBack then 
        --    self.callBack()
        --    self.callBack = nil
        --end
        DataCenter.RewardManager:ShowCommonReward(message)
        for _, v in pairs(message["reward"]) do
            DataCenter.RewardManager:AddOneReward(v)
        end

        DataCenter.ActChampionBattleManager:RefreshChampionBattleInfo(message)
        EventManager:GetInstance():Broadcast(EventId.ChampionBattleReceiveBoxBack)
        EventManager:GetInstance():Broadcast(EventId.ChampionBattleEntranceNotice)
    end
end

ActChampionBattleRewardMessage.OnCreate = OnCreate
ActChampionBattleRewardMessage.HandleMessage = HandleMessage

return ActChampionBattleRewardMessage