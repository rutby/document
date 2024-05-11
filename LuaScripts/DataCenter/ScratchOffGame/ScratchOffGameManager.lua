local ScratchOffGameManager = BaseClass("ScratchOffGameManager")
local Localization = CS.GameEntry.Localization

local ScratchOffGameActivityTemplate = require "DataCenter.ScratchOffGame.ScratchOffGameActivityTemplate"
local ScratchOffGameRankInfoTemplate = require "DataCenter.ScratchOffGame.ScratchOffGameRankInfoTemplate"
local ScratchOffGameRewardRecordInfoTemplate = require "DataCenter.ScratchOffGame.ScratchOffGameRewardRecordInfoTemplate"
local ScratchOffGameActivityParamTemplate = require "DataCenter.ScratchOffGame.ScratchOffGameActivityParamTemplate"
local CommonRewardItemInfoTemplate = require "DataCenter.ScratchOffGame.CommonRewardItemInfoTemplate"
local LuckyRewardItemInfoTemplate = require "DataCenter.ScratchOffGame.LuckyRewardItemInfoTemplate"

function ScratchOffGameManager : __init()
    self.rankInfoList = {}
    self.rewardRecordInfoList = {}
    self.activityParamInfoList = {}
    self.selectedHeroIndexDic = {}
    self:InitTemplateData()
end

function ScratchOffGameManager : __delete()
    self.rankInfoList = nil
    self.rewardRecordInfoList = nil
    self.activityParamInfoList = nil
    self.selectedHeroIndexDic = nil
end

function ScratchOffGameManager : SetActivityId(id)
    self.rankInfoList[tonumber(id)] = {}
    self.rewardRecordInfoList[tonumber(id)] = {}
    self.activityParamInfoList[tonumber(id)] = {}
    self.selectedHeroIndexDic[tonumber(id)] = 1
    SFSNetwork.SendMessage(MsgDefines.GetScratchOffGameActivityInfo, id)
end

function ScratchOffGameManager : OnRecvActivityParamInfo(msg)
    if msg == nil then
        return
    end
    local activityId = tonumber(msg["activityId"])
    local data = self:GetActivityParamInfo(activityId)
    if data and msg then
        local info = ScratchOffGameActivityParamTemplate.New()
        info:ParamData(msg)
        self.activityParamInfoList[activityId] = info
        EventManager:GetInstance():Broadcast(EventId.ScratchOffGameActivityParamUpdate)
    end
end

function ScratchOffGameManager : GetActivityParamInfo(activityId)
    local actId = tonumber(activityId)
    if self.activityParamInfoList[actId] then
        return self.activityParamInfoList[actId]
    end
    return nil
end

