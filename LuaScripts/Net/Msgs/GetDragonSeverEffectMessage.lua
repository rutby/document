---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2023/5/30 12:18
---
local GetDragonSeverEffectMessage = BaseClass("GetDragonSeverEffectMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
    base.OnCreate(self)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    local errCode = t["errorCode"]
    if errCode then
        UIUtil.ShowTipsId(errCode)
    else
        DataCenter.ActDragonManager:UpdateDragonEffect(t)
    end
end

GetDragonSeverEffectMessage.HandleMessage = HandleMessage
GetDragonSeverEffectMessage.OnCreate = OnCreate

return GetDragonSeverEffectMessage