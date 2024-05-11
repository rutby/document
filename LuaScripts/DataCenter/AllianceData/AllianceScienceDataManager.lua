---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by guqu.
--- DateTime: 2020/9/27 20:23
--- 
local AllianceScienceDataManager = BaseClass("AllianceScienceDataManager")
local AllianceScienceData = require "DataCenter.AllianceData.AllianceScienceData"
function AllianceScienceDataManager:__init()
    self.alScienceList ={}
    self.alScienceEffectDic = {}
    self.maxNum = 0--捐资源最多次数
    self.useNum = 0 --捐资源剩余使用次数 
    self.useGoldNum = 0 --捐钻石最多次数
    self.maxGoldNum =0 --捐钻石已使用次数
    self.timePoint =0 --上次捐献时间点
    self.refreshTimeBlock =0 --需要等待时间长度
    self.tabLine = {}
end
function AllianceScienceDataManager:InitData()
end
function AllianceScienceDataManager:__delete()
end

function AllianceScienceDataManager:GetShowRedScienceId(tabIndex)
    --local rowList = self:GetScienceRowList(tabIndex)
    --local retScienceList = {}
    --for j = 1, table.count(rowList) do
    --    local scienceList = rowList[j]
    --    local isShowRedColumn = false
    --    for k = 1, table.count(scienceList) do
    --        local data = scienceList[k]
    --        local info = self:GetOneAllianceScienceById(data.id)
    --        if info.curLevel < info.maxLevel then
    --            isShowRedColumn = true
    --            if info.currentPro < info.needPro then
    --                table.insert(retScienceList, info.scienceId)
    --            end
    --        end
    --    end
    --    if isShowRedColumn then
    --        return retScienceList
    --    end
    --end
end

function AllianceScienceDataManager:GetScienceRowList(tab)
    if self.tabLine[tab] == nil then
        local tableData = LocalController:instance():getTable(TableName.AlScienceTab)
        if tableData ~= nil then
            local indexList = tableData.index
            for k, v in pairs(tableData.data) do
                local tabIndex = v[indexList["tab"][1]]
                local position = v[indexList["position"][1]]
                local id = v[indexList["id"][1]]

                if self.tabLine[tabIndex] == nil then
                    self.tabLine[tabIndex] = {}
                end
                local positionX = position[1]
                local positionY = position[2]
                if positionX ~= nil and positionX > 0 and positionY ~= nil and positionY >0 then
                    if self.tabLine[tabIndex][positionX] == nil then
                        self.tabLine[tabIndex][positionX] = {}
                    end
                    self.tabLine[tabIndex][positionX][positionY] = id
                end
            end
        end
    end
    return self.tabLine[tab]
end

function AllianceScienceDataManager:GetResDonateRestCount()
    local max = self:GetResDonateMaxCount()
    if self.useNum < max then
        local curTime = UITimeManager:GetInstance():GetServerTime()
        local newTime = math.floor((curTime - self:GetTimePoint()) / self:GetRefreshTimeBlock()) + self.useNum
        if newTime > max then
            return max
        end
        return newTime
    end
    
    return self.useNum
end
function AllianceScienceDataManager:GetResDonateMaxCount()
    return self.maxNum
end
function AllianceScienceDataManager:GetGoldDonateRestCount()
    return self.useGoldNum
end
function AllianceScienceDataManager:GetGoldDonateMaxCount()
    return self.maxGoldNum
end
function AllianceScienceDataManager:GetTimePoint()
    return self.timePoint
end
function AllianceScienceDataManager:GetRefreshTimeBlock()
    return self.refreshTimeBlock
end

function AllianceScienceDataManager:UpdateAllianceScienceServer(message)
    local canSend = true
    local allianceScience = message["allianceScience"]
    if allianceScience ~= nil then
        for k,v in ipairs(allianceScience) do
            local scienceId = v["scienceId"]
            if scienceId > 0 then
                self:UpdateOneAllianceScience(v, false)
                if canSend then
                    -- 在联盟主界面需要显示可捐献的次数，但是主界面只有每个科技的等级信息，没有捐献信息
                    -- 可捐献次数所有科技是共享的，所以选第一个科技拿一下次数
                    canSend = false
                    SFSNetwork.SendMessage(MsgDefines.AlScienceNumFresh, scienceId)
                end
            end
        end
        self:UpdateAllianceScienceEffect()
    end
