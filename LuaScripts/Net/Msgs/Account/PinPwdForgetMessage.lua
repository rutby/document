---
--- Created by shimin.
--- DateTime: 2020/10/22 21:08
---
local PinPwdForgetMessage = BaseClass("PinPwdForgetMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
    base.OnCreate(self)
    if param ~= nil then
        self.sfsObj:PutUtfString("email", param.email)
    end
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    DataCenter.PinManager:PinPwdForgetHandle(t)
end

PinPwdForgetMessage.OnCreate = OnCreate
PinPwdForgetMessage.HandleMessage = HandleMessage

return PinPwdForgetMessage