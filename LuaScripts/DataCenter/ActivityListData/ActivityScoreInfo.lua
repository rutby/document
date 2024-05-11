--- Created by yixing
--- DateTime: 2020/03/08 14:42
---类似于军备类型活动，积分活动基础类，同样继承自ActivityInfo，对应新增枚举ActivityEventType
---
---
--------------------------------------------------------
--local ActivityInfo = require "DataCenter.ActivityListData.ActivityInfoData"

---@class ActivityScoreInfo 
local ActivityScoreInfo = BaseClass("ActivityScoreInfo", ActivityInfoData)
local base = ActivityInfoData

local function __init(self)
    base.__init(self)
    self.siegeST = nil
    self.siegeET = nil
    self.exchange = nil
    self.vsAllianceInfo = nil
    self.winReward = nil
end
local function __delete(self)
    self.siegeST = nil
    self.siegeET = nil
    self.exchange = nil
    self.vsInfos = nil
    self.vsAllianceList = nil
    self.winReward = nil
    base.__delete(self)
end


local function parseServerData(self, activity)
    base.ParseActivityData(self,activity)
    if activity ==nil then
        return
    end
    -- printInfo("aaaa打印事件积分活动"..self.id)
    if activity["siegeST"] ~= nil then
        self.siegeST = activity["siegeST"]
    end
    if activity["siegeET"] ~= nil then
        self.siegeET = activity["siegeET"]
    end
    if activity["exchange"] ~= nil then
        self.exchange = activity["exchange"] 
    end
    if activity["activityid"] ~= nil then        
        self.activityid = activity["activityid"]
        -- printInfo("打印积分活动2="..self.activityid)
    end
    --如果finish有值，进入活动周结算状态
    --联盟对决主界面入口，是否开启使用接口
    if activity["finish"] ~= nil then        
        self.finish = activity["finish"]
    end

end

ActivityScoreInfo.__init = __init
ActivityScoreInfo.__delete = __delete
ActivityScoreInfo.parseServerData = parseServerData
return ActivityScoreInfo