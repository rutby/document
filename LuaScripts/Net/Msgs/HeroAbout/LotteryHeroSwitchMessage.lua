---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zhangliheng.
--- DateTime: 7/20/21 2:56 PM
---
--- 阵营招募-阵营切换请求


local LotteryHeroSwitchMessage = BaseClass("LotteryHeroSwitchMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

---阵营切换请求
---@param originalId string 原始id
---@param targetId string 目标id
local function OnCreate(self, originalId, targetId)
    base.OnCreate(self)

    self.sfsObj:PutUtfString("originalId", originalId)
    self.sfsObj:PutUtfString("targetId", targetId)
end

local function HandleMessage(self, message)
    base.HandleMessage(self, message)

    if message["errorCode"] ~= nil then
        local lang = Localization:GetString(message["errorCode"])
        UIUtil.ShowTips(lang or message["errorCode"])
        return
    end

    local lotteryId = message['targetId']
    if message['gold'] ~= nil then
        --todo: Update gold
    end

    if message['free'] then
        local freeCount = 0
        local freeMax = 0
        if message['freeCount'] then
            freeCount = message['freeCount']
        end

        if message['freeMax'] then
            freeMax = message['freeMax']
        end
        
        DataCenter.LotteryDataManager:SetCampChangeInfo(freeCount, freeMax)
    end
    
    local leftCount = DataCenter.LotteryDataManager:GetLeftCampChangeFreeCount()
    EventManager:GetInstance():Broadcast(EventId.RecruitCampChange, lotteryId, leftCount)
end

LotteryHeroSwitchMessage.OnCreate = OnCreate
LotteryHeroSwitchMessage.HandleMessage = HandleMessage

return LotteryHeroSwitchMessage