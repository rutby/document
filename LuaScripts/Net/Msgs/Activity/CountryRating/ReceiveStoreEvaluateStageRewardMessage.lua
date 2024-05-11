--- 
--- Created by zzl
--- DateTime: 2023/10/9 18:33
---
local ReceiveStoreEvaluateStageRewardMessage = BaseClass("ReceiveStoreEvaluateStageRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

function ReceiveStoreEvaluateStageRewardMessage:OnCreate(activityId,stage)
    base.OnCreate(self)
    self.sfsObj:PutInt("activityId",activityId)
    self.sfsObj:PutInt("stage",stage)
end

function ReceiveStoreEvaluateStageRewardMessage:HandleMessage(t)
    base.HandleMessage(self, t)
    local errCode =  t["errorCode"]
    if errCode ~= nil then
        UIUtil.ShowTipsId(errCode)
    else
        DataCenter.CountryRatingData:GetReward(t)
    end
end

return ReceiveStoreEvaluateStageRewardMessage