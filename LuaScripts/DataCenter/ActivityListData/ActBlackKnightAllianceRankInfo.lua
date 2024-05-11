--- Created by shimin.
--- DateTime: 2023/3/6 20:36
--- 黑骑士活动联盟杀怪排行数据

local ActBlackKnightAllianceRankInfo = BaseClass("ActBlackKnightAllianceRankInfo")

function ActBlackKnightAllianceRankInfo:__init()
    self.abbr = ""--联盟简称 string  
    self.allianceName = 0--联盟名字 string  
    self.score = 0--分数 long  
    self.rank = 0--排名 int
    self.icon = ""--联盟图标 string
    self.allianceId = ""--联盟id
end

function ActBlackKnightAllianceRankInfo:__delete()
    self.abbr = ""--联盟简称 string  
    self.allianceName = 0--联盟名字 string  
    self.score = 0--分数 long  
    self.rank = 0--排名 int
    self.icon = ""--联盟图标 string
    self.allianceId = ""--联盟id
end

function ActBlackKnightAllianceRankInfo:ParseInfo(message)
    if message["abbr"] ~= nil then
        self.abbr = message["abbr"]
    end
    if message["allianceName"] ~= nil then
        self.allianceName = message["allianceName"]
    end
    if message["score"] ~= nil then
        self.score = message["score"]
    end
    if message["rank"] ~= nil then
        self.rank = message["rank"]
    end
    if message["icon"] ~= nil then
        self.icon = message["icon"]
    end
    if message["allianceId"] ~= nil then
        self.allianceId = message["allianceId"]
    end
end

return ActBlackKnightAllianceRankInfo