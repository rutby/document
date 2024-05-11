---
--- Created by shimin.
--- DateTime: 2020/10/13 16:23
---
local AccountChangePasswordMessage = BaseClass("AccountChangePasswordMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, account,param)
    base.OnCreate(self)
    if param ~= nil then
        DataCenter.AccountManager:SetParam({userName = account,pwd = param.pwd})
        local strkey = LuaEntry.Player.uid
        local _oldpwd = CS.AESHelper.Encrypt(param.oldpwd, strkey)
        local _pwd = CS.AESHelper.Encrypt(param.pwd, strkey)
        local _confirmpwd = CS.AESHelper.Encrypt(param.confirmpwd, strkey)
        self.sfsObj:PutUtfString("oldPassword", _oldpwd)
        self.sfsObj:PutUtfString("password", _pwd)
        self.sfsObj:PutUtfString("confirmPassword", _confirmpwd)
    end
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    DataCenter.AccountManager:AccountChangePasswordHandle(t)
end

AccountChangePasswordMessage.OnCreate = OnCreate
AccountChangePasswordMessage.HandleMessage = HandleMessage

return AccountChangePasswordMessage