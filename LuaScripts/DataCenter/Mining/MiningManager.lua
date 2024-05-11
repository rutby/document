local MiningManager = BaseClass("MiningManager")
local Localization = CS.GameEntry.Localization
local MiningQueueInfo = require "DataCenter.Mining.MiningQueueInfo"
local MiningArrReward = require "DataCenter.Mining.MiningArrReward"
local maxQueueNum = 3

function MiningManager : __init()
    self.actTemplateInfoList = {}
    self.actParamInfoList = {}
    self.miningLotteryResInfoList = {}
    self:InitRewardPreviewInfo()
    self.giftId = 0
end

function MiningManager : __delete()
    self.actTemplateInfoList = nil
    self.actParamInfoList = nil
    self.miningLotteryResInfoList = nil
    self.giftId = nil
end

function MiningManager : SetActivityId(id)
    self.actParamInfoList[tonumber(id)] = {}
    self.miningLotteryResInfoList[tonumber(id)] = {}
    SFSNetwork.SendMessage(MsgDefines.GetMiningActParamInfo, id)
end

function MiningManager : OnRecvMiningActParamInfo(msg)
    if msg == nil then
        return
    end
    local activityId = tonumber(msg["activityId"])
    local data = self:GetActParamInfoByActId(activityId)
    if data then
        local info = {}
        if msg["lotteryCount"] then
            info.lotteryCount = msg["lotteryCount"]
        end
        if msg["unlockQueues"] then
            info.unlockQueues = {}
            if not string.IsNullOrEmpty(msg["unlockQueues"]) then
                local spl = string.split_ss_array(msg["unlockQueues"], ";")
                for i = 1, #spl do
                    table.insert(info.unlockQueues, spl[i])
                end
            end
            --info.unlockQueues[queueId] = queueInfo
        end
        if msg["mineQueues"] then
            info.queueInfoList = {}
            for i = 1, maxQueueNum do
                local queueInfo = MiningQueueInfo.New()
                table.insert(info.queueInfoList, queueInfo)
            end
            for k,v in ipairs(msg["mineQueues"]) do
                local queueId = v.queueId
                local queueInfo = MiningQueueInfo.New()
                queueInfo:ParseData(v)
                info.queueInfoList[queueId] = queueInfo
            end
        end
        if msg["mineCountRecords"] then
            for k,v in ipairs(msg["mineCountRecords"]) do
                local id = v.itemId
                local count = v.count
                local rewardPreviewInfo = self:GetRewardPreviewInfo()
                if rewardPreviewInfo then
                    for k1,v1 in ipairs(rewardPreviewInfo.miningCarRewardInfoList) do
                        if v1.id == info.itemId then
                            v1.remainNum = v1.remainNum - 1
                        end
                    end
                end
            end
        end
        if msg["serverTime"] then
            CS.GameEntry.Timer:UpdateServerMilliseconds(msg["serverTime"])
            UITimeManager:GetInstance():UpdateServerMsDeltaTime(msg["serverTime"])
        end
        if msg["stageArr"] then
            info.stageArr = {}
            for i, v in ipairs(msg["stageArr"]) do
                local stageArr = MiningArrReward.New()
                stageArr:ParseData(v)
                info.stageArr[i] = stageArr
            end
        end
        if msg["unlock"] then
            info.unlock = msg["unlock"] --是否解锁付费奖励 0未解锁  已解锁
        end
        if msg["score"] then
            info.score = msg["score"]   --累计总积分
        end
        self.actParamInfoList[activityId] = info
        EventManager:GetInstance():Broadcast(EventId.MiningActParamInfoUpdate)
        EventManager:GetInstance():Broadcast(EventId.RefreshActivityRedDot)
    end
end

function MiningManager : GetActParamInfoByActId(activityId)
    local actId = tonumber(activityId)
    if self.actParamInfoList[actId] then
        return self.actParamInfoList[actId]
    end
    return nil
end

--领取矿车奖励返回
function MiningManager : OnRecvMiningCarRewardInfo(msg)
    if msg == nil then
        return
    end

    local activityId = tonumber(msg["activityId"])
    if msg["reward"] then
        DataCenter.RewardManager:ShowCommonReward(msg)
        for _, v in pairs(msg["reward"]) do
            DataCenter.RewardManager:AddOneReward(v)
        end
    end
    if msg["queue"] then
        local queueId = msg["queue"].queueId
        local queueInfo = MiningQueueInfo.New()
        queueInfo:ParseData(msg["queue"])
        local actParamInfo = self:GetActParamInfoByActId(activityId)
        actParamInfo.queueInfoList[queueId] = queueInfo
    end
    if msg["score"] then
        local actParamInfo = self:GetActParamInfoByActId(activityId)
        actParamInfo.score = msg["score"]
    end
    EventManager:GetInstance():Broadcast(EventId.TakeMiningCarReward)
    EventManager:GetInstance():Broadcast(EventId.RefreshActivityRedDot)
