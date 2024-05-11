


---BuffManager 
---@class Scene.LWBattle.Buff.BuffManager
local BuffManager = BaseClass("BuffManager")
local BuffBase = require"Scene.LWBattle.Buff.BuffBase"
local BuffProperty = require"Scene.LWBattle.Buff.BuffProperty"
local BuffBeTaunt = require"Scene.LWBattle.Buff.BuffBeTaunt"
local BuffShield = require "Scene.LWBattle.Buff.BuffShield"


function BuffManager:__init(logic,unit)
    self.logic=logic
    self.unit=unit
    self.buffs={}---@type table<number,Scene.LWBattle.Buff.BuffBase> uid->buff
    self.propertyBuffs={}---@type table<number,table<number,Scene.LWBattle.Buff.BuffBase>> propertyType->(uid->buff)
    self.metaId2Count={}---@type table<number,number> metaId->count 叠加用
    self.metaId2Buff={}---@type table<number,Scene.LWBattle.Buff.BuffBase> metaId->buff 覆盖用
    self.haloBuff={}---@type table<number,Scene.LWBattle.Buff.BuffBase> skillUid->buff 光环buff
    self.subType2Count={}---@type table<number,number> subType->count 统计每个subType下有多少buff
    self.type2Count={}---@type table<number,number> Type->count 统计每个Type下有多少buff
    self.metaId2BuffIdMap = {} ---@type table<number, number[]> metaId -> buffUid[] 记录相同metaId的buffUid 列表
    self.metaId2ActivingEffectId = {}---@type table<number, number> metaId->effectId 叠加buff只显示一个持续特效
    self.shieldBuffs = {}   ---@type table<number, Scene.LWBattle.Buff.BuffShield> uid -> shield buff
    self.nextUid=0
    self.shieldValue = 0
end


function BuffManager:__delete()
    self:Destroy()
end

--region 公共方法


--添加buff
function BuffManager:AddBuff(metaId,param)
    metaId = tonumber(metaId)
    ---@type DataCenter.LWBuff.LWBuffTemplate
    local meta = DataCenter.LWBuffTemplateManager:GetTemplate(metaId)
    local newBuff

    --buff叠加逻辑
    if meta.additive_type==1 then--替换同id的buff(等价于刷新持续时间)
        local oldBuff = self.metaId2Buff[metaId]
        if oldBuff then
            oldBuff:Reset()
            return oldBuff
        else
            newBuff = self:InnerCreateBuff(meta,param)
            self.metaId2Buff[metaId] = newBuff
        end
    elseif meta.additive_type==2 then--与同id的buff互相独立
        local curCount = self.metaId2Count[metaId]
        if curCount then
            if curCount>=meta.max_level then--达到最大叠加次数
                return nil
            else
                newBuff = self:InnerCreateBuff(meta,param)
                self.metaId2Count[metaId] = curCount + 1
            end
        else
            newBuff = self:InnerCreateBuff(meta,param)
            self.metaId2Count[metaId] = 1
        end
        
        self:ShowActivingEffect(meta, newBuff)
    end

    self.buffs[newBuff.id]=newBuff

    return newBuff
end

--添加光环型buff
--光环是技能的一种，该技能会每x秒搜索一次目标，对所有目标添加一个持续y秒（y>x）的作用号buff
--考虑到目前只有影响队友的光环，不存在进出光环的问题，x和y都取正无穷以节省刷新
--来自于同一个光环技能的buff会刷新持续时间，同名的不同光环技能的buff互相叠加，比如我有两个安东尼达斯，那所有人身上会有两个辉煌光环
function BuffManager:AddHaloBuff(skillUid,propertyDic,skillId)
    local oldBuff = self.haloBuff[skillUid]
    if oldBuff then--刷新持续时间
        oldBuff:Reset()
        return oldBuff
    else--构造假配置
        local fakeMeta={}
        fakeMeta.id=-1*(skillId or 99999)
        fakeMeta.type=BuffType.Halo
        fakeMeta.buff_time=HALO_BUFF_DURATION
        fakeMeta.sub_type=0
        local newBuff = self:InnerCreateBuff(fakeMeta,propertyDic)
        self.haloBuff[skillUid] = newBuff
        self.buffs[newBuff.id]=newBuff
    end
end


--移除所有buff(你被驱散了！)
function BuffManager:RemoveAllBuff()
    for _,buff in pairs(self.buffs) do
        buff:End()
    end
end

--移除所有指定类型的buff
function BuffManager:RemoveAllBuffByType(type)
    for _,buff in pairs(self.buffs) do
        if buff.meta.type == type then
            buff:End()
        end
    end
end

