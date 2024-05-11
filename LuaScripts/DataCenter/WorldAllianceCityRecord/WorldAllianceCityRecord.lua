---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2023/9/25 20:40
---
local WorldAllianceCityRecord = BaseClass("WorldAllianceCityRecord")

local function __init(self)
    self.uuid = 0
    self.cityId = 0
    self.recordTime = 0
    self.rankList = 0
    self.selfRank = IntMaxValue
    self.selfScore = 0
    self.recordState = AllianceCityRecordState.HISTORY
end

local function __delete(self)
    self.uuid = 0
    self.cityId = 0
    self.recordTime = 0
    self.rankList = 0
end

local function ParseData(self, message)
    if message ==nil then
        return
    end
    if message["uuid"]~=nil then
        self.uuid = message["uuid"]
    end
    if message["cityId"]~=nil then
        self.cityId = message["cityId"]
    end
    if message["recordTime"]~=nil then
        self.recordTime = message["recordTime"]
    end
    if message["state"]~=nil then
        self.recordState = message["state"]
    end
    if message["rankArr"] then
        self.rankList = {}
        local list = message["rankArr"]
        for i = 1 ,table.count(list) do
            local param = {}
            param.serverId = list[i].serverId
            param.country = list[i].country
            param.headSkinET = list[i].headSkinET
            param.monthCardEndTime = list[i].monthCardEndTime
            param.pic = list[i].pic
            param.picVer = list[i].picVer
            param.uid = list[i].uid
            param.headSkinId = list[i].headSkinId
            param.name = list[i].name
            param.rank = list[i].rank
            param.score = list[i].point
            if param.uid == LuaEntry.Player.uid then
                self.selfRank = list[i].rank
                self.selfScore = param.score
            end
            table.insert(self.rankList,param)
        end
    end
end


WorldAllianceCityRecord.__init = __init
WorldAllianceCityRecord.__delete = __delete
WorldAllianceCityRecord.ParseData = ParseData

return WorldAllianceCityRecord