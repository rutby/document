-- 获取联盟boss活动信息

local  ReceiveAllianceBossFreeRewardMessage = BaseClass("ReceiveAllianceBossFreeRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, activityId)
    base.OnCreate(self)
    self.sfsObj:PutInt("activityId", activityId)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)

    local errCode =  t["errorCode"]
    if errCode ~= nil then
        --错误码处理
        UIUtil.ShowTipsId(errCode)
        
    else
        --正常逻辑
        DataCenter.AllianceBossManager:OnHandleReceiveAllianceBossFreeRewardMessage(t)
    end
end

ReceiveAllianceBossFreeRewardMessage.OnCreate = OnCreate
ReceiveAllianceBossFreeRewardMessage.HandleMessage = HandleMessage

return  ReceiveAllianceBossFreeRewardMessage