---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 24224.
--- DateTime: 2022/11/25 17:40
---
local SeasonBalanceReceivePackageMessage = BaseClass("SeasonBalanceReceivePackageMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization
local function OnCreate(self,packageId)
    base.OnCreate(self)
    self.sfsObj:PutInt("packageId",packageId)
end

local function HandleMessage(self, message)
    base.HandleMessage(self, message)
    local errCode =  message["errorCode"]
    if errCode ~= nil then
        UIUtil.ShowTipsId(errCode)
    else
        DataCenter.DesertDataManager:OnGetSelfRewardCallBack()
        if message["reward"]~=nil then
            if message["heroExpReward"] ~= nil then
                -- 英雄经验奖励
                local reportReward = PBController.ParsePb1(message["heroExpReward"], "protobuf.ReportReward")
                local exps = reportReward["rewardHeroExps"]
                DataCenter.RewardManager:ShowCommonReward(message,CS.GameEntry.Localization:GetString("132234"),nil,exps)
            else
                DataCenter.RewardManager:ShowCommonReward(message,nil,nil)
            end

            for k,v in pairs(message["reward"]) do
                DataCenter.RewardManager:AddOneReward(v)
            end
        end

        EventManager:GetInstance():Broadcast(EventId.OnClaimSeasonRewardSucc)
    end
end

SeasonBalanceReceivePackageMessage.OnCreate = OnCreate
SeasonBalanceReceivePackageMessage.HandleMessage = HandleMessage

return SeasonBalanceReceivePackageMessage