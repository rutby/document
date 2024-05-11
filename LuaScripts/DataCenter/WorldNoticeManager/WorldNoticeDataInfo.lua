---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zzl.
--- DateTime: 
---
local WorldNoticeDataInfo = BaseClass("WorldNoticeDataInfo")
local rapidjson = require "rapidjson"
local MailParseHelper = require "DataCenter.MailData.MailParseHelper"
function WorldNoticeDataInfo:__init()
    self.uuid= nil              --long 唯一id
    self.noticeId = nil         --公告标识
    self.createTime = nil       --公告创建时间
    self.status = nil           --是否已读  0未读 1已读
    self.rewardStatus = nil     --是否领奖 0未领 1已领
    self.title = nil            --str json格式与邮件一致
    self.content = nil          --str json格式与邮件一致
    self.subTitle = nil             
    self.showType = ""         --分类名称;分类排序
    self.translateMsg = ""      --翻译
end

function WorldNoticeDataInfo:__delete()
    self.uuid= nil
    self.noticeId = nil
    self.createTime = nil
    self.status = nil
    self.rewardStatus = nil
    self.title= nil
    self.content = nil
    self.subTitle = nil
    self.showType = ""
    self.translateMsg = ""
end

function WorldNoticeDataInfo:UpdateDataInfo(message)
    if message==nil then
        return
    end

    if message["uuid"]~=nil then
        self.uuid = message["uuid"]
    end
    if message["noticeId"]~=nil then
        self.noticeId = message["noticeId"]
    end
    if message["createTime"]~=nil then
        self.createTime = message["createTime"]
    end
    if message["status"] then
        self.status = message["status"]
    end
    if message["rewardStatus"]~=nil then
        self.rewardStatus = message["rewardStatus"]
    end
    if message["title"]~=nil then
        local title = rapidjson.decode(message["title"]) or {}
        if (title["h"] ~= nil) then
            self.title = MailParseHelper:DecodeMessage(title["h"]["title"])
        else
            self.title =  ""
        end
    end

    if message["content"]~=nil then
        self.content = rapidjson.decode(message["content"]) or {}
    end
    self.subTitle = ""
    
    local reward = self:GetMailReward()
    if not reward then
        self.rewardStatus = 1
    end

    if message["showType"] then
        self.showType = message["showType"]
    end
end

function WorldNoticeDataInfo:GetMailMessage()
    return MailParseHelper:DecodeMessage(self.content["b"]["content"])
end

function WorldNoticeDataInfo:GetMailPay()
    if self.content["b"] == nil then
        return nil
    end
    return self.content["b"]["pay"]
end

function WorldNoticeDataInfo:GetMailReward()
    if self.content["b"] == nil then
        return nil
    end
    local reward = self.content["b"]["reward"]
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
function WorldNoticeDataInfo:GetMailUserInfo()
    if self.content["b"] == nil then
        return nil
    end
    return self.content["b"]["userInfo"]
end

function WorldNoticeDataInfo:GetMailMessageTranslated()
    return self.translateMsg
end

return WorldNoticeDataInfo