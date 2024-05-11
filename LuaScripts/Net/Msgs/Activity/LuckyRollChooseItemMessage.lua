---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zzl
--- DateTime: 
--- 选择奖励
local LuckyRollChooseItemMessage = BaseClass("LuckyRollChooseItemMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self,activityId,itemId,chooseIndex)
    base.OnCreate(self)
    self.sfsObj:PutInt("activityId",activityId)
    self.sfsObj:PutInt("itemId",itemId)
    self.sfsObj:PutInt("chooseIndex",chooseIndex)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    local errCode =  t["errorCode"]
    if errCode ~= nil then
        UIUtil.ShowTipsId(errCode) 
    else
        DataCenter.ActLuckyRollInfo:ChooseItemHandle(t)
    end
end

LuckyRollChooseItemMessage.OnCreate = OnCreate
LuckyRollChooseItemMessage.HandleMessage = HandleMessage

return LuckyRollChooseItemMessage