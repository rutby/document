local ActivityALVSDonateSoldierManager = BaseClass("ActivityALVSDonateSoldierManager")

local function __init(self)
    self.stageArr = {} -- arr 贡献奖励信息
    self.soldierScoreArr = {} -- arr捐兵对应积分
    self.taskInfo = {} -- obj 捐兵任务信息
    self.scoreList = {} -- arr 玩家积分排行数据
    self.scoreInfo = {} -- obj 积分数据
    self.useItemId = "" -- 消耗道具的id
    self.battleInfo = {}
    self.checkBattle = false
    self:AddListener()
end

local function __delete(self)
    self.stageArr = nil
    self.soldierScoreArr = nil
    self.taskInfo = nil
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

-- 获取捐兵活动总信息 如果有联盟的话进游戏发一次 加联盟和换联盟发一次
local function OnGetALVSDonateSoldierActivityInfo(self, checkBattle)
    if checkBattle ~= nil then
        self.checkBattle = checkBattle
    end
    SFSNetwork.SendMessage(MsgDefines.GetALVSDonateArmyActivityInfo)
end


local function OnHandleGetALVSDonateArmyActivityInfoMessage(self, sfsData)
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

    --[[
		"vsAllianceInfo"  //sfs obj 匹配的对手联盟信息
			"allianceId"  //str  
			"abbr"        //str 联盟简称
			"name"        //str 联盟名称
			"icon"        //str 联盟头像
			"serverId"    //int 联盟归属服
    ]]
    if sfsData["vsAllianceInfo"] ~= nil then
        self.vsAllianceInfo = sfsData["vsAllianceInfo"]
    end

    -- "para"           //string 各阶段时间配置
    -- 从活动开启时间开始算 准备期时间;准备期多久可以匹配;捐献期时间;进攻期时间;自动判负时间
    if sfsData["para"] ~= nil then
        self.timeConfigPara = string.split(sfsData["para"], ";")
    end

    -- 排行榜数据可能更新不及时 但是自己的分数selfScore会及时更新 

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

    -- 如果在列表中找到自己的数据 就更新 并且重新排名
    local reSort = false;
    if self.scoreInfo ~= nil  and self.scoreInfo.selfScore ~= nil and self.scoreList ~= nil then
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

    -- 发送消息更新界面
    EventManager:GetInstance():Broadcast(EventId.GetALVSDonateArmyActivityInfo)
    EventManager:GetInstance():Broadcast(EventId.RefreshActivityRedDot)

    -- 在获取联盟数据以后请求新捐兵数据的时候 判断是否在战斗中 
    -- 如果在战斗中则获取战斗数据 用于刷新ui上面的正在战斗提示
    if self.checkBattle == true then
        self.checkBattle = false
        local now = UITimeManager:GetInstance():GetServerTime()
        local donateEndTime = self:GetDonateEndTimeStamp()
        if now > donateEndTime then
            --到了战斗阶段 获取战斗阶段的敌我联盟信息
            if self:GetVsAllianceInfo() then
                -- 只有有联盟对手才发 获取战斗信息
                self:SendGetALVSDonateArmyBattleInfoMessage()
            end
        end
    end
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

    if self.scoreInfo ~= nil and self.scoreInfo.selfScore ~= nil and self.scoreInfo.selfScore > 0 then
        ret = self.scoreInfo.selfScore
    end

    return ret
end

-- 获取捐献比例参数
local function GetTodayDonateLimitPercent(self)
    local percent = 0

    local dataList = DataCenter.ActivityListDataManager:GetActivityDataByType(ActivityEnum.ActivityType.ALVSDonateSoldier)
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
local function OnHandleReceiveALVSDonateArmyTaskRewardMessage(self, sfsData)
    if sfsData["reward"] ~= nil then
        --r eward有可能为空
        DataCenter.RewardManager:ShowCommonReward(sfsData)
        for k,v in pairs(sfsData["reward"]) do
            DataCenter.RewardManager:AddOneReward(v)
        end
    end

    --处理任务数据
    self.taskInfo = sfsData["taskInfo"]

    EventManager:GetInstance():Broadcast(EventId.ReceiveALVSDonateArmyTaskReward)
    EventManager:GetInstance():Broadcast(EventId.RefreshActivityRedDot)
