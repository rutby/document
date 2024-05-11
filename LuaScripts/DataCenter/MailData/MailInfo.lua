--[[
	邮件基础信息
	这个数据基本上就是服务器下发的数据
	但是在其基础上又加了一些扩展字段，这个可能是老代码翻译过来的

	saveFlag = 移至保存邮箱 0-未保存 1-已保存 2-在普通邮箱里删除后 变为2 则以后不会在普通邮箱里出现

	邮件中这几个ext前缀的可能是因为历史原因存在的，我们这里先保留，以后不一定用
	"extParam1",
	"extParam2"
]]

local MailInfo = BaseClass("MailInfo")
local MailParseHelper = require "DataCenter.MailData.MailParseHelper"
local rapidjson = require "rapidjson"

-- 邮件只保存这些基本数据即可
local function __init(self)

    self.uid = ""
    self.toUser = ""
    self.fromUser = ""
    self.fromName = ""
    self.title = ""
    self.subTitle = ""
    self.contents = ""
    self.status = 0 --读取状态
    self.type = 0
    self.createTime = 0
    self.rewardStatus = 1 -- 0-未领取 1-已领取(没有奖励 此项也存1)
    self.rewardTime = 0
    self.itemIdFlag = 0
    self.groupId = -1
    self.translateMsg = nil
    self.translatedLang = nil
    self.expireTime = 0

    self.__ext = nil    -- 邮件扩展信息

    self.channelId = ""
    self.tabType = 0
    
    self.custom = ""
    self.customTb = nil
    self.isChat = false -- 被分享到聊天
    
    self.isReport = 0 --MailIsReportType 特殊类型 目前用于72类型，可扩展
end

local function __delete(self)

    self.uid = nil
    self.contents = nil
    self.title = nil
    self.subTitle = nil
    self.fromName = nil
    self.fromUser = nil
    self.status = nil --读取状态
    self.type = nil
    self.createTime = 0
    self.rewardStatus = nil
    self.rewardTime = nil
    self.itemIdFlag = nil
    self.groupId = nil
    self.translateMsg = nil
    self.translatedLang = nil
    self.expireTime = nil
    
    self.__ext = nil

    self.channelId = nil
    self.tabType = nil

    self.custom = nil
    self.customTb = nil
    self.isChat = nil
    
    self.isReport = nil
end

-- 解析网络数据
local function ParseBaseData(self, info)
    if table.IsNullOrEmpty(info) then
        return
    end

    self.uid = info.uid
    self.toUser = info.toUser

    --self.title = info.title
    --self.subTitle = info.subTitle
    --self.contents = info.contents

    self.fromName = info.fromName
    self.fromUser = info.fromUser

    self.type = info.type
    self.status = info.status

    self.createTime = info.createTime
    self.itemIdFlag = info.itemIdFlag
    self.translateMsg = info.translateMsg
    self.translatedLang = info.translatedLang
    self.expireTime = info.expireTime
    self.isReport = info.isReport

    if info.saveFlag and info.saveFlag ~= 0 then
        self.saveFlag = info.saveFlag
    end

    -- contentsArr是因为字符串有个最大长度
    self.title = info.title
    self.originTitle = info.title

    self.custom = info.custom
    
    local contents
    if info["contentsArr"] ~= nil then
        local contentsArr = info["contentsArr"]
        contents = string.join(contentsArr)
    elseif info["contentsLocal"] ~= nil then
        contents = info["contentsLocal"]
    else
        contents = info["contents"]
    end
    self.contents = contents

    if not string.IsNullOrEmpty(info.translationId) then
        self.translationId = info.translationId
    end

    -- 奖励相关的
    if not string.IsNullOrEmpty(info.rewardId) then
        self.rewardId = info.rewardId
    end

    -- 这两个值貌似一般都带。。。
    self.rewardStatus = info.rewardStatus
    self.rewardTime = info.rewardTime

end