end

--挖矿返回
function MiningManager : OnRecvMiningLotteryResInfo(msg)
    if msg == nil then
        return
    end
    local activityId = tonumber(msg["activityId"])
    local actParamInfo = self:GetActParamInfoByActId(activityId)
    actParamInfo.lotteryCount = actParamInfo.lotteryCount + 1
    local data = self:GetMiningLotteryResInfo(activityId)
    if data then
        local info = {}
        if msg["reward"] then
            for _, v in pairs(msg["reward"]) do
                DataCenter.RewardManager:AddOneReward(v)
            end
        end
        if msg["itemId"] then
            info.itemId = msg["itemId"]
            local type = LocalController:instance():getLine("activity_mining_para", info.itemId)
            if type == 1 then   -- 获得矿车奖励减少对应奖励剩余次数
                local rewardPreviewInfo = self:GetRewardPreviewInfo()
                if rewardPreviewInfo then
                    for k,v in ipairs(rewardPreviewInfo.miningCarRewardInfoList) do
                        if v.id == info.itemId then
                            v.remainNum = v.remainNum - 1
                        end
                    end
                end
            end
        end
        if msg["queue"] then
            local queueId = msg["queue"].queueId
            local queueInfo = MiningQueueInfo.New()
            queueInfo:ParseData(msg["queue"])
            info.queueInfo = queueInfo
            actParamInfo.queueInfoList[queueId] = queueInfo
        end
        if msg["serverTime"] then
            CS.GameEntry.Timer:UpdateServerMilliseconds(msg["serverTime"])
            UITimeManager:GetInstance():UpdateServerMsDeltaTime(msg["serverTime"])
        end
        if msg["score"] then
            actParamInfo.score = msg["score"]   --累计总积分
        end
        self.miningLotteryResInfoList[activityId] = info
        EventManager:GetInstance():Broadcast(EventId.MiningLotteryResInfoUpdate)
        EventManager:GetInstance():Broadcast(EventId.RefreshActivityRedDot)
    end
end

function MiningManager : GetMiningLotteryResInfo(activityId)
    local actId = tonumber(activityId)
    if self.miningLotteryResInfoList[actId] then
        return self.miningLotteryResInfoList[actId]
    end
    return nil
end

function MiningManager : OnRecvMiningQueueUnlockResInfo(msg)
    if msg == nil then
        return
    end

    local activityId = tonumber(msg["activityId"])
    local data = self:GetActParamInfoByActId(activityId)
    if data then
        if msg["unlockQueues"] then
            data.unlockQueues = {}
            if not string.IsNullOrEmpty(msg["unlockQueues"]) then
                local spl = string.split_ss_array(msg["unlockQueues"], ";")
                for i = 1, #spl do
                    table.insert(data.unlockQueues, spl[i])
                end
            end
        end
        if msg["score"] then
            data.score = msg["score"]
        end
        if msg["unlock"] then
            data.unlock = msg["unlock"]
        end
    end

    EventManager:GetInstance():Broadcast(EventId.MiningQueueUnlock)
end

function MiningManager : OnRecvMiningSpeedUpResInfo(msg)
    if msg == nil then
        return
    end
    
    if msg then
        local activityId = tonumber(msg["activityId"])
        if msg["queue"] then
            local queueId = msg["queue"].queueId
            local queueInfo = MiningQueueInfo.New()
            queueInfo:ParseData(msg["queue"])
            local actParamInfo = self:GetActParamInfoByActId(activityId)
            actParamInfo.queueInfoList[queueId] = queueInfo
        end
        if msg["serverTime"] then
            CS.GameEntry.Timer:UpdateServerMilliseconds(msg["serverTime"])
            UITimeManager:GetInstance():UpdateServerMsDeltaTime(msg["serverTime"])
        end
        EventManager:GetInstance():Broadcast(EventId.MiningQueueSpeedUp)
        EventManager:GetInstance():Broadcast(EventId.RefreshActivityRedDot)
    end
end

