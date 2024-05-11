---
--- Created by zzl.
--- DateTime:
---登陆请求验证码
local AccountLoginSendVerifyCodeMessage = BaseClass("AccountLoginSendVerifyCodeMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
    base.OnCreate(self)
    if param ~= nil then
        self.sfsObj:PutUtfString("mail", param.mail)
    end
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    if t["errorCode"] then
        UIUtil.ShowTipsId(t["errorCode"])
        return
    end
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIAddAccount)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIAccountVerify,{anim = true,isBlur = true}, t["mail"],1)
end

AccountLoginSendVerifyCodeMessage.OnCreate = OnCreate
AccountLoginSendVerifyCodeMessage.HandleMessage = HandleMessage

return AccountLoginSendVerifyCodeMessage