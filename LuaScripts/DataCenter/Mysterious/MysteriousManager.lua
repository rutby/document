local MysteriousManager = BaseClass("MysteriousManager")
local Localization = CS.GameEntry.Localization
local MysteriousActParam = require "DataCenter.Mysterious.MysteriousActParam"
local MysteriousActTemplate = require "DataCenter.Mysterious.MysteriousActTemplate"
local ScratchOffGameRankInfoTemplate = require "DataCenter.ScratchOffGame.ScratchOffGameRankInfoTemplate"

function MysteriousManager : __init()
    self.actParamInfoList = {}
    self.lotteryInfoList = {}
    self.rankInfoList = {}
    self.stageRewardInfoList = {}
    self:InitRewardPreviewInfo()
    self:InitMysteriousActivityTemplateData()
end

function MysteriousManager : __delete()
    self.actParamInfoList = nil
    self.lotteryInfoList = nil
    self.rankInfoList = nil
    self.stageRewardInfoList = nil
end

function MysteriousManager : SetActivityId(id)
    self.actParamInfoList[tonumber(id)] = nil
    self.lotteryInfoList[tonumber(id)] = {}
    self.rankInfoList[tonumber(id)] = {}
    self.stageRewardInfoList[tonumber(id)] = {}
    self:InitRewardPreviewCommonRewardInfo(id)
    SFSNetwork.SendMessage(MsgDefines.GetMysteriousActParamInfo, id)
end

function MysteriousManager : OnRecvMysteriousActParamInfo(msg)
    if msg == nil then
        return
    end
    local activityId = tonumber(msg["activityId"])
    local info = MysteriousActParam.New()
    info:ParseData(msg)
    self.actParamInfoList[activityId] = info
    EventManager:GetInstance():Broadcast(EventId.MysteriousActParamUpdate)
    EventManager:GetInstance():Broadcast(EventId.RefreshActivityRedDot)
end

function MysteriousManager : GetActParamInfoByActId(activityId)
    local actId = tonumber(activityId)
    if self.actParamInfoList[actId] then
        return self.actParamInfoList[actId]
    end
    return nil
end

function MysteriousManager : OnRecvMysteriousLotteryInfo(msg)
    if msg == nil then
        return
    end
    local activityId = tonumber(msg["activityId"])
    local data = self:GetMysteriousLotteryInfoByActId(activityId)
    if data then
        if msg["lotteryArr"] then
            data.lotteryArr = {}
            for k,v in ipairs(msg["lotteryArr"]) do
                local info = {}
                info.index = v.index
                info.number = v.number
                table.insert(data.lotteryArr, info)
            end
        end
        if msg["mysteriousInfo"] then
            local info = MysteriousActParam.New()
            info:ParseData(msg)
            self.actParamInfoList[activityId] = info
        end
        if msg["reward"] then
            for k,v in pairs(msg["reward"]) do
                DataCenter.RewardManager:AddOneReward(v)
            end
            data.reward = msg
            --todo DataCenter.RewardManager:ShowCommonReward(msg)
        end
        if msg["gold"] then
            LuaEntry.Player.gold = msg["gold"]
            EventManager:GetInstance():Broadcast(EventId.UpdateGold)
        end
        EventManager:GetInstance():Broadcast(EventId.MysteriousLotteryUpdate, msg)
        EventManager:GetInstance():Broadcast(EventId.RefreshActivityRedDot)
    end
end

function MysteriousManager : GetMysteriousLotteryInfoByActId(activityId)
    local actId = tonumber(activityId)
    if self.lotteryInfoList[actId] then
        return self.lotteryInfoList[actId]
    end
    return nil
end

