local ActivityDonateSoldierManager = BaseClass("ActivityDonateSoldierManager")

local function __init(self)
    self.stageArr = {} -- arr 贡献奖励信息
    self.soldierScoreArr = {} -- arr捐兵对应积分
    self.taskInfo = {} -- obj 捐兵任务信息
    self.expeditionOpenTime = 0 -- 远征开启时间
    self.scoreList = {} -- arr 玩家积分排行数据
    self.scoreInfo = {} -- obj 积分数据
    self.useItemId = "" -- 消耗道具的id
    self.battleInfo = {}
    self:AddListener()
end

local function __delete(self)
    self.stageArr = nil
    self.soldierScoreArr = nil
    self.taskInfo = nil
    self.expeditionOpenTime = nil
    self.scoreList = nil
    self.scoreInfo = nil
    self.useItemId = nil
    self.battleInfo = nil
    self:RemoveListener()
end

local function AddListener(self)
end

local function RemoveListener(self)
end

local function OnHandleGetDonateArmyActivityInfoMessage(self, sfsData)
    --[[
		"stageArr"              //sfs arr 贡献奖励信息
		[
			"id"				//int
			"normalReward"      //sfs arr 初级奖励
			[]
			"specialReward"		//sfs arr 精英奖励
			[]
			"normalState"		//int 初级奖励领取状态 0未领取 1已领取
			"specialState"		//int 精英奖励领取状态 0未领取 1已领取
			"needAllianceScore" 	//long 领奖需要的联盟积分
			"needUserScore" 		//long 领奖需要的个人积分
			"goodsId"			//string 解锁精英奖励需要的道具id
			"goodsNum"			//int 需要的道具数量
		]
    ]]
    self.stageArr = sfsData["stageArr"]
    if self.stageArr ~= nil and #self.stageArr > 0 then
        self.useItemId = self.stageArr[1].goodsId
    
        table.sort(self.stageArr, function(stageA, stageB)
            return stageA.id < stageB.id
        end)
    end
    
    --[[
		"soldierScoreArr"       //sfs arr 捐兵对应积分
		[
            "armyId"            //string 兵种id
            "score"             //int 一个兵加的分
		]
    ]]
    if sfsData['soldierScoreArr'] ~= nil then
        self.soldierScoreArr = sfsData['soldierScoreArr']
    end
    --[[
		"taskInfo"				//sfs obj 捐兵任务信息
		{
			"taskId"			//int 任务id  当前没任务不下发该字段
			"num"				//int 任务进度 当前没任务不下发该字段
			"state"				//int 任务状态 0未完成 1完成未领奖 2已领奖 当前没任务不下发该字段
			"reward"            //sfs arr 任务奖励 当前没任务不下发该字段
			"maxTaskNum"		//int 最多累计任务数量
			"taskNum"           //int 当前剩余任务数量
			"nextRecoverTime"   //long 下次任务恢复时间 单位ms  当任务满时该字段值为0 
		}
    ]]
    if sfsData['taskInfo'] ~= nil then
        self.taskInfo = sfsData['taskInfo']
    end


    if sfsData['expeditionOpenTime'] ~= nil then
        self.expeditionOpenTime = sfsData['expeditionOpenTime']
    end

    -- 发送消息更新界面
    EventManager:GetInstance():Broadcast(EventId.GetDonateArmyActivityInfo)
end

local function OnGetRewardStageArr(self)
    return self.stageArr
end

local function OnGetOneScoreBySoldierId(self, armyId)
    for _, v in pairs(self.soldierScoreArr) do
        if v["armyId"] == armyId then
            return v["score"]
        end
    end

    return 0
end

-- 当前任务数据
local function GetCurrentTaskInfo(self)
    return self.taskInfo
end

