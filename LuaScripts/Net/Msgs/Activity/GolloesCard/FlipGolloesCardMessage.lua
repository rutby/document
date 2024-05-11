---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zzl
--- DateTime: 
--- 翻卡
local FlipGolloesCardMessage = BaseClass("FlipGolloesCardMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self,activityId,index)
    base.OnCreate(self)
    self.sfsObj:PutInt("activityId",activityId)
    self.sfsObj:PutInt("index",index)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    local errCode =  t["errorCode"]
    if errCode ~= nil then
        UIUtil.ShowTipsId(errCode) 
    else
        DataCenter.ActGolloesCardData:FlipGolloesCardHandle(t)
    end
end

FlipGolloesCardMessage.OnCreate = OnCreate
FlipGolloesCardMessage.HandleMessage = HandleMessage

return FlipGolloesCardMessage