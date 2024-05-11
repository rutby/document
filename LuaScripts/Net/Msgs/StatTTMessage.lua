---
--- Created by shimin.
--- DateTime: 2021/8/18 15:56
---
local StatTTMessage = BaseClass("StatTTMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
    base.OnCreate(self)
    if param ~= nil then
        self.sfsObj:PutUtfString("id", param.id)
        self.sfsObj:PutUtfString("curId", param.curId)
        self.sfsObj:PutUtfString("type", param.type)
    end
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
end

StatTTMessage.OnCreate = OnCreate
StatTTMessage.HandleMessage = HandleMessage

return StatTTMessage