end

-- 捐兵请求返回处理 增加自己的分数和自己联盟的分数
local function OnHandleALVSDonateSoldierMessage(self, sfsData)
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

    if findSelf == false then
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

    EventManager:GetInstance():Broadcast(EventId.ALVSDonateSoldier)
    EventManager:GetInstance():Broadcast(EventId.RefreshActivityRedDot)
end

-- 领取捐兵贡献奖励请求返回处理 
local function OnHandleALVSReceiveDonateArmyStageRewardMessage(self, sfsData)
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

    EventManager:GetInstance():Broadcast(EventId.ReceiveALVSDonateArmyStageReward)
    EventManager:GetInstance():Broadcast(EventId.RefreshActivityRedDot)
end

-- 捐兵贡献任务数据推送处理
local function OnHandlePushALVSDonateArmyTaskUpdateMessage(self, sfsData)
    local taskId = sfsData["taskId"] 
    if self.taskInfo ~= nil and self.taskInfo.taskId == taskId then
        -- 需要检测是同一个任务才刷新 不然数据肯定有问题了
        self.taskInfo["state"] = sfsData["state"]
        self.taskInfo["num"] = sfsData["num"]
    end
    EventManager:GetInstance():Broadcast(EventId.PushALVSDonateArmyTaskUpdate)
end

-- 战斗联盟中心状态变化推送处理
local function OnHandlePushDonateArmyDefenceResultMessage(self, sfsData)
    local result = sfsData['result']
    local buildingId = sfsData['buildingId']
    --只会刷自己的联盟中心状态
    if self.battleAllianceArr ~= nil then

        for _,v in ipairs(self.battleAllianceArr) do
            if v.allianceId == LuaEntry.Player.allianceId then
                for k, v2 in ipairs(v.allianceBuildings) do
                    if v2.buildingId == buildingId then
                        if result == 1 then
                            v2.state = 2    --防守成功
                        elseif result == 2 then
                            v2.state = 3    --防守失败
                        end

                        break
                    end
                end
            end
        end
    end

    EventManager:GetInstance():Broadcast(EventId.PushDonateArmyDefenceResult)
end

-- 获取活动状态时间戳
-- 1.准备期到期时间戳 2.准备期可以匹配的时间戳 3.捐献期结束时间戳 4.进攻期结束时间戳 5.自动判负时间戳
local function GetTimeConfigPara(self)
    return self.timeConfigPara
end

-- 由于时间这里计算比较混乱 所以在manager里面计算 所有的统一成毫秒
-- 获取准备期结束时间戳 也就是捐献期开始时间戳
local function GetPrepareEndTimeStamp(self)
    if self.timeConfigPara == nil then
        return 0
    end

    local actStartTimeStamp = self:GetActivityStartTime()
    if actStartTimeStamp == 0 then
        return 0
    end

    local prepareEndPassTimeMinite = toInt(self.timeConfigPara[1])
    return actStartTimeStamp + prepareEndPassTimeMinite * 60000
end

-- 获取可以宣战的时间戳
local function GetCanDelcareStartTimeStamp(self)
    if self.timeConfigPara == nil then
        return 0
    end

    local actStartTimeStamp = self:GetActivityStartTime()
    if actStartTimeStamp == 0 then
        return 0
    end

    local prepareEndPassTimeMinite = toInt(self.timeConfigPara[2])
    return actStartTimeStamp + prepareEndPassTimeMinite * 60000
end

