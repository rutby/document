
local GetMysteriousRankInfoMessage = BaseClass("GetMysteriousRankInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, activityId)
    base.OnCreate(self)
    self.sfsObj:PutInt("activityId", tostring(activityId))
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    local errCode =  t["errorCode"]
    if errCode ~= nil then
        UIUtil.ShowTipsId(errCode)
    else
        DataCenter.MysteriousManager:OnRecvRankInfo(t)
    end
end

GetMysteriousRankInfoMessage.OnCreate = OnCreate
GetMysteriousRankInfoMessage.HandleMessage = HandleMessage

return GetMysteriousRankInfoMessage