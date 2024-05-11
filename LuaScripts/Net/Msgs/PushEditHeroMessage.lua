---
--- Created by shimin.
--- DateTime: 2020/11/16 16:33
---
local PushEditHeroMessage = BaseClass("PushEditHeroMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
    base.OnCreate(self)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    --HeroManager:GetInstance():PushEditHeroHandle(t)
end

PushEditHeroMessage.OnCreate = OnCreate
PushEditHeroMessage.HandleMessage = HandleMessage

return PushEditHeroMessage