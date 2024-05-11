-- 获取殖民战争玩家排行
local  GetColonialWarUserRankMessage = BaseClass("GetColonialWarUserRankMessage", SFSBaseMessage)
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
        EventManager:GetInstance():Broadcast(EventId.ColonizeWarPlayerRank,t)
    end
end

GetColonialWarUserRankMessage.OnCreate = OnCreate
GetColonialWarUserRankMessage.HandleMessage = HandleMessage

return  GetColonialWarUserRankMessage