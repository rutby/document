---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2020/11/5 14:32
---
local MineCaveManager = BaseClass("MineCaveManager");
local MineCaveData = require "DataCenter.ActivityListData.MineCaveData"
local MineCaveTemplate = require "DataCenter.ActivityListData.MineCaveTemplate"
local Localization = CS.GameEntry.Localization

local function __init(self)
    self.mineCaveInfo = nil
    self.mineCaveConf = nil
    self.refreshCost = nil
    self.attackMineIndex = nil
    self.dispatchFormationUid = nil
    self.plunderList = {}
    self.cachePveEnemyPower = 0
    self.toUnlockMinesInfo = nil
    self.cacheBattleMineInfo = nil
    self.cacheWinReward = nil
    self.cacheRewardMineInfo = nil
    self:AddListener()
end

local function __delete(self)
    self:RemoveListener()
    self.mineCaveInfo = nil
    self.mineCaveConf = nil
    self.refreshCost = nil
    self.attackMineIndex = nil
    self.dispatchFormationUid = nil
    self.plunderList = nil
    self.cachePveEnemyPower = nil
    self.toUnlockMinesInfo = nil
    self.cacheBattleMineInfo = nil
    self.cacheWinReward = nil
    self.cacheRewardMineInfo = nil
end

local function AddListener(self)
    EventManager:GetInstance():AddListener(EventId.OnPassDay, self.TryReqUpdateMineCaveInfo)
end

local function RemoveListener(self)
    EventManager:GetInstance():RemoveListener(EventId.OnPassDay, self.TryReqUpdateMineCaveInfo)
end

local function TryReqUpdateMineCaveInfo(self)
    SFSNetwork.SendMessage(MsgDefines.GetMineCaveInfo)
end

local function UpdateMineCaveInfo(self, message)
    if not self.mineCaveInfo then
        self.mineCaveInfo = MineCaveData.New()
    end
    self.mineCaveInfo:ParseData(message)
    self:UpdateToUnlockList()
    EventManager:GetInstance():Broadcast(EventId.UpdateMineCaveInfo)
    EventManager:GetInstance():Broadcast(EventId.RefreshActivityRedDot)
end

local function GetMineCaveInfo(self)
    return self.mineCaveInfo
end

local function CheckActMineIsShow(self)
    local isShowActMine = false
    local actData = nil
    local dataList = DataCenter.ActivityListDataManager:GetActivityDataByType(ActivityEnum.ActivityType.ActMineCave)
    if table.count(dataList) > 0 then
        actData = dataList[1]
    end
    --活动开启的话当前显示矿只显示各类型最高等级的矿
    if actData then
        local curTime = UITimeManager:GetInstance():GetServerTime()
        if actData.startTime < curTime and curTime < actData.endTime then
            isShowActMine = true
        end
    end
    return isShowActMine
end

--当前矿
local function GetPreviewList(self, tempScore)
    if not self.mineCaveConf then
        self:InitConf()
    end
    --检查活动
    local isShowActMine = self:CheckActMineIsShow()
    local retList = {}
    local list = {}
    local seasonId = DataCenter.SeasonDataManager:GetSeasonId()
    for i, v in ipairs(self.mineCaveConf) do
        if v.caveShow[1] <= tempScore and tempScore <= v.caveShow[2] then
            if v.func and v.func == 1 then
                local canPreview = LuaEntry.Effect:GetGameEffect(EffectDefine.MINE_CAVE_CAN_PREVIEW)
                if canPreview == 1 then
                    if v.season_show and v.season_show ~= "" then
                        if v.season_show[1] <= seasonId and seasonId <= v.season_show[2] then
                            if v.rewardType == RewardType.FLINT or v.rewardType == RewardType.OIL then
                                if isShowActMine then
                                    table.insert(list,v)
                                end
                            else
                                table.insert(list,v)
                            end
                        end
                    else
                        if v.rewardType == RewardType.FLINT or v.rewardType == RewardType.OIL then
                            if isShowActMine then
                                table.insert(list,v)
                            end
                        else
                            table.insert(list,v)
                        end
                    end
                end
            else
                if v.season_show and v.season_show ~= "" then
                    if v.season_show[1] <= seasonId and seasonId <= v.season_show[2] then
                        if v.rewardType == RewardType.FLINT or v.rewardType == RewardType.OIL then
                            if isShowActMine then
                                table.insert(list,v)
                            end
                        else
                            table.insert(list,v)
                        end
                    end
                else
                    if v.rewardType == RewardType.FLINT or v.rewardType == RewardType.OIL then
                        if isShowActMine then
                            table.insert(retList,v)
                        end
                    else
                        table.insert(retList,v)
                    end
                end
            end
        end
    end
    table.sort(list,function(a,b)
        if a.id < b.id then
            return true
        end
        return false
    end)
    local merge =  table.mergeArray(retList,list)
    if isShowActMine then
        --只取最高等级
        local mineList = {}
        for i = 1 ,table.count(merge) do
            if mineList[merge[i].type] then
                if mineList[merge[i].type].level < merge[i].level then
                    mineList[merge[i].type] = merge[i]
                end
            else
                mineList[merge[i].type] = merge[i]
            end
        end
        local array = {}
        for i ,v in pairs(mineList) do
            table.insert(array,v)
        end
        table.sort(array,function(a,b)
            if a.id < b.id then
                return true
            end
            return false
        end)
        return array
    end
    table.sort(merge, function(a,b)
        if a.level > b.level then
            return true
        elseif a.level < b.level then
            return false
        else
            if a.id < b.id then
                return true
            end
        end
        return false
    end)
    return merge