function MysteriousManager : OnRecvRankInfo(msg)
    if msg == nil then
        return
    end
    local data = self:GetRankInfoByActId(msg["activityId"])
    if data and msg then
        if self.rankInfoList[msg["activityId"]] == nil then
            self.rankInfoList[msg["activityId"]] = {}
        end
        if msg["selfRank"] then
            self.rankInfoList[msg["activityId"]].selfRank   = msg["selfRank"]           --自己的排名
        end
        if msg["selfScore"] then
            self.rankInfoList[msg["activityId"]].selfScore  = msg["selfScore"]          --自己的积分
        end
        self.rankInfoList[msg["activityId"]].rankReward = {}
        if msg["rankRewardArr"] then
            for i = 1 ,#msg["rankRewardArr"] do
                local param = {}
                param.reward = DataCenter.RewardManager:ReturnRewardParamForView(msg["rankRewardArr"][i]["reward"])
                param.startN = msg["rankRewardArr"][i]["start"]
                param.endN   = msg["rankRewardArr"][i]["end"]
                table.insert(self.rankInfoList[msg["activityId"]].rankReward, param)
            end
        end
        local reward = self.rankInfoList[msg["activityId"]].rankReward
        local max = 0
        for i = 1 ,table.count(reward) do
            if reward[i].endN > max then
                max = reward[i].endN
            end
        end
        if msg["rankList"] and next(msg["rankList"]) then
            self.rankInfoList[msg["activityId"]].rankList = {}
            for i = 1 ,#msg["rankList"] do
                if i <= max then
                    local info = ScratchOffGameRankInfoTemplate.New()
                    info:ParseRankInfo(msg["rankList"][i])
                    self.rankInfoList[msg["activityId"]].rankList[i] = info
                end
            end
        end
        EventManager:GetInstance():Broadcast(EventId.MysteriousRankInfoUpdate)
    end
end

function MysteriousManager : GetRankInfoByActId(activityId)
    local actId = tonumber(activityId)
    if self.rankInfoList[actId] then
        return self.rankInfoList[actId]
    end
    return nil
end

function MysteriousManager : OnRecvRewardInfo(msg)
    if msg == nil then
        return
    end
    local data = self:GetStageRewardInfoByActId(msg["activityId"])
    if data and msg then
        if msg["reward"] then
            for k,v in pairs(msg["reward"]) do
                DataCenter.RewardManager:AddOneReward(v)
            end
        end
        if msg["mysteriousInfo"] then
            local info = MysteriousActParam.New()
            info:ParseData(msg)
            self.actParamInfoList[msg["activityId"]] = info
        end
        EventManager:GetInstance():Broadcast(EventId.GetMysteriousStageReward, msg)
        EventManager:GetInstance():Broadcast(EventId.RefreshActivityRedDot)
    end
end

function MysteriousManager : GetStageRewardInfoByActId(activityId)
    local actId = tonumber(activityId)
    if self.stageRewardInfoList[actId] then
        return self.stageRewardInfoList[actId]
    end
    return nil
end

function MysteriousManager : IsNew(activityId)
    local actData = DataCenter.ActivityListDataManager:GetActivityDataById(tostring(activityId))
    if actData == nil then
        return false
    end
    local visited = Setting:GetPrivateBool(SettingKeys.MYSTERIOUS_VISIT .. actData.startTime, false)
    return not visited
end

function MysteriousManager : GetRedPointCount(activityId)
    local actParamInfo = self:GetActParamInfoByActId(activityId)
    if actParamInfo == nil then
        return 0
    end
    
    local round = actParamInfo.round
    local stage = actParamInfo.rewardStage + 1
    local score = actParamInfo.numbers[1] * actParamInfo.numbers[2] * actParamInfo.numbers[3]

    local redCount = 0
    for s, stageInfo in ipairs(self.stageInfoList[tonumber(activityId)][round]) do
        if s >= stage then
            if score >= stageInfo.needPoint then
                redCount = redCount + 1
            else
                break
            end
        end
    end
    
    return redCount
end

