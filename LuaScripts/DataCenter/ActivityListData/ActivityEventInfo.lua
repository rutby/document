---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by guqu.
--- DateTime: 2020/11/5 10:37
---
local ActivityEventInfo = BaseClass("ActivityEventInfo")

local function __init(self)
    self.startTime= 0
    self.endTime =0
    self.activityId =""
    self.actId = ""
    self.actName = ""
    self.type= -1
    self.eventId = ""
    self.getScoreMeth = ""
    self.curScore = 0
    self.isCrossFight = false
    self.canAttackCity = false
    self.crossFight = 0
    self.targetServerId = 0--对手服服务器id
    self.targetAllianceId = ""
    self.hasRewardList = {}
    self.targetReward ={}
    self.rewardScoreIndexArr ={}
    self.cost = {}
    self.weekEndTime = nil
    self.fightStartTime = 0
    self.fightEndTime = 0
    self.desertFightStartTime = 0
    self.desertFightEndTime = 0
    self.rewardScience = nil
    self.rewardScienceList = {}
    self.firstExitAllianceId = nil
    self.heroEventPoint = ""
end

local function __delete(self)
    self.startTime= nil
    self.endTime =nil
    self.activityId =nil
    self.actId = nil
    self.actName = nil
    self.type= nil
    self.eventId = nil
    self.getScoreMeth = nil
    self.curScore = nil
    self.hasRewardList = nil
    self.targetReward =nil
    self.rewardScoreIndexArr =nil
    self.isCrossFight = nil
    self.crossFight = 0
    self.cost = nil
    self.weekEndTime = nil
    self.rewardScience = nil
    self.rewardScienceList = nil
    self.firstExitAllianceId = nil
    self.heroEventPoint = ""
end