end

local function GetToUnlockMinesInfo(self)
    return self.toUnlockMinesInfo
end

--未解锁的矿
local function UpdateToUnlockList(self, forceUpdate)
    if not self.mineCaveInfo then
        return
    end

    if self.toUnlockMinesInfo and not forceUpdate then
        return
    end
    
    self.toUnlockMinesInfo = {
        score = 0,
        minesConfList = {},
    }

    --检查活动
    local isShowActMine = self:CheckActMineIsShow()
    
    local toUnlockConf = LuaEntry.DataConfig:TryGetStr("mine_cave", "k7")
    local toUnlockArr = string.split(toUnlockConf, "|")
    local curToUnlockArr = nil
    for i, v in ipairs(toUnlockArr) do
        local tempConf = string.split(v, ";")
        if #tempConf >= 2 then
            local showScore = tonumber(tempConf[1])
            if self.mineCaveInfo.curScore < showScore then
                curToUnlockArr = tempConf
                break
            end
        end
    end
    
    if curToUnlockArr then
        local seasonId = DataCenter.SeasonDataManager:GetSeasonId()
        self.toUnlockMinesInfo.score = tonumber(curToUnlockArr[1])
        self.toUnlockMinesInfo.minesConfList = {}
        for i = 2, #curToUnlockArr do
            local mineConf = self:GetMineConf(tonumber(curToUnlockArr[i]))
            if mineConf then
                if mineConf.season_show and mineConf.season_show ~= "" then
                    if mineConf.season_show[1] <= seasonId and seasonId <= mineConf.season_show[2] then
                        if mineConf.rewardType == RewardType.FLINT or mineConf.rewardType == RewardType.OIL then
                            if isShowActMine then
                                table.insert(self.toUnlockMinesInfo.minesConfList,mineConf)
                            end
                        else
                            table.insert(self.toUnlockMinesInfo.minesConfList,mineConf)
                        end
                    end
                else
                    if mineConf.rewardType == RewardType.FLINT or mineConf.rewardType == RewardType.OIL then
                        if isShowActMine then
                            table.insert(self.toUnlockMinesInfo.minesConfList,mineConf)
                        end
                    else
                        table.insert(self.toUnlockMinesInfo.minesConfList,mineConf)
                    end
                end
            end
        end
    end
    if isShowActMine then
        --只取最高等级
        local mineList = {}
        local merge = self.toUnlockMinesInfo.minesConfList
        for i = 1 ,table.count(merge) do
            if mineList[merge[i].type] then
                if mineList[merge[i].type].level < merge[i].level then
                    mineList[merge[i].type] = merge[i]
                end
            else
                mineList[merge[i].type] = merge[i]
            end
        end
        local array = {}
        for i ,v in pairs(mineList) do
            table.insert(array,v)
        end
        table.sort(array,function(a,b)
            if a.id < b.id then
                return true
            end
            return false
        end)
        self.toUnlockMinesInfo.minesConfList = {}
        self.toUnlockMinesInfo.minesConfList = array
    end
end

