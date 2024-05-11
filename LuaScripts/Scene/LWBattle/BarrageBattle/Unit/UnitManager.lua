---
--- PVE 单位管理器，负责所有单位的增删改查
---

---@class Scene.LWBattle.BarrageBattle.Unit.UnitManager
local UnitManager = BaseClass("UnitManager")

local ALL_TYPES = {
    [1] = UnitType.Zombie,
    [2] = UnitType.Member,
    [3] = UnitType.Junk,
    --[4] = UnitType.Plot,
    --[5] = UnitType.TacticalWeapon,
}

-- --barrage unit
-- local Zombie = require("Scene.LWBattle.BarrageBattle.Unit.Zombie")
-- local Boss = require("Scene.LWBattle.BarrageBattle.Unit.Boss")
-- local Member = require("Scene.LWBattle.BarrageBattle.Unit.Member")
-- local TacticalWeaponMember =require("Scene.LWBattle.BarrageBattle.Unit.TacticalWeaponMember")
-- --parkour unit
-- local ColliderMonster = require("Scene.LWBattle.ParkourBattle.Monster.MonsterImpl.ColliderMonster")
-- local CommonAIMonster = require("Scene.LWBattle.ParkourBattle.Monster.MonsterImpl.CommonAIMonster")
-- local TableMonster = require("Scene.LWBattle.ParkourBattle.Monster.MonsterImpl.TableMonster")
-- local TriggerGate = require("Scene.LWBattle.ParkourBattle.Monster.MonsterImpl.TriggerGate")
-- local TriggerGoods = require("Scene.LWBattle.ParkourBattle.Monster.MonsterImpl.TriggerGoods")
-- local HeroUnit = require("Scene.LWBattle.ParkourBattle.Team.HeroUnit")
-- local WorkerUnit = require("Scene.LWBattle.ParkourBattle.Team.WorkerUnit")
-- local WeaponUnit = require("Scene.LWBattle.ParkourBattle.Team.WeaponUnit")
-- --skirmish unit
-- local Captain = require("Scene.LWBattle.Skirmish.Unit.Captain")
-- local Minion = require("Scene.LWBattle.Skirmish.Unit.Minion")
-- local TacticalWeaponUnit = require "Scene.LWBattle.Skirmish.Unit.TacticalWeaponUnit"
-- --world unit
-- local WorldMember = require("Scene.LWWorldMarch.Member")
-- local WorldTacticalWeaponMember = require("Scene.LWWorldMarch.TacticalWeaponMember")
-- --Preview unit
-- local PreviewMember = require("Scene.PreviewSkillScene.Unit.PreviewSkillMember")
-- local PreviewZombie = require("Scene.PreviewSkillScene.Unit.PreviewSkillZombie")

function UnitManager:__init(battleMgr)
    self.battleMgr = battleMgr---@type DataCenter.ZombieBattle.ZombieBattleManager
    self.units={}---@type table<number,Scene.LWBattle.UnitBase>
    self.unitsByType={}---@type table<number,table<number,Scene.LWBattle.UnitBase>>
    self.unitsByType[UnitType.Zombie]={}
    self.unitsByType[UnitType.Member]={}
    self.unitsByType[UnitType.Junk]={}
    self.unitsByType[UnitType.Plot]={}
    self.unitsByType[UnitType.TacticalWeapon]={}
    self.morgueUnits={}--停尸间
    self.countDown = 1
    if DataCenter.LWBattleManager:UseNewDetect() then
        self.csManager = CS.PVEUnitManager()
        self.csManager:Init()
    end
    self.triggerList = CS.System.Collections.Generic.List(CS.CitySpaceManTrigger)()
end

function UnitManager:__delete()
    self:Destroy()
end