function MysteriousManager : InitRewardPreviewInfo()
    self.rewardPreviewInfoList = {}
    self.stageInfoList = {}
    LocalController:instance():visitTable("activity_mysterious", function(id, lineData)
        local activityId = tonumber(lineData:getValue("activity_id"))
        local info = self.rewardPreviewInfoList[activityId]
        if info == nil then
            info = {}
            info.finalRewardInfoList = {}
            info.gearRewardInfoList = {}
            info.commonRewardInfoList = {}
            self.rewardPreviewInfoList[activityId] = info
        end
        local stageInfo = self.stageInfoList[activityId]
        if stageInfo == nil then
            self.stageInfoList[activityId] = {}
        end

        local round = tonumber(lineData:getValue("round"))
        if info.gearRewardInfoList[round] == nil then
            info.gearRewardInfoList[round] = {}
        end
        if info.finalRewardInfoList[round] == nil then
            info.finalRewardInfoList[round] = {}
        end

        local stage = tonumber(lineData:getValue("stage"))
        if self.stageInfoList[activityId][round] == nil then
            self.stageInfoList[activityId][round] ={}
        end
        if self.stageInfoList[activityId][round][stage] == nil then
            self.stageInfoList[activityId][round][stage] = {}
        end
        self.stageInfoList[activityId][round][stage].needPoint = tonumber(lineData:getValue("need_point"))
        self.stageInfoList[activityId][round][stage].pic = lineData:getValue("banner_icon")
        
        local goods = lineData:getValue("goods")
        local spl_goods = string.split_ss_array(goods, ";")
        local goodsId = tonumber(spl_goods[1])
        local rewardItemInfo = {}
        rewardItemInfo.rewardType = RewardType.GOODS
        rewardItemInfo.itemId = goodsId
        rewardItemInfo.count = tonumber(spl_goods[2])
        local type = tonumber(lineData:getValue("type"))
        if type == 0 then   --档位奖励
            table.insert(info.gearRewardInfoList[round], rewardItemInfo)
        elseif type == 1 then   --终极大奖
            local finalRewardInfo = {}
            finalRewardInfo.rewardItemInfo = rewardItemInfo
            finalRewardInfo.icon = string.format(LoadPath.UIMysterious, lineData:getValue("banner_icon"))
            finalRewardInfo.showRemainNum = false
            table.insert(info.finalRewardInfoList[round], finalRewardInfo)
        end
    end)
end

function  MysteriousManager : InitRewardPreviewCommonRewardInfo(activityId)
    if (activityId == nil or self.rewardPreviewInfoList[tonumber(activityId)] == nil) then
        return
    end
    
    local actId = tonumber(activityId)
    local commonRewardList = self.rewardPreviewInfoList[actId].commonRewardInfoList
    local lineData = LocalController:instance():getLine("activity_panel", actId)
    local para4 = lineData:getValue("para4")
    local spl_para4 = string.split(para4, "|")
    for k,v in ipairs(spl_para4) do
        local spls = string.split(v, ";")
        if #spls == 3 then
            local rewardItemInfo = {}
            rewardItemInfo.rewardType = RewardType.GOODS
            rewardItemInfo.itemId =  tonumber(spls[1])
            rewardItemInfo.count = tonumber(spls[2])
            table.insert(commonRewardList, rewardItemInfo)
        end
    end
end

function MysteriousManager : GetRewardPreviewInfo(activityId)
    local actId = tonumber(activityId)
    return self.rewardPreviewInfoList[actId]
end

function MysteriousManager : InitMysteriousActivityTemplateData()
    self.activityTemplateList = {}
    LocalController:instance():visitTable("activity_panel", function(id, lineData)
        local activityId = tonumber(lineData:getValue("id"))
        local template = MysteriousActTemplate.New()
        template:ParseData(lineData)
        self.activityTemplateList[activityId] = template
    end)
end

function MysteriousManager : GetActTemplate(activityId)
    local actId = tonumber(activityId)
    if self.activityTemplateList[actId] then
        return self.activityTemplateList[actId]
    end
    return nil
end

function MysteriousManager : GetRoundByActId(activityId)
    local actParamInfo = self:GetActParamInfoByActId(activityId)
    if actParamInfo then
        return actParamInfo.round
    else
        return 1
    end
end

function MysteriousManager : CheckRoundStageNeedScore(activityId, round, stage)
    local score = 0
    local stageInfo = self.stageInfoList[tonumber(activityId)]
    if stageInfo[round] and stageInfo[round][stage] and stageInfo[round][stage].needPoint then
        score = stageInfo[round][stage].needPoint
    end
    return score
end

function MysteriousManager : GetStageInfo(activityId, round, stage)
    local info = self.stageInfoList[tonumber(activityId)]
    return info and info[round] and info[round][stage]
end

function MysteriousManager : GetRoundMaxScore(activityId, round)
    local stageInfo = self.stageInfoList[tonumber(activityId)]
    if stageInfo[round] == nil then
        return 0
    end
    return self:CheckRoundStageNeedScore(activityId, round, #stageInfo[round])
end

return MysteriousManager