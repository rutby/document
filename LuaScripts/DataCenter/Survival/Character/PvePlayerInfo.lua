---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by cola.
--- DateTime: 2022/11/2 上午11:34
---
local Messenger = require "Framework.Common.Messenger"
local PlayerEquipment = require "DataCenter.Survival.Character.PlayerEquipment"
local base = require "DataCenter.Survival.Character.CharacterBaseInfo"
local SU_Util = require("Scene.PVEBattleLevel.Utils.SU_Util")
local PvePlayerInfo = BaseClass("PvePlayerInfo", base)

local PvePlayerInfoEventId = {
    EquipChanged = "equip_changed_event",
    InfoChanged = "info_changed"
}

function PvePlayerInfo:__init()
    self.equipment = PlayerEquipment.New()
    self.m_messenger = Messenger.New()
    self.hunger = nil
    self.bathe = nil
    self.thirsty = nil
    self.stamina = nil
    self.level = nil
    self.addExp = nil
    self.exp = nil
    self.name = nil
    self.m_isSneak = false
    self.bornTime = nil
    self.deadTime = nil
    self.levelAtk = 0
    self.levelDef = 0
    self.levelHp = 0
    self.hpBuff = nil
    self.hpBuffShow = false
    self.hpBuffCheckTime = 0
    self.hpEffectNum = 0
    self.defenceEffectNum = 0
    self.attackEffectNum = 0
    self.moveSpeedEffectNum = 0
    self.hpBuffEffectNum = 0
    self.pee = nil --小便
    self.stool = nil --大便
    self.isPeeState = false
    self.deadRemoveItems = nil
    self:__initTemplate()
    self:__initEventListeners()
end

function PvePlayerInfo:__initTemplate()
    local template = {}
    
    template.detectCollectRange = LuaEntry.DataConfig:TryGetNum("survival_battle", "k1")
    template.sneakMoveSpeed = 0--LuaEntry.DataConfig:TryGetNum("survival_battle", "k2")
    template.critical = LuaEntry.DataConfig:TryGetNum("survival_battle", "k3")
    template.maxBlood = LuaEntry.DataConfig:TryGetNum("survival_battle", "k4")
    template.attack = LuaEntry.DataConfig:TryGetNum("survival_battle", "k5")
    template.moveSpeed = 0--LuaEntry.DataConfig:TryGetNum("survival_battle", "k6")
    template.attackRange = LuaEntry.DataConfig:TryGetNum("survival_battle", "k7")
    template.collectRange = LuaEntry.DataConfig:TryGetNum("survival_battle", "k8")
    template.attackSpeed = LuaEntry.DataConfig:TryGetNum("survival_battle", "k9")
    template.defence = LuaEntry.DataConfig:TryGetNum("survival_battle", "k10")
    template.standardMoveSpeed = LuaEntry.DataConfig:TryGetNum("survival_battle", "k11")            --标准移动速度
    template.standardSneakMoveSpeed = LuaEntry.DataConfig:TryGetNum("survival_battle", "k12")       --标准潜行移速
    template.standardWeaknessMoveSpeed = LuaEntry.DataConfig:TryGetNum("survival_battle", "k13")    --标准虚弱移速
    template.detectEnemyRange = LuaEntry.DataConfig:TryGetNum("survival_battle", "k15")
    template.weaknessMoveSpeed = 0--LuaEntry.DataConfig:TryGetNum("survival_battle", "k16")
    
    self:SetTemplate(template)
    self:SetMaxBlood(template.maxBlood)
end

function PvePlayerInfo:__initEventListeners()
    self.EquipSlotChangedHandler = function(data)
        self:EquipSlotChanged(data)
    end
    self.EquipUpdateHandler = function()
        self:EquipUpdate()
    end
    self.EffectNumChangedHandler = function()
        self:UpdateEffectData()
    end
    EventManager:GetInstance():AddListener(EventId.Survival_EquipSlotChanged, self.EquipSlotChangedHandler)
    EventManager:GetInstance():AddListener(EventId.Survival_PushUpdateBagGridData, self.EquipUpdateHandler)
    EventManager:GetInstance():AddListener(EventId.EffectNumChange,self.EffectNumChangedHandler)
end

