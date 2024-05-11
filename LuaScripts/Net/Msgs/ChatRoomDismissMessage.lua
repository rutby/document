---
--- Created by Beef.
--- DateTime: 2023/4/7 10:28
---
local ChatRoomDismissMessage = BaseClass("ChatRoomDismissMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, roomId)
    base.OnCreate(self)
    
    self.sfsObj:PutUtfString("roomId", roomId)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    if t["errorCode"] then
        return
    end
    
    EventManager:GetInstance():Broadcast(EventId.ChatRoomDismiss)
end

ChatRoomDismissMessage.OnCreate = OnCreate
ChatRoomDismissMessage.HandleMessage = HandleMessage

return ChatRoomDismissMessage