-- 获取捐兵排行榜信息请求返回处理
local function OnHandleGetDonateArmyScoreInfoMessage(self, sfsData)
    --[[
		"rankArr"  			//sfs arr 玩家积分排行数据
		[
			"uid"
			"score"    			//long 积分
			"name"
			"pic"
			"picVer"	
			"headSkinId"
			"headSkinET"	
			"serverId" 			//int 玩家所属服
			"allianceId"        //string 联盟id
		]
    ]]
    if sfsData["rankArr"] ~= nil then
        self.scoreList = sfsData["rankArr"]
        table.sort(self.scoreList, function(scoreA, scoreB)
            return scoreA.score > scoreB.score
        end)
    end
    --[[
		"scoreInfo"				// sfs obj 积分数据    
		{
			"selfScore" 		  //long 自己的积分
			"selfAllianceScore"   //long 己方联盟积分
			"vsAllianceScore"     //long 敌方联盟积分
		}
    ]]
    if sfsData["scoreInfo"] ~= nil then
        self.scoreInfo = sfsData["scoreInfo"]
    end

    local findSelf = false
    if self.scoreList == nil then
        self.scoreList = {}
    end

    for _, v in ipairs(self.scoreList) do
        if v.uid == LuaEntry.Player.uid then
            findSelf = true
            v.score = self.scoreInfo.selfScore
            break
        end
    end

    if findSelf == false and self.scoreInfo ~= nil and self.scoreInfo.selfScore ~= nil and self.scoreInfo.selfScore > 0 then
        -- 如果自己的数据没在排行榜里（通常出现在第一次捐献时） 做一个自己的数据放在列表里面
        local playerData = {}
        playerData.uid = LuaEntry.Player.uid
        playerData.score = self.scoreInfo.selfScore
        playerData.name = LuaEntry.Player.name
        playerData.pic = LuaEntry.Player.pic
        playerData.picVer = LuaEntry.Player.picVer
        playerData.headSkinId = LuaEntry.Player.headSkinId
        playerData.headSkinET = LuaEntry.Player.headSkinET
        playerData.serverId = LuaEntry.Player:GetSelfServerId()
        playerData.allianceId = LuaEntry.Player.allianceId

        table.insert(self.scoreList, playerData)
    end

    -- 排行榜数据可能更新不及时 但是自己的分数selfScore会及时更新 
    -- 如果在列表中找到自己的数据 就更新 并且重新排名
    local reSort = false;
    if self.scoreInfo ~= nil and self.scoreInfo.selfScore ~= nil and self.scoreInfo.selfScore > 0 and self.scoreList ~= nil then
        for _, v in ipairs(self.scoreList) do
            if v.uid == LuaEntry.Player.uid then
                v.score = self.scoreInfo.selfScore
                reSort = true
                break
            end
        end
    end 

    if reSort then
        table.sort(self.scoreList, function(scoreA, scoreB)
            return scoreA.score > scoreB.score
        end)
    end

    EventManager:GetInstance():Broadcast(EventId.GetDonateArmyScoreInfo)
    EventManager:GetInstance():Broadcast(EventId.RefreshActivityRedDot)
end

-- 获取当前玩家的捐献排名/分数数据
local function GetPlayerCurrDonateSoldierInfo(self)
    local retData = {rank = -1, score = 0}
    
    if self.scoreList == nil then
        return retData
    end

    for k, v in ipairs(self.scoreList) do
        if v.uid == LuaEntry.Player.uid then
            retData.rank = k
            retData.score = self.scoreInfo.selfScore
            break
        end
    end
    
    return retData;
end

local function GetScoreList(self)
    return self.scoreList
end

local function GetScoreNumberByType(self, type)
    local ret = 0
    if self.scoreList == nil then
        return ret
    end

    if type == 0 then
        --自己的分数
        ret = self.scoreInfo.selfScore
    elseif type == 1 then
        --己方联盟分数
        ret = self.scoreInfo.selfAllianceScore
    else
        --敌方联盟分数
        ret = self.scoreInfo.vsAllianceScore
    end

    if ret == nil then
        ret = 0
    end

    return ret
end

-- 获取当天已经捐过的分数
local function GetTodayDonateSumScore(self)
    local ret = 0

    -- 需求变了 现在按照已捐的总分数计算
    -- if self.scoreInfo ~= nil and self.scoreInfo.selfDailyScore ~= nil then
    --     ret = self.scoreInfo.selfDailyScore
    -- end

    if self.scoreInfo ~= nil and self.scoreInfo.selfScore ~= nil then
        ret = self.scoreInfo.selfScore
    end

    return ret
