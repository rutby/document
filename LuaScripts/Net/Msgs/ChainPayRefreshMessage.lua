---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2023/2/8 19:06
---

local ChainPayRefreshMessage = BaseClass("ChainPayRefreshMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, actId, group)
    base.OnCreate(self)
    self.sfsObj:PutInt("activityId", actId)
    self.sfsObj:PutInt("group", group)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    DataCenter.ChainPayManager:HandleRefresh(t)
end

ChainPayRefreshMessage.OnCreate = OnCreate
ChainPayRefreshMessage.HandleMessage = HandleMessage

return ChainPayRefreshMessage