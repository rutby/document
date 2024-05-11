---
--- Created by shimin.
--- DateTime: 2020/10/21 18:15
---
local PinSetPwdMessage = BaseClass("PinSetPwdMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
    base.OnCreate(self)
    if param ~= nil then
        DataCenter.PinManager:SetParam(param)
        local _pwd = CS.AESHelper.GetMd5Hash(LuaEntry.Player.uid..param.pwd)
        self.sfsObj:PutUtfString("password", _pwd)
        if param.oldPwd ~= nil and param.oldPwd ~= "" then
            local oldPwd = CS.AESHelper.GetMd5Hash(LuaEntry.Player.uid..param.oldPwd)
            self.sfsObj:PutUtfString("oldPassword", oldPwd)
        end
        if param.isOnlyChangePwd then
            self.sfsObj:PutUtfString("onlyChangePassword", "1")
        end
    end
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    DataCenter.PinManager:PinSetPwdHandle(t)
end

PinSetPwdMessage.OnCreate = OnCreate
PinSetPwdMessage.HandleMessage = HandleMessage

return PinSetPwdMessage