end

-- 获取捐献比例参数
local function GetTodayDonateLimitPercent(self)
    local percent = 0

    local dataList = DataCenter.ActivityListDataManager:GetActivityDataByType(ActivityEnum.ActivityType.DonateSoldierActivity)
    if dataList ~= nil and #dataList > 0 then
        local actData = dataList[1]
        if actData ~= nil then
            if actData.para1 == "" then
                percent = 0
            else
                percent = tonumber(actData.para1) / 100;
            end
        end
    end

    return percent
end

-- 领取捐兵任务奖励请求返回处理 弹奖励框 处理新的任务数据
local function OnHandleReceiveDonateArmyTaskRewardMessage(self, sfsData)
    local rewardArr = sfsData["reward"]

    if sfsData["reward"] ~= nil then
        --r eward有可能为空
        DataCenter.RewardManager:ShowCommonReward(sfsData)
        for k,v in pairs(sfsData["reward"]) do
            DataCenter.RewardManager:AddOneReward(v)
        end
    end

    --处理任务数据
    self.taskInfo = sfsData["taskInfo"]

    EventManager:GetInstance():Broadcast(EventId.ReceiveDonateArmyTaskReward)
    EventManager:GetInstance():Broadcast(EventId.RefreshActivityRedDot)
end

-- 捐兵请求返回处理 增加自己的分数和自己联盟的分数
local function OnHandleDonateSoldierMessage(self, sfsData)
    -- 更新
    if self.scoreInfo == nil then
        self.scoreInfo = {}
    end

    if sfsData ~= nil then
        self.scoreInfo.selfScore = sfsData["selfScore"]
        self.scoreInfo.selfAllianceScore = sfsData["selfAllianceScore"]
    end

    -- 更新列表中的自己分数
    local findSelf = false
    if self.scoreList == nil then
        self.scoreList = {}
    end
    
    for _, v in ipairs(self.scoreList) do
        if v.uid == LuaEntry.Player.uid then
            findSelf = true
            v.score = self.scoreInfo.selfScore
            break
        end
    end

    if findSelf == false and self.scoreInfo ~= nil and self.scoreInfo.selfScore > 0 then
        -- 如果自己的数据没在排行榜里（通常出现在第一次捐献时） 做一个自己的数据放在列表里面
        local playerData = {}
        -- "uid"
        -- "score"    			//long 积分
        -- "name"
        -- "pic"
        -- "picVer"	
        -- "headSkinId"
        -- "headSkinET"	
        -- "serverId" 			//int 玩家所属服
        -- "allianceId"        //string 联盟id
        playerData.uid = LuaEntry.Player.uid
        playerData.score = self.scoreInfo.selfScore
        playerData.name = LuaEntry.Player.name
        playerData.pic = LuaEntry.Player.pic
        playerData.picVer = LuaEntry.Player.picVer
        playerData.headSkinId = LuaEntry.Player.headSkinId
        playerData.headSkinET = LuaEntry.Player.headSkinET
        playerData.serverId = LuaEntry.Player:GetSelfServerId()
        playerData.allianceId = LuaEntry.Player.allianceId

        table.insert(self.scoreList, playerData)
    end
    
    -- 排序
    table.sort(self.scoreList, function(scoreA, scoreB)
        return scoreA.score > scoreB.score
    end)

    EventManager:GetInstance():Broadcast(EventId.DonateSoldier)
    EventManager:GetInstance():Broadcast(EventId.RefreshActivityRedDot)
end

