
--- 每日任务一键领取所有可领取奖励
local DailyQuestGetAllRewardMessage = BaseClass("DailyQuestGetAllRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
    base.OnCreate(self)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    DataCenter.DailyTaskManager:DailyQuestGetAllRewardHandle(t)
end

DailyQuestGetAllRewardMessage.OnCreate = OnCreate
DailyQuestGetAllRewardMessage.HandleMessage = HandleMessage

return DailyQuestGetAllRewardMessage