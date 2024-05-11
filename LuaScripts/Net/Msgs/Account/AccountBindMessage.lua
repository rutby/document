---
--- Created by shimin.
--- DateTime: 2020/10/13 16:23
---
local AccountBindMessage = BaseClass("AccountBindMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
    base.OnCreate(self)
    if param ~= nil then
        DataCenter.AccountManager:SetParam(param)
        self.sfsObj:PutUtfString("userName", param.userName)
        --local strkey = LuaEntry.Player.uid
        --local _pwd = CS.AESHelper.Encrypt(param.pwd, strkey)
        --self.sfsObj:PutUtfString("pwd", _pwd)
    end
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    DataCenter.AccountManager:AccountBindHandle(t)
end

AccountBindMessage.OnCreate = OnCreate
AccountBindMessage.HandleMessage = HandleMessage

return AccountBindMessage