-- 领取捐兵贡献奖励请求返回处理 
local function OnHandleReceiveDonateArmyStageRewardMessage(self, sfsData)
    --[[
		"reward"		 	  //sfs arr 领取获得的奖励
		"type"         		  原样返回
		"idArr"
    ]]
    local rewardArr = sfsData["reward"]
    --处理发奖
    if sfsData["reward"] ~= nil then
        DataCenter.RewardManager:ShowCommonReward(sfsData)
        for k,v in pairs(sfsData["reward"]) do
            DataCenter.RewardManager:AddOneReward(v)
        end
    end

    -- 1领取初级奖励 2领取精英奖励
    local rewardType = sfsData["type"]
    local key = ""
    if rewardType == 1 then
        key = "normalState"
    else
        key = "specialState"
    end

    --涉及领奖操作的id数组需要置为已领取(1)
    local idArr = sfsData["idArr"]
    if idArr ~= nil then
        -- 更新奖励状态
        for _, v in pairs(self.stageArr) do
            local findIdx = table.indexof(idArr, v["id"])
            if findIdx then
                v[key] = 1
            end
        end
    end

    EventManager:GetInstance():Broadcast(EventId.ReceiveDonateArmyStageReward)
    EventManager:GetInstance():Broadcast(EventId.RefreshActivityRedDot)
end

-- 捐兵贡献任务数据推送处理
local function OnHandlePushDonateArmyTaskUpdateMessage(self, sfsData)
    local taskId = sfsData["taskId"] 
    if self.taskInfo ~= nil and self.taskInfo.taskId == taskId then
        -- 需要检测是同一个任务才刷新 不然数据肯定有问题了
        self.taskInfo["state"] = sfsData["state"]
        self.taskInfo["num"] = sfsData["num"]
    end
    EventManager:GetInstance():Broadcast(EventId.PushDonateArmyTaskUpdate)
end

-- 获取捐兵活动总信息 如果有联盟的话进游戏发一次 加联盟和换联盟发一次
local function OnGetDonateSoldierActivityInfo(self)
    SFSNetwork.SendMessage(MsgDefines.GetDonateArmyActivityInfo)
    SFSNetwork.SendMessage(MsgDefines.GetDonateArmyScoreInfo)
end

-- 获取当前的可以领取的所有普通奖励数据
local function GetAllCanRecieveNormalReward(self)
    local retArr = {}

    if self.scoreInfo == nil then
        return retArr
    end

    if self.stageArr == nil then
        return retArr
    end
    
    for _,v in ipairs(self.stageArr) do
        if v.normalState == 0 then
            -- 如果当前奖励的普通奖励未领取
            if v.needAllianceScore <= self.scoreInfo.selfAllianceScore and v.needUserScore <= self.scoreInfo.selfScore then
                --并且已经达到了可以领取的分数
                table.insert(retArr, v)
            end
        end
    end

    return retArr
end


-- 获取当前的可以领取的所有高级奖励数据
local function GetAllCanRecieveAdvanceReward(self)
    local retArr = {}

    if self.scoreInfo == nil then
        return retArr
    end

    if self.stageArr == nil then
        return retArr
    end

    for _,v in ipairs(self.stageArr) do
        if v.specialState == 0 then
            -- 如果当前奖励的高级奖励未领取
            if v.needAllianceScore <= self.scoreInfo.selfAllianceScore and v.needUserScore <= self.scoreInfo.selfScore then
                --并且已经达到了可以领取的分数
                table.insert(retArr, v)
            end
        end
    end

    return retArr
end

local function GetIsCurrTaskRewardCanReceiveNum(self)
    local battleData = DataCenter.ActivityDonateSoldierManager:DonateSoldierInfoViewData()
    if battleData and battleData.state ~= nil then
        --进入战斗 任务就不要红点了
        return 0
    end
    
    local retCount = 0
    local taskInfo = DataCenter.ActivityDonateSoldierManager:GetCurrentTaskInfo()
    --state 0是未完成 的状态 state为nil是任务全部做完以后的情况
    if taskInfo ~= nil and taskInfo.state ~= 0  and taskInfo.state ~= nil then
        retCount = 1
    end

    return retCount
end

