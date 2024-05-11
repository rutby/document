---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2021/10/19 21:17
---
local EffectData= BaseClass("EffectData")


function EffectData:AddListener(msg_name, callback)
    local bindFunc = function(...) callback(self, ...) end
    self.__event_handlers[msg_name] = bindFunc
    EventManager:GetInstance():AddListener(msg_name, bindFunc)
end

function EffectData:RemoveListener(msg_name, callback)
    local bindFunc = self.__event_handlers[msg_name]
    if not bindFunc then
        Logger.LogError(msg_name, " not register")
        return
    end
    self.__event_handlers[msg_name] = nil
    EventManager:GetInstance():RemoveListener(msg_name, bindFunc)
end

function EffectData:__init()
    self.__event_handlers = {}
    self:__reset()
end

function EffectData:__reset()
    self.effectValues ={}--作用号加成效果
    
    self.effectStateMap ={} --状态 和 作用值 相关
    self.statusMap ={} --effectStateMap中ID所对应的Effect 的时间(玩家身上的buff)
    self.worldStatusMap = {} --effectStateMap中ID所对应的 Effect的开始时间和结束时间(世界提供的buff)
    self.reasonEffectValues = {}--建造时间科技研究时间拆分小的加成值， effectId,{<EffectReasonType,float>} 
    
    self.serverEffect = {}--key:effectId value:table{mainLv,num}
    self.serverActEffect = {}
    
    self.buildFurnitureEffect = {}--一个建筑的家具提供的作用号  生效范围：该建筑里的所有家具  <bUuid, <key, valye>>
end

function EffectData:InitFromNet(obj)
    self:__reset()
    if obj["effect"]~=nil then
        self.effectValues = {}
        self.reasonEffectValues = {}
        local effectList = obj["effect"]
        self:OnEffectChange(effectList, true)
    end

    if obj["effectState"]~=nil then
        self.statusMap = {}
        local stateDic = obj["effectState"]
        table.walk(stateDic,function(k,v)
            local key = tonumber(k)
            local value = tonumber(v)
            self:AddStatus(key,value)
        end)
    end

    if obj["status"]~=nil then
        self.effectStateMap ={}
        self:UpdateStatus(obj)
    end

    if obj["newEffectState"]~=nil then
        self.worldStatusMap = {}
        local stateDic = obj["newEffectState"]
        table.walk(stateDic,function(k,v)
            local oneData = {}
            if v["stateId"]~=nil then
                oneData.stateId = v["stateId"]
            end
            if v["st"]~=nil then
                oneData.startTime = v["st"]
            end
            if v["et"]~=nil then
                oneData.endTime = v["et"]
            end
            if oneData.stateId~=0 then
                self.worldStatusMap[oneData.stateId] = oneData
            end
        end)
    end

    local temp = obj["buildFurnitureEffect"]
    if temp ~= nil then
        self.buildFurnitureEffect = {}
        for k, v in ipairs(temp) do
            self:UpdateOneBuildEffectFurniture(v)
        end
    end
end

function EffectData:UpdateStatus(obj)
    if obj==nil then
        return
    end
    local data = obj["status"]
    if data == nil then
        return
    end
    table.walk(data,function(k,v)
        if v~=nil then
            local effectState = {}
            effectState.value = 0
            effectState.effectId = 0
            effectState.stateId = 0
            if v["effVal"]~=nil then
                effectState.value = v["effVal"]
            end
            if v["stateId"]~=nil then
                effectState.stateId = v["stateId"]
            end
            if v["effNum"]~=nil then
                effectState.effectId = v["effNum"]
            end
            if effectState.effectId~=nil and effectState.effectId~=0 then
                if self.effectStateMap[effectState.effectId]==nil then
                    self.effectStateMap[effectState.effectId] = {}
                end
                if effectState.stateId~=nil and effectState.stateId~=0 then
                    self.effectStateMap[effectState.effectId][effectState.stateId] = effectState
                end
            end
        end


    end)
