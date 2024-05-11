---
--- Created by shimin.
--- DateTime: 2020/10/14 18:30
---
---***新的登陆规则，此消息弃用***
local AccountLoginMessage = BaseClass("AccountLoginMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
    base.OnCreate(self)
    if param ~= nil then
        DataCenter.AccountManager:SetParam(param)
        self.sfsObj:PutUtfString("userName", param.userName)
        local strkey = LuaEntry.Player.uid
        local _pwd = CS.AESHelper.Encrypt(param.pwd, strkey)
        self.sfsObj:PutUtfString("pwd", _pwd)
        self.sfsObj:PutUtfString("deviceId", CS.GameEntry.Setting:GetString(SettingKeys.DEVICE_ID, ""))
    end
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    DataCenter.AccountManager:AccountLoginHandle(t)
end

AccountLoginMessage.OnCreate = OnCreate
AccountLoginMessage.HandleMessage = HandleMessage

return AccountLoginMessage