local function GetMyScore(self)
    local retScore = 0
    if self.mineCaveInfo then
        retScore = self.mineCaveInfo.curScore
    end
    return retScore
end

local function GetMineConf(self, mineId)
    if not self.mineCaveConf or not next(self.mineCaveConf) then
        self:InitConf()
    end
    for i, v in ipairs(self.mineCaveConf) do
        if v.id == mineId then
            return v
        end
    end
end

--uuid
local function GetMyCaveInfo(self, uuid)
    if not self.mineCaveInfo then
        return
    end
    return self.mineCaveInfo:GetMyMineInfo(uuid)
end

--index
local function GetMineInfo(self, index)
    if not self.mineCaveInfo then
        return
    end
    return self.mineCaveInfo:GetMineInfo(index)
end

local function InitConf(self)
    self.mineCaveConf = {}
    LocalController:instance():visitTable(TableName.MineCave,function(id,lineData)
        local item = MineCaveTemplate.New()
        item:InitData(lineData)
        table.insert(self.mineCaveConf,item)
    end)
end

local function CheckIfCanRefresh(self)
    local k4 = LuaEntry.DataConfig:TryGetNum("mine_cave", "k4")
    if self.mineCaveInfo and self.mineCaveInfo.refreshNum < k4 then
        return true
    else
        return false
    end
end

