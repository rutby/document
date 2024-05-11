local ParsePushSetMessage = BaseClass("ParsePushSetMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
	base.OnCreate(self)
    if param ~= nil then
        self.sfsObj:PutInt("type", param.type)
        self.sfsObj:PutInt("status", param.status)
        self.sfsObj:PutInt("audio", param.audio)
    end
end

local function HandleMessage(self, t)
	base.HandleMessage(self, t)
    DataCenter.PushSettingData:ParsePushSetHandle(t)
end

ParsePushSetMessage.OnCreate = OnCreate
ParsePushSetMessage.HandleMessage = HandleMessage

return ParsePushSetMessage