function PvePlayerInfo:__removeEventListeners()
    EventManager:GetInstance():RemoveListener(EventId.Survival_EquipSlotChanged, self.EquipSlotChangedHandler)
    EventManager:GetInstance():RemoveListener(EventId.Survival_PushUpdateBagGridData, self.EquipUpdateHandler)
    EventManager:GetInstance():RemoveListener(EventId.EffectNumChange,self.EffectNumChangedHandler)
end

function PvePlayerInfo:SetBaseMoveSpeed(speed,sneakSpeed,weaknessSpeed)
    speed = (speed == nil or speed == 0) and 35 or speed
    sneakSpeed = (sneakSpeed == nil or sneakSpeed == 0) and 28 or sneakSpeed
    weaknessSpeed = (weaknessSpeed == nil or weaknessSpeed == 0) and 28 or weaknessSpeed
    self.m_template.moveSpeed = speed
    self.m_template.sneakMoveSpeed = sneakSpeed
    self.m_template.weaknessMoveSpeed = weaknessSpeed
end

function PvePlayerInfo:initEquip()
    --初始化装备
    local equips = DataCenter.BagGridDataManager:GetEquipGridData()
    equips:ForEach(function(slotIdx, bagItemData)
        if EquipSlotReq[slotIdx] == nil or bagItemData == nil or bagItemData.count <= 0 then
            return
        end
        
        self.equipment:AddEquip(bagItemData.itemId)
    end)
    
    self.equipment:Refresh() --刷新一下属性
end

function PvePlayerInfo:GetEquipValue(partType,indexName,defaultValue)
    local equip = self.equipment:GetEquip(partType)
    local value = defaultValue
    if equip ~= nil then
        value = equip:getValue(indexName,defaultValue)
    end
    if string.IsNullOrEmpty(value) then
        return defaultValue
    end
    return value
end
--获取装备数据，返回的是template
function PvePlayerInfo:GetEquip(partType)
    return self.equipment:GetEquip(partType)
end

function PvePlayerInfo:EquipSlotChanged(data)
    if data == nil then
        return
    end
    
    local partType = EquipSlotReq[data["slotIdx"]]

    if partType == nil then
        return
    end
    local itemId = data["itemId"]
    if itemId ~= nil then
        self.equipment:AddEquip(itemId)
    else
        self.equipment:RemoveEquip(partType)
    end
    self.equipment:Refresh()--刷一下属性
    
    self:Broadcast(PvePlayerInfoEventId.EquipChanged,{partType = partType})
end

function PvePlayerInfo:EquipUpdate()
    local equips = DataCenter.BagGridDataManager:GetEquipGridData()
    equips:ForEach(function(slotIdx, bagItemData)
        local partType = EquipSlotReq[slotIdx]
        if partType == nil then
            return
        end

        local equip = self.equipment:GetEquip(partType)

        if bagItemData == nil or bagItemData.count <= 0 then
            --卸载装备，判断现在有没有装备
            if equip ~= nil then
                self.equipment:RemoveEquip(partType)

                self:Broadcast(PvePlayerInfoEventId.EquipChanged,{partType = partType})
            end
        else
            if equip == nil or equip.id ~= bagItemData.itemId then
                self.equipment:AddEquip(bagItemData.itemId)

                self:Broadcast(PvePlayerInfoEventId.EquipChanged,{partType = partType})
            end
        end
    end)

    self.equipment:Refresh()--刷一下属性
end

function PvePlayerInfo:UpdateInfo(data)
	local update_info = {}
	
    if data.hp then
        if self:SetCurBlood(data.hp) then
			update_info.hp_changed = true
		end
    end
	
    if data.food then
        self.hunger = data.food
        LuaEntry.Player:SetCurHunger(self.hunger)
    end
    if data.water then
        self.thirsty = data.water
        LuaEntry.Player:SetCurThirsty(self.thirsty)
    end
    if data.stamina then
        self.stamina = data.stamina
    end
    if data.level then
        self:SetLevel(data.level)
    end
    if data.exp then
        self.exp = data.exp
    end
    if data.name then
        self.name = data.name
    end
    if data.bornTime then
        self.bornTime = data.bornTime
    end
    if data.deadTime then
        self.deadTime = data.deadTime
    end

    if data.deadRemoveItems then
        self.deadRemoveItems = data.deadRemoveItems
    end
    if data.shower then
        self:InitBathe(data.shower)
    end

    if data.waterOutput then
        self.pee = data.waterOutput
    end
    if data.foodOutput then
        self.stool = data.foodOutput
    end
    self:UpdateEffectData()
    self:Broadcast(PvePlayerInfoEventId.InfoChanged, update_info)
