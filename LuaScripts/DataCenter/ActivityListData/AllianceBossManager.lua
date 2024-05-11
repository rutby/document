local AllianceBossManager = BaseClass("AllianceBossManager")

local function __init(self)
    self:AddListener()
    self.donateItemArr = nil
    self.bossInfo = nil
    self.freeRewardState = nil
    self.damage = nil
    self.donateTime = 0
    self.donateRankList = {}
    self.selfDonateRank = 0
    self.selfDonateScore = 0
    self.damageRewardList = {}
    self.selfDamageRank = 0
    self.selfDamageScore = 0
    self.damageRankList = {}
    self.rewardShowList = {}
    self.lvExpInfo = nil
end

local function __delete(self)
    self.donateRankList = nil
    self.damageRankList = nil
    self.damageRewardList = nil
    self.rewardShowList = nil
    self:RemoveListener()
end

local function StartUp(self)

end

local function AddListener(self)

end

local function RemoveListener(self)

end

-- 获取联盟boss活动数据
local function GetActivityData(self)
    local retData = nil
    local dataList = DataCenter.ActivityListDataManager:GetActivityDataByType(ActivityEnum.ActivityType.AllianceBoss)
    if dataList ~= nil and #dataList > 0 then
        local actData = dataList[1]
        if actData ~= nil then
            retData = actData
        end
    end

    return retData
end

-- 获取联盟boss活动的id
local function GetCurrActivityId(self)
    local dataList = DataCenter.ActivityListDataManager:GetActivityDataByType(ActivityEnum.ActivityType.AllianceBoss)
    if dataList ~= nil and #dataList > 0 then
        local actData = dataList[1]
        if actData ~= nil then
            return toInt(actData.id)
        end
    end

    return 0
end

-- 获取联盟boss活动开启时间
local function GetActivityStartTime(self)
    local dataList = DataCenter.ActivityListDataManager:GetActivityDataByType(ActivityEnum.ActivityType.AllianceBoss)
    if dataList ~= nil and #dataList > 0 then
        local actData = dataList[1]
        if actData ~= nil then
            return actData.startTime
        end
    end

    return 0
end

-- 获取联盟boss活动结束时间
local function GetActivityEndTime(self)
    local dataList = DataCenter.ActivityListDataManager:GetActivityDataByType(ActivityEnum.ActivityType.AllianceBoss)
    if dataList ~= nil and #dataList > 0 then
        local actData = dataList[1]
        if actData ~= nil then
            return actData.endTime
        end
    end

    return 0
end

-- 是否联盟boss活动在开启
local function IsAllianceBossActivityOpen(self)

    local dataList = DataCenter.ActivityListDataManager:GetActivityDataByType(ActivityEnum.ActivityType.AllianceBoss)
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

-- 检测是否应该显示new标志
local function CheckIfIsNew(self)
    if self:IsAllianceBossActivityOpen() == false then
        return false
    end

    local actEndTime = self:GetActivityEndTime()
    if actEndTime == 0 then
        return false
    end

    local checkEndTime = math.modf(actEndTime / 1000)
    local lastTime = Setting:GetPrivateInt(SettingKeys.ALLIANCE_BOSS_ACTIVITY_RED_NEW, 0)
    if checkEndTime > lastTime then
        -- 活动结束时间变化了 是新的活动
        return true
    end

    return false
end

-- 设置new标志不显示
local function SetIsNew(self)
    local actEndTime = self:GetActivityEndTime()
    if actEndTime == 0 then
        return
    end

    local checkEndTime = math.modf(actEndTime / 1000)
    Setting:SetPrivateInt(SettingKeys.ALLIANCE_BOSS_ACTIVITY_RED_NEW, checkEndTime)
end

-- 发送请求获取联盟boss活动数据
local function OnSendGetAllianceBossActivityInfoMessage(self)
    local actId = self:GetCurrActivityId()
    if actId > 0 then
        SFSNetwork.SendMessage(MsgDefines.GetAllianceBossActivityInfo, actId)
    end
end

