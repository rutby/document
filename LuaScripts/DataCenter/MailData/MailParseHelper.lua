--[[
	邮件复杂内容解析
	有些邮件的content比较复杂，可以解析出复杂内容
	这里使用惰性解析，第一次点击的时候才解析，然后缓存
]]


local MailParseHelper = {}
local base64 = require "Framework.Common.base64"
local MailBattleReport = require "DataCenter.MailData.DataExtModule.MailBattleReport"
local MailChampionBattleReport = require "DataCenter.MailData.DataExtModule.MailChampionBattleReport"
local MailScoutReport = require "DataCenter.MailData.DataExtModule.MailScoutReport"
local MailPickGarbage = require "DataCenter.MailData.DataExtModule.MailPickGarbage"
local MailExplore = require "DataCenter.MailData.DataExtModule.MailExplore"
local MailDestroyBuild = require "DataCenter.MailData.DataExtModule.MailDestroyBuild"
local MailDestroyRankList = require "DataCenter.MailData.DataExtModule.MailDestroyRankList"
local MailAllianceBuild = require "DataCenter.MailData.DataExtModule.MailAllianceBuild"
local MailMigrateApply = require "DataCenter.MailData.DataExtModule.MailMigrateApply"
local Localization = CS.GameEntry.Localization
local rapidjson = require "rapidjson"

-- 解析邮件内容
function MailParseHelper.ParseContent(mailData)
    -- if mailData.type == MailType.NEW_FIGHT then
    --     local ext = MailBattleReport.New()
    --     ext:ParseContent(mailData:GetMailSFSObj())
    --     return ext
    -- elseif mailData.type == MailType.MAIL_BOSS_REWARD then
    -- else
    --     return nil
    -- end
    if mailData.type == MailType.NEW_FIGHT or mailData.type == MailType.SHORT_KEEP_FIGHT_MAIL then
        local ext = MailBattleReport.New()
        ext:ParseContent(mailData:GetMailSFSObj())
        return ext
    elseif mailData.type == MailType.NEW_FIGHT_MINECAVE or mailData.type == MailType.NEW_FIGHT_ARENA then
        local ext = MailBattleReport.New()
        ext:SetMailType(mailData.type)
        ext:ParseContent(mailData:GetMailSFSObj())
        return ext
    elseif mailData.type == MailType.MAIL_BOSS_REWARD then

    elseif mailData.type == MailType.MAIL_SCOUT_RESULT then
        local ext = MailScoutReport.New()
        ext:ParseContent(mailData:GetMailSFSObj())
        return ext
    elseif mailData.type == MailType.MAIL_PICK_GARBAGE then
        local ext = MailPickGarbage.New()
        ext:ParseContent(mailData:GetMailSFSObj())
        return ext
    elseif mailData.type == MailType.MAIL_EXPLORE then
        local ext = MailExplore.New()
        ext:ParseContent(mailData:GetMailSFSObj())
        return ext
    elseif mailData.type == MailType.PLACE_ALLIANCE_BUILD_MAIL then
        local ext = MailAllianceBuild.New()
        ext:ParseContent(mailData:GetMailSFSObj())
        return ext
    elseif mailData.type == MailType.MIGRATE_APPLY then
        local ext = MailMigrateApply.New()
        ext:ParseContent(mailData:GetMailSFSObj())
        return ext
    elseif mailData.type == MailType.MARCH_DESTROY_MAIL then
        local ext = MailDestroyBuild.New()
        ext:ParseContent(mailData:GetMailSFSObj())
        return ext
    elseif mailData.type == MailType.ALLIANCE_CITY_RANK then
        local ext = MailDestroyRankList.New()
        ext:ParseContent(mailData:GetMailSFSObj())
        return ext
    elseif mailData.type == MailType.MAIL_ALCOMPETE_WEEK_REPORT then

    elseif mailData.type == MailType.RESOURCE_HELP_FROM or mailData.type == MailType.RESOURCE_HELP_TO or mailData.type == MailType.RESOURCE_HELP_FAIL then

    elseif mailData.type == MailType.MAIL_ALLIANCE_MARK_ADD then

    elseif mailData.type == MailType.ELITE_FIGHT_MAIL then
        local ext = MailChampionBattleReport.New()
        ext:ParseContent(mailData:GetMailSFSObj())
        return ext

    else
        return nil
    end
end

