---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by mac.
--- DateTime: 8/3/21 10:52 PM
---
local MailArmyResultBase = require "DataCenter.MailData.BattleReport.MailArmyResultBase"
local MailArmyResult_Team = BaseClass("MailArmyResult_Team", MailArmyResultBase)


function MailArmyResult_Team:InitData(armyResult)
    MailArmyResultBase.InitData(self, armyResult)

    self._isDefeat = armyResult["isDefeat"]
    local armyResultByType = self:GetArmyResultByType(armyResult)

    local armyObj = armyResultByType["armyObj"] or {}
    self._armyObj = self:InitCombatUnitData(armyObj)

    local afterArmyObj = armyResultByType["afterArmyObj"] or {}
    self._afterArmyObj = self:InitCombatUnitData(afterArmyObj)

    self:CheckArmyObj()
    
    self:InitDestroyValue(armyResultByType)
    self:InitDamagePercentInfo(armyResultByType)
end

return MailArmyResult_Team