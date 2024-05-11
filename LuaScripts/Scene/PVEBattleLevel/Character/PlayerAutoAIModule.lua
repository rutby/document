---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by mac.
--- DateTime: 2023/3/13 12:27 下午
---
--[[
    这个是玩家角色自动采集攻击的模块
    这块大概的逻辑是:
    1.角色主动选择最近的可采集的资源,需要考虑背包是否充足,是否有对应的工具
    2.是否有锁定玩家的怪,如果有,优先攻击丧尸
    
    在update里,筛选如果当前有 enemy, 设置当前状态为 attack, 在attack状态下,不做筛选,直接移动到丧尸身边,然后触发攻击直到当前丧尸死亡
    
]]
local PlayerAutoAIModule = BaseClass("PlayerAutoAIModule")
local Const = require("Scene.PVEBattleLevel.Const")
local CharacterStateType = require("Scene.PVEBattleLevel.Character.State.CharacterStateType")

local StateType = {
    None = 0,
    Collect = 1,
    Attack = 2
}

function PlayerAutoAIModule:AddListener(msg_name, callback)
    local bindFunc = function(...) callback(self, ...) end
    self.__event_handlers[msg_name] = bindFunc
    EventManager:GetInstance():AddListener(msg_name, bindFunc)
end

function PlayerAutoAIModule:RemoveListener(msg_name, callback)
    local bindFunc = self.__event_handlers[msg_name]
    if not bindFunc then
        Logger.LogError(msg_name, " not register")
        return
    end
    self.__event_handlers[msg_name] = nil
    EventManager:GetInstance():RemoveListener(msg_name, bindFunc)
end

function PlayerAutoAIModule:__init(player)
    self.__event_handlers = {}
    self.player = player
    self.m_isAIStart = false;
    self.m_curState = StateType.None
    self.m_target = nil
    self:Inner_AddListener()
end

function PlayerAutoAIModule:Destroy()
    self:Inner_RemoveListener()
end

function PlayerAutoAIModule:StartAI()
    self.m_isAIStart = true
    self.m_target = nil
    self.m_targetType = nil
    self.m_attacking = false
    self.m_collecting = false
    self.player.ai:RemoveSelectCircle()
    self.collectRadius = self.player:GetCollectRange()
    self.attackRadius = self.player:GetAttackRange()
end

function PlayerAutoAIModule:StopAI()
    self.m_isAIStart = false
    self.m_target = nil
    self.m_targetType = nil
    self.m_curState = StateType.None
end

function PlayerAutoAIModule:Inner_AddListener()
    self:AddListener(EventId.SU_PlayerStateDone, self.StateActionDone)
end

function PlayerAutoAIModule:Inner_RemoveListener()
    self:RemoveListener(EventId.SU_PlayerStateDone, self.StateActionDone)
end

function PlayerAutoAIModule:StateActionDone( stateType )
    if not self.m_isAIStart then
        return
    end
    if (stateType == CharacterStateType.Attack) then -- 表示攻击完成
        self:StopAttack()
        self:ResetTarget()
        self.m_curState = StateType.None
    elseif stateType == CharacterStateType.Collect then
        self:StopCollect()
        self:ResetTarget()
        self.m_curState = StateType.None
    elseif stateType == CharacterStateType.MoveByPath then
        if (self.m_curState == StateType.Attack) then
            self:BeginToAttack()
        elseif self.m_curState == StateType.Collect then
            self:BeginToCollect()
        end
    end
end

function PlayerAutoAIModule:ResetTarget()
    if (self.m_target ~= nil) then
        self.m_target:LostFocus()
    end
    self.m_target = nil
end

function PlayerAutoAIModule:GetRadius()
    if self.m_curState == StateType.Collect then
        return self.player:GetCollectRange()
    elseif self.m_curState == StateType.Attack then
        return self.player:GetAttackRange()
    end
    return 0
end

function PlayerAutoAIModule:GetTarget()
    local result = {}
    result["obj"] = self.m_target
    if self.m_curState == StateType.Collect then
        result["type"] = Const.TargetType.Collect
    elseif self.m_curState == StateType.Attack then
        result["type"] = Const.TargetType.Zombie
    end
    return result
end

function PlayerAutoAIModule:BeginToAttack()
    self.player:MoveToAttack()
    self.m_attacking = true
end
function PlayerAutoAIModule:StopAttack()
    self.player:StopAttack()
    self.m_attacking = false
    self.player.ai:Stop()
end
function PlayerAutoAIModule:BeginToCollect()
    self.player:MoveToCollect(Const.FingerAction.Down)
    self.m_collecting = true
end
function PlayerAutoAIModule:StopCollect()
    self.player:MoveToCollect(Const.FingerAction.Up)
    self.m_collecting = false
    self.player.ai:Stop()
end

