---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2023/10/17 20:50
---

local WatchAdManager = BaseClass("WatchAdManager")
local WatchAdData = require "DataCenter.WatchAd.WatchAdData"
local WatchAdTemplate = require "DataCenter.WatchAd.WatchAdTemplate"

local WatchCd = 30000

local function __init(self)
    self.templateDict = {}
    self.dataDict = {}
    self.lastWatchTime = 0

    if LocalController:instance():getTable(TableName.WatchAd) ~= nil then
        LocalController:instance():visitTable(TableName.WatchAd, function(id, lineData)
            local template = WatchAdTemplate.New()
            template:InitData(lineData)
            self.templateDict[id] = template
        end)
    end
    
    self:AddListeners()
end

local function __delete(self)
    self:RemoveListeners()
end

local function AddListeners(self)
    
end

local function RemoveListeners(self)
    
end

local function Enabled(self)
    if LuaEntry.DataConfig:CheckSwitch("watch_ad_aps_shop") then
        if CS.SDKManager.IS_UNITY_EDITOR() or CS.SDKManager.IS_UNITY_ANDROID() or CS.SDKManager.IS_UNITY_IOS() then
            return true
        end
    end
    return false
end

local function GetTemplate(self, id)
    return self.templateDict[tonumber(id)]
end

local function GetTemplateByLocation(self, location)
    for _, template in ipairs(self.templateDict) do
        if template.location == location then
            return template
        end
    end
    return nil
end

local function GetData(self, id)
    local template = self:GetTemplate(id)
    if template and template:HasAd() then
        return self.dataDict[tonumber(id)]
    end
end

local function GetDataByLocation(self, location)
    for _, data in ipairs(self.dataDict) do
        local template = self:GetTemplate(data.id)
        if template and template:HasAd() and template.location == location then
            return data
        end
    end
    return nil
end

local function ParseServerData(self, serverData)
    local id = serverData.id
    local data = self:GetData(id)
    if data == nil then
        data = WatchAdData.New()
    end
    data:ParseServerData(serverData)
    self.dataDict[tonumber(id)] = data
end

local function IsWatching(self)
    local curTime = UITimeManager:GetInstance():GetServerTime()
    return curTime - self.lastWatchTime < WatchCd
end

local function Watch(self, id)
    if self:IsWatching() then
        return
    end
    local curTime = UITimeManager:GetInstance():GetServerTime()
    self.lastWatchTime = curTime
    
    local template = self:GetTemplate(id)
    if template == nil or not template:HasAd() then
        return
    end
    
    if CS.SDKManager.IS_UNITY_EDITOR() then
        self:WatchFinish(id)
    else
        local adId,adv = template:GetAdId()
        if not string.IsNullOrEmpty(adId) then
            if adv == "unity" then
                DataCenter.UnityAdsManager:ShowRewarded(adId, tostring(id))
            elseif adv == "google" then
                DataCenter.GoogleAdsManager:ShowRewarded(adId, tostring(id))
            end
            
        end
    end
end

local function WatchFinish(self, id)
    if id == nil then
        return
    end
    
    local template = self:GetTemplate(id)
    if template == nil or not template:HasAd() then
        return
    end
    
    self:SendReceive(id)
end

local function WatchFail(self, id)
    if id == nil then
        return
    end

    local template = self:GetTemplate(id)
    if template == nil or not template:HasAd() then
        return
    end

    self.lastWatchTime = 0
    UIUtil.ShowTipsId(120289)
    EventManager:GetInstance():Broadcast(EventId.WatchAdFail)
end

local function SetRedTime(self, id)
    local curTime = UITimeManager:GetInstance():GetServerTime()
    Setting:SetPrivateString("WATCH_AD_TIME_" .. id, tostring(curTime))
    EventManager:GetInstance():Broadcast(EventId.RefreshWelfareRedDot)
end

local function CanShowRed(self, id)
    local data = self:GetData(id)
    local template = self:GetTemplate(id)
    if data and template and template:HasAd() then
        local time = tonumber(Setting:GetPrivateString("WATCH_AD_TIME_" .. id, "0"))
        local curTime = UITimeManager:GetInstance():GetServerTime()
        local sameDay = UITimeManager:GetInstance():IsSameDayForServer(curTime // 1000, time // 1000)
        if not sameDay then
            return true
        end
    end
    return false
end

local function CanShowRedByLocation(self, location)
    local template = self:GetTemplateByLocation(location)
    if template then
        return self:CanShowRed(template.id)
    end
    return false
end

local function SendReceive(self, id)
    SFSNetwork.SendMessage(MsgDefines.ReceiveWatchAdReward, tonumber(id))
end

local function HandleInit(self, message)
    if message["watchAdArr"] then
        for _, serverData in ipairs(message["watchAdArr"]) do
            self:ParseServerData(serverData)
        end
    end
end

local function HandleReceive(self, message)
    local delay = CS.SDKManager.IS_UNITY_EDITOR() and 1 or 0.01
    TimerManager:GetInstance():DelayInvoke(function()
        self.lastWatchTime = 0
        if message["reward"] then
            for _, v in pairs(message["reward"]) do
                DataCenter.RewardManager:AddOneReward(v)
            end
            DataCenter.RewardManager:ShowCommonReward(message)
        end
        if message["watchAd"] then
            self:ParseServerData(message["watchAd"])
        end
        EventManager:GetInstance():Broadcast(EventId.WatchAdReceive)
    end, delay)
end

WatchAdManager.__init = __init
WatchAdManager.__delete = __delete
WatchAdManager.AddListeners = AddListeners
WatchAdManager.RemoveListeners = RemoveListeners

WatchAdManager.Enabled = Enabled
WatchAdManager.GetTemplate = GetTemplate
WatchAdManager.GetTemplateByLocation = GetTemplateByLocation
WatchAdManager.GetData = GetData
WatchAdManager.GetDataByLocation = GetDataByLocation
WatchAdManager.ParseServerData = ParseServerData
WatchAdManager.IsWatching = IsWatching
WatchAdManager.Watch = Watch
WatchAdManager.WatchFinish = WatchFinish
WatchAdManager.WatchFail = WatchFail
WatchAdManager.SetRedTime = SetRedTime
WatchAdManager.CanShowRed = CanShowRed
WatchAdManager.CanShowRedByLocation = CanShowRedByLocation

WatchAdManager.SendReceive = SendReceive

WatchAdManager.HandleInit = HandleInit
WatchAdManager.HandleReceive = HandleReceive

return WatchAdManager