-- 联盟boss活动数据返回
local function OnHandleGetAllianceBossActivityInfoMessage(self, sfsData)
    --[[
        arr
        "itemId"  		//int 资源道具Id
        "exp"     		//int 捐献一个道具的经验
        "donateNum"		//int 已捐献数量
        "donateLimit"   //int 捐献数量上限
        "donateReward"  //sfs arr 通用奖励 捐献一个道具可获得的奖励
        "finalReward"   //sfs arr 通用奖励 捐献到上限可获得的最终奖励
    ]]
    if sfsData['donateItemArr'] then
        self.donateItemArr = sfsData['donateItemArr']
    end

    --[[
        obj
        当前boss的状态
        "lv"	 	//int 等级
        "exp"    	//long 当前经验
        "pointId"	//int boss世界坐标，未召唤时没有该字段
    ]]
    if sfsData['bossInfo'] then
        self.bossInfo = sfsData['bossInfo']
    end

    -- int 免费奖励领取状态  0 未领取  1已领取
    if sfsData['freeRewardState'] then
        self.freeRewardState = sfsData['freeRewardState']
    end

    -- long 自己已经对联盟boss造成的伤害
    if sfsData['damage'] then
        self.damage = sfsData['damage']
    end

    -- str 从活动开启时间开始算 捐献期持续多久(分钟) 后端para1和前端para1不一样
    if sfsData['para1'] then
        self.donateTime = tonumber(sfsData['para1'])
    end

    -- 捐献经验和boss等级的对应关系
    if sfsData['para3'] then
        self.levelPara = sfsData['para3']
    end

    if sfsData['damageRewardArr'] then
        self.rewardShowList = sfsData['damageRewardArr']
    end

    EventManager:GetInstance():Broadcast(EventId.GetAllianceBossActivityInfo)
end

-- 发送请求捐献联盟boss
local function OnSendAllianceBossDonateMessage(self, itemId, num)
    local actId = self:GetCurrActivityId()
    if actId > 0 then
        SFSNetwork.SendMessage(MsgDefines.AllianceBossDonate, actId, itemId, num)
    end
end

-- 捐献联盟boss请求返回
local function OnHandleAllianceBossDonateMessage(self, sfsData)
    -- "reward"       //sfs arr 获得的奖励
    -- "itemId"		 //int 捐献的资源道具Id
    -- "num"            //int 捐献的资源道具数量
    -- "donateNum"		//int 已捐献数量
    -- "bossInfo"   //sfs obj
    --     "lv"	 //int 等级
    --     "exp"    //long 当前经验
    --     "pointId"	//int boss世界坐标，未召唤时没有该字段
    -- "activityId"     //int 活动id
    if sfsData["reward"] ~= nil then
        --r eward有可能为空
        -- DataCenter.RewardManager:ShowCommonReward(sfsData)
        for _,v in pairs(sfsData["reward"]) do
            DataCenter.RewardManager:AddOneReward(v)
        end
    end

    if self.donateItemArr ~= nil and sfsData["itemId"] ~= nil and sfsData["donateNum"] ~= nil then
        for _, v in ipairs(self.donateItemArr) do
            if v.itemId == sfsData["itemId"] then
                v.donateNum = sfsData["donateNum"]
                break
            end
        end
    end

    if sfsData['bossInfo'] then
        self.bossInfo = sfsData['bossInfo']
    end

    EventManager:GetInstance():Broadcast(EventId.AllianceBossDonate)
end

--发送请求 召唤联盟boss
local function OnSendCallAllianceBossMessage(self)
    local actId = self:GetCurrActivityId()
    if actId > 0 then
        SFSNetwork.SendMessage(MsgDefines.CallAllianceBoss, actId)
    end
end

-- 召唤联盟boss请求返回
local function OnHandleCallAllianceBossMessage(self, sfsData)
    if sfsData['bossInfo'] then
        self.bossInfo = sfsData['bossInfo']
    end

    EventManager:GetInstance():Broadcast(EventId.CallAllianceBoss)
end

-- 接收到联盟boss召唤后推送
local function OnHandlePushAllianceBossCreateMessage(self, sfsData)
    if sfsData['bossInfo'] then
        self.bossInfo = sfsData['bossInfo']
    end

    EventManager:GetInstance():Broadcast(EventId.PushAllianceBossCreate)
end

-- 对联盟boss造成伤害变化推送
local function OnHandlePushAllianceBossDamageUpdateMessage(self, sfsData)
    if sfsData['damage'] then
        self.damage = sfsData['damage']
    end

    EventManager:GetInstance():Broadcast(EventId.PushAllianceBossDamageUpdate)
end

-- 发送请求 领取联盟boss免费奖励
local function OnSendReceiveAllianceBossFreeRewardMessage(self)
    local actId = self:GetCurrActivityId()
    if actId > 0 then
        SFSNetwork.SendMessage(MsgDefines.ReceiveAllianceBossFreeReward, actId)
    end
end

