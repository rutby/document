---
--- Created by shimin.
--- DateTime: 2020/10/21 18:15
---
local PinPwdCheckMessage = BaseClass("PinPwdCheckMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
    base.OnCreate(self)
    if param ~= nil then
        local uid = CS.GameEntry.Setting:GetString(SettingKeys.GAME_UID, "")
        local _pwd = CS.AESHelper.GetMd5Hash(uid..param.pwd)
        self.sfsObj:PutUtfString("password", _pwd)
    end
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    DataCenter.PinManager:PinPwdCheckHandle(t)
end

PinPwdCheckMessage.OnCreate = OnCreate
PinPwdCheckMessage.HandleMessage = HandleMessage

return PinPwdCheckMessage