--根据metaId移除buff
---@param count number 移除层数
function BuffManager:RemoveBuffByMetaId(metaId, count)
    removeCount = count or 1
    if self.metaId2BuffIdMap[metaId] then
        local list = self.metaId2BuffIdMap[metaId]
        local buffList = {}
        for _, mId in pairs(list) do
            if self.buffs[mId] then
                table.insert(buffList, self.buffs[mId])
            end
        end

        local buffCount = #buffList
        local maxCount = math.min(buffCount, removeCount)

        if maxCount < buffCount then
            --不完全移除时，需要先排序
            table.sort(buffList, function(a, b)
                local durationA = a.duration
                local durationB = b.durationB

                if (durationA ~= nil) and (durationB ~= nil) then
                    return durationA < durationB
                elseif durationA ~= nil then
                    return true
                elseif durationB ~= nil then
                    return false
                else
                    local buffAId = a.id
                    local buffBId = b.id
                    return buffAId < buffBId
                end
            end)
            
        end
        

        for i = 1, maxCount do
            local b = buffList[i]
            if b then
                b:End()
            end
        end
    end
end

--endregion


--内存释放
function BuffManager:Destroy()
    for _,buff in pairs(self.buffs) do
        buff:End()
    end
    self.unit=nil
    for _,property in pairs(self.propertyBuffs) do
        property={}
    end
    self.propertyBuffs={}
    self.metaId2Count={}
    self.buffs={}
    self.haloBuff={}
    self.subType2Count={}
    self.type2Count={}
    for _, buffIdList in pairs(self.metaId2BuffIdMap) do
        buffIdList = {}
    end
    self.metaId2BuffIdMap = {}

    for _, effectId in pairs(self.metaId2ActivingEffectId) do
        self.logic:RemoveEffectObj(effectId)
    end
    self.metaId2ActivingEffectId = {}
    self.shieldBuffs = {}
    self.shieldValue = 0
end

--每帧更新
function BuffManager:OnUpdate()
    for _,buff in pairs(self.buffs) do
        buff:Update()
    end
end




---@param meta DataCenter.LWBuff.LWBuffTemplate
function BuffManager:InnerCreateBuff(meta,param)
    local newBuff
    local uid=self:GetNextUid()
    if meta.type==BuffType.Property then--属性变化,param=skill level
        local propertyDic = meta:GetParaDictByLevel(param)
        newBuff=BuffProperty.New(self.logic,self,self.unit,meta,uid,propertyDic)---@type Scene.LWBattle.Buff.BuffProperty
    elseif meta.type==BuffType.Halo then--光环buff（本质还是属性变化),param=propertyDic
        newBuff=BuffProperty.New(self.logic,self,self.unit,meta,uid,param)---@type Scene.LWBattle.Buff.BuffProperty
    elseif meta.type==BuffType.BeTaunt then--被嘲讽,param=嘲讽源
        newBuff=BuffBeTaunt.New(self.logic,self,self.unit,meta,uid,param)---@type Scene.LWBattle.Buff.BuffBeTaunt
    elseif meta.type==BuffType.Shield then--护盾, param=施加者
        newBuff=BuffShield.New(self.logic, self, self.unit, meta, uid, param) ---@type Scene.LWBattle.Buff.BuffShield
    else
        newBuff=BuffBase.New(self.logic,self,self.unit,meta,uid)
    end
    newBuff:Start()
    if self.unit and self.unit.OnBuffAdded then self.unit:OnBuffAdded(newBuff) end
    EventManager:GetInstance():Broadcast(EventId.PVEBuffAdded, newBuff)
    self:RegisterSubType(meta.sub_type)
    self:RegisterType(meta.type)

    if not self.metaId2BuffIdMap[meta.id] then
        self.metaId2BuffIdMap[meta.id] = {}
    end
    table.insert(self.metaId2BuffIdMap[meta.id], newBuff.id)
    
    return newBuff
end

function BuffManager:ShowActivingEffect(meta, buff)
    if self.metaId2ActivingEffectId[meta.id] then
        return
    end
    
    local unit = buff.unit
    if unit == nil then
        return
    end

    local trans = unit:GetTransform()
    local effectId = nil
    if meta.ignore_rotate then
        effectId = self.logic:ShowEffectObj(meta.activing_effect, trans.localPosition, Quaternion.identity, 0, trans.parent)
    else
        effectId = self.logic:ShowEffectObj(meta.activing_effect, nil, Quaternion.identity, 0, trans)
    end
    
    self.metaId2ActivingEffectId[meta.id] = effectId
end


function BuffManager:RemoveActivingEffect(metaId)
    if self.metaId2ActivingEffectId[metaId] then
        self.logic:RemoveEffectObj(self.metaId2ActivingEffectId[metaId])
        
        self.metaId2ActivingEffectId[metaId] = nil
    end

end

