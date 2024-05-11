---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2021/8/2 21:57
---
local DetectEventRewardReceiveMessage = BaseClass("DetectEventRewardReceiveMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, uuid)
    base.OnCreate(self)
    self.sfsObj:PutLong("uuid", uuid)
    DataCenter.GuideManager:SetWaitingMessage(WaitMessageFinishType.DetectEventRewardReceive, true)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)

    if t["errorCode"] ~= nil then
        local errorCode = t["errorCode"]
        if errorCode ~= SeverErrorCode then
            UIUtil.ShowTips(Localization:GetString(t["errorCode"]))
        end
    else
        EventManager:GetInstance():Broadcast(EventId.DetectEventRewardGet, t["uuid"])
        DataCenter.RadarCenterDataManager:GetDetectEventRewardBack(t)
        EventManager:GetInstance():Broadcast(EventId.DetectInfoChange)
        EventManager:GetInstance():Broadcast(EventId.RefreshActivityRedDot)
    end
    
    if t["firstKill"] == true then
        for _, v in ipairs(t["reward"]) do
            if v.type == RewardType.HERO then
                local heroUuid = v.value.uuid
                if DataCenter.HeroDataManager:NeedShowNewHeroWindow(heroUuid) then
                    UIManager:GetInstance():OpenWindow(UIWindowNames.UINewHero, heroUuid)
                end
                break
            end
        end
    end
    DataCenter.GuideManager:SetWaitingMessage(WaitMessageFinishType.DetectEventRewardReceive, nil)
    EventManager:GetInstance():Broadcast(EventId.GuideWaitMessage)
end

DetectEventRewardReceiveMessage.OnCreate = OnCreate
DetectEventRewardReceiveMessage.HandleMessage = HandleMessage

return DetectEventRewardReceiveMessage