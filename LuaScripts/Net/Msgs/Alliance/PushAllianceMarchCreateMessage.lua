---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by guqu.
--- DateTime: 2020/8/10 15:59
---
local PushAllianceMarchCreateMessage = BaseClass("PushAllianceMarchCreateMessage", SFSBaseMessage)
-- 基类，用来调用基类方法
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization
local function OnCreate(self)
    base.OnCreate(self)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    DataCenter.AllianceWarDataManager:UpdateOneAllianceWarList(t)
    local attackName = ""
    if t["attackName"]~=nil then
        attackName = t["attackName"]
        if LuaEntry.Player.allianceId == t["attackAllianceId"] then
            UIUtil.ShowTips(Localization:GetString("390802",attackName))
        end
    end
    EventManager:GetInstance():Broadcast(EventId.AllianceWarUpdate)
end

PushAllianceMarchCreateMessage.OnCreate = OnCreate
PushAllianceMarchCreateMessage.HandleMessage = HandleMessage

return PushAllianceMarchCreateMessage