local function ParseData(self, message)
    if message==nil then
        return
    end
    if message["st"]~=nil then
        self.startTime = message["st"]
    end
    if message["et"]~=nil then
        self.endTime = message["et"]
    end
    if message["rt"] then
        self.readyTime = message["rt"]
    end
    if message["weekEndTime"] then
        self.weekEndTime = message["weekEndTime"]
    end
    if message["fightStartTime"] then
        self.fightStartTime = message["fightStartTime"]
    end
    if message["fightEndTime"] then
        self.fightEndTime = message["fightEndTime"]
    end
    if message["desertFightEndTime"] then
        self.desertFightEndTime = message["desertFightEndTime"]
    end
    if message["desertFightStartTime"] then
        self.desertFightStartTime = message["desertFightStartTime"]
    end
    if message["isCrossFight"] then
        self.isCrossFight = message["isCrossFight"]
    end
    if message["canAttackCity"] then
        self.canAttackCity = message["canAttackCity"]
    end
    if message["crossFight"] then
        self.crossFight = message["crossFight"]
    end
    if message["actId"]~=nil then
        self.actId = message["actId"]
    end
    if message["actName"]~=nil then
        self.actName = message["actName"]
    end
    if message["activityId"]~=nil then
        self.activityId = message["activityId"]
    end
    if message["t"]~=nil then
        self.type = message["t"]
    end
    if message["eventId"]~=nil then
        self.eventId = message["eventId"]
    end
    if message["value"] ~= nil then
        self.cost = string.split(message["value"],"|")
    end
    if message["score"]~=nil then
        self.getScoreMeth = {}
        local scoreIds = string.split(message["score"],"|")
        self.scoreIdList = scoreIds
        self.scoreIdListNew = {}
        table.walk(scoreIds,function (k,v)
            local oneData ={}
            oneData.name = GetTableData(TableName.Score,v,"name")
            local values = GetTableData(TableName.Score,v,"value")
            oneData.point = GetTableData(TableName.Score,v,"points")
            oneData.pointType = GetTableData(TableName.Score,v,"point_type")
            oneData.paramsList = string.split(values,";")
            oneData.tips = GetTableData(TableName.Score,v,"tips")
            table.insert(self.getScoreMeth,oneData)

            local id = v
            if id  ~= nil then
                local scoreTable = LocalController:instance():getLine("score", id)
                --local scoreTable =  CS.LF.LuaHelper.Table:GetDataRow(CS.LFDefines.TableName.Score, id);
                if scoreTable == nil then
                    return
                end
                local points = scoreTable:getValue("points")
                local tipsArr = scoreTable:getValue("tips")
                local idData = {}
                idData.id = id
                idData.points = points
                idData.tipsArr = tipsArr
                idData.tips = scoreTable:getValue("tips")
                idData.pic = scoreTable:getValue("pic")
                local groupArr = scoreTable:getValue("group")
                idData.group = groupArr
                local groupTab = string.split(groupArr,";")
                if groupArr ~= nil and groupArr ~= "" and #groupTab > 2 then
                    local groupId = groupArr[0]
                    if groupId ~= nil and groupIds[groupId] == nil then
                        groupIds[groupId] = groupId
                        idData.name = groupArr[1]
                        idData.valueStr = groupArr[2]
                        idData.groupId = groupId
                        table.insert(self.scoreIdListNew , idData)
                    end
                else
                    local name = scoreTable:getValue("name")
                    local params = scoreTable:getValue("point")
                    local value = scoreTable:getValue("value")
                    idData.name = name
                    idData.value = value
                    table.insert(self.scoreIdListNew , idData)
                end
            end
        end)
    end
    if message["value"] ~= nil then
        self.value = message["value"]
        self.valueList = string.split(self.value,"|")
    end
    if message["heroevent_point"] then
        self.heroEventPoint = message["heroevent_point"]
    end
    if message["target"] ~= nil then
        self.target = message["target"]
        self.targetList = string.split(self.target,"|")
    end
    if message["value"] ~= nil then
        self.gemPrice = message["value"]
        self.gemPriceList = string.split(self.gemPrice, "|")
    end
    self.currentScore = 0
    if message["userScore"]~=nil then
        local data = message["userScore"]
        if data["score"]~=nil then
            self.curScore = tonumber(data["score"])
        end
        if data["newRewardFlagList"]~=nil then
            self:RefreshNewRewardFlagList(data["newRewardFlagList"])
        end
        if data["newRewardFlagList"] ~= nil and data["newRewardFlagList"] ~= "" then
            self.newRewardFlagStr = data["newRewardFlagList"]
            local arr = string.split(self.newRewardFlagStr, ",")
            self.newRewardFlagList = {}
            for i= 1 , #arr do
                local index = tonumber(arr[i])
                self.newRewardFlagList[index] = index
            end
        end
        if data["score"] ~= nil then
            self.currentScore = data["score"]
        end
        if data["rewardFlagList"] ~= nil and data["rewardFlagList"] ~= "" then
            self.rewardFlagListStr = data["rewardFlagList"]
            local list = string.split(self.rewardFlagListStr , ",")
            self.rewardFlagList = {}
            for i = 1 , #list do
                local ind = tonumber(list[i])
                --同步ind是从0开始，而newRewardFlagList从1开始，调整为一致从1开始
                self.rewardFlagList[ind+1] = ind+1
            end
        end
    end

    if message["target"]~=nil and message["reward"]~=nil then
        self.targetReward = {}
        self.rewardScoreIndexArr ={}
        local targetArr = string.split(message["target"],"|")
        local rewardArr = message["reward"]
        local lastTag = 0
        if table.length(rewardArr) == #targetArr then
            for i = 1,table.length(rewardArr) do
                local tag = tonumber(targetArr[i])
                if self.type and self.type == EnumActivity.AllianceCompete.EventType and tag == lastTag then
                    tag = tag + 1
                end
                lastTag = tag
                local reward = DataCenter.RewardManager:ReturnRewardParamForView(rewardArr[i])
                self.targetReward[tag] = reward
                self.rewardScoreIndexArr[i] = tag
            end
        end
    end

    if message["minDayScore"] then
        self.minDayScore = message["minDayScore"]
    end

    if message["minWeekScore"] then
        self.minWeekScore = message["minWeekScore"]
    end

    if message["vsAllianceInfo"] ~= nil then
        self.vsAllianceInfo = message["vsAllianceInfo"]
        if self.vsAllianceInfo ~= nil then
            self.vsAllianceList = {}
            table.walk(self.vsAllianceInfo,function(k,v)
                -- printInfo("联盟对决，联盟名字="..v["alName"])
                local allianceId = v["allianceId"]
                if allianceId == nil then
                    -- logErrorWithTag("AllianceBattleAct", "数据已错误，服务器未同步到联盟对决vsAllianceInfo完整数据,忽略或换个号或者找后端修改数据")
                    Logger.LogError("数据已错误，服务器未同步到联盟对决vsAllianceInfo完整数据,忽略或换个号或者找后端修改数据")
                else
                    local myAlId = LuaEntry.Player.allianceId
                    self.vsAllianceList[allianceId] = {}
                    self.vsAllianceList[allianceId].id = allianceId
                    self.vsAllianceList[allianceId].alName = v["alName"]
                    self.vsAllianceList[allianceId].abbr = v["abbr"]
                    self.vsAllianceList[allianceId].icon = v["icon"]
                    self.vsAllianceList[allianceId].alScore = v["alScore"]
                    self.vsAllianceList[allianceId].win = v["win"]
                    self.vsAllianceList[allianceId].winScore = v["winScore"]
                    self.vsAllianceList[allianceId].serverId = v["serverId"]
                    if myAlId~=allianceId then
                        self.targetServerId = v["serverId"]
                        self.targetAllianceId = allianceId
                    end
                    if v["mvpPlayer"] ~= nil then
                        self.mvpPlayer = v["mvpPlayer"]
                        -- printInfo("联盟对决，mvp名字=aaaaaa123="..self.mvpPlayer["name"])
                        self.vsAllianceList[allianceId].mvpPlayer = {}
                        self.vsAllianceList[allianceId].mvpPlayer.uid = self.mvpPlayer["uid"]
                        self.vsAllianceList[allianceId].mvpPlayer.pic = self.mvpPlayer["pic"]
                        self.vsAllianceList[allianceId].mvpPlayer.picVer = self.mvpPlayer["picVer"]
                        self.vsAllianceList[allianceId].mvpPlayer.monthCardEndTime = self.mvpPlayer["monthCardEndTime"]
                        self.vsAllianceList[allianceId].mvpPlayer.headSkinId = self.mvpPlayer["headSkinId"]
                        self.vsAllianceList[allianceId].mvpPlayer.headSkinET = self.mvpPlayer["headSkinET"]

                        self.vsAllianceList[allianceId].mvpPlayer.GetHeadBgImg = function(self)
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
                        self.vsAllianceList[allianceId].mvpPlayer.name = self.mvpPlayer["name"]
                    end
                end
            end)
        end
    end

    if message["winReward"] ~= nil then
        self.winReward = message["winReward"]
        if self.winReward then--把钻石放到第一个
            local cacheReward = nil
            for i, v in ipairs(self.winReward) do
                if v.type == RewardType.GOLD then
                    cacheReward = v
                    table.remove(self.winReward, i)
                    break
                end
            end
            if cacheReward then
                table.insert(self.winReward, 1, cacheReward)
            end
        end
    end
    if message["winWeekReward"] ~= nil then
        self.winWeekReward = message["winWeekReward"]
        if self.winWeekReward then--把钻石放到第一个
            local cacheReward = nil
            for i, v in ipairs(self.winWeekReward) do
                if v.type == RewardType.GOLD then
                    cacheReward = v
                    table.remove(self.winWeekReward, i)
                    break
                end
            end
            if cacheReward then
                table.insert(self.winWeekReward, 1, cacheReward)
            end
        end
    end
    if message["minDayScore"] ~= nil then
        self.minDayScore = message["minDayScore"]
    end
    if message["minWeekScore"] ~= nil then
        self.minWeekScore = message["minWeekScore"]
    end
    if message["reward_science"]  then
        self.rewardScience = message["reward_science"]
        self.rewardScienceList = {}
        if not string.IsNullOrEmpty(self.rewardScience) then
            local rewardScienceArr = string.split(self.rewardScience, "@")
            for i, v in ipairs(rewardScienceArr) do
                local scienceList = {}
                local scienceArr = string.split(v, "|")
                for m, n in ipairs(scienceArr) do
                    local science_Dialog = string.split(n, ";")
                    if #science_Dialog == 2 then
                        local newTb = {}
                        newTb.scienceId = science_Dialog[1]
                        newTb.dialogId = science_Dialog[2]
                        table.insert(scienceList, newTb)
                    end
                end
                table.insert(self.rewardScienceList, scienceList)
            end
        end
    end
    if message["firstExitAllianceId"] then
        self.firstExitAllianceId = message["firstExitAllianceId"]
    end
