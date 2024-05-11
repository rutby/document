---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zzl.
--- DateTime: 
---
local ActSevenLoginData = BaseClass("ActSevenLoginData")
local ActSevenLoginInfo = require "DataCenter.ActivityListData.ActSevenLogin.ActSevenLoginInfo"

local function __init(self)
    self.list = {}
    self.isShow = true
end

local function __delete(self)
    self.list = nil
end

local function SetActivityId(self,id)
    self.list[tonumber(id)] = {}
end

local function ParseActivityData(self, dayActsMessage)
    if dayActsMessage ==nil then
        return
    end
    if self.list[dayActsMessage["activityId"]] then
        local info = ActSevenLoginInfo.New()
        if dayActsMessage["dayArr"] then
            local dayActs = dayActsMessage["dayArr"]
            info:ParseLoginActs(dayActs)
        end
        if dayActsMessage["lastReceiveTime"] then
            info:ParseLastTime(dayActsMessage["lastReceiveTime"])
        end
        self.list[dayActsMessage["activityId"]] = info
        if self.isShow then
            local actId =  self:CheckActLogin()
            if actId then
                local curTime = UITimeManager:GetInstance():GetServerTime()
                if dayActsMessage["lastReceiveTime"] == 0 or not UITimeManager:GetInstance():IsSameDayForServer(curTime // 1000, dayActsMessage["lastReceiveTime"] // 1000) then
                    DataCenter.UIPopWindowManager:Push(UIWindowNames.UISevenLogin, { anim = true, UIMainAnim = UIMainAnimType.AllHide, isBlur = true },actId)
                end
            end
            self.isShow = false
        end
    end
    EventManager:GetInstance():Broadcast(EventId.OnRefreshSevenLogin)
end

--领取阶段奖励
local function GetRewardState(self,message)
    if message ==nil then
        return
    end
    if message["reward"] ~= nil then
        for k,v in pairs(message["reward"]) do
            DataCenter.RewardManager:AddOneReward(v)
        end
    end
    DataCenter.RewardManager:ShowCommonReward(message)
    if self.list[message["activityId"]] and next(self.list[message["activityId"]]) then
        self.list[message["activityId"]]:SetDayState(message["day"])
        if message["lastReceiveTime"] then
            self.list[message["activityId"]]:ParseLastTime(message["lastReceiveTime"])
        end
        EventManager:GetInstance():Broadcast(EventId.OnRefreshSevenLogin)
    end
end

local function GetInfoByActId(self,activityId)
    if self.list[activityId] then
        return self.list[activityId]
    end
    return nil
end

--主界面是否显示活动
local function CheckActLogin(self)
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local mainLv = DataCenter.BuildManager.MainLv
    if self.list and next(self.list) then
        for i ,v in pairs(self.list) do
            if v.loginReward and next(v.loginReward) then
                local actListData = DataCenter.ActivityListDataManager:GetActivityDataById(tostring(i))
                --检查活动是否过期还存在
                if actListData then
                    --检查结束时间和等级
                    if curTime < actListData.endTime and curTime > actListData.startTime and actListData.needMainCityLevel <= mainLv then
                        --检查领取次数
                        for k ,n in pairs(v.loginReward) do
                            if n.state == 0 then
                                return i
                            end
                        end
                    end
                end
            end
        end
    end
    return false
end


ActSevenLoginData.__init = __init
ActSevenLoginData.__delete = __delete
ActSevenLoginData.SetActivityId = SetActivityId
ActSevenLoginData.ParseActivityData = ParseActivityData
ActSevenLoginData.GetInfoByActId = GetInfoByActId
ActSevenLoginData.GetRewardState = GetRewardState
ActSevenLoginData.CheckActLogin = CheckActLogin
return ActSevenLoginData