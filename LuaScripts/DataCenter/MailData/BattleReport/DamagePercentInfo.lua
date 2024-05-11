---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2022/3/3 11:58
---
local DamagePercentInfo = BaseClass("DamagePercentInfo")

function DamagePercentInfo:InitData(damagePercentInfo)
    self.targetUuid = damagePercentInfo["targetUuid"]--施加伤害的uuid
    self.damagePercent = damagePercentInfo["damagePercent"]
    self.woundedPercent = damagePercentInfo["woundedPercent"]
    self.injuredPercent = damagePercentInfo["injuredPercent"]
    self.deadPercent = damagePercentInfo["deadPercent"]
    self.selfUuid = damagePercentInfo["selfUuid"]--收到伤害的uuid
end
return DamagePercentInfo