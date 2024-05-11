---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2024/3/6 10:33
---

local StageEffectAttackSpeedTriggerEvent = BaseClass("StageEffectAttackSpeedTriggerEvent")

function StageEffectAttackSpeedTriggerEvent:Execute(param)
    local type = StageEffectType.AttackSpeed
    local val = tonumber(param.para) * 0.01
    DataCenter.LWBattleManager.logic.stageEffectMgr:Add(type, val)
end

return StageEffectAttackSpeedTriggerEvent 