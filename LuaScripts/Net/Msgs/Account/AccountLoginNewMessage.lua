---
--- Created by zzl.
--- DateTime: 
---
---登陆验证验证码
local AccountLoginNewMessage = BaseClass("AccountLoginNewMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param,type)
    base.OnCreate(self)
    if param ~= nil then
        DataCenter.AccountManager:SetParam(param)
        self.sfsObj:PutUtfString("mail", param.mail)
        self.sfsObj:PutUtfString("verifyCode", param.code)
    else
        self.sfsObj:PutInt("type", 1)
    end
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    if t["errorCode"] then
        UIUtil.ShowTipsId(t["errorCode"])
        return
    end
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIAccountVerify)
    DataCenter.AccountManager:AccountLoginHandle(t)
end

AccountLoginNewMessage.OnCreate = OnCreate
AccountLoginNewMessage.HandleMessage = HandleMessage

return AccountLoginNewMessage