-- 捐献期结束时间戳
local function GetDonateEndTimeStamp(self)
    if self.timeConfigPara == nil then
        return 0
    end

    local actStartTimeStamp = self:GetActivityStartTime()
    if actStartTimeStamp == 0 then
        return 0
    end

    -- 捐献期结束的时间是以准备期结束的时间往后推self.timeConfigPara[3]分钟
    local prepareEndPassTimeMinite = toInt(self.timeConfigPara[1]) + toInt(self.timeConfigPara[3])
    return actStartTimeStamp + prepareEndPassTimeMinite * 60000
end

-- 获取 进攻期结束时间戳
local function GetAttackEndTimeStamp(self)
    if self.timeConfigPara == nil then
        return 0
    end

    local actStartTimeStamp = self:GetActivityStartTime()
    if actStartTimeStamp == 0 then
        return 0
    end

    -- 捐献期结束的时间是以捐献期结束的时间往后推self.timeConfigPara[5]分钟
    local prepareEndPassTimeMinite = toInt(self.timeConfigPara[1]) + toInt(self.timeConfigPara[3]) + toInt(self.timeConfigPara[4])
    return actStartTimeStamp + prepareEndPassTimeMinite * 60000
end

-- 获取 被自动判负的时间戳
local function GetAutoDefeateTimeStamp(self)
    if self.timeConfigPara == nil then
        return 0
    end

    local actStartTimeStamp = self:GetActivityStartTime()
    if actStartTimeStamp == 0 then
        return 0
    end

    local prepareEndPassTimeMinite = toInt(self.timeConfigPara[1]) + toInt(self.timeConfigPara[3]) + toInt(self.timeConfigPara[5])
    return actStartTimeStamp + prepareEndPassTimeMinite * 60000
end

--------- 匹配联盟列表请求相关 --------- 

--发送请求获取匹配列表
local function SendGetALVSDonateArmyDeclareWarListMessage(self)
    SFSNetwork.SendMessage(MsgDefines.GetALVSDonateArmyDeclareWarList)
end

-- 新捐兵获取匹配列表请求返回处理
local function OnHandleGetALVSDonateArmyDeclareWarListMessage(self, sfsData)
    --[[
		"allianceArr"   //sfsArr
				"allianceId" 
				"abbr"
				"name"
				"icon"
				"serverId"   //int 联盟所属服
				"rank"       //int 排名
				"score"      //long 赛季积分
				"power"      //long 战力
				"matched"    //int 0 未匹配 1已匹配
    ]]
    self.declareAllianceArr = sfsData['allianceArr']
    EventManager:GetInstance():Broadcast(EventId.ALVSDeclareAllianceListReturn)
end

-- 获取匹配联盟列表
local function GetDeclareAllianceArr(self)
    return self.declareAllianceArr
end

--------- 随机匹配联盟请求相关 --------- 

-- 发送请求获取随机匹配对手
local function SendALVSDonateArmyRandomMatchEnemyMessage(self)
    SFSNetwork.SendMessage(MsgDefines.ALVSDonateArmyRandomMatchEnemy)
end

-- 新捐兵随机匹配请求返回处理
local function OnHandleALVSDonateArmyRandomMatchEnemyMessage(self, sfsData)
    --[[
		"allianceId"  //str  
		"abbr"        //str 联盟简称
		"name"        //str 联盟名称
		"icon"        //str 联盟头像
		"serverId"    //int 联盟归属服
		"rank"        //int 联盟当前排名
		"score"		  //long 联盟赛季积分
		"power"       //long 联盟战力
    ]]
    self.randomDeclareAlliance = sfsData
    EventManager:GetInstance():Broadcast(EventId.ALVSRandomMatchReturn)
end

-- 获取新捐兵随机匹配联盟信息
local function GetRandomDeclareAllianceInfo(self)
    return self.randomDeclareAlliance
end

--------- 联盟宣战请求相关 --------- 

