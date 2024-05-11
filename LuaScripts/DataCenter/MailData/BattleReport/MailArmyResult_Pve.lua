---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by mac.
--- DateTime: 3/28/22 4:05 PM
---
local Localization = CS.GameEntry.Localization
local MailArmyResultBase = require "DataCenter.MailData.BattleReport.MailArmyResultBase"
local MailArmyResult_Pve = BaseClass("MailArmyResult_Pve", MailArmyResultBase)


function MailArmyResult_Pve:InitData(armyResult)
    MailArmyResultBase.InitData(self, armyResult)
    local armyResultByType = self:GetArmyResultByType(armyResult)
    self._monsterId = armyResultByType["monsterId"] or 0
    
    local armyResultBase = armyResultByType["base"]
    
    local armyObj = armyResultBase["armyObj"] or {}
    self._armyObj = self:InitCombatUnitData(armyObj)

    local afterArmyObj = armyResultBase["afterArmyObj"] or {}
    self._afterArmyObj = self:InitCombatUnitData(afterArmyObj)

    self:CheckArmyObj()

    self:InitDestroyValue(armyResultBase)
    self:InitDamagePercentInfo(armyResultBase)
end

function MailArmyResult_Pve:GetName()
    return "no name MailArmyResult_Pve"
    --local monsterId = self._monsterId
    --local level = DataCenter.MonsterTemplateManager:GetTableValue( monsterId, "level")
    --local name = DataCenter.MonsterTemplateManager:GetTableValue( monsterId, "name")
    --local strMonsterName = Localization:GetString(name)
    --return Localization:GetString("310128", level, strMonsterName)
end

function MailArmyResult_Pve:GetName_ForShare()
    return nil
    --local param = {["type"] = "dialog"}
    --local monsterId = self._monsterId
    --local name = DataCenter.MonsterTemplateManager:GetTableValue( monsterId, "name")
    --param["level"] = DataCenter.MonsterTemplateManager:GetTableValue( monsterId, "level")
    --param["name"] = name
    --return param
end

function MailArmyResult_Pve:GetInfo()
    return nil
end

function MailArmyResult_Pve:GetPointId()
    return 0
end


return MailArmyResult_Pve