---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by guqu.
--- DateTime: 2020/9/3 16:15
---
local AllianceRankData = BaseClass("AllianceRankData")

local function __init(self)
    self.uid = ""
    self.name = ""
    self.allianceAbbr = ""
    self.allianceName = ""
    self.power =0
    self.kill = 0
    self.rank = 0
    self.type = RankType.None
    self.icon = ""
    self.country = DefaultNation
end

local function __delete(self)
    self.uid = nil
    self.name = nil
    self.allianceAbbr = nil
    self.allianceName = nil
    self.power = nil
    self.kill = nil
    self.rank = nil
    self.type = nil
    self.icon = nil
    self.country = nil
end
local function ParseData(self, message,type)
    self.type =type
    if message ==nil then
        return
    end
    if message["uid"]~=nil  then
        self.uid = message["uid"]
    end
    if message["leader"]~=nil  then
        self.name = message["leader"]
    end
    if message["abbr"]~=nil  then
        self.allianceAbbr = message["abbr"]
    end
    if message["alliancename"]~=nil  then
        self.allianceName = message["alliancename"]
    end
    if message["fightpower"]~=nil  then
        self.power = message["fightpower"]
    end
    if message["armyKill"]~=nil  then
        self.kill = message["armyKill"]
    end
    if message["icon"] ~= nil then
        self.icon = message["icon"]
    end
    if message["country"] then
        self.country = message["country"]
    end
end
local function SetRank(self,rank)
    self.rank = rank
end

local function GetCountryFlagTemplate(self)
    local country = string.IsNullOrEmpty(self.country) and DefaultNation or self.country
    return DataCenter.NationTemplateManager:GetNationTemplate(country)
end

AllianceRankData.__init = __init
AllianceRankData.__delete = __delete
AllianceRankData.ParseData = ParseData
AllianceRankData.SetRank = SetRank
AllianceRankData.GetCountryFlagTemplate = GetCountryFlagTemplate
return AllianceRankData