local function DecodeMessage(self, message)
    if (message == nil) then
        return ""
    end
    local decode = ""
    if message["text"] ~= nil then
        decode = self:DecodeText(message["text"])
    elseif message["dialog"] ~= nil then
        decode = self:DecodeDialog(message["dialog"])
    elseif message["worldAllianceCity"] ~= nil then
        decode = self:DecodeAllianceCity(message["worldAllianceCity"])
    elseif message["point"] ~= nil then
        decode = self:DecodePoint(message["point"])
    elseif message["url"] ~= nil then
        decode = self:DecodeUrl(message["url"])
    elseif message["user"] ~= nil then
        decode = self:DecodeUser(message["user"])
    elseif message["alliance"] ~= nil then
        decode = self:DecodeAlliance(message["alliance"])
    elseif message["monster"] ~= nil then
        decode = self:DecodeMonster(message["monster"])
    elseif message["percent"] ~= nil then
        decode = self:DecodePercent(message["percent"])
    elseif message["scout"] ~= nil then
        decode = self:DecodeScout(message["scout"])
    elseif message["dateTime"] ~= nil then
        decode = self:DecodeDateTime(message["dateTime"])
    elseif message["textWithParams"] ~= nil then
        decode = self:DecodeTextWithParams(message["textWithParams"])
    elseif message["integerWithSpearated"]~=nil then
        decode = self:DecodeIntegerWithSpearated(message["integerWithSpearated"])
    elseif message["minePlunderInfo"] then
        decode = self:DecodeMinePlunderInfo(message["minePlunderInfo"])
    elseif message["worldDesert"] then
        decode = self:DecodeWorldDesert(message["worldDesert"])
    elseif message["effect"] and message["effect"]["effectStr"] then
        decode = self:DecodeEffectValueText(message["effect"]["effectStr"])

    end
    local color = ""
    if message["color"] ~= nil then
        if message["color"] == "RED" then
            color = "red"
        elseif message["color"] == "GREEN" then
            color = "#63AE46"
        end
    end
    if string.IsNullOrEmpty(color) then
        return decode
    else
        return "<color=" .. color .. ">" .. decode .. "</color>"
    end
end

local function DecodeText(self, text)
    return text
end
local function DecodeIntegerWithSpearated(self,data)
    local num = data["value"]
    return string.GetFormattedSeperatorNum(num)
end

local function DecodeMinePlunderInfo(self, data)
    local userName = data.userName
    local rewardType = data.rewardType
    local itemId = data.itemId
    local plunderRewardNum = data.plunderRewardNum
    local resName = DataCenter.RewardManager:GetNameByType(rewardType, itemId)
    return Localization:GetString("302228", userName, plunderRewardNum, resName)
end

local function DecodeTextWithParams(self, data)
    local text = data["text"]
    if string.IsNullOrEmpty(text) then
        return ""
    end
    if not table.IsNullOrEmpty(data["params"]) then
        for k, v in pairs(data["params"]) do
            local param = self:DecodeMessage(v)
            if not string.IsNullOrEmpty(param) then
                text = string.gsub(text, "{" .. (k - 1) .. "}", param)
            end
        end
    end
    return text
end

local function DecodeAllianceCity(self, info)
    local id = info["id"] or 0
    local name = info["cityName"]or ""
    if name == nil or name =="" then
        name = GetTableData(TableName.WorldCity, id, "name")
        name = Localization:GetString(name)
    end
    return name
end

local function DecodeDialog(self, dialog)
    local dialogId = dialog["id"]
    if string.IsNullOrEmpty(dialogId) then
        return ""
    end
    local params = {}
    if not table.IsNullOrEmpty(dialog["params"]) then
        for _, v in pairs(dialog["params"]) do
            local param = self:DecodeMessage(v)
            if not string.IsNullOrEmpty(param) then
                table.insert(params, param)
            else
                table.insert(params, "")
            end
        end
    end
    if not table.IsNullOrEmpty(params) then
        return Localization:GetString(dialogId, SafeUnpack(params))
    else
        return Localization:GetString(dialogId)
    end
end

local function DecodePoint(self, point)
    local server = point["server"]
    local x = point["x"]
    local y = point["y"]
    local worldId = point["worldId"] or 0
    local text = ""
    if server == LuaEntry.Player:GetSelfServerId() then
        -- X:{0} Y:{1}
        text = Localization:GetString("310137", x, y)
    else
        -- {0}区 X:{1} Y:{2}
        if DataCenter.AccountManager:GetServerTypeByServerId(server) == ServerType.DRAGON_BATTLE_FIGHT_SERVER then
            text = Localization:GetString("376134", x, y)
        else
            text = Localization:GetString("128005", server, x, y)
        end
    end
    local link = {
        action = "Jump",
        server = server,
        worldId = worldId,
        x = x,
        y = y,
    }
    local json = rapidjson.encode(link)
    json = base64.encode(json)
    local ret = "<link=" .. json .. "><u>" .. text .. "</u></link>"
    return ret
end

local function DecodeUrl(self, url)
    local href = url["href"] or ""
    local text = url["text"] or href
    local link = {
        action = "Url",
        url = href
    }
    local json = rapidjson.encode(link)
    json = base64.encode(json)
    local ret = "<link=" .. json .. "><u>" .. text .. "</u></link>"
    return ret
end

local function DecodeUser(self, user)
    local abbr = user["abbr"] or ""
    local name = user["name"] or ""
    if string.IsNullOrEmpty(abbr) then
        return name
    end
    return "[" .. abbr .. "]" .. name
