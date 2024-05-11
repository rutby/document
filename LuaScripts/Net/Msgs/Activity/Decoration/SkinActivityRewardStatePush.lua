---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2023/2/7 11:15
---

local SkinActivityRewardStatePush = BaseClass("SkinActivityRewardStatePush", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self,activityId)
    base.OnCreate(self)
    self.sfsObj:PutInt("activityId",activityId)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    DataCenter.DecorationGiftPackageManager:ActivityRewardStatePushHandler(t)
end

SkinActivityRewardStatePush.OnCreate = OnCreate
SkinActivityRewardStatePush.HandleMessage = HandleMessage

return SkinActivityRewardStatePush