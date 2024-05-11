---
--- Created by shimin.
--- DateTime: 2020/9/14 15:55
--- 每日任务活跃度领奖
local DailyQuestRewardMessage = BaseClass("DailyQuestRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
    base.OnCreate(self)
    if param then
        self.sfsObj:PutInt("stage", param)
    end
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    DataCenter.DailyTaskManager:DailyQuestRewardMessageHandle(t)
end

DailyQuestRewardMessage.OnCreate = OnCreate
DailyQuestRewardMessage.HandleMessage = HandleMessage

return DailyQuestRewardMessage