end

function AllianceScienceDataManager:UpdateOneAllianceScience(message, noUpdateEffect)
    local id = message["scienceId"]
    if id ~= nil then
        if self.alScienceList[id] == nil then
            self.alScienceList[id] = AllianceScienceData.New()
        end
        self.alScienceList[id]:ParseData(message)
        if not noUpdateEffect then
            self:UpdateAllianceScienceEffect()
        end
    end
end

function AllianceScienceDataManager:UpdateAllianceScienceRecommend(msg)
    for i, v in pairs(self.alScienceList) do
        v.state = 0
    end
    local scienceId = msg["scienceId"]
    if scienceId ~= nil and scienceId > 0 then
        self.alScienceList[scienceId].state = 1
    end
    EventManager:GetInstance():Broadcast(EventId.OnAlScienceRecommendChange, scienceId)
end

function AllianceScienceDataManager:UpdateAllianceScienceEffect()
    self.alScienceEffectDic = {}
    for k, oneData in pairs(self.alScienceList) do
        local effectKey = oneData.para1
        local effectValue = oneData.para2
        local effectKey_arr = string.split_ii_array(effectKey, ";")
        local effectValue_arr = string.split_ii_array(effectValue, ";")
        for i = 1, table.count(effectKey_arr) do
            local eK = effectKey_arr[i]
            local eV = 0
            if effectValue_arr[i] ~= nil then
                eV = effectValue_arr[i]
            end
            if self.alScienceEffectDic[eK] ~= nil then
                eV = self.alScienceEffectDic[eK] + eV
            end
            self.alScienceEffectDic[eK] = eV
        end
    end
end

function AllianceScienceDataManager:GetOneAllianceScienceById(alScienceId)
    return self.alScienceList[alScienceId]
end
function AllianceScienceDataManager:EndRefreshAllScienceNum(message)
    if message["maxNum"]~=nil then
        self.maxNum = message["maxNum"]
    end
    if message["useNum"]~=nil then
        self.useNum = message["useNum"]
    end
    if message["maxGoldNum"]~=nil then
        self.maxGoldNum = message["maxGoldNum"]
    end
    if message["useGoldNum"]~=nil then
        self.useGoldNum = message["useGoldNum"]
    end
    if message["timePoint"]~=nil then
        self.timePoint = message["timePoint"]
    end
    if message["refreshTimeBlock"]~=nil then
        self.refreshTimeBlock = message["refreshTimeBlock"]
    end
    if message["accPoint"]~=nil then
        local data =  DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
        if data ~= nil then
            data.accPoint = message["accPoint"]
            DataCenter.AllianceShopDataManager:SetAccPoint(message["accPoint"])
        end
    end
    if message["alliancepoint"]~=nil then
        local data =  DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
        if data ~= nil then
            data.alliancePoint = message["alliancepoint"]
            DataCenter.AllianceShopDataManager:SetAlliancePoint(message["alliancepoint"])
        end
    end
    EventManager:GetInstance():Broadcast(EventId.AllianceScienceDonate)
    EventManager:GetInstance():Broadcast(EventId.UpdateMainAllianceRedCount)
end
function AllianceScienceDataManager:GetCurrentSearchScience()
    local curTime = UITimeManager:GetInstance():GetServerTime()
    for k,v in pairs(self.alScienceList) do
        if v.finishTime>curTime then
            return v
        end
    end
end

function AllianceScienceDataManager:GetAllianceScienceEffectById(effect)
    local effectValue = 0
    if self.alScienceEffectDic[effect] ~= nil then
        effectValue = self.alScienceEffectDic[effect]
    end
    return effectValue
end

--是否有该等级的科技
function AllianceScienceDataManager:HasScienceByIdAndLevel(id, level)
    local temp = self:GetOneAllianceScienceById(id)
    return temp ~= nil and temp.curLevel >= level
end

function AllianceScienceDataManager:GetScienceLevel(id)
    local science = self:GetOneAllianceScienceById(id)
    if science ~= nil then
        return science.curLevel
    end
    return 0
end

return AllianceScienceDataManager