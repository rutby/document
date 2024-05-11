---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2021/8/2 21:50
---
local UserRecoverBuildingStaminaMessage = BaseClass("UserRecoverBuildingStaminaMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization
local function OnCreate(self, bUuid)
    base.OnCreate(self)
    self.sfsObj:PutLong("uuid", bUuid)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    if t["errorCode"] ~= nil then
        UIUtil.ShowTips(Localization:GetString(t["errorCode"]))
    else
        DataCenter.BuildManager:AddBuilding(t)
        if t["resource"]~=nil then
            LuaEntry.Resource:UpdateResource(t["resource"])
        end
        UIUtil.ShowTipsId(300541) 
    end
    
end
UserRecoverBuildingStaminaMessage.OnCreate = OnCreate
UserRecoverBuildingStaminaMessage.HandleMessage = HandleMessage

return UserRecoverBuildingStaminaMessage