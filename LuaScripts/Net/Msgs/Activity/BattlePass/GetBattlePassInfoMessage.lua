---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zzl
--- DateTime: 
--- 
local GetBattlePassInfoMessage = BaseClass("GetBattlePassInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self,activityId)
    base.OnCreate(self)
    self.sfsObj:PutInt("activityId",activityId)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    local errCode =  t["errorCode"]
    if errCode ~= nil then
        UIUtil.ShowTipsId(errCode) 
    else
        DataCenter.ActBattlePassData:ParseEventData(t)
    end
end

GetBattlePassInfoMessage.OnCreate = OnCreate
GetBattlePassInfoMessage.HandleMessage = HandleMessage

return GetBattlePassInfoMessage