-- 盟主选择了对战的联盟 也就是宣战 --type 1是随机出来的联盟 2是非随机的联盟
local function SendALVSDonateArmyDeclareWarMessage(self, allianceId, type)
    SFSNetwork.SendMessage(MsgDefines.ALVSDonateArmyDeclareWar, tostring(allianceId), toInt(type))
end

-- 新捐兵宣战请求返回处理
local function OnHandleALVSDonateArmyDeclareWarMessage(self, sfsData)
    self.vsAllianceInfo = sfsData["vsAllianceInfo"]
    UIUtil.ShowTipsId(302859) -- 宣战成功
end

-- 获取新捐兵捐兵对手联盟信息
local function GetVsAllianceInfo(self)
    return self.vsAllianceInfo
end

-- 匹配到对手推送
local function OnHandlePushALVSDonateArmyMatchSuccess(self, sfsData)
    --匹配到对手后 发送
    EventManager:GetInstance():Broadcast(EventId.PushALVSMatchSuccessReturn)
end

--------- 联盟盟主开启迎战请求相关 --------- 

-- 盟主开启迎战 也就是开启战斗阶段
local function SendALVSDonateArmyOpenAttackMessage(self)
    SFSNetwork.SendMessage(MsgDefines.ALVSDonateArmyOpenAttack)
end

-- 盟主开启迎战后推送
local function OnHandlePushALVSDonateArmyBattleStart(self, sfsData)
    --盟主开启迎战后推送
    EventManager:GetInstance():Broadcast(EventId.PushALVSDonateArmyBattleStartReturn)
end

-- 获取战斗阶段的敌我联盟信息
local function SendGetALVSDonateArmyBattleInfoMessage(self)
    SFSNetwork.SendMessage(MsgDefines.GetALVSDonateArmyBattleInfo)
end

-- 获取对决信息 //进入第三阶段的界面发送
local function OnHandleGetALVSDonateArmyBattleInfoMessage(self, sfsData)
    --[[
        allianceArr
            "allianceId"  //str  
            "abbr"        //str 联盟简称
            "name"        //str 联盟名称
            "icon"        //str 联盟头像
            "serverId"    //int 联盟归属服
            "state"					  //int 0未开启迎战 1 战斗中  2结束等待结算  3 胜利  4 失败 5平局
            "score"       //long 本盟防守积分
            "winRound"    //int 成功防守波次
            allianceBuildings
                buildingId    //int 联盟中心建筑id
                serverId      //int 建筑所在服务器id
                pointId       //int 建筑坐标，=0 表示没放
                state         //int 0未开始  1 正在进攻当前联盟中心  2 防守成功  3 防守失败
                round					  //int 当前攻击波次
                nextRoundTime			  //long 下波海盗攻击时间,没有该字段表示没有下一波了
    ]]
    self.battleAllianceArr = sfsData['allianceArr']
    EventManager:GetInstance():Broadcast(EventId.ALVSDonateArmyBattleInfoReturn)
end

-- 获取战斗阶段的两个联盟的数据
local function GetBattleArrlianceArr(self)
    return self.battleAllianceArr
end

-- 盟主迎战返回处理
local function OnHandleALVSDonateArmyOpenAttackMessage(self, sfsData)
    if sfsData['allianceArr'] then
        self.battleAllianceArr = sfsData['allianceArr']
    end

    UIUtil.ShowTipsId(308039) -- 即将迎战
end

-------------------------------------------------------------

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
    if LuaEntry.Player:IsInAlliance() == false then 
        return 0
    end
    local battleData = DataCenter.ActivityALVSDonateSoldierManager:DonateSoldierInfoViewData()
    if battleData and battleData.state ~= nil then
        --进入战斗 任务就不要红点了
        return 0
    end
    
    --todo wsy 需要判断当前阶段 只有在捐兵阶段才能显示任务红点
    
    local retCount = 0
    local taskInfo = DataCenter.ActivityALVSDonateSoldierManager:GetCurrentTaskInfo()
    --state 0是未完成 的状态 state为nil是任务全部做完以后的情况
    if taskInfo ~= nil and taskInfo.state ~= 0  and taskInfo.state ~= nil then
        retCount = 1
    end

    return retCount
