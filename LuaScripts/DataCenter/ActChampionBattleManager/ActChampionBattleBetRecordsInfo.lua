---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Remodify yixing - 2022/1/4 20:04:56
--- 冠军对决--info活动
---  

---@class ActChampionBattleBetRecordsInfo
local ActChampionBattleBetRecordsInfo = BaseClass("ActChampionBattleBetRecordsInfo")

local function __init(self)
    self.type = 0
    self.playerInfo = nil
    self.time = 0
    self.oneBetCount = 0
    self.odds = 0
    self.state = 0
    self.totalWinCount = 0
    self.phase = 0
    self.location = 0
end

local function parseServerData(type , player, record, state)
    --下注状态0未结束，1已结束
    self.state = state
    --对应不同的UIItem
    self.type = type
    self.playerInfo = player
    if type == 1 or type == 3 then
        self.time = record.time
        self.oneBetCount = record.oneBetCount
        self.odds = record.odds
    elseif type == 2 then
        self.totalWinCount = record
    end
end

ActChampionBattleBetRecordsInfo.__init = __init
ActChampionBattleBetRecordsInfo.parseServerData = parseServerData

return ActChampionBattleBetRecordsInfo