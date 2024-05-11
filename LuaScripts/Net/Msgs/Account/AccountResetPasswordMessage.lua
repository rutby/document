---
--- Created by zzl.
--- DateTime: 2021/12/03 12:03
---利用邮箱验证码重置密码
local AccountResetPasswordMessage = BaseClass("AccountResetPasswordMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
    base.OnCreate(self)
    if param ~= nil then
        DataCenter.AccountManager:SetParam({userName = param.mail,pwd = param.pwd})
        self.sfsObj:PutUtfString("mail", param.mail)
        self.sfsObj:PutUtfString("verifyCode", param.verifyCode)
        local strkey = LuaEntry.Player.uid
        local _pwd = CS.AESHelper.Encrypt(param.pwd, strkey)
        local _confirmpwd = CS.AESHelper.Encrypt(param.confirmpwd, strkey)
        self.sfsObj:PutUtfString("password", _pwd)
        self.sfsObj:PutUtfString("confirmPassword", _confirmpwd)
    end
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    --UIManager:GetInstance():OpenWindow(UIWindowNames.UIModifySuccess)
    if UIManager:GetInstance():IsPanelLoadingComplete(UIWindowNames.UIAddAccount) then
        local window = UIManager:GetInstance():GetWindow(UIWindowNames.UIAddAccount)
        if window~=nil and window.View~=nil then
            window.View:SetAccount(t["mail"])
        end
    end
end

AccountResetPasswordMessage.OnCreate = OnCreate
AccountResetPasswordMessage.HandleMessage = HandleMessage

return AccountResetPasswordMessage