end

--获取最新基础血量
function PvePlayerInfo:GetNewMaxBlood()
    local levelData = DataCenter.PveHeroTemplateManager:GetLevelUpTemplate(self.level)
    if levelData ~= nil then
        self.levelAtk = levelData.lord_atk
        self.levelDef = levelData.lord_def
        self.levelHp = levelData.lord_hp

        return self.m_template.maxBlood + self.levelHp
    end
end

function PvePlayerInfo:UpdateLevelData()
    local levelData = DataCenter.PveHeroTemplateManager:GetLevelUpTemplate(self.level)
    if levelData ~= nil then
        self.levelAtk = levelData.lord_atk
        self.levelDef = levelData.lord_def
        self.levelHp = levelData.lord_hp

        local maxBlood = self.m_template.maxBlood + self.levelHp
        if self:IsBathe() then
            --需要洗澡状态下血量减少10%
             maxBlood = math.floor(maxBlood * 0.9)
        end
        self:SetMaxBlood(maxBlood)
    end
end
--更新作用号
function PvePlayerInfo:UpdateEffectData()
    local hpEffectNum = Mathf.Floor(LuaEntry.Effect:GetEffectValue(EffectDefine.PVE_PLAYER_HP))
    local defenceEffectNum = Mathf.Floor(LuaEntry.Effect:GetEffectValue(EffectDefine.PVE_PLAYER_DEFENCE))
    local attackEffectNum = Mathf.Floor(LuaEntry.Effect:GetEffectValue(EffectDefine.PVE_PLAYER_ATTACK))
    local moveSpeedEffectNum = LuaEntry.Effect:GetEffectValue(EffectDefine.PVE_PLAYER_MOVE_SPEED) --浮点数
    local hpBuffEffectNum = Mathf.Floor(LuaEntry.Effect:GetEffectValue(EffectDefine.PVE_PLAYER_FOOD_HP))
    if self.hpEffectNum ~= hpEffectNum
        or self.defenceEffectNum ~= defenceEffectNum 
        or self.attackEffectNum ~= attackEffectNum
        or self.moveSpeedEffectNum ~= moveSpeedEffectNum
        or self.hpBuffEffectNum ~= hpBuffEffectNum
    then
        self.hpEffectNum = hpEffectNum
        self.defenceEffectNum = defenceEffectNum
        self.attackEffectNum = attackEffectNum
        self.moveSpeedEffectNum = moveSpeedEffectNum / 100
        self.hpBuffEffectNum = hpBuffEffectNum
        
        EventManager:GetInstance():Broadcast(EventId.SU_PLayerEffectChange, self)
    end
end

function PvePlayerInfo:GetDefence()
    local defence = self.m_template.defence + self.equipment:GetDefence()
    return defence + self.levelDef + self.defenceEffectNum
end

function PvePlayerInfo:GetAttack()
    local attack = self.equipment:GetAttack()
    attack = attack ~= 0 and attack or self.m_template.attack
    return attack + self.levelAtk + self.attackEffectNum
end

function PvePlayerInfo:GetAttackSpeed()
    local attackSpeed = self.equipment:GetAttackSpeed()
    return attackSpeed ~= 0 and attackSpeed or self.m_template.attackSpeed
end
--攻击间隔
function PvePlayerInfo:GetCoolDown()
    return self.equipment:GetCoolDown()
end

function PvePlayerInfo:GetMoveSpeed()
    local moveSpeed = Mathf.Max(self.equipment:GetMoveSpeed(),self.m_template.moveSpeed)
    if self:IsWeakness() then
        moveSpeed = self.m_template.weaknessMoveSpeed
    elseif self:IsSneak() then
        moveSpeed = self.m_template.sneakMoveSpeed
    end
    moveSpeed = moveSpeed - tonumber(self:GetEquipValue(SurvivalEquipType.Weapon,"debuff",0))
    moveSpeed = moveSpeed + moveSpeed * self.moveSpeedEffectNum
    return moveSpeed