end
function EffectData:InitServerEffect(message)
    self.serverEffect = {}
    if message["serverEffects"]~=nil then
        local arr = message["serverEffects"]
        for k,v in pairs(arr) do
            local level = v["level"]
            local effect =  v["effect"]
            if level~=nil and level~="" and effect~=nil and effect~="" then
                local levelArr = string.split(level,"-")
                local effectArr = string.split(effect,"|")
                if #levelArr>0 and # effectArr>0 then
                    local minLevel = tonumber(levelArr[1])
                    local maxLevel = minLevel
                    if #levelArr>1 then
                        maxLevel = tonumber(levelArr[2])
                    end
                    if minLevel~=nil and maxLevel~=nil then
                        for i =1 ,#effectArr do
                            local effectStr = effectArr[i]
                            local oneEffectStr = string.split(effectStr,";")
                            if #oneEffectStr>1 then
                                local effectId = tonumber(oneEffectStr[1])
                                local num = tonumber(oneEffectStr[2])
                                if effectId~=nil and num~=nil then
                                    if self.serverEffect[effectId] == nil then
                                        self.serverEffect[effectId] = {}
                                    end
                                    if maxLevel>=minLevel then
                                        for a = minLevel ,maxLevel do
                                            if self.serverEffect[effectId][a]==nil then
                                                self.serverEffect[effectId][a] = 0
                                            end
                                            self.serverEffect[effectId][a] = self.serverEffect[effectId][a]+num
                                        end
                                    end
                                end
                            end
                        end
                    end
                    
                end
            end 
        end
    end
end

function EffectData:InitServerActEffect(message)
    self.serverActEffect= {}
    for k,v in pairs(message) do
        local key = tonumber(k)
        local value = tonumber(v)
        if key~=nil and value~=nil then
            self.serverActEffect[key] = value
        end
        
    end
end

function EffectData:GetServerAllActEffect()
    return self.serverActEffect
end

function EffectData:GetServerActEffect(effId)
    if self.serverActEffect[effId]~=nil then
        return self.serverActEffect[effId]
    end
    return 0
end
function EffectData:Release()
end

function EffectData:GetEffectValue(effId)
    if self.effectValues[effId]~=nil then
        return self.effectValues[effId]
    end
    return 0
end

function EffectData:GetEffectStateValue(effId)
    local ret = 0
    if self.effectStateMap[effId]~=nil then
        local effList = self.effectStateMap[effId]
        local curTime = UITimeManager:GetInstance():GetServerTime()
        table.walk(effList,function(k,v)
            if self.statusMap[v.stateId]~=nil then
                if curTime < self.statusMap[v.stateId] then
                    ret = ret+v.value
                end
            end
            if self.worldStatusMap[v.stateId]~=nil then
                if curTime<self.worldStatusMap[v.stateId].endTime and curTime > self.worldStatusMap[v.stateId].startTime then
                    ret = ret+v.value
                end
            end
        end)
    end
    return ret
end

function EffectData:GetGameEffect(effect)
    local allianceCityEffect = DataCenter.WorldAllianceCityDataManager:GetAllianceCityEffectById(effect)
    local allianceScienceEffect = DataCenter.AllianceScienceDataManager:GetAllianceScienceEffectById(effect)
    local dragonEffect = DataCenter.ActDragonManager:GetDragonEffectById(effect)
    local serverActEffect = self:GetServerActEffect(effect)
    local serverEffect = 0
    if self.serverEffect[effect]~=nil then
        local mainLv = DataCenter.BuildManager.MainLv
        if mainLv~=nil then
            if self.serverEffect[effect][mainLv]~=nil then
                serverEffect = self.serverEffect[effect][mainLv]
            end
        end
    end
    local total = self:GetEffectValue(effect) 
            + self:GetEffectStateValue(effect) 
            + allianceCityEffect 
            + allianceScienceEffect+serverEffect+dragonEffect+serverActEffect
    
    return total
