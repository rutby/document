---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 
--- DateTime: 
---每日任务完成推送
local PushDailyQuestMessage = BaseClass("PushDailyQuestMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
    base.OnCreate(self)
end

local function HandleMessage(self, message)
    base.HandleMessage(self, message)
    if message["errorCode"] ~= nil then
        UIUtil.ShowTips(Localization:GetString(message["errorCode"]))
        return
    end
    if message["dailyQuest"] ~= nil then
        for k,v in pairs(message["dailyQuest"]) do
            DataCenter.DailyTaskManager:UpdateOneDailyTaskInfo(v)
            EventManager:GetInstance():Broadcast(EventId.DailyQuestSuccess)
            --阿柴要求 屏蔽掉
            --local template = DataCenter.DailyTaskTemplateManager:GetQuestTemplate(v.id)
            --if template ~= nil then
            --    UIUtil.ShowTips(Localization:GetString("170479",Localization:GetString(template.name)))
            --end
        end
    end
end

PushDailyQuestMessage.OnCreate = OnCreate
PushDailyQuestMessage.HandleMessage = HandleMessage

return PushDailyQuestMessage