---
--- Created by shimin.
--- DateTime: 2020/6/30 20:18
---
local ExchangeInfoMessage = BaseClass("ExchangeInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
    base.OnCreate(self)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    GiftPackageData.InitPackage(t)
end

ExchangeInfoMessage.OnCreate = OnCreate
ExchangeInfoMessage.HandleMessage = HandleMessage

return ExchangeInfoMessage