end

local function GetIsCurrRewardCanReceiveNum(self)
    if LuaEntry.Player:IsInAlliance() == false then 
        return 0
    end
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

-- 领取所有可领取的普通奖励
local function OnReceiveStageReward(self, type, idArray)
    SFSNetwork.SendMessage(MsgDefines.ReceiveALVSDonateArmyStageReward, type, idArray)
end

-- 获取消耗的道具id
local function GetUseItemId(self)
    return self.useItemId
end

local function GetDonateSoldierActivityId(self)
    local ret = nil
    local dataList = DataCenter.ActivityListDataManager:GetActivityDataByType(ActivityEnum.ActivityType.ALVSDonateSoldier)
    if dataList ~= nil and #dataList > 0 then
        local actData = dataList[1]
        if actData ~= nil then
            return actData.id
        end
    end
    return ret
end

local function IsALVSDonateSoldierActivityOpen(self)
    -- 新捐兵只要活动打开就显示 不管在不在联盟

    local dataList = DataCenter.ActivityListDataManager:GetActivityDataByType(ActivityEnum.ActivityType.ALVSDonateSoldier)
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

local function GetActivityStartTime(self)
    local dataList = DataCenter.ActivityListDataManager:GetActivityDataByType(ActivityEnum.ActivityType.ALVSDonateSoldier)
    if dataList ~= nil and #dataList > 0 then
        local actData = dataList[1]
        if actData ~= nil then
            return actData.startTime
        end
    end

    return 0
end

local function GetActivityEndTime(self)
    local dataList = DataCenter.ActivityListDataManager:GetActivityDataByType(ActivityEnum.ActivityType.ALVSDonateSoldier)
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
    if self:IsALVSDonateSoldierActivityOpen() == false then
        return false
    end

    local actEndTime = self:GetActivityEndTime()
    if actEndTime == 0 then
        return false
    end

    local checkEndTime = math.modf(actEndTime / 1000)
	local lastTime = Setting:GetPrivateInt(SettingKeys.DONATE_SOLDIER_ALVS_ACTIVITY_RED_NEW, 0)
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
        Setting:SetPrivateInt(SettingKeys.DONATE_SOLDIER_ALVS_ACTIVITY_RED_NEW, checkEndTime)
    end
end

local function GetLastRefreshTime(self)
    if self.lastRefreshTime == nil then
        return -1
    else
        return self.lastRefreshTime
    end
end

-- 捐献士兵活动获取的排行榜数据
local function GetALVSDonateSoldierActivityDataList(self, justSelfAlliance, addFake)
    local retData = DeepCopy(DataCenter.ActivityALVSDonateSoldierManager:GetScoreList())

    if justSelfAlliance == true then
        local gripData = {}
        for _,v in ipairs(retData) do
            if v.allianceId == LuaEntry.Player.allianceId then
                table.insert(gripData,v);
            end
        end
        if addFake then
            local curNum = #gripData
            if curNum < 10 then
                local addFakeNum = 10 - curNum
                for i = 1, addFakeNum do
                    --假数据
                    table.insert(gripData, {uid = "", score = 0, name = "", pic = "", serverId = 0, picVer = 1, headSkinId = 0, headSkinET = 0, allianceId = ""});
                end
            end
        end

        return gripData
    else

        if addFake then
            local curNum = #retData
            if curNum < 10 then
                local addFakeNum = 10 - curNum
                for i = 1, addFakeNum do
                    --假数据
                    table.insert(retData, {uid = "", score = 0, name = "", pic = "", serverId = 0, picVer = 1, headSkinId = 0, headSkinET = 0, allianceId = ""});
                end
            end
        end
        return retData
    end
    
end

