---
--- Created by .
--- DateTime:
--- 每日任务活跃度领奖(可以领多个)
local DailyQuestRewardMultiMessage = BaseClass("DailyQuestRewardMultiMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
    base.OnCreate(self)
    if param then
        local array = SFSArray.New()
        table.walk(param,function (k,v)
            array:AddInt(v)
        end)
        self.sfsObj:PutSFSArray("stages", array)
    end
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    DataCenter.DailyTaskManager:DailyQuestRewardMessageHandle(t)
end

DailyQuestRewardMultiMessage.OnCreate = OnCreate
DailyQuestRewardMultiMessage.HandleMessage = HandleMessage

return DailyQuestRewardMultiMessage