function ScratchOffGameManager : OnRecvLotteryRes(msg)
    if msg == nil then
        return
    end
    
    if msg then
        local activityId = msg["activityId"]
        if msg["gold"] then
            LuaEntry.Player.gold = msg["gold"]
            EventManager:GetInstance():Broadcast(EventId.UpdateGold)
        end
        
        local activityTemplate = self:GetActivityParamInfo(activityId)
        if activityTemplate and msg["scratchInfo"] then
            if msg["scratchInfo"].totalLotteryCount then
                activityTemplate.totalLotteryCount = msg["scratchInfo"].totalLotteryCount
            end
            if msg["scratchInfo"].oneLotteryCount then
                activityTemplate.oneLotteryCount = msg["scratchInfo"].oneLotteryCount
                EventManager:GetInstance():Broadcast(EventId.RefreshActivityRedDot)
            end
            if msg["scratchInfo"].tenLotteryCount then
                activityTemplate.tenLotteryCount = msg["scratchInfo"].tenLotteryCount
            end
            if msg["scratchInfo"].score then
                activityTemplate.score = msg["scratchInfo"].score
            end
        end
        if activityTemplate and msg["diamondPool"] then
            activityTemplate.diamondPool = msg["diamondPool"]
        end

        if msg["reward"] then
            for k,v in pairs(msg["reward"]) do
                DataCenter.RewardManager:AddOneReward(v)
            end
        end

        self.recentLotteryResInfoList = {}
        self.recentLotteryResInfoList.diamond = 0
        if msg["lotteryItems"] then
            for k,v in pairs(msg["lotteryItems"]) do
                local resInfo = {}
                if v.normalItemId then
                    local lineData = LocalController:instance():getLine("activity_scratch_para", tonumber(v.normalItemId))
                    local commonInfo = CommonRewardItemInfoTemplate.New()
                    commonInfo:ParseData(lineData, activityId)
                    resInfo.commonItemInfo = commonInfo
                end
                resInfo.levelTxt = ""
                if v.specialItemId then
                    local level = GetTableData("activity_scratch_para", v.specialItemId, "title")
                    resInfo.ifLottery = tonumber(level) > 0
                    resInfo.specialItemId = v.specialItemId
                    resInfo.levelTxt = self:GetScratchOffRankBySpecialId(v.specialItemId)
                    if resInfo.ifLottery then
                        local iconPath = self:GetScratchOffLuckyIconBySpecialId(v.specialItemId)
                        resInfo.iconPath1 = iconPath
                        resInfo.iconPath2 = iconPath
                        resInfo.iconPath3 = iconPath
                    else
                        local iconPaths = self:GetRandomThreeLuckyIconPathByActId(activityId)
                        resInfo.iconPath1 = iconPaths[1]
                        resInfo.iconPath2 = iconPaths[2]
                        resInfo.iconPath3 = iconPaths[3]
                    end
                end
                resInfo.diamond = 0
                if v.diamond then
                    resInfo.diamond = v.diamond
                    self.recentLotteryResInfoList.diamond = self.recentLotteryResInfoList.diamond + tonumber(v.diamond)
                end
                table.insert(self.recentLotteryResInfoList, resInfo)
            end
        end
        if msg["hasScoreReward"] then
            local hasScoreReward = tonumber(msg["hasScoreReward"])
            if hasScoreReward == 1 then
                EventManager:GetInstance():Broadcast(EventId.ScratchOffGameGetExtraReward)
            end
        end
        
        EventManager:GetInstance():Broadcast(EventId.ScratchOffGameRewardLotteryInfoUpdate)
        EventManager:GetInstance():Broadcast(EventId.ScratchOffGameActivityParamUpdate)
    end
end

function ScratchOffGameManager : OnRecvRankInfo(msg)
    if msg == nil then
        return
    end
    local data = self:GetRankInfoByActId(msg["activityId"])
    if data and msg then
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
        EventManager:GetInstance():Broadcast(EventId.ScratchOffGameRankInfoUpdate)
    end
end

function ScratchOffGameManager : GetRankInfoByActId(activityId)
    local actId = tonumber(activityId)
    if self.rankInfoList[actId] then
        return self.rankInfoList[actId]
    end
    return nil
end

function ScratchOffGameManager : OnRecvRewardRecordInfo(msg)
    if msg == nil then
        return
    end
    local data = self:GetRewardRecordInfoListByActId(msg["activityId"])
    if data and msg then
        data = {}
        if msg["recordArr"] then
            for i = 1 ,#msg["recordArr"] do
                local info = ScratchOffGameRewardRecordInfoTemplate.New()
                info:ParseInfo(msg["recordArr"][i])
				table.insert(data, info)
            end
            self.rewardRecordInfoList[tonumber(msg["activityId"])] = data
        end
        EventManager:GetInstance():Broadcast(EventId.ScratchOffGameRewardRecordInfoUpdate)
    end
end

function ScratchOffGameManager : GetRewardRecordInfoListByActId(activityId)
    local actId = tonumber(activityId)
    if self.rewardRecordInfoList[actId] then
        return self.rewardRecordInfoList[actId]
    end
    return nil
end

function ScratchOffGameManager : OnRecvSwitchHeroRes(msg)
    if msg == nil then
        return
    end
    if msg then
        local activityId = msg["activityId"]
        local activityTemplate = self:GetActivityParamInfo(activityId)
        if activityTemplate and msg["scratchInfo"] then
            if msg["scratchInfo"].totalLotteryCount then
                activityTemplate.totalLotteryCount = msg["scratchInfo"].totalLotteryCount
            end
            if msg["scratchInfo"].oneLotteryCount then
                activityTemplate.oneLotteryCount = msg["scratchInfo"].oneLotteryCount
                EventManager:GetInstance():Broadcast(EventId.RefreshActivityRedDot)
            end
            if msg["scratchInfo"].tenLotteryCount then
                activityTemplate.tenLotteryCount = msg["scratchInfo"].tenLotteryCount
            end
            if msg["scratchInfo"].score then
                activityTemplate.score = msg["scratchInfo"].score
            end
            if msg["scratchInfo"].chooseIndex then
                activityTemplate.chooseIndex = msg["scratchInfo"].chooseIndex
            end
        end
        EventManager:GetInstance():Broadcast(EventId.ScratchOffGameSelectedHeroUpdate)
    end
