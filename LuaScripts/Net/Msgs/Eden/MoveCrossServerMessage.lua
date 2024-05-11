---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by
--- DateTim
---MoveCrossServerMessage


local MoveCrossServerMessage = BaseClass("MoveCrossServerMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, serverId,worldId,type)
    base.OnCreate(self)
    self.sfsObj:PutInt("serverId", serverId)
    self.sfsObj:PutInt("worldId", worldId)
    self.sfsObj:PutInt("type", type)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    EventManager:GetInstance():Broadcast(EventId.OnSetEdenUI,UISetEdenType.Close)
    local errCode =  t["errorCode"]
    if errCode ~= nil then
        UIUtil.ShowTipsId(errCode)
    else
        if t["serverInfo"]~=nil then
            local message = t["serverInfo"]
            Setting:SetString(SettingKeys.SERVER_IP, message["ip"])
            Setting:SetInt(SettingKeys.SERVER_PORT, message["port"])
            Setting:SetString(SettingKeys.SERVER_ZONE, message["zone"])
        end
        CS.ApplicationLaunch.Instance:ReStartGame()
    end
end

MoveCrossServerMessage.OnCreate = OnCreate
MoveCrossServerMessage.HandleMessage = HandleMessage

return MoveCrossServerMessage
