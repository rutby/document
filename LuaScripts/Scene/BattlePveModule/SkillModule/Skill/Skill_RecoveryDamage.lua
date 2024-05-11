---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by mac.
--- DateTime: 3/29/22 11:15 AM
---

local base = require "Scene.BattlePveModule.SkillModule.Skill.SkillBase"
local Skill_RecoveryDamage = BaseClass("Skill_RecoveryDamage", base)
local Const= require "Scene.BattlePveModule.Const"

--[[
    伤兵恢复  261009={0}发动了{1}！{2}恢复了{3}兵力
]]

function Skill_RecoveryDamage:DoAttack( actionItem, callback ,maxTime)
    base.DoAttack(self, actionItem, callback)
    -- 普攻的展示为 发起发做攻击处理, 受击方做受击处理
    local _atkIdx = actionItem:GetTriggerIndex()
    local _atkCampType = PveActorMgr:GetInstance():GetCampTypeByTriggerIndex(_atkIdx)
    local _atkModelObj = PveActorMgr:GetInstance():GetModelMgr():GetModelObjByHeroId(_atkCampType, actionItem:GetHeroId())
    local _defIdx = actionItem:GetTargetIndex()
    local _defCampType = PveActorMgr:GetInstance():GetCampTypeByTriggerIndex(_defIdx)
    if (_atkModelObj == nil) then
        -- 这个时候表示没有找到实体.直接进行下一步
        self:DoCallback()
        return
    end

    -- 有些英雄在起初攻击的时候会有前摇,看英雄来处理
    --_atkModelObj:BeginAttack()
    -- 对方受击
    local atkValue = actionItem:GetValue()["value"]
    local ratio = PveActorMgr:GetInstance():GetHp2PowerRatio(_defCampType)
    atkValue = atkValue * ratio
    atkValue = Mathf.Floor(atkValue)
    local _hitInfo = self:_CalculateTargetHit(_defCampType, atkValue)
    local _modelMgr = PveActorMgr:GetInstance():GetModelMgr()
    local _targetModelList = _defCampType == Const.CampType.Player and _modelMgr:GetModelListByCamp(Const.CampType.Player) or _modelMgr:GetModelListByCamp(Const.CampType.Target)

    if (PveActorMgr:GetInstance():IsStopPlay()) then
        for index, value in pairs(_hitInfo) do
            local modelObj = _targetModelList[tonumber(index)]
            if (modelObj ~= nil) then
                modelObj:RecvHit(value)
            end
        end
        self:DoCallback()
        return
    end
    local heroId = actionItem:GetHeroId()
    local skillId = actionItem._actionData["skillId"] or 0
    local rarity = GetTableData(HeroUtils.GetHeroXmlName(),tonumber(heroId), "rarity")
    local effectName = GetTableData(TableName.SkillTab, skillId, "skill_anim")
    local delayFinishTime = 2
    if maxTime~=nil then
        delayFinishTime = maxTime
    end
    if LuaEntry.DataConfig:CheckSwitch("s_skill") and rarity == 1 then
        if effectName~=nil and effectName~="" then
            PveActorMgr:GetInstance():ShowSHeroLevelSkill(heroId,skillId,_atkCampType == Const.CampType.Target)
            TimerManager:GetInstance():DelayInvoke(function()
                -- 执行回调
                PveActorMgr:GetInstance():HideSHeroLevelSkill()
                for index, value in pairs(_hitInfo) do
                    local modelObj = _targetModelList[tonumber(index)]
                    if (modelObj ~= nil) then
                        modelObj:RecvHit(value)
                        modelObj:PlayEffectAddHp()
                    end
                end
                self:DoCallback()
            end, 4* PveActorMgr:GetInstance():GetSpeed())
        else
            TimerManager:GetInstance():DelayInvoke(function()
                for index, value in pairs(_hitInfo) do
                    local modelObj = _targetModelList[tonumber(index)]
                    if (modelObj ~= nil) then
                        modelObj:RecvHit(value)
                        modelObj:PlayEffectAddHp()
                    end
                end
                self:DoCallback()
            end, 2* PveActorMgr:GetInstance():GetSpeed())
            TimerManager:GetInstance():DelayInvoke(function()
                -- 执行回调
                PveActorMgr:GetInstance():HideSHeroLevelSkill()
            end,delayFinishTime*PveActorMgr:GetInstance():GetSpeed())
        end
    else
        for index, value in pairs(_hitInfo) do
            local modelObj = _targetModelList[tonumber(index)]
            if (modelObj ~= nil) then
                modelObj:RecvHit(value)
                modelObj:PlayEffectAddHp()
            end
        end
        --_defModelObj:RecvHit(atkValue)
        --_defModelObj:PlayEffectAddHp()
        -- 执行回调
        self:DoCallback()
    end
