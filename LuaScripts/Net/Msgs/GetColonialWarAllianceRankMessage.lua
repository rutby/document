-- 获取殖民战争联盟排行
local  GetColonialWarAllianceRankMessage = BaseClass("GetColonialWarAllianceRankMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, activityId)
    base.OnCreate(self)
    self.sfsObj:PutInt("activityId", activityId)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)

    local errCode =  t["errorCode"]
    if errCode ~= nil then
        UIUtil.ShowTipsId(errCode)
    else
        EventManager:GetInstance():Broadcast(EventId.ColonizeWarAllianceRank,t)
    end
end

GetColonialWarAllianceRankMessage.OnCreate = OnCreate
GetColonialWarAllianceRankMessage.HandleMessage = HandleMessage

return  GetColonialWarAllianceRankMessage