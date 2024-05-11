---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2022/5/6 11:32
---

local ClaimMineCaveRewardMessage = BaseClass("ClaimMineCaveRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self,uuid)
    base.OnCreate(self)
    self.sfsObj:PutLong('uuid', uuid)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    local errCode =  t["errorCode"]
    if errCode ~= nil then
        UIUtil.ShowTipsId(errCode)
    else
        if t["reward"] then
            DataCenter.MineCaveManager:ShowMineRewards(t)
            --DataCenter.RewardManager:ShowCommonReward(t)
            for k,v in pairs(t["reward"]) do
                DataCenter.RewardManager:AddOneReward(v)
            end
        end
        DataCenter.MineCaveManager:UpdateMineCaveInfo(t)
    end
end

ClaimMineCaveRewardMessage.OnCreate = OnCreate
ClaimMineCaveRewardMessage.HandleMessage = HandleMessage

return ClaimMineCaveRewardMessage