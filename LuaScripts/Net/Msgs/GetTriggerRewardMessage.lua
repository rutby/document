---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2022/8/17 19:25
---
local GetTriggerRewardMessage = BaseClass("GetTriggerRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GetTriggerRewardMessage:OnCreate(param)
    base.OnCreate(self)
    if param ~= nil then
        self.sfsObj:PutInt("level", param.level)
        self.sfsObj:PutInt("trigger", param.trigger)
    end
end

function GetTriggerRewardMessage:HandleMessage(t)
    base.HandleMessage(self, t)
    local battleLevel = DataCenter.BattleLevel
    if battleLevel then
        battleLevel:OnGetTriggerRewardHandler(t)
    end
end

return GetTriggerRewardMessage