local function GetIsCurrRewardCanReceiveNum(self)
    local retCount = 0
    if self.scoreInfo == nil then
        return retCount
    end

    if self.scoreInfo.selfAllianceScore == nil or self.scoreInfo.selfScore == nil then
        return retCount
    end

    if self.stageArr == nil then
        return retCount
    end

    for _,v in ipairs(self.stageArr) do
        if v.normalState == 0 then
            -- 如果当前奖励的普通奖励未领取
            if v.needAllianceScore <= self.scoreInfo.selfAllianceScore and v.needUserScore <= self.scoreInfo.selfScore then
                --并且已经达到了可以领取的分数
                retCount = retCount + 1
            end
        end
    end

    return retCount
end

-- 新任务红点数量
local function GetNewTaskRedPointCount(self)
    if self:IsDonateSoldierActivityOpen() == false then
        return 0
    end
    local count = 0
	local recordLastRefreshTime = Setting:GetPrivateInt(SettingKeys.DONATE_SOLDIER_ACTIVITY_NEW_TASK_RED, 0)
    local lastRefreshTime = math.floor(self:GetLastRefreshTime() / 1000)
    if lastRefreshTime > recordLastRefreshTime  then
        -- 任务刷新时间变化了 是新的任务
        count = 1
    end

    return count
end

local function ResetNewTaskRedPoint(self)
    if self:GetLastRefreshTime() > 0 then
        Setting:SetPrivateInt(SettingKeys.DONATE_SOLDIER_ACTIVITY_NEW_TASK_RED,  math.floor(self.lastRefreshTime / 1000))
        EventManager:GetInstance():Broadcast(EventId.RefreshActivityRedDot)
    end
end

-- 领取所有可领取的普通奖励
local function OnReceiveStageReward(self, type, idArray)
    SFSNetwork.SendMessage(MsgDefines.ReceiveDonateArmyStageReward, type, idArray)
end

-- 获取消耗的道具id
local function GetUseItemId(self)
    return self.useItemId
end

--获取 远征开启时间时间戳
local function GetExpeditionOpenTime(self)
    return self.expeditionOpenTime
end

local function GetDonateSoldierActivityId(self)
    local ret = nil
    local dataList = DataCenter.ActivityListDataManager:GetActivityDataByType(ActivityEnum.ActivityType.DonateSoldierActivity)
    if dataList ~= nil and #dataList > 0 then
        local actData = dataList[1]
        if actData ~= nil then
            return actData.id
        end
    end
    return ret
end

local function CheckIsDonateSoldierActivityOpenOnAllianceChange(self)
    -- 玩家加入联盟的时候 联盟对决的信息可能还没有同步 所以在加入联盟的时候 发联盟捐兵任务请求时不判断联盟对决了
    if LuaEntry.Player:IsInAlliance() == false then 
        --如果玩家不在联盟里则不显示捐兵活动
        return false
    end

    local dataList = DataCenter.ActivityListDataManager:GetActivityDataByType(ActivityEnum.ActivityType.DonateSoldierActivity)
    if dataList ~= nil and #dataList > 0 then
        local actData = dataList[1]
        local curTime = UITimeManager:GetInstance():GetServerTime()
        if curTime > actData.startTime and curTime < actData.endTime then
            -- 已经开始
            return true
        end
    end

    return false
end

local function IsDonateSoldierActivityOpen(self)
    --在活动页面判断捐兵活动是否开启要用最严格的判断 1.判断是否在联盟里 2.判断是否在联盟对决中 3.是否联盟捐兵活动正在进行
    if LuaEntry.Player:IsInAlliance() == false then 
        --如果玩家不在联盟里则不显示捐兵活动
        return false
    else
        local isInAlCompete = DataCenter.AllianceCompeteDataManager:CheckIfIsInCompete()
        if isInAlCompete == false then
            --如果玩家在联盟里但是联盟对决没有开则也不显示捐兵活动
            return false;
        end
    end

    local dataList = DataCenter.ActivityListDataManager:GetActivityDataByType(ActivityEnum.ActivityType.DonateSoldierActivity)
    if dataList ~= nil and #dataList > 0 then
        local actData = dataList[1]
        local curTime = UITimeManager:GetInstance():GetServerTime()
        if curTime > actData.startTime and curTime < actData.endTime then
            -- 已经开始
            return true
        end
    end

    return false
end

