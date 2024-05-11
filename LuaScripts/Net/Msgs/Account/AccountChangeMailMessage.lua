---
--- Created by shimin.
--- DateTime: 2020/10/19 17:17
---
local AccountChangeMailMessage = BaseClass("AccountChangeMailMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
    base.OnCreate(self)
    if param ~= nil then
        DataCenter.AccountManager:SetParam(param)
        self.sfsObj:PutUtfString("newEmail", param.newEmail)
        local strkey = LuaEntry.Player.uid
        local _pwd = CS.AESHelper.Encrypt(param.pwd, strkey)
        self.sfsObj:PutUtfString("pwd", _pwd)
    end
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    DataCenter.AccountManager:AccountChangeMailHandle(t)
end

AccountChangeMailMessage.OnCreate = OnCreate
AccountChangeMailMessage.HandleMessage = HandleMessage

return AccountChangeMailMessage