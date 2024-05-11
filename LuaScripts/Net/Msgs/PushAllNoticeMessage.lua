---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2021/10/28 10:53
---
local PushAllNoticeMessage = BaseClass("PushAllNoticeMessage", SFSBaseMessage)
-- 基类，用来调用基类方法
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization
local function OnCreate(self)
    base.OnCreate(self)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    NoticeTipsManager:GetInstance():NetPush(t)
end

PushAllNoticeMessage.OnCreate = OnCreate
PushAllNoticeMessage.HandleMessage = HandleMessage

return PushAllNoticeMessage