function MiningManager : GetRedPointCount(activityId)
    local count = 0
    local hasSpaceCar = self:CheckHasSpaceCar(activityId)
    if hasSpaceCar then
        count = count + 1
    end
    --Logger.Log("Test GetRedPointCount count:"..count)
    local actParamInfo = self:GetActParamInfoByActId(tonumber(activityId))
    if actParamInfo then
        if actParamInfo.queueInfoList then
            for i = 1, #actParamInfo.queueInfoList do
                local canTakeRewardCount = actParamInfo.queueInfoList[i]:GetCanTakeRewardMinesCount()
                count = count + canTakeRewardCount
            end
        end

        if actParamInfo.stageArr and next(actParamInfo.stageArr) then
            local stageArr = actParamInfo.stageArr
            for i = 1, table.count(stageArr) do
                if actParamInfo.score >= stageArr[i].needScore then
                    if stageArr[i].normalState == 0 then
                        count = count + 1
                    end
                    if actParamInfo.unlock == 1 and stageArr[i].specialState == 0 then
                        count = count + 1
                    end
                end
            end
        end
    end
    --Logger.Log("Test GetRedPointCount count:"..count)
    return count
end

function MiningManager : GetActTemplateInfoByActId(activityId)
    local actId = tonumber(activityId)
    if self.actTemplateInfoList[actId] == nil then
        local info = {}
        local lineData = LocalController:instance():getLine("activity_panel", actId)

        info.queueInfoList = {}
        local param1 = lineData:getValue("para2")
        local spl1 = string.split_ss_array(param1, "|")
        for k,v in ipairs(spl1) do
            local spl_queueInfo = string.split_ss_array(v, ";")
            local queueInfo = {}
            queueInfo.queueId = tonumber(spl_queueInfo[1])          --矿车列队编号
            queueInfo.carNum = tonumber(spl_queueInfo[2])           --矿车数量
            queueInfo.giftNum = tonumber(spl_queueInfo[3])          --礼包ID
            --第一个队列默认解锁
            if spl_queueInfo[4] then
                queueInfo.giftScore = tonumber(spl_queueInfo[4])    --购买礼包后获得积分
            end
            queueInfo.isFree = queueInfo.giftNum <= 0
            table.insert(info.queueInfoList, queueInfo)
        end
        
        local param2 = lineData:getValue("para3")
        local spl2 = string.split_ss_array(param2, ";")
        info.speedUpItemId = tonumber(spl2[1])
        info.speedUpTime = tonumber(spl2[2])
        self.actTemplateInfoList[actId] = info
    end
    return self.actTemplateInfoList[actId]
end

function MiningManager : GetRemainExploreCountByActId(activityId)
    local actId = tonumber(activityId)
    local maxNum = tonumber(GetTableData("activity_panel", actId, "para1"))
    local info = self:GetActParamInfoByActId(actId)
    if info then
        local lotteryCount = info.lotteryCount
        return maxNum - lotteryCount
    else
        return 0
    end
end

function MiningManager : InitRewardPreviewInfo()
    self.rewardPreviewInfoList = {}
    LocalController:instance():visitTable("activity_mining_para", function(id, lineData)
        local activityId = tonumber(lineData:getValue("activity"))
        local info = self.rewardPreviewInfoList[activityId]
        if info == nil then
            info = {}
            info.itemRewardInfoList = {}
            info.miningCarRewardInfoList = {}
            self.rewardPreviewInfoList[activityId] = info
        end

        --local goods = lineData:getValue("goods")
        --local spl_goods = string.split_ss_array(goods, ";")
        --local goodsId = tonumber(spl_goods[1])
        local rewardItemInfo = {}
        rewardItemInfo.rewardType = RewardType.GOODS
        --rewardItemInfo.itemId = goodsId
        --rewardItemInfo.count = tonumber(spl_goods[2])
        rewardItemInfo.itemId = nil
        rewardItemInfo.count = 0
        local type = tonumber(lineData:getValue("type"))
        if type == 0 then
            table.insert(info.itemRewardInfoList, rewardItemInfo)
        elseif type == 1 then
            local miningCarInfo = {}
            miningCarInfo.id = tonumber(id)
            miningCarInfo.rewardItemInfo = rewardItemInfo
            local icon = lineData:getValue("reward_icon")
            miningCarInfo.icon = string.format(LoadPath.UIMiningCarImg, icon)
            miningCarInfo.remainNum = tonumber(lineData:getValue("reward_time"))
            table.insert(info.miningCarRewardInfoList, miningCarInfo)
        end
    end)
end

function MiningManager : GetRewardPreviewInfo(activityId)
    local actId = tonumber(activityId)
    return self.rewardPreviewInfoList[actId]
end

function MiningManager : GetMiningCarImgPath(id)
    local icon = GetTableData("activity_mining_para", tonumber(id), "reward_icon")
    return string.format(LoadPath.UIMiningCarImg, icon)