local function ParseMailData(self, message)

    self.ParseBaseData(self, message)
    self.SetMailChannel(self)
end
local function SetMailChannel(self)

    if self.type == MailType.MAIL_SCOUT_RESULT or self.type == MailType.NEW_FIGHT or self.type == MailType.SHORT_KEEP_FIGHT_MAIL
            or self.type == MailType.NEW_COLLECT_MAIL or self.type == MailType.MAIL_BOSS_REWARD 
            or self.type == MailType.MAIL_ALCOMPETE_WEEK_REPORT or self.type == MailType.RESOURCE_HELP_FROM or self.type == MailType.MONSTER_COLLECT_REWARD
            or self.type == MailType.RESOURCE_HELP_TO or self.type == MailType.RESOURCE_HELP_FAIL or self.type == MailType.MAIL_ALLIANCE_MARK_ADD or self.type == MailType.CHALLENGE_BOSS_REWARD 
            or self.type == MailType.COLLECT_OVER_FLOW_MAIL or self.type == MailType.NEW_FIGHT_BLACK_KNIGHT or self.type == MailType.NEW_FIGHT_EXPEDITIONARY_DUEL then
        self.tabType = MailChannelType.Mail_Channel_Fight
    elseif self.type == MailType.GIFT_BUY_EXCHANGE then
        self.tabType = MailChannelType.Mail_Channel_System
    elseif self.type == MailType.COLLECT_ADDITION_REWARD then
        self.tabType = MailChannelType.Mail_Channel_System
    elseif self.type == MailType.MAIL_PRESIDENT_SEND or self.type == MailType.MAIL_ALLIANCE_ALL or self.type == MailType.MAIL_USER or self.type == MailType.MAIL_PRESIDENT_SEND then
        self.tabType = MailChannelType.Mail_Channel_Chat
    elseif self.type == MailType.MAIL_SELF_SEND then
        self.tabType = MailChannelType.Mail_Channel_Self
    else
        self.tabType = MailChannelType.Mail_Channel_System
    end
end

local function SetMailRead(self)
    if self.status ~= 1 then
        self.status = 1
    end
end

--设置isReport
local function SetMailReport(self,value)
    if self.isReport ~= value then
        self.isReport = value
    end
end

-- tabHeader.h.title
-- tabHeader.h.subTitle
local function GetMailHeader(self)
    if (self.tabHeader == nil) then
        self.tabHeader = rapidjson.decode(self.title) or {}
    end
    return self.tabHeader
end

-- tabBody.b.content
-- tabBody.b.pay
-- tabBody.b.reward
-- tabBody.b.user_info
-- tabBody.obj
local function GetMailBody(self)
    if (self.tabBody == nil) then
        self.tabBody = rapidjson.decode(self.contents) or {}
    end
    return self.tabBody
end

local function GetBattleContent(self)
    local tabBody = self:GetMailBody()
    if tabBody.obj ~= nil then
        return tabBody.obj.battleContent or ""
    end
    return ""
end

local function GetScoutContent(self)
    local tabBody = self:GetMailBody()
    if tabBody.obj ~= nil then
        return tabBody.obj.scoutContent or ""
    end
    return ""
end

local function GetMailCustom(self)
    if not self.customTb then
        self.customTb = rapidjson.decode(self.custom) or {}
    end
    return self.customTb
end

local function GetMailTitle(self)
    self:GetMailHeader()
    if (type(self.tabHeader) == "number") then
        return "老版本"
    end
    if self.tabHeader["h"] == nil then
        return "老版本"
    end
    if (self.tabHeader["h"] ~= nil) then
        return MailParseHelper:DecodeMessage(self.tabHeader["h"]["title"])
    else
        return ""
    end
end

local function GetMailSubTitle(self)
    self:GetMailHeader()
    if (type(self.tabHeader) == "number") then
        return "老版本"
    end
    if self.tabHeader["h"] == nil then
        return "老版本"
    end
    if (self.tabHeader["h"] ~= nil) then
        return MailParseHelper:DecodeMessage(self.tabHeader["h"]["subTitle"])
    else
        return ""
    end
