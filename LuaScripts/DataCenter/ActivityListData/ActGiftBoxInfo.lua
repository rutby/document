---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zzl.
--- DateTime: 
---
local ActGiftBoxInfo = BaseClass("ActGiftBoxInfo")
local ActGolloesCardRankInfo = require "DataCenter.ActivityListData.ActGolloesCardRankInfo"

local function __init(self)
    self.activityId = 0 --活动id
    self.oneLotteryCount = 0 --今日单抽次数
    self.fiveLotteryCount = 0 --今日5连抽次数
    self.lastResetTime = 0 --上次重置世界，用来判断跨天
    self.giftBoxs = {}  --宝箱信息
    self.lotteryList = {} --所有宝箱信息
    self.selfScore = 0  --自己的积分
    self.selfRank = 0 --自己的排名
    self.rankList = {}
    self.rankRewardArr = {}
end

local function __delete(self)
    self.activityId = nil
    self.oneLotteryCount = nil
    self.fiveLotteryCount = nil
    self.lastResetTime = nil
    self.giftBoxs = nil
    self.lotteryList = nil
    self.selfScore = 0 
    self.selfRank = 0 
    self.rankList = {}
    self.rankRewardArr = {}
end

local function ParseInfo(self, message)
    if message==nil then
        return
    end
    if message["activityId"] then
        self.activityId = message["activityId"]
    end
    if message["oneLotteryCount"] then
        self.oneLotteryCount = message["oneLotteryCount"]
    end
    if message["fiveLotteryCount"] then
        self.fiveLotteryCount = message["fiveLotteryCount"]
    end
    if message["lastResetTime"] then
        self.lastResetTime = message["lastResetTime"]
    end
    if message["giftBoxs"] then
        for i = 1 ,table.count(message["giftBoxs"]) do
            self.giftBoxs[i] = {}
            self.giftBoxs[i].uuid = message["giftBoxs"][i].uuid     	    --宝箱uuid
            self.giftBoxs[i].expireTime = message["giftBoxs"][i].expireTime --宝箱过期时间
            self.giftBoxs[i].itemId = message["giftBoxs"][i].itemId         --activity_boxopen_para 配置表的Id
        end
    end
end

--fiveLottery  是否5连抽 1是 0否
local function RefreshCount(self,fiveLottery)
    if fiveLottery == 1 then
        self.fiveLotteryCount = self.fiveLotteryCount + 1
    else
        self.oneLotteryCount = self.oneLotteryCount + 1
    end
end

local function ParseGiftBox(self,message)
    if message["newGiftBoxs"] then
        for i = 1 ,table.count(message["newGiftBoxs"]) do
            local param = {}
            param.uuid = message["newGiftBoxs"][i].uuid
            param.expireTime = message["newGiftBoxs"][i].expireTime
            param.itemId = message["newGiftBoxs"][i].itemId
            table.insert(self.giftBoxs,param)
        end
    end
end

local function RefreshBox(self,uuid)
    if self.giftBoxs then
        for i = 1 ,table.count(self.giftBoxs) do
            if self.giftBoxs[i].uuid == uuid then
                table.remove(self.giftBoxs,i)
                break
            end
        end
    end
end

--获取今日宝箱抽取次数
local function ParseLotteryCount(self,message)
    if message["lotteryCounts"] then
        self.lotteryList = {}
        local lotteryCounts = message["lotteryCounts"]
        for i = 1 ,table.count(lotteryCounts) do
            local param = {}
            param.count = lotteryCounts[i].count   --今日抽取次数
            param.itemId = lotteryCounts[i].itemId
            table.insert(self.lotteryList,param)
        end
    end
end

--获取总抽取次数
local function CompareAllNum(self)
    return self.fiveLotteryCount * 5 + self.oneLotteryCount
end

--获取红点：免费剩余次数
local function GetActRed(self)
    local template = DataCenter.ActGiftBoxData:GetActTemplateByActId(tonumber(self.activityId))
    if template then
        if self.oneLotteryCount < template.cost_1_free then
            return template.cost_1_free - self.oneLotteryCount
        end
    end
    return 0
end

--{{{排行榜
--排行榜信息
local function ParseRankInfo(self,message)
    if message["selfScore"] then
        self.selfScore = message["selfScore"]
    end
    if message["selfRank"] then
        self.selfRank = message["selfRank"]
    end
    if message["rankList"] and next(message["rankList"]) then
        for i = 1 ,#message["rankList"] do
            local info = ActGolloesCardRankInfo.New()
            info:ParseRankInfo(message["rankList"][i])
            self.rankList[i] = info
        end
    end
    if message["rankRewardArr"] and next(message["rankRewardArr"]) then
        for i = 1 ,#message["rankRewardArr"] do
            self.rankRewardArr[i] = {}
            self.rankRewardArr[i].reward = DataCenter.RewardManager:ReturnRewardParamForView(message["rankRewardArr"][i]["reward"])
            self.rankRewardArr[i].startN = message["rankRewardArr"][i]["start"]
            self.rankRewardArr[i].endN = message["rankRewardArr"][i]["end"]
        end
    end
end
--获取排行榜信息
local function GetRankList(self)
    return self.rankList
end
--获取排行榜奖励
local function GetRewardArr(self)
    return self.rankRewardArr
end
--}}}


ActGiftBoxInfo.__init = __init
ActGiftBoxInfo.__delete = __delete
ActGiftBoxInfo.ParseInfo = ParseInfo
ActGiftBoxInfo.RefreshCount = RefreshCount
ActGiftBoxInfo.ParseGiftBox = ParseGiftBox
ActGiftBoxInfo.RefreshBox = RefreshBox
ActGiftBoxInfo.ParseLotteryCount = ParseLotteryCount
ActGiftBoxInfo.CompareAllNum = CompareAllNum
ActGiftBoxInfo.GetActRed = GetActRed
ActGiftBoxInfo.ParseRankInfo = ParseRankInfo
ActGiftBoxInfo.GetRankList = GetRankList
ActGiftBoxInfo.GetRewardArr = GetRewardArr
return ActGiftBoxInfo