--对外接口：移除所有单位，销毁他的表现层和数据层，一般是在退出关卡时调用
function UnitManager:Destroy()
    if DataCenter.LWBattleManager:UseNewDetect() then
        self.csManager:UnInit()
    end
    for _,v in pairs(self.units) do
        self:RemoveUnit(v)
    end
    for _,v in pairs(self.morgueUnits) do
        v:DestroyData()
    end
    self.morgueUnits={}
    ObjectPool:GetInstance():ClearAll()
    --ObjectPool:GetInstance():Clear(Zombie)
    --ObjectPool:GetInstance():Clear(Boss)
    --ObjectPool:GetInstance():Clear(Member)
    --ObjectPool:GetInstance():Clear(TacticalWeaponMember)
    --
    --ObjectPool:GetInstance():Clear(ColliderMonster)
    --ObjectPool:GetInstance():Clear(CommonAIMonster)
    --ObjectPool:GetInstance():Clear(TableMonster)
    --ObjectPool:GetInstance():Clear(TriggerGate)
    --ObjectPool:GetInstance():Clear(TriggerGoods)
    --ObjectPool:GetInstance():Clear(HeroUnit)
    --ObjectPool:GetInstance():Clear(WorkerUnit)
    --
    --ObjectPool:GetInstance():Clear(Captain)
    --ObjectPool:GetInstance():Clear(Minion)
    --ObjectPool:GetInstance():Clear(TacticalWeaponUnit)
    --
    --ObjectPool:GetInstance():Clear(WorldMember)
    --ObjectPool:GetInstance():Clear(WorldTacticalWeaponMember)
    --
    --ObjectPool:GetInstance():Clear(PreviewMember)
    --ObjectPool:GetInstance():Clear(PreviewZombie)
    
end

function UnitManager:SetArea(x, y, width, height, cellXCount, cellYCount)
    self.csManager:SetArea(x, y, width, height, cellXCount, cellYCount)
end

--对外接口：注册一个单位，注册的单位会每帧调一次OnUpdate()
function UnitManager:AddUnit(unit)
    self.units[unit.guid]=unit
    self.unitsByType[unit.unitType][unit.guid]=unit
end

--对外接口：移除一个单位，不再update，销毁他的表现层，保留数据层，一般是在死亡动画播完后调用
function UnitManager:RemoveUnit(unit)
    if self.units[unit.guid] then
        self.units[unit.guid]=nil
        self.unitsByType[unit.unitType][unit.guid]=nil
        unit:DestroyView()
        table.insert(self.morgueUnits,unit)
    end
end


function UnitManager:OnUpdate()
    if DataCenter.LWBattleManager:UseNewDetect() then
        self.csManager:ClearArea()
        self.triggerList:Clear()
        for _, unit in pairs(self.units) do
            if unit.trigger then
                self.triggerList:Add(unit.trigger)
            end
        end
        self.csManager:AddTriggers(self.triggerList)
    end
    
    --for _,v in pairs(self.units) do
    --    v:OnUpdate()
    --end
    --
    ----清理停尸间尸体
    --self.countDown = self.countDown - Time.deltaTime
    --if self.countDown<0 then
    --    self.countDown = 1
    --    for i = #self.morgueUnits, 1 ,-1  do
    --        local unit = self.morgueUnits[i]
    --        if unit.morgueDuration>=3 then
    --            table.remove(self.morgueUnits,i)
    --            unit:DestroyData()
    --            ObjectPool:GetInstance():Save(unit)
    --        else
    --            unit.morgueDuration = unit.morgueDuration + 1
    --        end
    --    end
    --end
end

function UnitManager:RemoveAllUnitByType(type)
    for _,v in pairs(self.unitsByType[type]) do
        self:RemoveUnit(v)
    end
end

function UnitManager:RemoveUnitById(id)
    local unit=self.units[id]
    if unit then
        self:RemoveUnit(unit)
    end
end


function UnitManager:GetUnit(id)
    return self.units[id]
end

function UnitManager:GetAllZombie()
    return self.unitsByType[UnitType.Zombie]
end
function UnitManager:GetAllMember()
    return self.unitsByType[UnitType.Member]
end
function UnitManager:GetAllJunk()
    return self.unitsByType[UnitType.Junk]
end

--获取某几类单位的一个随机实例
function UnitManager:GetRandomUnitByTypes(unitTypes,exclusions)
    local randomPool={}
    for _,unitType in ipairs(ALL_TYPES) do
        if (unitTypes & unitType)>0 then
            for _,unit in pairs(self.unitsByType[unitType]) do
                if unit:GetCurBlood()>0 and (not exclusions or not exclusions[unit.guid]) and not unit:IsStealth() then
                    table.insert(randomPool,unit)
                end
            end
        end
    end
    local totalNum=#randomPool
    if totalNum<=0 then
        return nil
    end
    local rand=math.random(totalNum)
    return randomPool[rand]
end


--获取某几类单位的一个最近实例
function UnitManager:GetNearestUnitByTypes(unitTypes,center,exclusions)
    local nearest
    local minDist = IntMaxValue
    for _,unitType in ipairs(ALL_TYPES) do
        if (unitTypes & unitType)>0 then
            for _,unit in pairs(self.unitsByType[unitType]) do
                if unit:GetCurBlood()>0 and (not exclusions or not exclusions[unit.guid]) and not unit:IsStealth() then
                    local dist = Vector3.ManhattanDistanceXZ(center, unit:GetPosition())
                    if dist < minDist then
                        minDist = dist
                        nearest = unit
                    end
                end
            end
        end
    end
    return nearest
