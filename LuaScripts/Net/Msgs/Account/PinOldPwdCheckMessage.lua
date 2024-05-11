---
--- Created by shimin.
--- DateTime: 2020/10/21 17:55
---
local PinOldPwdCheckMessage = BaseClass("PinOldPwdCheckMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
    base.OnCreate(self)
    if param ~= nil then
        local _pwd = CS.AESHelper.GetMd5Hash(LuaEntry.Player.uid..param.pwd)
        self.sfsObj:PutUtfString("oldPassword", _pwd)
    end
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    DataCenter.PinManager:PinOldPwdCheckHandle(t)
end

PinOldPwdCheckMessage.OnCreate = OnCreate
PinOldPwdCheckMessage.HandleMessage = HandleMessage

return PinOldPwdCheckMessage