---
--- Created by zzl.
--- DateTime: 2021/12/03 12:03
---忘记密码 向邮箱发送验证码
local AccountForgetPasswordMessage = BaseClass("AccountForgetPasswordMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, account)
    base.OnCreate(self)
    if account ~= "" then
        self.sfsObj:PutUtfString("mail", account)
    end
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    DataCenter.AccountManager:AccountForgetPasswordHandle(t)
end

AccountForgetPasswordMessage.OnCreate = OnCreate
AccountForgetPasswordMessage.HandleMessage = HandleMessage

return AccountForgetPasswordMessage