end

local function DecodeAlliance(self, alliance)
    local abbr = alliance["abbr"] or ""
    local name = alliance["name"] or ""
    return "[" .. abbr .. "]" .. name
end

local function DecodeMonster(self, monster)
    local id = monster["id"] or 0
    local level = DataCenter.MonsterTemplateManager:GetTableValue( id, "level")
    local name = DataCenter.MonsterTemplateManager:GetTableValue( id, "name")
    return Localization:GetString("310128", level, Localization:GetString(name))
end

local function DecodePercent(self, percent)
    if percent["intValue"] ~= nil then
        return percent["intValue"] .. "%"
    end
    if percent["doubleValue"] ~= nil then
        return string.format("%.2f", percent["doubleValue"]) .. "%"
    end
    return ""
end

local function DecodeScout(self, scout)
    -- {"target":"BASE","targetId":"400000"}
    -- {"target":"BULIDING","targetId":"403003"}
    if scout["target"] == "BASE" or scout["target"] == "MAIN_BUILDING" then
        return Localization:GetString("100618")
    elseif scout["target"] == "BUILDING" then
        return Localization:GetString(GetTableData(DataCenter.BuildTemplateManager:GetTableName(), scout["targetId"],"name"))
    elseif scout["target"] == "ARMY" then
        return Localization:GetString("300637")
    elseif scout["target"] == "ALLIANCE_CITY" then
        local name = scout["cityName"]or ""
        if name == nil or name =="" then
            name = GetTableData(TableName.WorldCity, scout["targetId"], "name")
            name = Localization:GetString(name)
        end
        return name
    elseif scout["target"] == "DESERT" then
        local name = scout["targetId"] or ""
        if not string.IsNullOrEmpty(name) then
            local nameId = GetTableData(TableName.Desert, scout["targetId"], "desert_name")
            name = Localization:GetString(nameId)
            local level = GetTableData(TableName.Desert, scout["targetId"], "desert_level")
            if level and level>0 then
                name = "Lv."..level..name
            else
                name = Localization:GetString("110245")
            end
        end
        return name
    end
    return ""
end

local function DecodeDateTime(self, time)
    if time['milliseconds'] ~= nil then
        return UITimeManager:GetInstance():TimeStampToTimeForLocal(time['milliseconds'])
    end
    if time['seconds'] ~= nil then
        return UITimeManager:GetInstance():TimeStampToTimeForLocal(time['seconds'])
    end
    return ""
end

local function DecodeWorldDesert(self,desert)
    local desertId = desert.id
    local nameId = GetTableData(TableName.Desert, desertId, "desert_name")
    local name = Localization:GetString(nameId)
    local level = GetTableData(TableName.Desert, desertId, "desert_level")
    if level and level>0 then
        name = "Lv."..level..name
    else
        name = Localization:GetString("110245")
    end
    return name
end

local function DecodeEffectValueText(self, valueText)
    if string.IsNullOrEmpty(valueText) then
        return ""
    end
    local effectVec = string.split(valueText, "|")
    if effectVec == nil or #effectVec == 0 then
        return ""
    end
    local result = ""
    local totalNum = #effectVec
    for i = 1, totalNum do
        local vec = string.split(effectVec[i], ";")
        if table.count(vec) == 2 then
            local effectId = toInt(vec[1])
            local value = vec[2]
            local nameStr = GetTableData(TableName.EffectNumDesc, effectId, 'des')
            local name = Localization:GetString(nameStr)
            local type = toInt(GetTableData(TableName.EffectNumDesc, effectId, 'type'))
            local addValue = DecorationUtil.GetEffectNumWithType(value, type)
            result = result..name..addValue
            --if i < totalNum then
                result = result.."\n"
            --end
        end
    end
    return result
end

MailParseHelper.DecodeEffectValueText = DecodeEffectValueText
MailParseHelper.DecodeAllianceCity = DecodeAllianceCity
MailParseHelper.DecodeMessage = DecodeMessage
MailParseHelper.DecodeText = DecodeText
MailParseHelper.DecodeTextWithParams = DecodeTextWithParams
MailParseHelper.DecodeMinePlunderInfo = DecodeMinePlunderInfo
MailParseHelper.DecodeDialog = DecodeDialog
MailParseHelper.DecodePoint = DecodePoint
MailParseHelper.DecodeUrl = DecodeUrl
MailParseHelper.DecodeUser = DecodeUser
MailParseHelper.DecodeAlliance = DecodeAlliance
MailParseHelper.DecodeMonster = DecodeMonster
MailParseHelper.DecodePercent = DecodePercent
MailParseHelper.DecodeScout = DecodeScout
MailParseHelper.DecodeDateTime = DecodeDateTime
MailParseHelper.DecodeIntegerWithSpearated =DecodeIntegerWithSpearated
MailParseHelper.DecodeWorldDesert = DecodeWorldDesert
return MailParseHelper
