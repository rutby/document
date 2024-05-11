---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2023/1/13 15:56
---
local SeasonForceGetRewardMessage = BaseClass("SeasonForceGetRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization
local function OnCreate(self,uuidList)
    base.OnCreate(self)
    local uuidArr = SFSArray.New()
    for i, v in ipairs(uuidList) do
        uuidArr:AddLong(v)
    end
    self.sfsObj:PutSFSArray("uuidArr", uuidArr)
end

local function HandleMessage(self, message)
    base.HandleMessage(self, message)
    local errCode =  message["errorCode"]
    if errCode ~= nil then
        UIUtil.ShowTipsId(errCode)
    else
        if message["forceRewardArr"]~=nil then
            DataCenter.DesertDataManager:RefreshForceReward(message["forceRewardArr"])
        end
        if message["reward"]~=nil then
            DataCenter.RewardManager:ShowCommonReward(message,nil,nil)

            for k,v in pairs(message["reward"]) do
                DataCenter.RewardManager:AddOneReward(v)
            end
        end
    end
end

SeasonForceGetRewardMessage.OnCreate = OnCreate
SeasonForceGetRewardMessage.HandleMessage = HandleMessage

return SeasonForceGetRewardMessage