-- 领取联盟boss免费奖励
local function OnHandleReceiveAllianceBossFreeRewardMessage(self, sfsData)
    if sfsData["reward"] ~= nil then
        --reward有可能为空
        DataCenter.RewardManager:ShowCommonReward(sfsData)
        for _,v in pairs(sfsData["reward"]) do
            DataCenter.RewardManager:AddOneReward(v)
        end
    end

    if sfsData['freeRewardState'] then
        self.freeRewardState = sfsData['freeRewardState']
    end
    EventManager:GetInstance():Broadcast(EventId.RefreshActivityRedDot)
    EventManager:GetInstance():Broadcast(EventId.ReceiveAllianceBossFreeReward)
end

-- 发送请求 获取联盟boss捐献排行榜
local function OnSendGetAllianceBossDonateRankMessage(self)
    local actId = self:GetCurrActivityId()
    if actId > 0 then
        SFSNetwork.SendMessage(MsgDefines.GetAllianceBossDonateRank, actId)
    end
end

-- 获取联盟boss捐献排行榜请求返回
local function OnHandleGetAllianceBossDonateRankMessage(self, sfsData)
    if sfsData['rankList'] then
        self.donateRankList = sfsData['rankList']
    end

    if sfsData['selfRank'] then
        self.selfDonateRank = sfsData['selfRank']
    end

    if sfsData['selfScore'] then
        self.selfDonateScore = sfsData['selfScore']
    end

    EventManager:GetInstance():Broadcast(EventId.GetAllianceBossDonateRank)
end

-- 发送请求 获取联盟boss伤害排行榜
local function OnSendGetAllianceBossDamageRank(self)
    local actId = self:GetCurrActivityId()
    if actId > 0 then
        SFSNetwork.SendMessage(MsgDefines.GetAllianceBossDamageRank, actId)
    end
end

-- 获取联盟boss伤害排行榜返回
local function OnHandleGetAllianceBossDamageRankMessage(self, sfsData)
    if sfsData['rankList'] then
        self.damageRankList = sfsData['rankList']
    end

    if sfsData['rankRewardArr'] then
        self.damageRewardList = sfsData['rankRewardArr']
    end

    if sfsData['selfRank'] then
        self.selfDamageRank = sfsData['selfRank']
    end

    if sfsData['selfScore'] then
        self.selfDamageScore = sfsData['selfScore']
    end

    EventManager:GetInstance():Broadcast(EventId.GetAllianceBossDamageRank)
end

-- 获取捐献阶段结束时间戳(毫秒)
local function GetDonateStageEndTime(self)
    local retTime = 0

    if self.donateTime ~= nil and self.donateTime > 0 then
        local startTime = self:GetActivityStartTime()
        if startTime ~= nil and startTime > 0 then
            retTime  = startTime + self.donateTime * 60000 -- 分钟->毫秒
        end
    end

    return retTime
end

-- 获取捐献界面数据
local function GetDonateItemArr(self)
    table.sort(self.donateItemArr, 
        function(cellA, cellB)
            if cellA.itemId < cellB.itemId then
                return true
            end
            return false
        end)
    return self.donateItemArr
end

-- 获取伤害奖励界面数据
local function GetDamageRewardCellsData(self)
    local ret = {}
    local actData = self:GetActivityData()
    if actData ~= nil then
        local rewardStr = actData.para1
        if rewardStr ~= nil then
            local tbl1 = nil
            tbl1 = string.split(rewardStr, "|")
            if tbl1 and #tbl1 > 0 then
                for k,v in ipairs(tbl1) do
                    local damage_boxnum_table = string.split(v, ";")
                    local rewardData = nil
                    if self.rewardShowList and k <= #self.rewardShowList then
                        rewardData = DeepCopy(self.rewardShowList[k].reward)
                    end
                    local damage = toInt(damage_boxnum_table[1])
                    local boxnum = toInt(damage_boxnum_table[2])
                    local dataTbl = {damage = damage, itemNum = boxnum, reward = rewardData}
                    table.insert(ret, dataTbl)
                end
            end
        end
    end

    return ret
end

-- 获取捐献奖励界面数据
local function GetDonateRewardCellsData(self)
    return self.donateRankList
end

-- 获取当前boss信息
local function GetBossInfo(self)
    return self.bossInfo
end

-- 是否可以领取免费奖励
local function GetIsFreeRewardCanReceive(self)
    -- int 免费奖励领取状态  0 未领取  1已领取
    local ret = false
    if self.freeRewardState ~= nil and self.freeRewardState == 0 then
        ret = true
    end

    return ret
end