end


function ScratchOffGameManager : InitTemplateData()
    self:InitTransTable()
    self:InitScratchOffGameActivityTemplateData()
    self:InitRewardItemInfoData()
end

function ScratchOffGameManager : InitTransTable()
    self.scratchIdToActIdDic = {}
    self.actIdToScratchIdDic = {}
    LocalController:instance():visitTable("activity_scratch", function(id, lineData)
        local id = tonumber(lineData:getValue("id"))
        local activityId = tonumber(lineData:getValue("activity"))
        self.scratchIdToActIdDic[id] = activityId
        self.actIdToScratchIdDic[activityId] = id
    end)
end

function ScratchOffGameManager : GetActivityIdByScratchId(scratchId)
    return self.scratchIdToActIdDic[scratchId]
end

function ScratchOffGameManager : GetScratchIdByActivityId(activityId)
    return self.actIdToScratchIdDic[activityId]
end

function ScratchOffGameManager : InitScratchOffGameActivityTemplateData()
    self.activityTemplateList = {}
    self.activityIconRateList = {}
    LocalController:instance():visitTable("activity_scratch", function(id, lineData)
        local activityId = tonumber(lineData:getValue("activity"))
        local template = ScratchOffGameActivityTemplate.New()
        template:ParseData(lineData)
        self.activityTemplateList[activityId] = template
        
        local icon_rate = lineData:getValue("icon_rate")
        local spl_icon_rate = string.split_ss_array(icon_rate, "|")
        local iconRateList = {}
        iconRateList.totalRate = 0
        for k,v in pairs(spl_icon_rate) do
            local spl = string.split_ss_array(v, ";")
            local iconRate = {}
            iconRate.icon = string.format(LoadPath.UIScratchOffLuckyIcon, spl[1])
            iconRate.rate = tonumber(spl[2])
            iconRateList.totalRate = iconRateList.totalRate + iconRate.rate
            table.insert(iconRateList, iconRate)
        end
        self.activityIconRateList[activityId] = iconRateList
    end)
end

function ScratchOffGameManager : InitRewardItemInfoData()
    self.commonRewardItemInfosList = {}
    self.luckyRewardItemInfosList = {}
    LocalController:instance():visitTable("activity_scratch_para", function(id, lineData)
        local scratchId = tonumber(lineData:getValue("scratch_id"))
        local activityId = self:GetActivityIdByScratchId(scratchId)
        
        local rewardType =  tonumber(lineData:getValue("type")) -- 1 普通奖励 2 幸运奖励
        if rewardType == 1 then
            local commonInfoList = self:GetCommonRewardItemInfoListByActId(activityId)
            if commonInfoList == nil then
                commonInfoList = {}
            end
            local commonInfo = CommonRewardItemInfoTemplate.New()
            commonInfo:ParseData(lineData, activityId)
            table.insert(commonInfoList, commonInfo)
            self.commonRewardItemInfosList[activityId] = commonInfoList
        elseif rewardType == 2 then
            local luckyInfoList = self:GetLuckyRewardItemInfoListByActId(activityId)
            if luckyInfoList == nil then
                luckyInfoList = {}
            end
            local luckInfo = LuckyRewardItemInfoTemplate.New()
            luckInfo:ParseData(lineData, activityId)
            table.insert(luckyInfoList, luckInfo)
            self.luckyRewardItemInfosList[activityId] = luckyInfoList
        end
    end)
end

function ScratchOffGameManager : GetCommonRewardItemInfoListByActId(activityId)
    local info = self.commonRewardItemInfosList[activityId]
    return info
end