end

function PvePlayerInfo:GetWeaknessMoveSpeed()
    local moveSpeed = self.m_template.weaknessMoveSpeed
    moveSpeed = moveSpeed - tonumber(self:GetEquipValue(SurvivalEquipType.Weapon,"debuff",0))
    moveSpeed = moveSpeed + moveSpeed * self.moveSpeedEffectNum
    return moveSpeed  
end

function PvePlayerInfo:GetMoveAnimSpeed()
    local moveSpeed = self:GetMoveSpeed()
    local standardMoveSpeed = self.m_template.standardMoveSpeed
    if self:IsWeakness() then
        standardMoveSpeed = self.m_template.standardWeaknessMoveSpeed
    elseif self:IsSneak() then
        standardMoveSpeed = self.m_template.standardSneakMoveSpeed
    end

    local animSpeed = moveSpeed / standardMoveSpeed

    return animSpeed
end

function PvePlayerInfo:GetMaxBlood()
    local maxBlood = base.GetMaxBlood(self) + self.hpEffectNum
    return maxBlood
end

function PvePlayerInfo:GetAttackRange()
    local range = self.equipment:GetRange()
    return range ~= 0 and range or self.m_template.attackRange
end

function PvePlayerInfo:GetCollectRange()
    return self.m_template.collectRange
end

function PvePlayerInfo:GetDetectCollectRange()
    return self.m_template.detectCollectRange
end

function PvePlayerInfo:GetDetectEnemyRange()
    return self.m_template.detectEnemyRange
end

function PvePlayerInfo:GetAttackAnimName()
    return self.equipment:GetAnimName(AnimationType.Attack)
end

function PvePlayerInfo:GetDefaultAnimName()
    return self.equipment:GetAnimName(AnimationType.Idle)
end

function PvePlayerInfo:GetMoveAnimName()
    return self.equipment:GetAnimName(AnimationType.Move)
end

function PvePlayerInfo:GetRunAnimName()
    return self.equipment:GetAnimName(AnimationType.Run)
end

function PvePlayerInfo:GetSneakIdleAnimName()
    return self.equipment:GetAnimName(AnimationType.SneakIdle)
end

function PvePlayerInfo:GetSneakMoveAnimName()
    return self.equipment:GetAnimName(AnimationType.SneakMove)
end

function PvePlayerInfo:GetInertialIdle()
    return self.equipment:GetAnimName(AnimationType.InertialIdle)
end

--潜行下的特殊攻击，部分武器会配
function PvePlayerInfo:GetSneakAttack()
    return self.equipment:GetAnimName(AnimationType.Sneak)
end

function PvePlayerInfo:UpdateAttackTime()
    self.equipment:UpdateAttackTime()
end

function PvePlayerInfo:SetHunger(value)
    self.hunger = value * 1.0
    UIUtil.CheckShowDeadlyEffect()
    LuaEntry.Player:SetCurHunger(self.hunger)
end

function PvePlayerInfo:GetHunger()
    return self.hunger
end

function PvePlayerInfo:SetThirsty(value)
    self.thirsty = value * 1.0
    UIUtil.CheckShowDeadlyEffect()
    LuaEntry.Player:SetCurThirsty(self.thirsty)
end

function PvePlayerInfo:GetThirsty()
    return self.thirsty
end

function PvePlayerInfo:SetLevel(value)
    self.level = value
    self:UpdateLevelData()
    DataCenter.AccountListManager:UpdatePlayerMainLv(LuaEntry.Player.serverId,LuaEntry.Player.uid,self.level)
end

function PvePlayerInfo:GetLevel()
    return self.level
end

function PvePlayerInfo:SetAddExp(value)
    self.addExp = value
end

function PvePlayerInfo:GetAddExp()
    if self.addExp == nil then
        self.addExp = 0
    end
    return self.addExp
end

function PvePlayerInfo:SetExp(value)
    self.exp = value
end

function PvePlayerInfo:GetExp()
    return self.exp
end