end

function MiningManager : GetMiningCarScore(id)
    local score = GetTableData("activity_mining_para", tonumber(id), "score")
    return score
end

function MiningManager : GetSpeedUpTime(activityId)
    local info = self:GetActTemplateInfoByActId(activityId)
    return info.speedUpTime
end

function MiningManager : CheckHasSpaceCar(activityId)
    local enough = false
    local actTemplateInfo = self:GetActTemplateInfoByActId(tonumber(activityId))
    local actParamInfo = self:GetActParamInfoByActId(tonumber(activityId))

    local unLockQueueIndexList = {}
    if actTemplateInfo.queueInfoList then
        for k,v in ipairs(actTemplateInfo.queueInfoList) do
            if v.isFree then
                table.insert(unLockQueueIndexList, v.queueId)
            end
        end
    end
    if actParamInfo.unlockQueues then
        for k,v in pairs(actParamInfo.unlockQueues) do
            table.insert(unLockQueueIndexList, tonumber(v))
        end
    end

    if actParamInfo.queueInfoList then
        for k,v in pairs(unLockQueueIndexList) do
            local miningCars = actParamInfo.queueInfoList[v].mines
            if miningCars == nil or #miningCars < 4 then
                enough = true
                break
            end
        end
    end
    
    return enough
end

--获取当前阶段
function MiningManager:GetCurStage(actId)
    local data = self:GetActParamInfoByActId(actId)
    local curScore = data.score
    local stageArr = data.stageArr
    local count = table.count(stageArr)
    local stage = 0
    local before = 0
    local after = 0
    if stageArr and next(stageArr) then
        if curScore >= stageArr[count].needScore then
            stage = stageArr[count].stage
        else
            for i = 1, count do
                if curScore <= stageArr[i].needScore then
                    if curScore == stageArr[i].needScore then
                        stage = stageArr[i].stage
                    else
                        stage = stageArr[i].stage - 1
                    end
                    if stage > 0 then
                        if stage ~= 1 then
                            before = stageArr[i - 1].needScore
                        end
                        after = stageArr[i].needScore
                    end
                    break
                end
            end
        end
    end
    return stage,before,after
end

--获取所有付费解锁奖励
function MiningManager:GetSpecialReward(actId)
    local data = self:GetActParamInfoByActId(actId)
    local stageArr = data.stageArr
    local list = {}
    if stageArr and next(stageArr) then
        for i = 1, table.count(stageArr) do
            local param = {}
            param.count = stageArr[i].specialReward[1].count
            param.itemId = stageArr[i].specialReward[1].itemId
            param.rewardType = stageArr[i].specialReward[1].rewardType
            table.insert(list,param)
        end
    end
    local tempTab = {}
    local rewardList = {}
    for i = 1, #list do
        if tempTab[list[i].itemId] then
            tempTab[list[i].itemId].count = tempTab[list[i].itemId].count + list[i].count
        else
            tempTab[list[i].itemId] = list[i]
        end
    end
    for i, v in pairs(tempTab) do
        table.insert(rewardList,v)
    end
    table.sort(rewardList, function(a,b)
        local templateA = DataCenter.ItemTemplateManager:GetItemTemplate(a.itemId)
        local templateB = DataCenter.ItemTemplateManager:GetItemTemplate(b.itemId)
        if templateA.order > templateB.order then
            return true
        end
        return false
    end)
    return rewardList
end
--领取阶段奖励返回
function MiningManager:ReceiveStageRewardHandle(message)
    if message["reward"] then
        for _, v in pairs(message["reward"]) do
            DataCenter.RewardManager:AddOneReward(v)
        end
        DataCenter.RewardManager:ShowCommonReward(message)
    end
    local activityId = tonumber(message["activityId"])
    local actParamInfo = self:GetActParamInfoByActId(activityId)
    local rewardStageArr = message["rewardStageArr"]
    if actParamInfo and actParamInfo.stageArr and next(actParamInfo.stageArr) then
        for i = 1, table.count(actParamInfo.stageArr) do
            for k = 1, table.count(rewardStageArr) do
                if actParamInfo.stageArr[i].stage == rewardStageArr[k] then
                    actParamInfo.stageArr[i]:StageUpdate(message["type"])
                end
            end
        end
    end
    EventManager:GetInstance():Broadcast(EventId.MiningQueueSpeedUp)
    EventManager:GetInstance():Broadcast(EventId.RefreshActivityRedDot)
end

function MiningManager:SetGiftId(id)
    self.giftId = id
end
function MiningManager:GetGiftId()
    return self.giftId
end

return MiningManager