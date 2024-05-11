---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2021/9/8 21:24
---
local repaidJson = require "rapidjson"
local MailExplore = BaseClass("MailExplore")

local function _init(self)
    self.result = 1--0 胜利  1 失败
    self.userUid = ""
    self.userName = ""
    self.userPic = ""
    self.userPicVer = 0
    self.allianceAbbr = ""

    self.enemyPointX = 0
    self.enemyPointY = 0
    self.enemyPointServerId = 0

    self.attackerPointX = 0
    self.attackerPointY = 0
    self.attackerPointServerId = 0

    self.totalDamage = 0
    self.showTotalDamage = 0
    self.eventId = 0
    self.heroInfos = {}
end

local function GetHeroExpAddInfo(self)
    local totalRewardExpArr = {}
    for _, hero in pairs(self.heroInfos) do
        if hero.expAdd > 0 then
            local heroId = hero.heroId
            if (totalRewardExpArr[heroId] == nil) then
                totalRewardExpArr[heroId] = {}
            end
            totalRewardExpArr[heroId].expAdd = hero.expAdd
            totalRewardExpArr[heroId].heroId = heroId
            totalRewardExpArr[heroId].level = hero.heroLevel
            totalRewardExpArr[heroId].nowExp = hero.nowExp
            totalRewardExpArr[heroId].oldExp = hero.oldExp
            totalRewardExpArr[heroId].oldLevel = hero.oldLevel
        end
    end
    return totalRewardExpArr
end

local function ParseContent(self, mailContent)
    self._jsonContent = mailContent
    if (table.IsNullOrEmpty(self._jsonContent)) then
        return
    end
    self.result = self._jsonContent["result"] or 1

    local userInfo = self._jsonContent["userInfo"]
    if userInfo ~= nil then
        self.userUid = userInfo["uid"] or ""
        self.userName = userInfo["name"] or ""
        self.userPic = userInfo["pic"] or ""
        self.userPicVer = userInfo["picVer"] or 0
        self.allianceAbbr = userInfo["allianceAbbr"] or ""
    end

    local enemyPointInfo = self._jsonContent["enemyPointInfo"]
    if enemyPointInfo ~= nil then
        self.enemyPointX = enemyPointInfo["x"] or 0
        self.enemyPointY = enemyPointInfo["y"] or 0
        self.enemyPointServerId = enemyPointInfo["serverId"] or 0
    end

    local selfPointInf = self._jsonContent["selfPointInfo"]
    if selfPointInf ~= nil then
        self.attackerPointX = selfPointInf["x"] or 0
        self.attackerPointY = selfPointInf["y"] or 0
        self.attackerPointServerId = selfPointInf["serverId"] or 0
    end
    
    local enemyInfos = self._jsonContent["enemyInfo"]

    if enemyInfos ~= nil then
        self.enemyInfo = {}
        self.enemyInfo["initHealth"] = enemyInfos["initHealth"]
        self.enemyInfo["health"] = enemyInfos["health"]
    end
    
    self.heroInfos = {}
    local heroInfos = self._jsonContent["heroInfos"]
    local maxDamage = 0
    if heroInfos ~= nil then
        local damage = 0
        table.walk(heroInfos, function (_, v) 
            local hero = {}
            if v["heroId"] ~= nil then
                hero.heroId = v["heroId"] or 0
                hero.heroLevel = v["heroLevel"] or 0
                hero.heroQuality = v["heroQuality"] or 0
                hero.heroUid = v["uuid"] or 0
                hero.damage = v["damage"] or 0
                hero.nowExp = v["nowExp"] or 0
                hero.expAdd = v["expAdd"] or 0
                hero.oldLevel = v["oldLevel"] or 1
                hero.oldExp = v["oldExp"] or 0
                damage = damage + hero.damage
                if hero.damage > maxDamage then
                    maxDamage = hero.damage
                end
                table.insert(self.heroInfos, hero)
            end
        end)
        self.totalDamage = damage
    end

    self.showTotalDamage = math.max(maxDamage, 0.7 * self.totalDamage)

    self.eventId = self._jsonContent["eventId"] or 0
end

local function GetName(self)
    local name = DataCenter.DetectEventTemplateManager:GetRealName(self.eventId)
    if name ~= nil then
        return name
    end
    return ""
end

local function GetUserName(self)
    if self.allianceAbbr == nil or self.allianceAbbr == "" then
        return self.userName
    end
    return "[".. self.allianceAbbr.."]"..self.userName
end

local function GetExploreWin(self)
    return self.result == 0
end

MailExplore._init = _init
MailExplore.GetHeroExpAddInfo = GetHeroExpAddInfo
MailExplore.ParseContent = ParseContent
MailExplore.GetName = GetName
MailExplore.GetExploreWin = GetExploreWin
MailExplore.GetUserName = GetUserName

return MailExplore