---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2023/2/28 16:47
---

local GloryActVsData = BaseClass("GloryActVsData")

local function __init(self)
    self.allianceId = ""
    self.serverId = 0
    self.alName = ""
    self.alIcon = ""
    self.abbr = ""
    self.score = 0
    self.attack = 0
    self.territoryLoseTime = 0
    self.territoryNumber = 0
    self.territoryScoreAdd = 0
    self.fightMember = 0
    self.occupy = 0 -- 占领土地数量
    self.crashwb = 0 -- 摧毁世界建筑数量
    self.crashtc = 0 -- 摧毁联盟中心数量
    self.placeAssemble = 0 -- 建造前沿阵地数量
    self.isWin = 0 -- 1: 胜利
    self.mvp =
    {
        uid = "",
        score = 0,
        name = "",
        headSkinId = 0,
        headSkinET = 0,
        sex = SexType.None,
    }
end

local function ParseServerData(self, serverData)
    if serverData.allianceId then
        self.allianceId = serverData.allianceId
    end
    if serverData.serverId then
        self.serverId = serverData.serverId
    end
    if serverData.alName then
        self.alName = serverData.alName
    end
    if serverData.alIcon then
        self.alIcon = serverData.alIcon
    end
    if serverData.abbr then
        self.abbr = serverData.abbr
    end
    if serverData.score then
        self.score = serverData.score
    end
    if serverData.attack then
        self.attack = serverData.attack
    end
    if serverData.territoryLoseTime then
        self.territoryLoseTime = serverData.territoryLoseTime
    end
    if serverData.territoryNumber then
        self.territoryNumber = serverData.territoryNumber
    end
    if serverData.territoryScoreAdd then
        self.territoryScoreAdd = serverData.territoryScoreAdd
    end
    if serverData.fightMember then
        self.fightMember = serverData.fightMember
    end
    if serverData.occupy then
        self.occupy = serverData.occupy
    end
    if serverData.crashwb then
        self.crashwb = serverData.crashwb
    end
    if serverData.crashtc then
        self.crashtc = serverData.crashtc
    end
    if serverData.placeAssemble then
        self.placeAssemble = serverData.placeAssemble
    end
    if serverData.isWin then
        self.isWin = serverData.isWin
    end
    if serverData.mvp then
        self.mvp = serverData.mvp
    end
end

local function HasMvp(self)
    return self.mvp and not string.IsNullOrEmpty(self.mvp.uid)
end

GloryActVsData.__init = __init

GloryActVsData.ParseServerData = ParseServerData
GloryActVsData.HasMvp = HasMvp

return GloryActVsData