end

--获取某几类单位的一个最远实例
function UnitManager:GetFarthestUnitByTypes(unitTypes,center,exclusions)
    local farthest
    local maxDist = 0
    for _,unitType in ipairs(ALL_TYPES) do
        if (unitTypes & unitType)>0 then
            for _,unit in pairs(self.unitsByType[unitType]) do
                if unit:GetCurBlood()>0 and (not exclusions or not exclusions[unit.guid]) and not unit:IsStealth() then
                    local dist = Vector3.ManhattanDistanceXZ(center, unit:GetPosition())
                    if dist > maxDist then
                        maxDist = dist
                        farthest = unit
                    end
                end
            end
        end
    end
    return farthest
end


--获取某几类单位的一个最贫血实例
function UnitManager:GetLowestHPUnitByTypes(unitTypes,exclusions)
    local lowest
    local lowestHP = IntMaxValue
    for _,unitType in ipairs(ALL_TYPES) do
        if (unitTypes & unitType)>0 then
            for _,unit in pairs(self.unitsByType[unitType]) do
                if (not exclusions or not exclusions[unit.guid]) and not unit:IsStealth() then
                    local curHP=unit:GetCurBlood()
                    if curHP>0 and curHP < lowestHP then
                        lowestHP = curHP
                        lowest = unit
                    end
                end
            end
        end
    end
    return lowest
end

--获取某几类单位的一个最高最大血实例
function UnitManager:GetHighestMaxHPUnitByTypes(unitTypes,exclusions)
    local highest
    local highestHP = 0
    for _,unitType in ipairs(ALL_TYPES) do
        if (unitTypes & unitType)>0 then
            for _,unit in pairs(self.unitsByType[unitType]) do
                if (not exclusions or not exclusions[unit.guid]) and not unit:IsStealth() then
                    local curHP=unit:GetCurBlood()
                    if curHP>0 then
                        local maxHp = unit:GetMaxBlood()
                        if maxHp > highestHP then
                            highestHP = maxHp
                            highest = unit
                        end
                    end
                end
            end
        end
    end
    return highest
end

--获取某几类单位的一个最大作用号实例
function UnitManager:GetHighestPropertyUnitByTypes(unitTypes, exclusions, propertyType)
    local highest
    local highestProperty = 0
    for _,unitType in ipairs(ALL_TYPES) do
        if (unitTypes & unitType)>0 then
            for _,unit in pairs(self.unitsByType[unitType]) do
                if (not exclusions or not exclusions[unit.guid]) and not unit:IsStealth() then
                    if unit:GetCurBlood()>0 then
                        local property = unit:GetProperty(propertyType)
                        if property > highestProperty then
                            highestProperty = property
                            highest = unit
                        end
                    end
                end
            end
        end
    end
    return highest
end

--获取某几类单位的集合
function UnitManager:GetAllUnitsByTypes(unitTypes,exclusions)
    local ret={}
    --按照unitTypes筛选
    for _,unitType in ipairs(ALL_TYPES) do
        if (unitTypes & unitType)>0 then
            for _,unit in pairs(self.unitsByType[unitType]) do
                if unit:GetCurBlood()>0 and (not exclusions or not exclusions[unit.guid]) then
                    table.insert(ret,unit)
                end
            end
        end
    end
    return ret
end

--强制结束闪白
function UnitManager:ForceFinishFlash()
    for _, unit in pairs(self.units) do
        unit:ForceFinishFlash()
    end
end

function UnitManager:GetUnitsInCircle(center, radius, filter)
    local units = {}
    local list = self.csManager:GetUnitsInCircle(center.x, center.z, radius)
    for i = 0, list.Count - 1 do
        local unit = self:GetUnit(list[i].ObjectId)
        if unit then
            if filter(unit) then
                table.insert(units, unit)
            end
        end
    end
    return units
end

function UnitManager:GetUnitsInRect(center, sizeX, sizeZ, filter)
    local units = {}
    local list = self.csManager:GetUnitsInRect(center.x, center.z, sizeX, sizeZ)
    for i = 0, list.Count - 1 do
        local unit = self:GetUnit(list[i].ObjectId)
        if unit then
            if filter(unit) then
                table.insert(units, unit)
            end
        end
    end
    return units
end

return UnitManager