local function GetRefreshCost(self)
    if not self.refreshCost then
        self:InitRefreshCost()
    end
    local nextIndex = self.mineCaveInfo.refreshNum + 1
    for i, v in ipairs(self.refreshCost) do
        if v[1] <= nextIndex and nextIndex <= v[2] then
            return v[3], v[2]
        end
    end
    return self.refreshCost[#self.refreshCost][3]
end

local function InitRefreshCost(self)
    local k5 = LuaEntry.DataConfig:TryGetStr("mine_cave", "k5")
    
    --test
    if string.IsNullOrEmpty(k5) then
        k5 = "0;100;1"
    end
    
    local strCostArr = string.split(k5, "|")
    self.refreshCost = {}
    for i, v in ipairs(strCostArr) do
        local temp = string.split(v, ";")
        local cost = {}
        table.insert(cost, tonumber(temp[1]))
        table.insert(cost, tonumber(temp[2]))
        table.insert(cost, tonumber(temp[3]))
        table.insert(self.refreshCost, cost)
    end
end

local function ResetMineInfo(self, mineId)
    if not self.mineCaveInfo then
        return
    end
    self.mineCaveInfo:ResetMineInfo(mineId)
    
end

local function GetBattleParam(self)
    local formationUuid = self.dispatchFormationUid
    --local busyFormations = self.mineCaveInfo:GetBusyFormations()
    --local formationIds = DataCenter.ArmyFormationDataManager:GetArmyFormationIdList()
    --for i, v in ipairs(formationIds) do
    --    if not table.hasvalue(busyFormations, v) then
    --        formationUuid = v
    --        break
    --    end
    --end
    return self.attackMineIndex, formationUuid, self.attackMonsterId
end

local function SetAttackMineIndex(self, tempIndex, monsterId)
    self.attackMineIndex = tempIndex
    self.attackMonsterId = monsterId
end

local function SetDispatchFormation(self, formationUid)
    self.dispatchFormationUid = formationUid
end

local function CheckIfHeroIsBusy(self, heroId)
    if not self.mineCaveInfo or not self.mineCaveInfo.myMinesList then
        return false
    end
    for i, v in ipairs(self.mineCaveInfo.myMinesList) do
        for _, m in ipairs(v.heros) do
            if m.heroId == heroId then
                return true
            end
        end
    end
end

local function CheckIfCanAttack(self)
    if not self.mineCaveInfo then
        return false, 0
    end

    local curTime = UITimeManager:GetInstance():GetServerSeconds()
    local lastTime = self.mineCaveInfo.lastRefreshTime // 1000
    if not UITimeManager:GetInstance():IsSameDayForServer(lastTime,curTime) then
        local formationIds = DataCenter.ArmyFormationDataManager:GetArmyFormationIdList()
        return true, #formationIds
    end
    
    local tempTimes = self.mineCaveInfo.fightNum
    local addNum = LuaEntry.Effect:GetGameEffect(EffectDefine.REFRESH_MINE_CAVE_REFRESH_TIME_ADD)
    local maxTimes = LuaEntry.DataConfig:TryGetNum("mine_cave", "k3")
    if tempTimes >= maxTimes+addNum then
        return false, 0
    end
    local remainTimes = maxTimes+addNum - tempTimes

    local busyFormations = self.mineCaveInfo:GetBusyFormations()
    local formationNum = 0
    local list = DataCenter.ArmyFormationDataManager:GetArmyFormationIdList()
    if list~=nil and #list>0 then
        for i =1,#list do
            local showUnLock = true
            local formationInfo = DataCenter.ArmyFormationDataManager:GetOneArmyInfoByUuid(list[i])
            local index = i
            if formationInfo~=nil then
                index = formationInfo.index
                if index == 4 then
                    local hasMonthCard = DataCenter.MonthCardNewManager:CheckIfMonthCardActive()
                    if hasMonthCard == false then
                        if formationInfo then
                            local march = DataCenter.WorldMarchDataManager:GetOwnerFormationMarch(LuaEntry.Player.uid, formationInfo.uuid, LuaEntry.Player.allianceId)
                            if march ==nil then
                                showUnLock = false
                            end
                        else
                            showUnLock = false
                        end
                    end
                end
            else
                showUnLock = false
            end
            if showUnLock == true then
                formationNum = formationNum+1
            end
        end
    end
    if #busyFormations >= formationNum then
        return false, 0
    end
    local freeFormationCount = formationNum - #busyFormations
    local freeNum = math.min(remainTimes, freeFormationCount)
    return true, freeNum
end

local function CheckIfHasReward(self)
    if not self.mineCaveInfo then
        return false, 0
    end

    local num = 0
    local serverT = UITimeManager:GetInstance():GetServerTime()
    for i, v in ipairs(self.mineCaveInfo.myMinesList) do
        if v.endTime <= serverT and not v.rewarded then
            num = num + 1
        end
    end
    return num > 0, num
end

local function GetRedCount(self)
    local totalNum = 0
    local canAttack, redCount = self:CheckIfCanAttack()
    local canClaim, claimCount = self:CheckIfHasReward()
    local hasNewLog = self:CheckIfHasPlunderRed()
    if self.hasVisit then
        
    elseif canAttack and redCount>0 then
        totalNum = totalNum + 1
    end
    if canClaim then
        totalNum = totalNum + claimCount
    end
    if hasNewLog then
        totalNum = totalNum + 1
    end
    return totalNum
end

local function SetHasVisit(self,value)
    self.hasVisit = value
    EventManager:GetInstance():Broadcast(EventId.RefreshActivityRedDot)
end  
local function CheckIfIsAllComplete(self)
    if not self.mineCaveInfo then
        return false
    end
    
    local tempTimes = self.mineCaveInfo.fightNum
    local addNum = LuaEntry.Effect:GetGameEffect(EffectDefine.REFRESH_MINE_CAVE_REFRESH_TIME_ADD)
    local maxTimes = LuaEntry.DataConfig:TryGetNum("mine_cave", "k3")
    if tempTimes < maxTimes+addNum then
        return false
    end
    
    local serverT = UITimeManager:GetInstance():GetServerTime()
    for i, v in ipairs(self.mineCaveInfo.myMinesList) do
        if (v.endTime <= serverT and not v.rewarded) or v.endTime > serverT then
            return false
        end
    end
    
    return true
end

local function CheckIfHasPlunderRed(self)
    local strKey = "GetPlunderLogTime_" .. LuaEntry.Player.uid
    local lastTime = CS.GameEntry.Setting:GetString(strKey, "0")
    local lastT = tonumber(lastTime)
    for i, v in pairs(self.plunderList) do
        if v.time > lastT and (v.plunderType == MineCavePlunderType.DefenseFail or v.plunderType == MineCavePlunderType.DefenseWin) then
            return true
        end
    end
end

local function ResetGetPlunderLogTime()
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local strKey = "GetPlunderLogTime_" .. LuaEntry.Player.uid
    CS.GameEntry.Setting:SetString(strKey, tostring(curTime))

    EventManager:GetInstance():Broadcast(EventId.RefreshActivityRedDot)
end

local function UpdatePlunderList(self, msg)
    self.plunderList = {}
    if msg.records then
        for i, v in pairs(msg.records) do
            self:AddOneNewPlunderLog(v, false)
        end
        table.sort(self.plunderList, function(a, b)
            return a.time > b.time
        end)
        EventManager:GetInstance():Broadcast(EventId.OnRecvMineCavePlunderLog)
    end
end

local function OnRecvNewPlunderLog(self, msg)
    if msg.newRecord then
        self:AddOneNewPlunderLog(msg.newRecord, true)
    end
end

local function AddOneNewPlunderLog(self, tb, needBroadcast)
    needBroadcast = needBroadcast or true
    local newLog = {}
    newLog.uuid = tb.uuid
    newLog.playerUid = tb.playerUid
    newLog.playerName = tb.playerName
    newLog.playerAlAbbr = tb.playerAlAbbr
    newLog.plunderType = tb.type--1,防守失败；2，防守成功；3，进攻胜利；4，进攻失败
    newLog.time = tb.time
    newLog.playerPic = tb.playerPic
    newLog.playerPicVer = tb.playerPicVer
    newLog.monthCardEndTime = tb.playerMonthCardEndTime
    newLog.headSkinId = tb.headSkinId
    newLog.headSkinET = tb.headSkinET

    newLog.GetHeadBgImg = function(self)
        --local headBgImg = nil
        local serverTimeS = UITimeManager:GetInstance():GetServerSeconds()
        --if self.monthCardEndTime and self.monthCardEndTime > serverTimeS then
        --    headBgImg = "Common_playerbg_golloes"
        --end
        --if headBgImg and headBgImg ~= "" then
        --    return string.format(LoadPath.CommonNewPath,headBgImg)
        --end
        local headBgImg = DataCenter.DecorationDataManager:GetHeadFrame(self.headSkinId, self.headSkinET, self.monthCardEndTime and self.monthCardEndTime > serverTimeS)
        return headBgImg
    end
    if tb.type == 1 or tb.type == 3 then
        newLog.rewardType = tb.params.rewardType
        newLog.itemId = tb.params.itemId
        newLog.rewardNum = tb.params.plunderRewardNum
    end
    table.insert(self.plunderList, 1, newLog)
    if needBroadcast then
        EventManager:GetInstance():Broadcast(EventId.OnRecvMineCavePlunderLog)
    end
end

local function GetPlunderList(self)
    return self.plunderList
end

local function GetEnemyPlayerPower(self)
    return self.cachePveEnemyHeroPower
end

local function CheckIfEnemyIsPlayer(self)
    return self.cachePveEnemyHeroPower
end

local function SetEnemyPlayerPower(self, power)
    if string.IsNullOrEmpty(power) then
        self.cachePveEnemyHeroPower = nil
        return
    end
    self.cachePveEnemyHeroPower = {}
    if not string.IsNullOrEmpty(power) then
        local heroArr = string.split(power, "|")
        for i, v in ipairs(heroArr) do
            local powerArr = string.split(v, ";")
            if #powerArr == 2 then
                self.cachePveEnemyHeroPower[powerArr[1]] = tonumber(powerArr[2])
            end
        end
    end
end

local function CacheRewards(self, reward)
    self.cacheWinReward = reward
end

local function CacheBattleMineInfo(self, mineInfo)
    self.cacheBattleMineInfo = mineInfo
end

local function CacheRewardMineInfo(self, mineInfo)
    self.cacheRewardMineInfo = mineInfo
end

local function ShowMineRewards(self, t)
    if self.cacheRewardMineInfo and self.cacheRewardMineInfo.rewardState == 1 then
        local strTip = ""
        local template = self:GetMineConf(self.cacheRewardMineInfo.mineId)
        if template then
            strTip = Localization:GetString("302402", (100 - template.plunder))
        end
        self.cacheBattleMineInfo = nil
        DataCenter.RewardManager:ShowMineCaveRewards(t, Localization:GetString("311110"), strTip, GetRewardTitleType.BattleFail)
    else
        DataCenter.RewardManager:ShowCommonReward(t)
    end
end

local function TryShowReward(self)
    if self.cacheWinReward then
        for k,v in pairs(self.cacheWinReward) do
            DataCenter.RewardManager:AddOneReward(v)
        end
        
        local strTip = ""
        if self.cacheBattleMineInfo and not string.IsNullOrEmpty(self.cacheBattleMineInfo.ownerUid) then
            local pName = ""
            if string.IsNullOrEmpty(self.cacheBattleMineInfo.allianceAbbr) then
                pName = self.cacheBattleMineInfo.ownerName
            else
                pName = "[" .. self.cacheBattleMineInfo.allianceAbbr .. "]" .. self.cacheBattleMineInfo.ownerName
            end
            local template = self:GetMineConf(self.cacheBattleMineInfo.mineId)
            if template then
                strTip = Localization:GetString("302401", template.plunder)
            end
            self.cacheBattleMineInfo = nil
        end
        
        local msg = {}
        msg.reward = self.cacheWinReward
        DataCenter.RewardManager:ShowMineCaveRewards(msg, nil, strTip, GetRewardTitleType.Common)
        
        self.cacheWinReward = nil
    end
end

local function CacheTargetMineInfo(self, mineInfo)
    self.cacheTargetMineInfo = mineInfo
end

local function CheckIfNeedPreloadEnemy(self)
    if not self.cacheTargetMineInfo or string.IsNullOrEmpty(self.cacheTargetMineInfo.ownerUid) then
        return true
    else
        return false
    end
end

MineCaveManager.__init = __init
MineCaveManager.__delete = __delete
MineCaveManager.UpdateMineCaveInfo = UpdateMineCaveInfo
MineCaveManager.GetMineCaveInfo = GetMineCaveInfo
MineCaveManager.CheckActMineIsShow = CheckActMineIsShow
MineCaveManager.GetPreviewList = GetPreviewList
MineCaveManager.InitConf = InitConf
MineCaveManager.CheckIfCanRefresh = CheckIfCanRefresh
MineCaveManager.GetRefreshCost = GetRefreshCost
MineCaveManager.InitRefreshCost = InitRefreshCost
MineCaveManager.GetMineConf = GetMineConf
MineCaveManager.GetMyCaveInfo = GetMyCaveInfo
MineCaveManager.GetMineInfo = GetMineInfo
MineCaveManager.ResetMineInfo = ResetMineInfo
MineCaveManager.GetBattleParam = GetBattleParam
MineCaveManager.SetAttackMineIndex = SetAttackMineIndex
MineCaveManager.CheckIfHeroIsBusy = CheckIfHeroIsBusy
MineCaveManager.CheckIfCanAttack = CheckIfCanAttack
MineCaveManager.GetRedCount = GetRedCount
MineCaveManager.CheckIfHasReward = CheckIfHasReward
MineCaveManager.UpdatePlunderList = UpdatePlunderList
MineCaveManager.OnRecvNewPlunderLog = OnRecvNewPlunderLog
MineCaveManager.AddOneNewPlunderLog = AddOneNewPlunderLog
MineCaveManager.GetPlunderList = GetPlunderList
MineCaveManager.GetEnemyPlayerPower = GetEnemyPlayerPower
MineCaveManager.SetEnemyPlayerPower = SetEnemyPlayerPower
MineCaveManager.CheckIfHasPlunderRed = CheckIfHasPlunderRed
MineCaveManager.CheckIfIsAllComplete = CheckIfIsAllComplete
MineCaveManager.ResetGetPlunderLogTime = ResetGetPlunderLogTime
MineCaveManager.CheckIfEnemyIsPlayer = CheckIfEnemyIsPlayer
MineCaveManager.CacheRewards = CacheRewards
MineCaveManager.CacheBattleMineInfo = CacheBattleMineInfo
MineCaveManager.CacheRewardMineInfo = CacheRewardMineInfo
MineCaveManager.TryShowReward = TryShowReward
MineCaveManager.ShowMineRewards = ShowMineRewards
MineCaveManager.AddListener = AddListener
MineCaveManager.RemoveListener = RemoveListener
MineCaveManager.TryReqUpdateMineCaveInfo = TryReqUpdateMineCaveInfo
MineCaveManager.SetDispatchFormation = SetDispatchFormation
MineCaveManager.CacheTargetMineInfo = CacheTargetMineInfo
MineCaveManager.CheckIfNeedPreloadEnemy = CheckIfNeedPreloadEnemy
MineCaveManager.GetToUnlockMinesInfo = GetToUnlockMinesInfo
MineCaveManager.UpdateToUnlockList = UpdateToUnlockList
MineCaveManager.GetMyScore = GetMyScore
MineCaveManager.SetHasVisit = SetHasVisit
return MineCaveManager