ActivityALVSDonateSoldierManager.__init = __init
ActivityALVSDonateSoldierManager.__delete = __delete
ActivityALVSDonateSoldierManager.AddListener = AddListener
ActivityALVSDonateSoldierManager.RemoveListener = RemoveListener
ActivityALVSDonateSoldierManager.OnHandleGetALVSDonateArmyActivityInfoMessage = OnHandleGetALVSDonateArmyActivityInfoMessage
ActivityALVSDonateSoldierManager.OnGetRewardStageArr = OnGetRewardStageArr
ActivityALVSDonateSoldierManager.GetCurrentTaskInfo = GetCurrentTaskInfo
ActivityALVSDonateSoldierManager.OnHandleReceiveALVSDonateArmyTaskRewardMessage = OnHandleReceiveALVSDonateArmyTaskRewardMessage
ActivityALVSDonateSoldierManager.OnHandleALVSDonateSoldierMessage = OnHandleALVSDonateSoldierMessage
ActivityALVSDonateSoldierManager.OnHandleALVSReceiveDonateArmyStageRewardMessage = OnHandleALVSReceiveDonateArmyStageRewardMessage
ActivityALVSDonateSoldierManager.OnHandlePushALVSDonateArmyTaskUpdateMessage = OnHandlePushALVSDonateArmyTaskUpdateMessage
ActivityALVSDonateSoldierManager.SendGetALVSDonateArmyDeclareWarListMessage = SendGetALVSDonateArmyDeclareWarListMessage
ActivityALVSDonateSoldierManager.OnHandleGetALVSDonateArmyDeclareWarListMessage = OnHandleGetALVSDonateArmyDeclareWarListMessage
ActivityALVSDonateSoldierManager.GetDeclareAllianceArr = GetDeclareAllianceArr
ActivityALVSDonateSoldierManager.SendALVSDonateArmyRandomMatchEnemyMessage = SendALVSDonateArmyRandomMatchEnemyMessage
ActivityALVSDonateSoldierManager.SendALVSDonateArmyDeclareWarMessage = SendALVSDonateArmyDeclareWarMessage
ActivityALVSDonateSoldierManager.OnHandleALVSDonateArmyDeclareWarMessage = OnHandleALVSDonateArmyDeclareWarMessage
ActivityALVSDonateSoldierManager.GetVsAllianceInfo = GetVsAllianceInfo
ActivityALVSDonateSoldierManager.OnHandleALVSDonateArmyRandomMatchEnemyMessage = OnHandleALVSDonateArmyRandomMatchEnemyMessage
ActivityALVSDonateSoldierManager.GetRandomDeclareAllianceInfo = GetRandomDeclareAllianceInfo
ActivityALVSDonateSoldierManager.OnHandlePushALVSDonateArmyMatchSuccess = OnHandlePushALVSDonateArmyMatchSuccess
ActivityALVSDonateSoldierManager.SendALVSDonateArmyOpenAttackMessage = SendALVSDonateArmyOpenAttackMessage
ActivityALVSDonateSoldierManager.OnHandlePushALVSDonateArmyBattleStart = OnHandlePushALVSDonateArmyBattleStart
ActivityALVSDonateSoldierManager.SendGetALVSDonateArmyBattleInfoMessage = SendGetALVSDonateArmyBattleInfoMessage
ActivityALVSDonateSoldierManager.OnHandleGetALVSDonateArmyBattleInfoMessage = OnHandleGetALVSDonateArmyBattleInfoMessage
ActivityALVSDonateSoldierManager.GetBattleArrlianceArr = GetBattleArrlianceArr
ActivityALVSDonateSoldierManager.OnHandleALVSDonateArmyOpenAttackMessage = OnHandleALVSDonateArmyOpenAttackMessage
ActivityALVSDonateSoldierManager.OnHandlePushDonateArmyDefenceResultMessage = OnHandlePushDonateArmyDefenceResultMessage
ActivityALVSDonateSoldierManager.OnGetOneScoreBySoldierId = OnGetOneScoreBySoldierId
ActivityALVSDonateSoldierManager.OnGetALVSDonateSoldierActivityInfo = OnGetALVSDonateSoldierActivityInfo
ActivityALVSDonateSoldierManager.GetScoreNumberByType = GetScoreNumberByType
ActivityALVSDonateSoldierManager.GetAllCanRecieveNormalReward = GetAllCanRecieveNormalReward
ActivityALVSDonateSoldierManager.GetAllCanRecieveAdvanceReward = GetAllCanRecieveAdvanceReward
ActivityALVSDonateSoldierManager.OnReceiveStageReward = OnReceiveStageReward
ActivityALVSDonateSoldierManager.GetScoreList = GetScoreList
ActivityALVSDonateSoldierManager.GetUseItemId = GetUseItemId
ActivityALVSDonateSoldierManager.GetPlayerCurrDonateSoldierInfo = GetPlayerCurrDonateSoldierInfo
ActivityALVSDonateSoldierManager.IsALVSDonateSoldierActivityOpen = IsALVSDonateSoldierActivityOpen
ActivityALVSDonateSoldierManager.OnGetDonateSoldierInfoViewData = OnGetDonateSoldierInfoViewData
ActivityALVSDonateSoldierManager.GetActivityStartTime = GetActivityStartTime
ActivityALVSDonateSoldierManager.GetActivityEndTime = GetActivityEndTime
ActivityALVSDonateSoldierManager.DonateSoldierInfoViewData = DonateSoldierInfoViewData
ActivityALVSDonateSoldierManager.GetDonateSoldierActivityId = GetDonateSoldierActivityId
ActivityALVSDonateSoldierManager.OnSendGetDonateSoldierInfoMsg = OnSendGetDonateSoldierInfoMsg
ActivityALVSDonateSoldierManager.OnSendGetDonateSoldierRankMsg = OnSendGetDonateSoldierRankMsg
ActivityALVSDonateSoldierManager.OnGetDonateSoldierRankData = OnGetDonateSoldierRankData
ActivityALVSDonateSoldierManager.GetDonateSolderRankArrayByType = GetDonateSolderRankArrayByType
ActivityALVSDonateSoldierManager.GetIsCurrRewardCanReceiveNum = GetIsCurrRewardCanReceiveNum
ActivityALVSDonateSoldierManager.GetIsCurrTaskRewardCanReceiveNum = GetIsCurrTaskRewardCanReceiveNum
ActivityALVSDonateSoldierManager.CheckIfIsNew = CheckIfIsNew
ActivityALVSDonateSoldierManager.SetIsNew = SetIsNew
ActivityALVSDonateSoldierManager.GetTodayDonateSumScore = GetTodayDonateSumScore
ActivityALVSDonateSoldierManager.GetTodayDonateLimitPercent = GetTodayDonateLimitPercent
ActivityALVSDonateSoldierManager.GetLastRefreshTime = GetLastRefreshTime
ActivityALVSDonateSoldierManager.GetTimeConfigPara = GetTimeConfigPara
ActivityALVSDonateSoldierManager.GetALVSDonateSoldierActivityDataList = GetALVSDonateSoldierActivityDataList
ActivityALVSDonateSoldierManager.GetPrepareEndTimeStamp = GetPrepareEndTimeStamp
ActivityALVSDonateSoldierManager.GetCanDelcareStartTimeStamp = GetCanDelcareStartTimeStamp
ActivityALVSDonateSoldierManager.GetDonateEndTimeStamp = GetDonateEndTimeStamp
ActivityALVSDonateSoldierManager.GetAttackEndTimeStamp = GetAttackEndTimeStamp
ActivityALVSDonateSoldierManager.GetAutoDefeateTimeStamp = GetAutoDefeateTimeStamp

return ActivityALVSDonateSoldierManager