---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zhangliheng.
--- DateTime: 8/11/21 6:48 PM
---
--- 后端push picVer更新

local PushPicVerUpdateMessage = BaseClass("PushPicVerUpdateMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
    base.OnCreate(self)
end

local function HandleMessage(self, message)
    base.HandleMessage(self, message)

    local uid = message['uid']
    if uid ~= LuaEntry.Player:GetUid() then
        return
    end

    LuaEntry.Player:UpdatePic(message)
end

PushPicVerUpdateMessage.OnCreate = OnCreate
PushPicVerUpdateMessage.HandleMessage = HandleMessage

return PushPicVerUpdateMessage


