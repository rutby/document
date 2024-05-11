--- 获取上传头像活动信息
--- Created by shimin.
--- DateTime: 2023/10/9 18:33
---
local GetUploadPicActivityInfoMessage = BaseClass("GetUploadPicActivityInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GetUploadPicActivityInfoMessage:OnCreate(param)
    base.OnCreate(self)
    if param ~= nil then
        self.sfsObj:PutInt("activityId",param.activityId)
    end
end

function GetUploadPicActivityInfoMessage:HandleMessage(t)
    base.HandleMessage(self, t)
    DataCenter.ChangeNameAndPicManager:GetUploadPicActivityInfoHandle(t)
end

return GetUploadPicActivityInfoMessage