end

local function RefreshNewRewardFlagList(self,str)
    self.hasRewardList = string.split(str,",")
end

local function GetStateByScoreIndex(self,scoreIndex)
    local state = TaskState.NoComplete
    if self.curScore >= scoreIndex then
        state = TaskState.CanReceive
    end
    local index = 0
    table.walk(self.rewardScoreIndexArr,function (k,v)
        if scoreIndex == v then
            index =k
        end
    end)
    table.walk(self.hasRewardList,function (k,v)
        if tonumber(v)==index then
            state = TaskState.Received
        end
    end)
    return state
end

local function GetCanReceiveCount(self)
    local count = 0
    local maxUnlockIndex = IntMaxValue
    if self.type == EnumActivity.AllianceCompete.EventType then
        --local useNum = LuaEntry.Effect:GetGameEffect(EffectDefine.APS_ALLIANCE_ARMS_USE_NUM)
        --maxUnlockIndex = (useNum + 1) * 3

        local unlockNum = 3
        if LuaEntry.Effect:GetGameEffect(EffectDefine.APS_ALCOMPETE_ACT_UNLOCK_BOX_3) == 1 then
            unlockNum = 9
        elseif LuaEntry.Effect:GetGameEffect(EffectDefine.APS_ALCOMPETE_ACT_UNLOCK_BOX_2) == 1 then
            unlockNum = 6
        end
        maxUnlockIndex = unlockNum
    end
    table.walk(self.rewardScoreIndexArr,function (k,v)
        if k <= maxUnlockIndex and self:GetStateByScoreIndex(v) == TaskState.CanReceive then
            count =count+1
        end
    end)
    return count