end

local function GetMailMessage(self)
    self:GetMailBody()
    if (type(self.tabBody) == "number") then
        return "老版本"
    end
    if self.tabBody["b"] == nil then
        return "老版本"
    end
    if self.isChat then
        if self.type == MailType.MAIL_SCOUT_ALERT then
            return MailShowHelper.GetMailContent_ScoutAlert(self)
        end
    end
    return MailParseHelper:DecodeMessage(self.tabBody["b"]["content"])
end

local function GetMailMessageTranslated(self)
    return self.translateMsg
end

-- Smartfox 对象
local function GetMailSFSObj(self)
    self:GetMailBody()
    if (type(self.tabBody) == "number") then
        return "老版本"
    end
    if self.tabBody["obj"] == nil then
        return "老版本"
    end
    return self.tabBody["obj"]
end

local function GetMailPay(self)
    self:GetMailBody()
    if self.tabBody["b"] == nil then
        return nil
    end
    return self.tabBody["b"]["pay"]
end

local function GetMailReward(self)
    self:GetMailBody()
    if self.tabBody["b"] == nil then
        return nil
    end
    local reward = self.tabBody["b"]["reward"]
    if reward~=nil and reward["rewardInfo"]~=nil then
        local rewardInfo = reward["rewardInfo"]
        local showReward = {}
        for k,v in pairs(rewardInfo) do
            local needInsert = true
            if #showReward>0 then
                for i=1, #showReward do
                    if needInsert == true then
                        local data = showReward[i]
                        if data["type"] == v["type"] then
                            local itemId = data["id"]
                            if itemId~=nil and itemId~=0 and itemId~="" then
                                if itemId == v["id"] then
                                    data["num"] = data["num"]+v["num"]
                                    needInsert = false
                                end
                            else
                                data["num"] = data["num"]+v["num"]
                                needInsert = false
                            end
                        end
                    end
                end
            end
            if needInsert then
                table.insert(showReward,v)
            end
        end
        reward["rewardInfo"] = showReward
    end
    return reward
end

-- 特殊邮件显示个人信息
local function GetMailUserInfo(self)
    self:GetMailBody()
    if self.tabBody["b"] == nil then
        return nil
    end
    return self.tabBody["b"]["userInfo"]
end

-- 获取邮件的扩展信息
-- 如果邮件还没有解析的话，就解析一下
local function GetMailExt(self)
    if self.__ext == nil then
        self.__ext = MailParseHelper.ParseContent(self)
    end
    return self.__ext
end

-- 是否可以手动领奖
local function CanClaimReward(self)
    return self.rewardStatus == 0
end

MailInfo.__init = __init
MailInfo.__delete = __delete
MailInfo.ParseBaseData = ParseBaseData
MailInfo.ParseMailData = ParseMailData
MailInfo.SetMailChannel = SetMailChannel
MailInfo.SetMailRead = SetMailRead
MailInfo.SetMailReport = SetMailReport
MailInfo.GetMailTitle = GetMailTitle
MailInfo.GetMailSubTitle = GetMailSubTitle
MailInfo.GetMailMessage = GetMailMessage
MailInfo.GetMailReward = GetMailReward
MailInfo.GetMailPay = GetMailPay
MailInfo.GetMailUserInfo = GetMailUserInfo
MailInfo.GetMailSFSObj = GetMailSFSObj
MailInfo.GetMailExt = GetMailExt
MailInfo.GetMailHeader = GetMailHeader
MailInfo.GetMailBody = GetMailBody
MailInfo.GetBattleContent = GetBattleContent
MailInfo.GetScoutContent = GetScoutContent
MailInfo.GetMailCustom = GetMailCustom
MailInfo.CanClaimReward = CanClaimReward
MailInfo.GetMailMessageTranslated = GetMailMessageTranslated

return MailInfo


