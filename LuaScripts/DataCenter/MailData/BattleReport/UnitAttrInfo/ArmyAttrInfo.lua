---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2022/3/2 21:58
---
local ArmyAttrInfo = BaseClass("ArmyAttrInfo")

function ArmyAttrInfo:InitData(armyAttrInfo)
    self.reason = armyAttrInfo["reason"]
    self.value = armyAttrInfo["value"]
end
return ArmyAttrInfo