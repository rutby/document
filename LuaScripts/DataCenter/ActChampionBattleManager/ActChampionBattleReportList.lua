---
--- Activity/Model/ActChampionBattle/ActChampionBattleReportList
--- Create by Terry - 2021/12/8 16:32:36
--- 冠军对决--战报列表
---  

---@class ActChampionBattleReportList
local ActChampionBattleReportList = BaseClass("ActChampionBattleReportList")

local function __init(self)

end

local function __delete(self)

end

local function ParseServerData(self, message)
    if message == nil then
        return
    end

    self.fightResult = {};
    self.fightersInfo = {};

    if message["fightList"] ~= nil then
        local fightList = message["fightList"];
        for i = 1, #fightList do
            self.fightResult[i] = {};

            if fightList[i]["phase"] ~= nil then
                self.fightResult[i]["phase"] = fightList[i]["phase"]
            end
            if fightList[i]["uuid"] ~= nil then
                self.fightResult[i]["uuid"] = fightList[i]["uuid"]
            end
            if fightList[i]["round"] ~= nil then
                self.fightResult[i]["round"] = fightList[i]["round"]
            end
            if fightList[i]["type"] ~= nil then
                --0 海选  1:8进4  2:4进2  3：决赛
                self.fightResult[i]["type"] = fightList[i]["type"]
            end
            if fightList[i]["loseUid"] ~= nil then
                self.fightResult[i]["loseUid"] = fightList[i]["loseUid"]
            end
            if fightList[i]["winUid"] ~= nil then
                self.fightResult[i]["winUid"] = fightList[i]["winUid"]
            end
            if fightList[i]["uid1"] ~= nil then
                self.fightResult[i]["uid1"] = fightList[i]["uid1"]
            end
            if fightList[i]["uid2"] ~= nil then
                self.fightResult[i]["uid2"] = fightList[i]["uid2"]
            end
            if fightList[i]["score"] ~= nil then
                self.fightResult[i]["score"] = fightList[i]["score"]
            end
            if fightList[i]["reportId"] ~= nil then
                self.fightResult[i]["reportId"] = fightList[i]["reportId"]
            end
            if fightList[i]["winScore"] ~= nil then
                self.fightResult[i]["winScore"] = fightList[i]["winScore"]
            else
                self.fightResult[i]["winScore"] = 0
            end
            if fightList[i]["winRecord"] ~= nil then
                self.fightResult[i]["winRecord"] = fightList[i]["winRecord"]
            else
                self.fightResult[i]["winRecord"] = ""
            end
        end

        local fightRoles = message["fightRoles"];
        for i = 1, #fightRoles do
            self.fightersInfo[i] = {};

            if fightRoles[i]["uid"] ~= nil then
                self.fightersInfo[i]["uid"] = fightRoles[i]["uid"]
            end
            if fightRoles[i]["name"] ~= nil then
                self.fightersInfo[i]["name"] = fightRoles[i]["name"]
            end
            if fightRoles[i]["serverId"] ~= nil then
                self.fightersInfo[i]["serverId"] = fightRoles[i]["serverId"]
            end
            if fightRoles[i]["abbr"] ~= nil then
                self.fightersInfo[i]["abbr"] = fightRoles[i]["abbr"]
            end
            if fightRoles[i]["pic"] ~= nil then
                self.fightersInfo[i]["pic"] = fightRoles[i]["pic"]
            end
            if fightRoles[i]["picver"] ~= nil then
                self.fightersInfo[i]["picver"] = fightRoles[i]["picver"]
            end
            if fightRoles[i]["score"] ~= nil then
                self.fightersInfo[i]["score"] = fightRoles[i]["score"]
            end
            if fightRoles[i]["rank"] ~= nil then
                self.fightersInfo[i]["rank"] = fightRoles[i]["rank"]
            end
            if fightRoles[i]["headFrame"] ~= nil then
                self.fightersInfo[i]["headFrame"] = fightRoles[i]["headFrame"]
            end

        end
    end
end

local function GetBattleReportCount(self)
    if self.fightResult == nil then
        return 0;
    else
        return #self.fightResult;
    end
end

ActChampionBattleReportList.__init = __init
ActChampionBattleReportList.__delete = __delete
ActChampionBattleReportList.ParseServerData = ParseServerData
ActChampionBattleReportList.GetBattleReportCount = GetBattleReportCount

return ActChampionBattleReportList