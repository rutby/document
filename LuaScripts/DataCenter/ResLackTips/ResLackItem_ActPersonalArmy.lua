---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zzl.
--- DateTime:
---

--[[
军备
]]

local ResLackItemBase = require "DataCenter.ResLackTips.ResLackItemBase"
local ResLackItem_ActPersonalArmy = BaseClass("ResLackItem_ActPersonalArmy", ResLackItemBase)

function ResLackItem_ActPersonalArmy:CheckIsOk( _resType, _needCnt )
    self.index = nil
    self.actId = nil
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local list = DataCenter.ActivityListDataManager:GetNowActivityList()
    local temp = {}
    for i, v in pairs(list) do
        if v.type == ActivityEnum.ActivityType.Arms then
            if v.endTime > curTime and (v.personalEventType == nil or v.personalEventType ~= PersonalEventType.Permanent)  then  --常驻军备不单独显示
                table.insert(temp,v)
            end
        end
    end
    if temp[1] ~= nil then
        if temp[2] ~= nil then
            table.sort(temp,function(a,b)
                return tonumber(a.activityId) < tonumber(b.activityId)
            end)
        end
       
        for _ ,v in ipairs(temp) do
            local eventInfo = DataCenter.ActPersonalArmsInfo:GetEventInfo(v.activityId)
            if eventInfo == nil then
                return
            end
            local all = #eventInfo.targetList
            for i = 1 ,all, 1 do
                local isShow = true
                for k = 1, #eventInfo.hasRewardList, 1 do
                    if tonumber(eventInfo.hasRewardList[k]) == i then
                        isShow = false
                    end
                end
                if isShow then
                    local reward = eventInfo.targetReward[tonumber(eventInfo.targetList[i])]
                    if reward then
                        self.actId = v.id
                        self.index = i
                        return true
                    end
                end
            end
        end
    end
    return false
end

function ResLackItem_ActPersonalArmy:TodoAction()
    GoToUtil.GoActWindow(tonumber(self.actId),self.index)
    
end

return ResLackItem_ActPersonalArmy


