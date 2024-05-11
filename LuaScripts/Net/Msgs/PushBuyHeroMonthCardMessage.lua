---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2022/3/28 17:05
---
local PushBuyHeroMonthCardMessage = BaseClass("PushBuyHeroMonthCardMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
    base.OnCreate(self)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    DataCenter.HeroMonthCardManager:DoWhenBuyCard()
end

PushBuyHeroMonthCardMessage.OnCreate = OnCreate
PushBuyHeroMonthCardMessage.HandleMessage = HandleMessage

return PushBuyHeroMonthCardMessage