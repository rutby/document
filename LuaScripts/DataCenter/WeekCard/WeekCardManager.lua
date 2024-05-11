---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2022/5/11 17:12
---WeekCardManager


local WeekCardManager = BaseClass("WeekCardManager")
local Localization = CS.GameEntry.Localization
local WeekCardData = require "DataCenter.WeekCard.WeekCardData"

local function __init(self)
    self.weekCardList= {}
    self.lastRecvFreeTime = 0
    self.cacheCustomRewards = nil--{id, rewardStr}
    self:AddListener()
end

local function __delete(self)
    self.weekCardList = nil
    self.cacheCustomRewards = nil
    self:RemoveListener()
end

local function AddListener(self)
    --EventManager:GetInstance():AddListener(EventId.GarbageCollectStart, self.ShowExploringTime)
end

local function RemoveListener(self)
    --EventManager:GetInstance():RemoveListener(EventId.GarbageCollectStart, self.ShowExploringTime)
end

local function InitData(self)
    SFSNetwork.SendMessage(MsgDefines.GetWeekCardList)
end

local function UpdateWeekCardList(self, tb)
    for i, v in ipairs(tb) do
        self:UpdateOneWeekCard(v, true)
    end
    EventManager:GetInstance():Broadcast(EventId.OnWeekCardInfoChange)
    EventManager:GetInstance():Broadcast(EventId.RefreshWelfareRedDot)
end

local function UpdateOneWeekCard(self, t, notBroadcast)
    local isExist = false
    for i, v in ipairs(self.weekCardList) do
        if v.id == t.id then
            v:ParseData(t)
            if self.cacheCustomRewards and self.cacheCustomRewards.id == t.id then
                DataCenter.WeekCardManager:SelectCustomRewardsReq(self.cacheCustomRewards.id, self.cacheCustomRewards.rewardStr)
                self.cacheCustomRewards = nil
            end
            isExist = true
            break
        end
    end
    if not isExist then
        local newCard = WeekCardData.New()
        newCard:ParseData(t)
        table.insert(self.weekCardList, newCard)
    end
    
    if not notBroadcast then
        EventManager:GetInstance():Broadcast(EventId.OnWeekCardOneInfoChange, t.id)
        EventManager:GetInstance():Broadcast(EventId.RefreshWelfareRedDot)
    end
end

local function UpdateWeekCardFreeReward(self, t)
    if t.lastRewardTime then
        self.lastRecvFreeTime = t.lastRewardTime
    end
    EventManager:GetInstance():Broadcast(EventId.RefreshWelfareRedDot)
end

local function CheckIfHasFreeReward(self)
    local serverTimeS = UITimeManager:GetInstance():GetServerSeconds()
    local lastT = math.modf(self.lastRecvFreeTime / 1000)
    return not UITimeManager:GetInstance():IsSameDayForServer(serverTimeS, lastT)
end

--{id, rewardStr}
local function SetSelectedRewards(self, tb)
    self.cacheCustomRewards = tb
end


local function GetWeekCardList(self)
    local serverTime = UITimeManager:GetInstance():GetServerTime()
    table.sort(self.weekCardList, function(a, b)
        local isBoughtA = a.endTime > serverTime
        local isBoughtB = b.endTime > serverTime
        if isBoughtA ~= isBoughtB then
            return isBoughtA
        else
            return a.order < b.order
        end
    end)
    return self.weekCardList
end

local function CheckIfHasRed(self)
    local serverTime = UITimeManager:GetInstance():GetServerTime()
    local serverSec = UITimeManager:GetInstance():GetServerSeconds()
    local total = 0
    for i, v in ipairs(self.weekCardList) do
        if v.endTime > serverTime then
            if v.typeFunction == 2 and string.IsNullOrEmpty(v.selectedGoods) then
                total = total + 1
            elseif not UITimeManager:GetInstance():IsSameDayForServer(serverSec, math.modf(v.lastRecvTime / 1000)) then
                total = total + 1
            end
        end
    end

    if self:CheckIfHasFreeReward() then
        total = total + 1
    end
    
    return total > 0, total
end

local function SelectCustomRewardsReq(self, id, str)
    SFSNetwork.SendMessage(MsgDefines.SetWeekCardCustomRewards, id, str)
end

local function OnRecvSelectedCustomRewards(self, msg)
    local id = msg["id"]
    for i, v in ipairs(self.weekCardList) do
        if v.id == id then
            v.selectedGoods = msg["selectGoods"]
            break
        end
    end

    EventManager:GetInstance():Broadcast(EventId.OnWeekCardCustomRewardUpdate, id)
end


WeekCardManager.__init = __init
WeekCardManager.__delete = __delete

WeekCardManager.AddListener = AddListener
WeekCardManager.RemoveListener = RemoveListener

WeekCardManager.InitData = InitData
WeekCardManager.GetWeekCardList = GetWeekCardList
WeekCardManager.UpdateWeekCardList = UpdateWeekCardList
WeekCardManager.UpdateOneWeekCard = UpdateOneWeekCard
WeekCardManager.CheckIfHasRed = CheckIfHasRed
WeekCardManager.SelectCustomRewardsReq = SelectCustomRewardsReq
WeekCardManager.OnRecvSelectedCustomRewards = OnRecvSelectedCustomRewards
WeekCardManager.UpdateWeekCardFreeReward = UpdateWeekCardFreeReward
WeekCardManager.CheckIfHasFreeReward = CheckIfHasFreeReward
WeekCardManager.SetSelectedRewards = SetSelectedRewards

return WeekCardManager