local function GetBossLvAndExpInfo(self)
    if self.lvExpInfo == nil then
        if self.levelPara ~= nil then
            self.lvExpInfo = {}
            local split = string.split(self.levelPara, "|")
            for _, v in ipairs(split) do
                local split2 = string.split(v, ";")
                local level = toInt(split2[1])
                local info = {level = level, bossId = split2[2], exp = toInt(split2[3]), multiple = toInt(split2[4])}
                self.lvExpInfo[level] = info
            end
        end
    end

    return self.lvExpInfo
end

local function GetCurrBossSelfDamage(self)
    return self.damage
end

local function GetDamageRankListData(self)
    return self.damageRankList
end

local function GetDamageRewardListData(self)
    return self.damageRewardList
end

-- 获取当前boss奖励倍率
local function GetMultipleNumber(self)
    -- 目前只按照boss等级来计算倍率
    local num = 1
    local bossInfo = DataCenter.AllianceBossManager:GetBossInfo()
    if bossInfo ~= nil then
        num = bossInfo.lv
    end
    return num
end

local function GetSelfDamageRank(self)
    return self.selfDamageRank,self.selfDamageScore
end

AllianceBossManager.__init = __init
AllianceBossManager.__delete = __delete
AllianceBossManager.StartUp = StartUp
AllianceBossManager.AddListener = AddListener
AllianceBossManager.RemoveListener = RemoveListener
AllianceBossManager.GetActivityData = GetActivityData
AllianceBossManager.GetCurrActivityId = GetCurrActivityId
AllianceBossManager.GetActivityStartTime = GetActivityStartTime
AllianceBossManager.GetActivityEndTime = GetActivityEndTime
AllianceBossManager.IsAllianceBossActivityOpen = IsAllianceBossActivityOpen
AllianceBossManager.CheckIfIsNew = CheckIfIsNew
AllianceBossManager.SetIsNew = SetIsNew

-- 消息相关
AllianceBossManager.OnSendGetAllianceBossActivityInfoMessage = OnSendGetAllianceBossActivityInfoMessage
AllianceBossManager.OnHandleGetAllianceBossActivityInfoMessage = OnHandleGetAllianceBossActivityInfoMessage
AllianceBossManager.OnSendAllianceBossDonateMessage = OnSendAllianceBossDonateMessage
AllianceBossManager.OnHandleAllianceBossDonateMessage = OnHandleAllianceBossDonateMessage
AllianceBossManager.OnSendCallAllianceBossMessage = OnSendCallAllianceBossMessage
AllianceBossManager.OnHandleCallAllianceBossMessage = OnHandleCallAllianceBossMessage
AllianceBossManager.OnHandlePushAllianceBossCreateMessage = OnHandlePushAllianceBossCreateMessage
AllianceBossManager.OnHandlePushAllianceBossDamageUpdateMessage = OnHandlePushAllianceBossDamageUpdateMessage
AllianceBossManager.OnSendReceiveAllianceBossFreeRewardMessage = OnSendReceiveAllianceBossFreeRewardMessage
AllianceBossManager.OnHandleReceiveAllianceBossFreeRewardMessage = OnHandleReceiveAllianceBossFreeRewardMessage
AllianceBossManager.OnSendGetAllianceBossDonateRankMessage = OnSendGetAllianceBossDonateRankMessage
AllianceBossManager.OnHandleGetAllianceBossDonateRankMessage = OnHandleGetAllianceBossDonateRankMessage
AllianceBossManager.OnSendGetAllianceBossDamageRank = OnSendGetAllianceBossDamageRank
AllianceBossManager.OnHandleGetAllianceBossDamageRankMessage = OnHandleGetAllianceBossDamageRankMessage


AllianceBossManager.GetDonateStageEndTime = GetDonateStageEndTime
AllianceBossManager.GetDonateItemArr = GetDonateItemArr
AllianceBossManager.GetDamageRewardCellsData = GetDamageRewardCellsData
AllianceBossManager.GetDonateRewardCellsData = GetDonateRewardCellsData
AllianceBossManager.GetBossInfo = GetBossInfo
AllianceBossManager.GetIsFreeRewardCanReceive = GetIsFreeRewardCanReceive
AllianceBossManager.GetBossLvAndExpInfo = GetBossLvAndExpInfo
AllianceBossManager.GetCurrBossSelfDamage = GetCurrBossSelfDamage
AllianceBossManager.GetDamageRankListData = GetDamageRankListData
AllianceBossManager.GetDamageRewardListData = GetDamageRewardListData
AllianceBossManager.GetMultipleNumber = GetMultipleNumber
AllianceBossManager.GetSelfDamageRank = GetSelfDamageRank

return AllianceBossManager