function BuffManager:InnerRemoveBuff(buff)
    self.buffs[buff.id]=nil
    if buff.meta.id then
        self.metaId2Buff[buff.meta.id]=nil
        if self.metaId2Count[buff.meta.id] then
            self.metaId2Count[buff.meta.id]=self.metaId2Count[buff.meta.id]-1

            if self.metaId2Count[buff.meta.id] <= 0 then
                self:RemoveActivingEffect(buff.meta.id)
            end
        end
        self:UnregisterSubType(buff.meta.sub_type)
        self:UnregisterType(buff.meta.type)

        if self.metaId2BuffIdMap[buff.meta.id] then
            table.removebyvalue(self.metaId2BuffIdMap[buff.meta.id], buff.id)
        end
        
    end
    if self.unit and self.unit.OnBuffRemoved then self.unit:OnBuffRemoved(buff) end
    EventManager:GetInstance():Broadcast(EventId.PVEBuffRemoved, buff)
end


function BuffManager:GetNextUid()
    self.nextUid = self.nextUid + 1
    return self.nextUid
end

-- 是否存在某个类型的buff
function BuffManager:HasAnyBuffWithType(type)
    return self.type2Count[type] and self.type2Count[type]>0
end


--拿取某个Type的buff数
function BuffManager:GetTypeBuffCount(type)
    return self.type2Count[type] or 0
end

--注册某个Type的buff
function BuffManager:RegisterType(type)
    if not self.type2Count[type] then
        self.type2Count[type]=0
    end
    self.type2Count[type] = self.type2Count[type] + 1
end

--注销某个Type的buff
function BuffManager:UnregisterType(type)
    self.type2Count[type] = self.type2Count[type] - 1
end


--拿取某个SubType的buff数
function BuffManager:GetSubTypeBuffCount(subType)
    return self.subType2Count[subType] or 0
end

--注册某个SubType的buff
function BuffManager:RegisterSubType(subType)
    if not self.subType2Count[subType] then
        self.subType2Count[subType]=0
    end
    self.subType2Count[subType] = self.subType2Count[subType] + 1
end

--注销某个SubType的buff
function BuffManager:UnregisterSubType(subType)
    self.subType2Count[subType] = self.subType2Count[subType] - 1
end


--拿取PropertyBuff
function BuffManager:GetPropertyBuff(propertyType)
    local buffs=self.propertyBuffs[propertyType]
    if buffs==nil then
        return 0
    end
    local ret=0
    for _,buff in pairs(buffs) do
        ret=ret+buff:GetPropertyValue(propertyType)
    end
    return ret
end

--注册PropertyBuff
function BuffManager:RegisterPropertyBuff(propertyType,buff)
    if not self.propertyBuffs[propertyType] then
        self.propertyBuffs[propertyType]={}
    end
    self.propertyBuffs[propertyType][buff.id]=buff
end


--注销PropertyBuff
function BuffManager:UnregisterPropertyBuff(propertyType,buff)
    self.propertyBuffs[propertyType][buff.id]=nil
end

--缓存护盾buff
function BuffManager:RegisterShieldBuff(buff)
    self.shieldBuffs[buff.id] = buff
    
    self.shieldValue = 0
    for _, v in pairs(self.shieldBuffs) do
        self.shieldValue = self.shieldValue + v:GetShieldValue()
    end
end

function BuffManager:UnregisterShieldBuff(buff)
    self.shieldBuffs[buff.id] = nil

    self.shieldValue = 0
    for _, v in pairs(self.shieldBuffs) do
        self.shieldValue = self.shieldValue + v:GetShieldValue()
    end
end

---@return number 获取总护盾值
function BuffManager:GetShieldValue()
    return self.shieldValue
end


---@return number 护盾吸收后的剩余伤害值
function BuffManager:ReduceShieldValue(hurt)
    if self.shieldValue <= 0 then
        return hurt
    end

    if hurt > self.shieldValue then
        --护盾全部扣除
        for _, v in pairs(self.shieldBuffs) do
            v:ReduceAll()
        end
        
        local remain = hurt - self.shieldValue
        self.shieldValue = 0
        
        return remain
    end

    --提前计算剩余总护盾值
    self.shieldValue = self.shieldValue - hurt
    
    --扣减伤害
    local buffs = {}
    for _, v in pairs(self.shieldBuffs) do
        table.insert(buffs, v)
    end

    if #buffs == 1 then
        --只有一个护盾
        
        return buffs[1]:ReduceShieldValue(hurt)
    end
    
    table.sort(buffs, function(a, b) 
        --按剩余时间排序
        local durationA = a.duration
        local durationB = b.durationB

        if (durationA ~= nil) and (durationB ~= nil) then
            return durationA < durationB
        elseif durationA ~= nil then
            return true
        elseif durationB ~= nil then
            return false
        else
            local buffAId = a.id
            local buffBId = b.id
            return buffAId < buffBId
        end
    end)

    local remainHurt = hurt
    for _, v in ipairs(buffs) do
        remainHurt = v:ReduceShieldValue(remainHurt)
        if remainHurt <= 0 then
            return remainHurt
        end
    end
    
    return remainHurt
end

--移除所有护盾
function BuffManager:RemoveAllShield()
    for _, v in pairs(self.shieldBuffs) do
        v:ReduceAll()
    end
end

return BuffManager