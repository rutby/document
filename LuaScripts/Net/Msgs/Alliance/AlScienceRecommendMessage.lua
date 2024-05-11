---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by guqu.
--- DateTime: 2020/9/30 10:42
---
local AlScienceRecommendMessage = BaseClass("AlScienceRecommendMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization
local function OnCreate(self,scienceId,state)
    base.OnCreate(self)
    self.sfsObj:PutInt("scienceId", scienceId)
    self.sfsObj:PutInt("state", state)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    local errCode =  t["errorCode"]
    if errCode ~= nil then
        UIUtil.ShowTipsId(errCode) 
    else
        DataCenter.AllianceScienceDataManager:EndRefreshAllScienceNum(t)
        DataCenter.AllianceScienceDataManager:UpdateOneAllianceScience(t)
        EventManager:GetInstance():Broadcast(EventId.AllianceTechnology)
    end
end
AlScienceRecommendMessage.OnCreate = OnCreate
AlScienceRecommendMessage.HandleMessage = HandleMessage
return AlScienceRecommendMessage