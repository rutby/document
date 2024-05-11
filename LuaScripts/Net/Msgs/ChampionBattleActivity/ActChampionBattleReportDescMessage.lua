---
--- Created by Terry.
--- DateTime: 2021/12/08 15:17
--- 冠军对决-请求战报详细信息
---
local ActChampionBattleReportDescMessage = BaseClass("ActChampionBattleReportDescMessage", SFSBaseMessage)
local base = SFSBaseMessage
local MailInfo = require "DataCenter.MailData.MailInfo"
local Localization = CS.GameEntry.Localization

local function OnCreate(self, type, reportId)
    base.OnCreate(self)
    self.sfsObj:PutLong("type", type)
    self.sfsObj:PutUtfString("reportId", reportId)
end

local function HandleMessage(self, message)
    base.HandleMessage(self, message)
    if message.errorCode ~= nil then
        UIUtil.ShowTipsId(message.errorCode)
        return
    end

    local mailInfo = MailInfo.New()

    message.contents = "{\"b\":{},\"obj\":{\"battleContent\":\""..message.content.."\"}}"
    message.type = MailType.ELITE_FIGHT_MAIL
    message.title = "{\"h\":{}}"
    message.uid = 0
    mailInfo:ParseBaseData(message)
    local mailExt = mailInfo:GetMailExt()
    local version = mailExt:GetVersion()
    if version==nil or version<=0 then
        UIUtil.ShowTipsId(390843)
        return
    end
    if mailExt.showRoundList == nil or table.count(mailExt.showRoundList) == 0 then
        local name = ""
        local selfName = ""
        local otherName = ""
        local selfHas = false
        local otherHas = false
        table.walk(mailExt._fightRoundList, function (_, v)
            if v._otherInfo and string.IsNullOrEmpty(otherName) then
                otherName = v._otherInfo.name
            end
            if v._selfInfo and string.IsNullOrEmpty(selfName) then
                selfName = v._selfInfo.name
            end
            local _otherArmyResult = v._otherArmyResult
            if _otherArmyResult ~= nil and _otherArmyResult._armyObj ~= nil and _otherArmyResult._armyObj._tHeroes ~= nil and table.count(_otherArmyResult._armyObj._tHeroes) > 0  then
                otherHas = true
            end
            local _selfArmyResult = v._selfArmyResult
            if _selfArmyResult ~= nil and _selfArmyResult._armyObj ~= nil and _selfArmyResult._armyObj._tHeroes ~= nil and table.count(_selfArmyResult._armyObj._tHeroes) > 0  then
                selfHas = true
            end
        end)
        if not selfHas then
            name = selfName
        elseif not otherHas then
            name = otherName
        end

        UIUtil.ShowTips(Localization:GetString("302132", name))
        mailInfo = nil
    end
    if UIManager:GetInstance():IsWindowOpen(UIWindowNames.LFChampionBattleFight) then
        EventManager:GetInstance():Broadcast(EventId.ChampionBattleReportDataBack, mailInfo)
    else
        if mailInfo ~= nil then
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIShareMail, NormalBlurPanelAnim,mailInfo)
        end
    end
end

ActChampionBattleReportDescMessage.OnCreate = OnCreate
ActChampionBattleReportDescMessage.HandleMessage = HandleMessage

return ActChampionBattleReportDescMessage