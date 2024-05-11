---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2023/3/14 15:40
---

local SeasonWeekTemplate = BaseClass("SeasonWeekTemplate")

local function __init(self)
    self.id = 0
    self.season = 0
    self.startDay = 0
    self.endDay = 0
    self.packId = ""
    self.name = ""
    self.activities = {} -- List<{ type, id, icon }>
    self.show = { icon = "", title = {}, desc = {} }
    self.icon = ""
end

local function __delete(self)
    self.id = nil
    self.season = nil
    self.startDay = nil
    self.endDay = nil
    self.packId = nil
    self.name = nil
    self.activities = nil
    self.show = nil
    self.icon = nil
end

local function InitData(self,row)
    if row == nil then
        return
    end

    self.id = tonumber(row:getValue("id")) or 0
    self.season = tonumber(row:getValue("season")) or 0
    local dayStr = tostring(row:getValue("season_begin_time")) or ""
    local daySpls = string.split(dayStr, ",")
    if #daySpls == 2 then
        self.startDay = tonumber(daySpls[1])
        self.endDay = tonumber(daySpls[2])
    end
    self.packId = tostring(row:getValue("season_week_exchange")) or ""
    self.name = tostring(row:getValue("name")) or ""
    self.activities = {}
    local activityStr = tostring(row:getValue("activity")) or ""
    for _, str in ipairs(string.split(activityStr, "|")) do
        local spls = string.split(str, ";")
        if #spls == 3 then
            local activity =
            {
                type = tonumber(spls[1]),
                id = spls[2],
                icon = spls[3],
            }
            table.insert(self.activities, activity)
        end
    end
    local showStr = tostring(row:getValue("show")) or ""
    local showSpls = string.split(showStr, ";")
    self.show =
    {
        icon = showSpls[1] or "",
        title = string.split(showSpls[2] or "", "|"),
        desc = string.split(showSpls[3] or "", "|"),
    }
    self.icon = tostring(row:getValue("icon")) or ""
end

local function GetEndTime(self)
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local zeroTime = UITimeManager:GetInstance():GetTodayZeroServerTime(curTime // 1000) * 1000
    local day = DataCenter.SeasonDataManager:GetSeasonDurationDay() + 1
    return zeroTime + (self.endDay - day + 1) * 86400000
end

SeasonWeekTemplate.__init = __init
SeasonWeekTemplate.__delete = __delete
SeasonWeekTemplate.InitData = InitData

SeasonWeekTemplate.GetEndTime = GetEndTime

return SeasonWeekTemplate