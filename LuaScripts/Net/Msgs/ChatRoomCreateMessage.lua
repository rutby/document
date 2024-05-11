---
--- Created by Beef.
--- DateTime: 2023/4/7 10:02
---
local ChatRoomCreateMessage = BaseClass("ChatRoomCreateMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
    base.OnCreate(self)
    
    self.sfsObj:PutLong("type", param.type)
    self.sfsObj:PutUtfString("name", param.name)
    
    local memberList = param.memberList
    if type(memberList) == "string" then
        memberList = string.split(memberList, ";")
    end
    if type(memberList) == "table" then
        self.sfsObj:PutLuaArray("members", memberList)
    end
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    if t["errorCode"] then
        return
    end
    
    EventManager:GetInstance():Broadcast(EventId.ChatRoomCreate, t["success"])
end

ChatRoomCreateMessage.OnCreate = OnCreate
ChatRoomCreateMessage.HandleMessage = HandleMessage

return ChatRoomCreateMessage