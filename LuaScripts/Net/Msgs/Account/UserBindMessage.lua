---
--- Created by shimin.
--- DateTime: 2020/10/09 18:48
---
local UserBindMessage = BaseClass("UserBindMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
    base.OnCreate(self)
    DataCenter.UserBindManager:SetParam(param)
    if param ~= nil then
        self.sfsObj:PutUtfString("googlePlay", param.googlePlay)
        self.sfsObj:PutUtfString("gmail", param.gmail)
        self.sfsObj:PutUtfString("facebook", param.facebook)
        self.sfsObj:PutUtfString("fbEmail", param.fbEmail)
        self.sfsObj:PutUtfString("deviceId", param.deviceId)
        self.sfsObj:PutUtfString("mail", param.mail)
        self.sfsObj:PutUtfString("pass", param.pass)
        self.sfsObj:PutInt("optType", param.optType)
        self.sfsObj:PutUtfString("googleAccountName", param.googleAccountName)
        self.sfsObj:PutUtfString("facebookAccountName", param.facebookAccountName)
        self.sfsObj:PutUtfString("accessToken", param.accessToken)

        self.sfsObj:PutUtfString("oicq", param.oicq)
        self.sfsObj:PutUtfString("oicqName", param.oicqName)
        self.sfsObj:PutUtfString("weibo", param.weibo)
        self.sfsObj:PutUtfString("weiboName", param.weiboName)
        self.sfsObj:PutUtfString("weixin", param.weixin)
        self.sfsObj:PutUtfString("weixinName", param.weixinName)
        if  CS.SDKManager.IS_UNITY_IPHONE() then
            self.sfsObj:PutUtfString("pf", "AppStore")
        end
        
    end
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    DataCenter.UserBindManager:UserBindHandle(t)
end

UserBindMessage.OnCreate = OnCreate
UserBindMessage.HandleMessage = HandleMessage

return UserBindMessage