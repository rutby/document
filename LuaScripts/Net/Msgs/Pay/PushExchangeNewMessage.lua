
local PushExchangeNewMessage = BaseClass("PushExchangeNewMessage", SFSBaseMessage)
-- 基类，用来调用基类方法
local base = SFSBaseMessage

local function OnCreate(self)
	base.OnCreate(self)
end

local function HandleMessage(self, t)
	base.HandleMessage(self, t)
	GiftPackageData.pushPack(t)
end

PushExchangeNewMessage.OnCreate = OnCreate
PushExchangeNewMessage.HandleMessage = HandleMessage

return PushExchangeNewMessage