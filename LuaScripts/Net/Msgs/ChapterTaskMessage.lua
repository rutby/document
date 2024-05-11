local ChapterTaskMessage = BaseClass("ChapterTaskMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
	base.OnCreate(self)
    if param ~= nil then
        self.sfsObj:PutUtfString("chapterid", tostring(param.chapterId))
        if param.garbageRefresh ~= nil then
            self.sfsObj:PutBool("garbageRefresh",false)
        end
    end
end

local function HandleMessage(self, t)
	base.HandleMessage(self, t)
    DataCenter.ChapterTaskManager:ChapterTaskHandle(t)
end

ChapterTaskMessage.OnCreate = OnCreate
ChapterTaskMessage.HandleMessage = HandleMessage

return ChapterTaskMessage