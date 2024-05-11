---
--- Created by shimin.
--- DateTime: 2021/8/18 16:01
---
local SaveGuideMessage = BaseClass("SaveGuideMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
    base.OnCreate(self)
    if param ~= nil then
        self.sfsObj:PutUtfString("saveKey", param.saveKey)
        self.sfsObj:PutUtfString("saveValue", param.saveValue)
    end
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    EventManager:GetInstance():Broadcast(EventId.SaveGuide)
end

SaveGuideMessage.OnCreate = OnCreate
SaveGuideMessage.HandleMessage = HandleMessage

return SaveGuideMessage