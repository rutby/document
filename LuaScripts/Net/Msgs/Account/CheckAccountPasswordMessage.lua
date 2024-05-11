---
--- Created by zzl.
--- DateTime: 2021/12/03 12:03
---验证密码
local CheckAccountPasswordMessage = BaseClass("CheckAccountPasswordMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, oldpwd)
    base.OnCreate(self)
    if oldpwd ~= "" then
        local strkey = LuaEntry.Player.uid
        local _oldpwd = CS.AESHelper.Encrypt(oldpwd, strkey)
        self.sfsObj:PutUtfString("oldPassword", _oldpwd)
    end
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    if t["success"] == true then
        EventManager:GetInstance():Broadcast(EventId.CheckAccountPwdSuccess)
    else
        UIUtil.ShowTipsId(208200)
    end
end

CheckAccountPasswordMessage.OnCreate = OnCreate
CheckAccountPasswordMessage.HandleMessage = HandleMessage

return CheckAccountPasswordMessage