end

local function CheckIfShowCrossServer(self)
    return (self.fightStartTime~=nil and self.fightStartTime>0 and self.vsAllianceList ~= nil and table.count(self.vsAllianceList) > 1), self.fightStartTime, self.fightEndTime
end

local function CheckIfShowCrossDesert(self)
    return (self.desertFightStartTime~=nil and self.desertFightStartTime>0 and self.vsAllianceList ~= nil and table.count(self.vsAllianceList) > 1), self.desertFightStartTime, self.desertFightEndTime
end
local function GetRewardScience(self, boxIndex)
    if not self.rewardScienceList or #self.rewardScienceList < boxIndex then
        return nil
    end
    local scienceList = self.rewardScienceList[boxIndex]
    for i, v in ipairs(scienceList) do
        local curLevel = DataCenter.ScienceManager:GetScienceLevel(tonumber(v.scienceId))
        local maxLevel = DataCenter.ScienceManager:GetScienceMaxLevel(tonumber(v.scienceId))
        if curLevel < maxLevel then
            return v
        end
    end
    return nil
end

ActivityEventInfo.__init = __init
ActivityEventInfo.__delete = __delete
ActivityEventInfo.ParseData = ParseData
ActivityEventInfo.RefreshNewRewardFlagList = RefreshNewRewardFlagList
ActivityEventInfo.GetStateByScoreIndex = GetStateByScoreIndex
ActivityEventInfo.GetCanReceiveCount = GetCanReceiveCount
ActivityEventInfo.CheckIfShowCrossServer = CheckIfShowCrossServer
ActivityEventInfo.GetRewardScience = GetRewardScience
ActivityEventInfo.CheckIfShowCrossDesert = CheckIfShowCrossDesert
return ActivityEventInfo