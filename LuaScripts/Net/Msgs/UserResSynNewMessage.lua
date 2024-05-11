---
--- Created by shimin.
--- DateTime: 2021/7/13 18:47
---
local UserResSynNewMessage = BaseClass("UserResSynNewMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
    base.OnCreate(self)
    if param ~= nil then
        self.sfsObj:PutInt("resourceType", param.resourceType)
        self.sfsObj:PutUtfString("itemId", param.itemId or '')
    end
end

local function HandleMessage(self, message)
    base.HandleMessage(self, message)
    DataCenter.BuildManager:UserResSynNewHandle(message)
end

UserResSynNewMessage.OnCreate = OnCreate
UserResSynNewMessage.HandleMessage = HandleMessage

return UserResSynNewMessage