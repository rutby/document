---
--- Created by shimin.
--- DateTime: 2020/11/18 15:01
---
local UserSyntheticHeroMessage = BaseClass("UserSyntheticHeroMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
    base.OnCreate(self)
    if param ~= nil then
        self.sfsObj:PutUtfString("itemUuid", param.itemUuid)
    end
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    --HeroManager:GetInstance():UserSyntheticHeroHandle(t)
end

UserSyntheticHeroMessage.OnCreate = OnCreate
UserSyntheticHeroMessage.HandleMessage = HandleMessage

return UserSyntheticHeroMessage