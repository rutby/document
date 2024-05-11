---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2023/7/25 10:54
---

local PushMarchEmojiMessage = BaseClass("PushMarchEmojiMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
    base.OnCreate(self)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    WorldMarchEmotionManager:GetInstance():HandlePush(t)
end

PushMarchEmojiMessage.OnCreate = OnCreate
PushMarchEmojiMessage.HandleMessage = HandleMessage

return PushMarchEmojiMessage