local function GetActivityEndTime(self)
    local dataList = DataCenter.ActivityListDataManager:GetActivityDataByType(ActivityEnum.ActivityType.DonateSoldierActivity)
    if dataList ~= nil and #dataList > 0 then
        local actData = dataList[1]
        if actData ~= nil then
            return actData.endTime
        end
    end

    return 0
end

local function OnSendGetDonateSoldierInfoMsg(self)
    SFSNetwork.SendMessage(MsgDefines.GetDonateArmyInfoMessage)
end

local function OnGetDonateSoldierInfoViewData(self, sfsData)
    self.battleInfo = sfsData
    EventManager:GetInstance():Broadcast(EventId.UIDonateSoldierInfoDataUpdate)
end

local function DonateSoldierInfoViewData(self)
    return self.battleInfo
end

-- 获取防守分数排行数据
local function OnSendGetDonateSoldierRankMsg(self, type)
    SFSNetwork.SendMessage(MsgDefines.GetDonateArmyRankMessage, type)
end

local function OnGetDonateSoldierRankData(self, sfsData)
    if sfsData["type"] == 1 then
        --己方排行
        self.selfAllianceRank = sfsData["rankArr"]
    else
        --敌方排行
        self.enemyAllianceRank = sfsData["rankArr"]
    end
    EventManager:GetInstance():Broadcast(EventId.UIDonateSoldierRankDataUpdate)
end

local function GetDonateSolderRankArrayByType(self, type)
    if type == 1 then
        --己方
        return self.selfAllianceRank;
    else
        --敌方
        return self.enemyAllianceRank;
    end
end

local function CheckIfIsNew(self)
    if self:IsDonateSoldierActivityOpen() == false then
        return false
    end

    local actEndTime = self:GetActivityEndTime()
    if actEndTime == 0 then
        return false
    end

    local checkEndTime = math.modf(actEndTime / 1000)
	local lastTime = Setting:GetPrivateInt(SettingKeys.DONATE_SOLDIER_ACTIVITY_RED_NEW, 0)
    if checkEndTime > lastTime then
        -- 活动结束时间变化了 是新的活动
		return true
    end

	return false
end

local function SetIsNew(self, isNew)
    local actEndTime = self:GetActivityEndTime()
    if actEndTime == 0 then
        return
    end

    local checkEndTime = math.modf(actEndTime / 1000)
    if isNew  == false then
        Setting:SetPrivateInt(SettingKeys.DONATE_SOLDIER_ACTIVITY_RED_NEW, checkEndTime)
    end
end

local function GetLastRefreshTime(self)
    if self.lastRefreshTime == nil then
        return -1
    else
        return self.lastRefreshTime
    end
end

local function OnSendOpenSiegeMsg(self)
    SFSNetwork.SendMessage(MsgDefines.PirateSiegeOpen)
end

--开启战斗阶段
local function OnHandlePirateSiegeOpenMessage(self)
    --不做处理 在push里面处理
end

local function OnHandlePushPirateSiegeBattleStart(self)
    EventManager:GetInstance():Broadcast(EventId.PushPirateSiegeBattleStartEvent)
end

