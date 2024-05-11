---
--- Created by shimin.
--- DateTime: 2023/1/31 11:50
--- 士兵死亡记录管理器
---
local DeadArmyRecordManager = BaseClass("DeadArmyRecordManager")
local DeadArmyRecordData = require "DataCenter.ArmyManager.DeadArmyRecordData"
local Localization = CS.GameEntry.Localization
local Setting = CS.GameEntry.Setting

function DeadArmyRecordManager:__init()
    self.deadRecords = {}--士兵的死亡记录
    self.readRecordTime = 0--上一次查看死亡记录的时间，存在setting中，有没有红点拿数据时间和这个时间比大小
end

function DeadArmyRecordManager:__delete()
    self.deadRecords = {}--士兵的死亡记录
    self.readRecordTime = 0--上一次查看死亡记录的时间，存在setting中，有没有红点拿数据时间和这个时间比大小
end

function DeadArmyRecordManager:Startup()
end

function DeadArmyRecordManager:InitReadRecordTime()
    local deadTime = Setting:GetPrivateString(SettingKeys.DEAD_ARMY_READ_TIME, "")
    if deadTime == "" then
        self.readRecordTime = 0
    else
        self.readRecordTime = tonumber(deadTime)
    end
end

function DeadArmyRecordManager:GetDeadArmyRecord()
    return self.deadRecords
end

function DeadArmyRecordManager:SendGetDeadArmyRecord()
    SFSNetwork.SendMessage(MsgDefines.GetDeadArmyRecord)
end

function DeadArmyRecordManager:GetDeadArmyRecordHandle(message)
    if message["errorCode"] == nil then
        local records = message["records"]
        if records ~= nil then
            self.deadRecords = {}
            for k, v in ipairs(records) do
                local one = DeadArmyRecordData.New()
                one:UpdateInfo(v)
                if not one:NeedDelete() then
                    table.insert(self.deadRecords, one)
                end
            end
            if self.deadRecords[2] ~= nil then
                table.sort(self.deadRecords, function(a,b) 
                    return b.time < a.time
                end)
            end
            EventManager:GetInstance():Broadcast(EventId.RefreshDeadArmyRecord)
        end
    else
        UIUtil.ShowTips(Localization:GetString(message["errorCode"]))
    end
end

function DeadArmyRecordManager:IsShowRedDot()
    return self:GetReadRecordTime() < self:GetRecordTime()
end

function DeadArmyRecordManager:GetRecordTime()
    if self.deadRecords[1] ~= nil then
        return self.deadRecords[1].time
    end
    return 0
end

function DeadArmyRecordManager:GetReadRecordTime()
    return self.readRecordTime
end

function DeadArmyRecordManager:SetReadRecordTime()
    local time = 0
    if self.deadRecords[1] ~= nil then
        time = self.deadRecords[1].time
    end
    if self.readRecordTime ~= time then
        self.readRecordTime = time
        Setting:SetPrivateString(SettingKeys.DEAD_ARMY_READ_TIME, tostring(time))
        EventManager:GetInstance():Broadcast(EventId.RefreshDeadArmyRecordRedDot)
    end
end

function DeadArmyRecordManager:GetDeadArmyRecordTotalNum()
    local result = 0
    for k,v in ipairs(self.deadRecords) do
        result = result + v:GetTotalNum()
    end
    return result
end

--是否有死亡记录
function DeadArmyRecordManager:HasDeadArmyRecord()
    return self.deadRecords[1] ~= nil
end

return DeadArmyRecordManager
