local PushTaskChapterTaskMessage = BaseClass("PushTaskChapterTaskMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
	base.OnCreate(self)
end

local function HandleMessage(self, t)
	base.HandleMessage(self, t)
	DataCenter.ChapterTaskManager:PushTaskChapterTaskHandle(t)
end

PushTaskChapterTaskMessage.OnCreate = OnCreate
PushTaskChapterTaskMessage.HandleMessage = HandleMessage

return PushTaskChapterTaskMessage