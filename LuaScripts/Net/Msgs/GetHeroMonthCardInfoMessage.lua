---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2022/3/28 17:05
---

local GetHeroMonthCardInfoMessage = BaseClass("GetHeroMonthCardInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
    base.OnCreate(self)
end

local function HandleMessage(self, message)
    base.HandleMessage(self, message)
    DataCenter.HeroMonthCardManager:DoWhenAllDataBack(message)
end

GetHeroMonthCardInfoMessage.OnCreate = OnCreate
GetHeroMonthCardInfoMessage.HandleMessage = HandleMessage

return GetHeroMonthCardInfoMessage