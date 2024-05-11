---
--- Created by zzl.
--- DateTime: 2021/12/03 12:03
---校验验证码是否正确
local CheckAccountMailVerifyCodeMessage = BaseClass("CheckAccountMailVerifyCodeMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
    base.OnCreate(self)
    if param ~= nil then
        self.sfsObj:PutUtfString("mail", param.mail)
        self.sfsObj:PutUtfString("verifyCode", param.code)
    end
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    if t["errorCode"] == nil then
        UIManager:GetInstance():DestroyWindow(UIWindowNames.UIAccountVerify)
        --UIManager:GetInstance():OpenWindow(UIWindowNames.UIModifyPassword,t["mail"],t["verifyCode"],true)
    else
        UIUtil.ShowTipsId(t["errorCode"])
    end
end

CheckAccountMailVerifyCodeMessage.OnCreate = OnCreate
CheckAccountMailVerifyCodeMessage.HandleMessage = HandleMessage

return CheckAccountMailVerifyCodeMessage