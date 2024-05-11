---
--- Created by shimin
--- DateTime: 2023/3/17 17:19
--- 王座礼包信息
---
local PresidentPresentInfo = BaseClass("PresidentPresentInfo")
local PresidentPresentPerInfo = require "DataCenter.GovernmentManager.PresidentPresentPerInfo"

function PresidentPresentInfo:__init()
    self.dict = {} --礼包信息 key是wonder_gift表type
    self.uidMap = {}--key是玩家uid
end

function PresidentPresentInfo:__delete()
    self.dict = {} --礼包信息 key是wonder_gift表type
    self.uidMap = {}--key是玩家uid
end

function PresidentPresentInfo:ParseData(message)
    if message == nil then
        return
    end
    if message["list"] then
        for _, v in ipairs(message["list"]) do
            local presentId = v.presentId
            if presentId ~= nil then
                local template = DataCenter.WonderGiftTemplateManager:GetTemplate(presentId)
                if template ~= nil then
                    if self.dict[template.type] == nil then
                        local param = PresidentPresentPerInfo.New()
                        param:ParseData(v)
                        self.dict[template.type] = param
                    else
                        self.dict[template.type]:ParseData(v)
                    end
                end
            end
        end
    end
    if message["uidArr"] then
        self.uidMap = {}
        for _, v in ipairs(message["uidArr"]) do
            self.uidMap[v] = true
        end
    end
end

function PresidentPresentInfo:GetPresentByRewardType(rewardType)
    return self.dict[rewardType]
end

function PresidentPresentInfo:IsGetReward(uid)
    return self.uidMap[uid] ~= nil
end

function PresidentPresentInfo:IsSendFinishByRewardType(rewardType)
    local present = self:GetPresentByRewardType(rewardType)
    if present ~= nil then
        local template = DataCenter.WonderGiftTemplateManager:GetTemplate(present.presentId)
        if template ~= nil then
            return template.num <= present.useCount
        end
    end
    
    return false
end

function PresidentPresentInfo:AddUidArr(message)
    if message ~= nil then
        local use = 0
        local arr = message["uidArr"]
        if arr ~= nil then
            for k,v in ipairs(arr) do
                self.uidMap[v] = true
                use = use + 1
            end
        end
        local presentId = message["presentId"]
        for k, v in pairs(self.dict) do
            if v.presentId == presentId then
                v.useCount = v.useCount + use
            end
        end
    end
end

--是否有没发奖的
function PresidentPresentInfo:IsNeedReward()
    for k,v in pairs(self.dict) do
        local template = DataCenter.WonderGiftTemplateManager:GetTemplate(v.presentId)
        if template ~= nil then
            if template.num > v.useCount then
                return true
            end
        end
    end

    return false
end

return PresidentPresentInfo