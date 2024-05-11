---
--- Created by shimin.
--- DateTime: 2020/9/29 18:41
--- 开新号
local NewAccountMessage = BaseClass("NewAccountMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Setting = CS.GameEntry.Setting
local Localization = CS.GameEntry.Localization
local function OnCreate(self, param)
    base.OnCreate(self)
    if param ~= nil then
        --self.sfsObj:PutInt("old", param.old)
        if param.confirm == 2 then
            self.sfsObj:PutInt("confirm", 1)
        end
        if param.specify then
            self.sfsObj:PutInt("specify", 1)
            self.sfsObj:PutInt("targetServer", param.targetServer)
        end
    end
end

local function HandleMessage(self, message)
    base.HandleMessage(self, message)

    if message["errorCode"] ~= nil then
        local lang = Localization:GetString(message["errorCode"])
        UIUtil.ShowTips(lang or message["errorCode"])
        return
    end
    
    --Setting:SetString(SettingKeys.GAME_ACCOUNT, "")
    ----Setting:SetString(SettingKeys.GAME_PWD, "")
    Setting:SetString(SettingKeys.GAME_UID, "")
    --Setting:SetString(SettingKeys.UUID, "")
    Setting:SetString(SettingKeys.SERVER_IP, "")
    Setting:SetInt(SettingKeys.SERVER_PORT, 0)
    Setting:SetString(SettingKeys.SERVER_ZONE, "")
    LuaEntry.DataConfig:ClearMd5()
    CS.GameEntry.Network.Uid = ""
    --CS.UnityEngine.PlayerPrefs.DeleteAll()

    CS.ApplicationLaunch.Instance:ReStartGame()
end

NewAccountMessage.OnCreate = OnCreate
NewAccountMessage.HandleMessage = HandleMessage

return NewAccountMessage