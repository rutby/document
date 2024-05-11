local TaskRewardGetMessage = BaseClass("TaskRewardGetMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
	base.OnCreate(self)
    if param ~= nil then
        self.sfsObj:PutUtfString("id", param.id)
    end
    DataCenter.GuideManager:SetWaitingMessage(WaitMessageFinishType.TaskRewardGet, true)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    DataCenter.TaskManager:TaskRewardGetHandle(t)
    DataCenter.ChapterTaskManager:TaskRewardGetHandle(t)
    DataCenter.GuideManager:SetWaitingMessage(WaitMessageFinishType.TaskRewardGet, nil)
    EventManager:GetInstance():Broadcast(EventId.GuideWaitMessage)
    EventManager:GetInstance():Broadcast(EventId.RefreshActivityRedDot)
end

TaskRewardGetMessage.OnCreate = OnCreate
TaskRewardGetMessage.HandleMessage = HandleMessage

return TaskRewardGetMessage