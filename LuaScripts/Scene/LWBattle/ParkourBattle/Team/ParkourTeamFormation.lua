---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by wsf.
--- ParkourTeam阵型管理
---

---@class ParkourTeamFormation
---@field pos Common.Tools.UnityEngine.Vector3[]
local ParkourTeamFormation = BaseClass("ParkourTeamFormation")

local FirstXOffset = 1 --第一排x轴间隔
local XOffset = 1 --x轴间隔
local ZOffset = 2   --z轴间隔
local ZStart = 2.5  --默认起始z轴位置

--其他模式占位参数 默认值
local DefaultNormalFirstXOffset = 1 --第一排x轴间隔
local DefaultNormalXOffset = 2 --x轴间隔
local DefaultNormalZOffset = 2   --z轴间隔
local DefaultNormalZStart = 2.5  --默认起始z轴位置

--塔防模式占位参数
--默认值
local DefaultDefenseFirstXOffset = 1.8 --第一排x轴间隔
local DefaultDefenseXOffset = 2.9 --x轴间隔
local DefaultDefenseZOffset = 2.5   --z轴间隔
local DefaultDefenseZStart = 2.5  --默认起始z轴位置

--逻辑用值
local DefenseFirstXOffset = 1.8 --第一排x轴间隔
local DefenseXOffset = 2.9 --x轴间隔
local DefenseZOffset = 2.5   --z轴间隔
local DefenseZStart = 2.5  --默认起始z轴位置

local RowNumber = 3 --每行单位数
local BaseCount = 5 --基础阵容单位数

local defaultWeaponPos = 6 --无人机占第6位 （第三排居中位置）
local weaponPos = 6 
function ParkourTeamFormation:__init(specialPos)
    self.pos = nil
    self.posCount = 0
    
    if specialPos and type(specialPos) == "table" and #specialPos == 4 then
        DefenseFirstXOffset = specialPos[1]
        DefenseXOffset = specialPos[2]
        DefenseZOffset = specialPos[3]
        DefenseZStart = specialPos[4]

        FirstXOffset = DefenseFirstXOffset
        XOffset = DefenseXOffset
        ZOffset = DefenseZOffset
        ZStart = DefenseZStart
    else
        DefenseFirstXOffset = DefaultDefenseFirstXOffset
        DefenseXOffset = DefaultDefenseXOffset
        DefenseZOffset = DefaultDefenseZOffset
        DefenseZStart = DefaultDefenseZStart
        
        FirstXOffset = DefaultNormalFirstXOffset
        XOffset = DefaultNormalXOffset
        ZOffset = DefaultNormalZOffset
        ZStart = DefaultNormalZStart
    end
end

function ParkourTeamFormation:__delete()
    self.pos = nil
    self.posCount = 0
end

---@param initBattleFormation boolean 初始化时就自动计算阵位（读表默认英雄情况下）
---@param backwards boolean true:向后延伸 false:居中
---@param defense boolean 是否为塔防模式
function ParkourTeamFormation:Init(initBattleFormation, backwards, defense)
    self.backwards = backwards
    self.defense = defense

    local zStart = self.defense and DefenseZStart or ZStart
    
    if initBattleFormation then
        weaponPos = -1 -- 没有无人机的模式
        self.pos = {}
        self:ReSize(BaseCount, true)
    else
        --自选阵容时的占位
        self.pos={
            [1]=Vector3.New(-2.3,0, zStart),
            [2]=Vector3.New(2.3,0, zStart),
            [3]=Vector3.New(-3.3,0,zStart - 4),
            [4]=Vector3.New(0,0,zStart - 4),
            [5]=Vector3.New(3.3,0,zStart - 4),
        }
        self.posCount = 5
        
        -- DS 无战术装备
        --local has = DataCenter.TacticalWeaponManager:HasTacticalWeapon()--是否已解锁无人机
        local has = false
        if has then
            weaponPos = defaultWeaponPos
        else
            weaponPos = -1
        end
    end
end

function ParkourTeamFormation:ChangeToBattleFormation()
    --切换到战斗阵容
    self:ReSize(self.posCount, true)
end

function ParkourTeamFormation:GetOffsetByIndex(index)
    if index > self.posCount then
        --扩容处理
        self:ReSize(index)
    end
    
    return self.pos[index]
end

function ParkourTeamFormation:ReSize(index, force)
    local addCount = index - self.posCount;
    if addCount <= 0 and not force then
        return self.posCount
    end

    local skipWeaponPos = 0
    if (weaponPos > 0) and (index >= weaponPos) then
        --需要把无人机的位置空出来
        skipWeaponPos = 1
    end

    local firstXOffset = self.defense and DefenseFirstXOffset or FirstXOffset
    local xOffset = self.defense and DefenseXOffset or XOffset
    local zOffset = self.defense and DefenseZOffset or ZOffset
    local zStart = self.defense and DefenseZStart or ZStart
    
    addCount = math.ceil(addCount / RowNumber) * RowNumber
    local newCount = self.posCount + addCount

    local StartZ = zStart
    if not self.backwards then
        local OffsetCount = (newCount + skipWeaponPos) - BaseCount --计算整体阵型时要把无人机的阵位让出来
        local OffsetRow = math.floor(OffsetCount / RowNumber)
        local OffsetZ = OffsetRow / 2 * zOffset
        StartZ = zStart + OffsetZ
    end

    for i = 1, newCount do
        if i == 1 then
            self.pos[i] = Vector3.New(-firstXOffset, 0, StartZ)
        elseif i == 2 then
            self.pos[i] = Vector3.New(firstXOffset, 0, StartZ)
        elseif i <= BaseCount then
            --左对齐
            local offset = i - 2
            local x = (offset - 1) % RowNumber
            local z = math.ceil(offset / RowNumber)
            self.pos[i] = Vector3.New(xOffset * (x - 1), 0, StartZ - z * zOffset)
        else
            --中对齐
            local calcIndex = i
            if (weaponPos > 0) and (i >= weaponPos) then
                --跳过无人机位置
                calcIndex = calcIndex + 1
            end
            local offset = calcIndex - 2
            local x = (offset - 1) % RowNumber
            local z = math.ceil(offset / RowNumber)
            self.pos[i] = Vector3.New(xOffset * math.ceil(x / 2) * (-1)^x, 0 ,StartZ - z * zOffset)
        end
    end
    
    self.posCount = newCount

    return self.posCount
end

function ParkourTeamFormation:GetWeaponPos()
    -- 拿到当前阵型最后一排的z轴位置 再加上偏移 无人机居中 x为0
    -- 固定拿第5个位置做偏移
    if not self.posCount then
        return Vector3.zero
    end
    local pos = self.pos[5]
    local posZ = pos.z - 3
    return Vector3.New(0, 0, posZ)
end

return ParkourTeamFormation