ActivityDonateSoldierManager.__init = __init
ActivityDonateSoldierManager.__delete = __delete
ActivityDonateSoldierManager.AddListener = AddListener
ActivityDonateSoldierManager.RemoveListener = RemoveListener
ActivityDonateSoldierManager.OnHandleGetDonateArmyActivityInfoMessage = OnHandleGetDonateArmyActivityInfoMessage
ActivityDonateSoldierManager.OnGetRewardStageArr = OnGetRewardStageArr
ActivityDonateSoldierManager.GetCurrentTaskInfo = GetCurrentTaskInfo
ActivityDonateSoldierManager.OnHandleGetDonateArmyScoreInfoMessage = OnHandleGetDonateArmyScoreInfoMessage
ActivityDonateSoldierManager.OnHandleReceiveDonateArmyTaskRewardMessage = OnHandleReceiveDonateArmyTaskRewardMessage
ActivityDonateSoldierManager.OnHandleDonateSoldierMessage = OnHandleDonateSoldierMessage
ActivityDonateSoldierManager.OnHandleReceiveDonateArmyStageRewardMessage = OnHandleReceiveDonateArmyStageRewardMessage
ActivityDonateSoldierManager.OnHandlePushDonateArmyTaskUpdateMessage = OnHandlePushDonateArmyTaskUpdateMessage
ActivityDonateSoldierManager.OnGetOneScoreBySoldierId = OnGetOneScoreBySoldierId
ActivityDonateSoldierManager.OnGetDonateSoldierActivityInfo = OnGetDonateSoldierActivityInfo
ActivityDonateSoldierManager.GetScoreNumberByType = GetScoreNumberByType
ActivityDonateSoldierManager.GetAllCanRecieveNormalReward = GetAllCanRecieveNormalReward
ActivityDonateSoldierManager.GetAllCanRecieveAdvanceReward = GetAllCanRecieveAdvanceReward
ActivityDonateSoldierManager.OnReceiveStageReward = OnReceiveStageReward
ActivityDonateSoldierManager.GetScoreList = GetScoreList
ActivityDonateSoldierManager.GetUseItemId = GetUseItemId
ActivityDonateSoldierManager.GetExpeditionOpenTime = GetExpeditionOpenTime
ActivityDonateSoldierManager.OnJoinOrCreateAlliance = OnJoinOrCreateAlliance
ActivityDonateSoldierManager.GetPlayerCurrDonateSoldierInfo = GetPlayerCurrDonateSoldierInfo
ActivityDonateSoldierManager.IsDonateSoldierActivityOpen = IsDonateSoldierActivityOpen
ActivityDonateSoldierManager.OnGetDonateSoldierInfoViewData = OnGetDonateSoldierInfoViewData
ActivityDonateSoldierManager.GetActivityEndTime = GetActivityEndTime
ActivityDonateSoldierManager.DonateSoldierInfoViewData = DonateSoldierInfoViewData
ActivityDonateSoldierManager.GetDonateSoldierActivityId = GetDonateSoldierActivityId
ActivityDonateSoldierManager.OnSendGetDonateSoldierInfoMsg = OnSendGetDonateSoldierInfoMsg
ActivityDonateSoldierManager.OnSendGetDonateSoldierRankMsg = OnSendGetDonateSoldierRankMsg
ActivityDonateSoldierManager.OnGetDonateSoldierRankData = OnGetDonateSoldierRankData
ActivityDonateSoldierManager.GetDonateSolderRankArrayByType = GetDonateSolderRankArrayByType
ActivityDonateSoldierManager.GetIsCurrRewardCanReceiveNum = GetIsCurrRewardCanReceiveNum
ActivityDonateSoldierManager.GetIsCurrTaskRewardCanReceiveNum = GetIsCurrTaskRewardCanReceiveNum
ActivityDonateSoldierManager.CheckIfIsNew = CheckIfIsNew
ActivityDonateSoldierManager.SetIsNew = SetIsNew
ActivityDonateSoldierManager.CheckIsDonateSoldierActivityOpenOnAllianceChange = CheckIsDonateSoldierActivityOpenOnAllianceChange
ActivityDonateSoldierManager.GetTodayDonateSumScore = GetTodayDonateSumScore
ActivityDonateSoldierManager.GetTodayDonateLimitPercent = GetTodayDonateLimitPercent
ActivityDonateSoldierManager.GetLastRefreshTime = GetLastRefreshTime
ActivityDonateSoldierManager.GetNewTaskRedPointCount = GetNewTaskRedPointCount
ActivityDonateSoldierManager.ResetNewTaskRedPoint = ResetNewTaskRedPoint
ActivityDonateSoldierManager.OnSendOpenSiegeMsg = OnSendOpenSiegeMsg
ActivityDonateSoldierManager.OnHandlePirateSiegeOpenMessage = OnHandlePirateSiegeOpenMessage
ActivityDonateSoldierManager.OnHandlePushPirateSiegeBattleStart = OnHandlePushPirateSiegeBattleStart

return ActivityDonateSoldierManager