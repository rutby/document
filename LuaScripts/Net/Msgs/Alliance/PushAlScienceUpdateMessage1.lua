---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by cola.
--- DateTime: 2022/4/1 上午11:58
--- 科技升级完成后更新当前科技数据
local PushAlScienceUpdateMessage1 = BaseClass("PushAlScienceUpdateMessage1", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
    base.OnCreate(self)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    DataCenter.AllianceScienceDataManager:EndRefreshAllScienceNum(t)
    DataCenter.AllianceScienceDataManager:UpdateOneAllianceScience(t)
    EventManager:GetInstance():Broadcast(EventId.AllianceTechnology)
end

PushAlScienceUpdateMessage1.OnCreate = OnCreate
PushAlScienceUpdateMessage1.HandleMessage = HandleMessage

return PushAlScienceUpdateMessage1