end

function EffectData:AddStatus(stateId,time)
    self.statusMap[stateId] = time
end

function EffectData:RemoveStatus(stateId)
    stateId = tonumber(stateId)
    if self.statusMap[stateId]~=nil then
        self.statusMap[stateId] = 0
    end
end

function EffectData:OnEffectChange(effectList, isInit)
    table.walk(effectList,function(k,v)
        local key = tonumber(k)
        local value = tonumber(v)
        if key ~= nil then
            self.effectValues[key] = value
        elseif k == "reasons" then
            for k1,v1 in pairs(v) do
                local subEffect = {}
                for k2,v2 in pairs(v1) do
                    if k2 == "id" then
                        self.reasonEffectValues[tonumber(v2)] = subEffect
                    else
                        subEffect[tonumber(k2)] = tonumber(v2)
                    end
                end
             
            end
        elseif k == "reason" then
            local subEffect = {}
            for k2,v2 in pairs(v) do
                if k2 == "id" then
                    self.reasonEffectValues[tonumber(v2)] = subEffect
                else
                    subEffect[tonumber(k2)] = tonumber(v2)
                end
            end
        end
    end)
end

function EffectData:UpdateEffectStatus(effVal,effId,stateId, endTime)
    local effectState = {}
    effectState.value = effVal
    effectState.effectId = effId
    effectState.stateId = stateId
    if effectState.effectId~=nil and effectState.effectId~=0 then
        if self.effectStateMap[effectState.effectId] == nil then
            self.effectStateMap[effectState.effectId] = {}
        end
        if effectState.stateId~=nil and effectState.stateId~=0 then
            self.effectStateMap[effectState.effectId][effectState.stateId] = effectState
        end
        if endTime ~= nil and endTime>0 then
            self.statusMap[effectState.stateId] = endTime
        end
    end
end
function EffectData:UpdateEffectWorldStatus(effVal,effId,stateId,endTime,startTime)
    local effectState = {}
    effectState.value = effVal
    effectState.effectId = effId
    effectState.stateId = stateId
    if effectState.effectId~=nil and effectState.effectId~=0 then
        if self.effectStateMap[effectState.effectId] == nil then
            self.effectStateMap[effectState.effectId] = {}
        end
        if effectState.stateId~=nil and effectState.stateId~=0 then
            self.effectStateMap[effectState.effectId][effectState.stateId] = effectState
        end
        if endTime ~= nil and endTime>0 and startTime~=nil and startTime>0 then
            local oneData = {}
            oneData.stateId = stateId
            oneData.startTime = startTime
            oneData.endTime = endTime
            if oneData.stateId~=0 then
                self.worldStatusMap[oneData.stateId] = oneData
            end
        end
    end
end

function EffectData:GetStatusMap()
    return self.statusMap
end
function EffectData:GetWorldStatusMap()
    return self.worldStatusMap
end

--获取作用号中每一个子原因的值
function EffectData:GetReasonEffectValue(effectId,reasonType)
    if self.reasonEffectValues ~= nil and self.reasonEffectValues[effectId] ~= nil then
        return self.reasonEffectValues[effectId][reasonType]
    end
end

function EffectData:UpdateOneBuildEffectFurniture(message)
    local bUuid = message["bUuid"]
    if bUuid ~= nil then
        local oneData = {}
        self.buildFurnitureEffect[bUuid] = oneData
        for k1, v1 in pairs(message) do
            if k1 ~= "bUuid" then
                oneData[tonumber(k1)] = v1
            end
        end
    end
end

function EffectData:GetBuildEffect(bUuid, effectId)
    if self.buildFurnitureEffect[bUuid] == nil then
        return 0
    end
    return self.buildFurnitureEffect[bUuid][tonumber(effectId)] or 0
end

return EffectData