function PvePlayerInfo:GetName()
    return self.name
end

function PvePlayerInfo:SetSneak(value)
    self.m_isSneak = value
end

function PvePlayerInfo:IsSneak()
    return self.m_isSneak
end

--是否为虚弱状态
function PvePlayerInfo:IsWeakness()
    return self.hunger <= 0 or self.thirsty <= 0 or self:IsPeeOrStoolState() or DataCenter.GuideManager:IsPlayerShowWeakness()
end

function PvePlayerInfo:AddListener( eventId, handler)
    self.m_messenger:AddListener(eventId, handler)
end

function PvePlayerInfo:RemoveListener( eventId, handler)
    self.m_messenger:RemoveListener(eventId, handler)
end

function PvePlayerInfo:Broadcast(eventId,userData)
    self.m_messenger:Broadcast(eventId, userData)
end

function PvePlayerInfo:__delete()
    self.equipment = nil
    self.m_messenger:Cleanup()
    self.m_messenger = nil
    self.hunger = nil
    self.Bathe = nil
    self.thirsty = nil
    self.stamina = nil
    self.level = nil
    self.exp = nil
    self.name = nil
    self.bornTime = nil
    self.deadTime = nil
    self.hpBuff = nil
    self.hpBuffShow = nil
    self.hpBuffCheckTime = nil
    self.isPlayBatheAni = false
    self.deadRemoveItems = nil
    self:__removeEventListeners()
end

function PvePlayerInfo:AddHpBuff(buff)
    if self.hpBuff == nil then
        self.hpBuff = {}
    end

    local buffs = string.split_ii_array(buff, ';')
    if table.count(buffs) == 2 then
        for i = 1, buffs[2] do
            table.insert(self.hpBuff, buffs[1] + self.hpBuffEffectNum)
        end
    end
end

function PvePlayerInfo:GetHpBuff()
    return self.hpBuff
end

function PvePlayerInfo:ClearHpBuff()
    self.hpBuff = {}
end

function PvePlayerInfo:RefrsshHpBuffCheckTime(time)
    if time > 0 then
        self.hpBuffCheckTime = self.hpBuffCheckTime + time
    else
        self.hpBuffCheckTime = 0
    end
    return self.hpBuffCheckTime
end

function PvePlayerInfo:SetHpBuffShow(show)
    self.hpBuffShow = show
end

function PvePlayerInfo:GetHpBuffShow()
    return self.hpBuffShow
end

--初始化洗澡值
function PvePlayerInfo:InitBathe(shower)
    self.bathe = shower
    self:UpdateLevelData()
end

--洗澡值
function PvePlayerInfo:SetBathe(value)
    self.bathe = value * 1.0
end

--洗澡值
function PvePlayerInfo:GetBathe()
    return self.bathe
end

--是否为需要洗澡状态
function PvePlayerInfo:IsBathe()
    if self.bathe then
        return self.bathe <= 0.1
    end
    return false
end

--小便值
function PvePlayerInfo:SetPee(value)
    self.pee = value * 1.0
end

--小便值
function PvePlayerInfo:GetPee()
    return self.pee
end

--大便值
function PvePlayerInfo:SetStool(value)
    self.stool = value * 1.0
end

--大便值
function PvePlayerInfo:GetStool()
    return self.stool
end

--是否是小便状态
function PvePlayerInfo:IsPeeState()
    if self.pee then
        return self.pee <= 0.1
    end
    return false
end

--是否是大便状态
function PvePlayerInfo:IsStoolState()
    if self.stool then
        return self.stool <= 0.1
    end
    return false
end

--是否是大小便状态
function PvePlayerInfo:IsPeeOrStoolState()
    --某些关卡ItenConfig配置了是否开启PeeOrStool功能使用
    local level= SceneManager.GetLevel()
    local levelId = level:GetLevelId()
    local isCanPeeOrStool = tonumber(SU_Util.GetItemConfig(levelId, "pis_function")) or 1  --1开启 2关闭
    if isCanPeeOrStool == 2 then
        return false
    end
    return self:IsPeeState() or self:IsStoolState()
end

PvePlayerInfo.PvePlayerInfoEventId = PvePlayerInfoEventId

return PvePlayerInfo