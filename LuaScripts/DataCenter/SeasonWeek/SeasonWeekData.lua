---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2023/3/14 17:08
---

local SeasonWeekData = BaseClass("SeasonWeekData")

local function __init(self)
    self.buffRecords = {} -- List<id>
    self.rewardStatus = 0
    self.needNum = 0
    self.reward = {}
end

local function ParseServerData(self, serverData)
    if serverData["buffRecord"] then
        self.buffRecords = {}
        local strs = string.split(serverData["buffRecord"], "|")
        for _, str in ipairs(strs) do
            table.insert(self.buffRecords, tonumber(str))
        end
    end
    if serverData["rewardStatus"] then
        self.rewardStatus = serverData["rewardStatus"]
    end
    if serverData["needNum"] then
        self.needNum = serverData["needNum"]
    end
    if serverData["reward"] then
        self.reward = serverData["reward"]
    end
end

local function HasBuff(self)
    local template = DataCenter.SeasonWeekManager:GetCurTemplate()
    return template and table.hasvalue(self.buffRecords, template.id)
end

local function CanReceive(self)
    return #self.buffRecords >= self.needNum and self.rewardStatus == 0
end

SeasonWeekData.__init = __init
SeasonWeekData.__delete = __delete

SeasonWeekData.ParseServerData = ParseServerData
SeasonWeekData.HasBuff = HasBuff
SeasonWeekData.CanReceive = CanReceive

return SeasonWeekData