--[[
    检测已经到了范围内,开始处理状态
]]
function PlayerAutoAIModule:CheckInRange()
    local target = self.m_target
    if target == nil then
        self.m_curState = StateType.None
        return
    else
        if (self.m_targetType == Const.TargetType.Collect) then
            local _itemInfo = target:GetInfo()
            if (_itemInfo == nil or _itemInfo:IsFinished()) then
                --self.m_curState = StateType.None
                return
            end
        end
    end
    local radius = 1--self:GetRadius()
    local modelRadius = self.m_target:GetModelRadius()
    if self.m_curState == StateType.Collect then
        radius = self.collectRadius
        modelRadius = modelRadius * 0.5 --采集物为了适配光圈，把这个参数当成直径来用了，所以这里需要*0.5
    elseif self.m_curState == StateType.Attack then
        radius = self.attackRadius
    end
    local dis = Vector3.Distance(self.player:GetPosition(),target:GetPosition()) - modelRadius
    if dis <= radius then
        if self.m_curState == StateType.Collect then
            self.player:Collect(target)
        elseif self.m_curState == StateType.Attack then
            self.player:Attack(target)
        end
    else
        self.player:MovePath(target:GetPosition())
    end
end

function PlayerAutoAIModule:OnUpdate( deltaTime )
    if (self.m_isAIStart == false) then
        return
    end
    if (self.m_curState ~= StateType.None) then -- 表明现在已经有对应的工作,忽略其他的
        self:CheckInRange()
        return
    end
    -- 筛选敌人
    if (self:FindEnemy()) then
        self.m_curState = StateType.Attack
        self:MoveToTarget()
        return
    elseif self:FindResource() then
        self.m_curState = StateType.Collect
        self:MoveToTarget()
    else
        self:ExitMode()
    end
end

--[[
    寻找最近的锁定玩家的怪物
]]
function PlayerAutoAIModule:FindEnemy()
    local _target = DataCenter.BattleLevel:GetRoleMgr():FindEnemyHasLockedPlayer()
    if (_target == nil) then
        return false
    end
    self:SetTarget(_target, Const.TargetType.Zombie)
    return true
end

function PlayerAutoAIModule:SetTarget( target, targettype )
    if (self.m_target ~= target) then
        if (target ~= nil) then
            target:Focus()
        end
        self.m_target = target
        self.m_targetType = targettype
        local param = {}
        param["type"] = targettype
        param["obj"] = target
        EventManager:GetInstance():Broadcast(EventId.SU_PlayerTargetChange, param)
    end
end

--[[
    筛选资源
]]
function PlayerAutoAIModule:FindResource()
    local _allMapItemList = DataCenter.BattleLevel:GetObjMgr():GetAllObject()
    local _distance = 100000000
    local _resource = nil
    local _user_pos = self.player:GetPosition()
    for _, objItem in pairs(_allMapItemList) do
        local _objInfo = objItem:GetInfo()
        if (_objInfo == nil) then
            goto continue
        end
        local _objType = _objInfo:GetObjectType()
        if (_objType ~= Const.ObjectType.Normal and _objType ~= Const.ObjectType.Tree) then -- 目前只做普通采集和砍树,石块的处理
            goto continue
        end
        -- 过滤掉白点
        if _objInfo:IsGuidePoint() then
            goto continue
        end
        local _objId = objItem:GetUuid()
        local _itemInfo = DataCenter.SV_MapItemInfoManager:GetItemInfoList():GetItemInfoByUuid(_objId)
        if (_itemInfo == nil) then
            goto continue
        end
        if (_itemInfo:IsResourceEmpty() or _itemInfo:IsFinished()) then
            goto continue
        end
        local toolsId = _itemInfo:GetTools()
        if (not string.IsNullOrEmpty(toolsId)) then -- 如果当前没有对应的工具,跳过
            if (not DataCenter.BagGridDataManager:HasItemInPocket(toolsId) and not DataCenter.BagGridDataManager:GetEquipGridData():HasItem(toolsId)) then
                goto continue
            end
        end
        -- 检测是否背包充足
        local _resource_Info = objItem:GetInfo()
        if (_resource_Info ~= nil) then
            local _reward = _resource_Info:GetReward()
            for itemId, itemNum in pairs(_reward) do
                if (not BagUtil.CanPutItemInPocket(itemId, itemNum)) then -- 如果放不下,直接忽略
                    goto continue
                end
            end
        end
        -- 位置检测
        local _enemyPos = objItem:GetPosition()
        local _tmp = Mathf.Pow(_user_pos.x-_enemyPos.x, 2) + Mathf.Pow(_user_pos.z - _enemyPos.z, 2)
        if (_tmp < _distance) then
            _resource = objItem
            _distance = _tmp
        end
        ::continue::
    end
    if (_resource ~= nil) then
        self:SetTarget(_resource, Const.TargetType.Collect, true)
    end
    return _resource ~= nil
end

function PlayerAutoAIModule:MoveToTarget()
    if (self.m_target == nil) then return end
    local _targetPos = self.m_target:GetPosition()
    self.player:MovePath(_targetPos)
end

function PlayerAutoAIModule:ExitMode()
    self:SetTarget(nil, Const.TargetType.None, true)
    EventManager:GetInstance():Broadcast(EventId.SU_StopPlayerAutoAI)
end

return PlayerAutoAIModule