end

--[[
    计算伤害值
]]
local tabRank = {-1, 1}
function Skill_RecoveryDamage:_CalculateTargetHit( defSide , addValue)
    addValue = Mathf.Abs(addValue)
    local _tabHit = {} -- 对对方造成的伤害
    local _aliveCnt = 0 -- 攻击方总共有多少存活,用来做最后一个收尾的处理
    local _totalAddHp = 0 -- 临时变量,辅助收尾处理
    local _tmpTabAddHp = {} -- 攻击方可以造成的伤害 k=model数组的index(str), v 伤害值
    -- 计算总战力
    local _modelMgr = PveActorMgr:GetInstance():GetModelMgr()
    local _targetModelList = defSide == Const.CampType.Player and _modelMgr:GetModelListByCamp(Const.CampType.Player) or _modelMgr:GetModelListByCamp(Const.CampType.Target)
    _aliveCnt = table.count(_targetModelList)

    local _index_tmp1 = 1
    local ratio = 1 / _aliveCnt
    ratio = Mathf.DecimalFormat(ratio) -- 做小数点后两位
    -- 计算可以造成的伤害值
    for index, modelObj in pairs(_targetModelList) do
        if (_index_tmp1 == _aliveCnt) then
            _tmpTabAddHp[tostring(index)] = addValue-_totalAddHp
        else
            local _addHp = Mathf.Floor(addValue * ratio)
            _tmpTabAddHp[tostring(index)] = _addHp
            _totalAddHp = _totalAddHp + _addHp
            _index_tmp1 = _index_tmp1 + 1
        end
    end
    -- 按照对位进行伤害,如果对位不存在或者对方isDead则筛选其他站位的
    local _targetHp = {}
    local _targetMaxHp = {}
    for index, model in pairs(_targetModelList) do
        _targetHp[tostring(index)] = model:GetCurHp()
        _targetMaxHp[tostring(index)] = model:GetMaxHp()
    end
    local _targetHp_clone = DeepCopy(_targetHp)
    for index, value in pairs(_tmpTabAddHp) do
        local leftvalue = value
        for i = 0, 4 do
            if (i == 0) then
                local modelLeftHp = _targetMaxHp[index] - _targetHp_clone[index]
                if (modelLeftHp >= leftvalue) then
                    _targetHp_clone[index] = _targetHp_clone[index] + leftvalue
                    leftvalue = 0
                    goto continue
                else
                    leftvalue = leftvalue - (_targetMaxHp[index]-_targetHp_clone[index])
                    _targetHp_clone[index] = _targetMaxHp[index]
                end
            else
                -- 对左右两边的进行筛选
                local tabRankCnt = table.count(tabRank)
                for j = 1, tabRankCnt do
                    local newIndex = tostring(tonumber(index) + tabRank[j]*i)
                    local modelHp = _targetHp_clone[newIndex]
                    if (modelHp ~= nil and modelHp > 0) then
                        if (modelHp >= leftvalue) then
                            _targetHp_clone[newIndex] = _targetHp_clone[newIndex] + leftvalue
                            leftvalue = 0
                            goto continue
                        else
                            leftvalue = leftvalue - (_targetMaxHp[newIndex]-_targetHp_clone[newIndex])
                            _targetHp_clone[newIndex] = _targetMaxHp[newIndex]
                        end
                    end
                end
            end
        end
        ::continue::
    end
    -- 计算最终伤害
    for k, v in pairs(_targetHp) do
        _tabHit[k] = _targetHp_clone[k] - v
    end
    return _tabHit
end

return Skill_RecoveryDamage