function ScratchOffGameManager : GetLuckyRewardItemInfoListByActId(activityId)
    local info = self.luckyRewardItemInfosList[activityId]
    return info
end

function ScratchOffGameManager : GetExtraRewardItemInfoByActId(activityId)
    local activityTemplate = self:GetActivityTemplate(activityId)
    local choose = self:GetSelectedHeroIndexByActId(activityId)
    local extraItemId = activityTemplate.extraRewardItemId[choose]
    local extraItemInfo = DataCenter.ItemTemplateManager:GetItemTemplate(extraItemId)
    extraItemInfo.count = activityTemplate.extraRewardItemNum[choose]
    return extraItemInfo
end

function ScratchOffGameManager : GetSelectedHeroIndexByActId(activityId)
    local activityParamInfo = self:GetActivityParamInfo(tonumber(activityId))
    local chooseHeroIndex = activityParamInfo.chooseIndex
    return chooseHeroIndex
end

function ScratchOffGameManager : GetActivityTemplate(activityId)
    local actId = tonumber(activityId)
    if self.activityTemplateList[actId] then
        return self.activityTemplateList[actId]
    end
    return nil
end

function ScratchOffGameManager : GetScratchOffRankBySpecialId(specialItemId)   --specialItemId 中奖id
    local level = tonumber(GetTableData("activity_scratch_para", specialItemId, "title"))
    local rank = ""
    if level == 1 then
        rank = Localization:GetString(372935)
    elseif level == 2 then
        rank = Localization:GetString(372936)
    elseif level == 3 then
        rank = Localization:GetString(372937)
    elseif level == 4 then
        rank = Localization:GetString(372938)
    elseif level == 5 then
        rank = Localization:GetString(372939)
    end
    return rank
end

function ScratchOffGameManager : GetScratchOffLuckyIconBySpecialId(specialItemId)   --specialItemId 中奖id
    local icon = GetTableData("activity_scratch_para", specialItemId, "icon")
    return string.format(LoadPath.UIScratchOffLuckyIcon, icon)
end

function ScratchOffGameManager : GetRecentLotteryRes()
    return self.recentLotteryResInfoList
end

function ScratchOffGameManager : GetRandomThreeLuckyIconPathByActId(activityId)
	local actId = tonumber(activityId)
    local iconRateList = self.activityIconRateList[actId]
    local totalRate = iconRateList.totalRate
    local indexList = {}
    for i = 1, 3 do
        local rate = math.random(1, totalRate) - 1
        local curRate = 0
        for k,v in ipairs(iconRateList) do
            local nextRate = curRate + v.rate
            if rate >= curRate and rate < nextRate then
                indexList[i] = k
                break
            else
                curRate = nextRate
            end
        end
    end
    while indexList[1] == indexList[2] and indexList[1] == indexList[3] do
        local rate = math.random(1, totalRate) - 1
        local curRate = 0
        for k,v in ipairs(iconRateList) do
            local nextRate = curRate + v.rate
            if rate >= curRate and rate < nextRate then
                indexList[3] = k
                break
            else
                curRate = nextRate
            end
        end
    end
    
    local iconPaths = {}
    table.insert(iconPaths, string.format(iconRateList[indexList[1]].icon))
    table.insert(iconPaths, string.format(iconRateList[indexList[2]].icon))
    table.insert(iconPaths, string.format(iconRateList[indexList[3]].icon))
    return iconPaths
end

function ScratchOffGameManager : GetFirstScratchOffResInfo(activityId)
    local choose = self:GetSelectedHeroIndexByActId(activityId)
    local firstResInfo = self.recentLotteryResInfoList[1]
    local info = {}
    info.icon1 = firstResInfo.iconPath1
    info.icon2 = firstResInfo.iconPath2
    info.icon3 = firstResInfo.iconPath3
    info.commonResItemInfo = firstResInfo.commonItemInfo.resItemInfo[math.min(choose, #firstResInfo.commonItemInfo.resItemInfo)]
    return info
end

function ScratchOffGameManager : GetRedPointCount(activityId)
    local count = 1
    local info = self:GetActivityParamInfo(activityId)
    if info and info.oneLotteryCount and info.oneLotteryCount > 0 then
        count = 0
    end
    return count
end

return ScratchOffGameManager