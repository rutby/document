---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2022/9/8 16:45
---
local GetChatBlockListCommand = BaseClass("GetChatBlockListCommand", SFSBaseMessage)
local base = SFSBaseMessage
local function OnCreate(self)
    base.OnCreate(self)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    local errCode =  t["errorCode"]
    if errCode ~= nil then
        UIUtil.ShowTipsId(errCode)
    else
        ChatManager2:GetInstance().Restrict:onServerInfo(t)
        EventManager:GetInstance():Broadcast(EventId.OnGetBlockList)
    end
end

GetChatBlockListCommand.OnCreate = OnCreate
GetChatBlockListCommand.HandleMessage = HandleMessage

return GetChatBlockListCommand