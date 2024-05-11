--- 领取上传头像活动奖励
--- Created by shimin.
--- DateTime: 2023/10/9 18:33
---
local ReceiveUploadPicActivityRewardMessage = BaseClass("ReceiveUploadPicActivityRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

function ReceiveUploadPicActivityRewardMessage:OnCreate(param)
    base.OnCreate(self)
    if param ~= nil then
        self.sfsObj:PutInt("activityId",param.activityId)
    end
end

function ReceiveUploadPicActivityRewardMessage:HandleMessage(t)
    base.HandleMessage(self, t)
    DataCenter.ChangeNameAndPicManager:ReceiveUploadPicActivityRewardHandle(t)
end

return ReceiveUploadPicActivityRewardMessage