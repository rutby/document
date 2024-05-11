
local GetMysteriousRewardResMessage = BaseClass("GetMysteriousRewardResMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, activityId, stage)
    base.OnCreate(self)
    self.sfsObj:PutInt("activityId", tostring(activityId))
    self.sfsObj:PutInt("stage", tostring(stage))
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    local errCode =  t["errorCode"]
    if errCode ~= nil then
        UIUtil.ShowTipsId(errCode)
    else
        DataCenter.MysteriousManager:OnRecvRewardInfo(t)
    end
end

GetMysteriousRewardResMessage.OnCreate = OnCreate
GetMysteriousRewardResMessage.HandleMessage = HandleMessage

return GetMysteriousRewardResMessage