---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2021/9/7 15:01
---

local WorldAddAllianceMarkMessage = BaseClass("WorldAddAllianceMarkMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, point, server, type, name)
    base.OnCreate(self)
    self.sfsObj:PutInt("point", point)
    self.sfsObj:PutInt("serverId", server)
    self.sfsObj:PutInt("markType", type)
    self.sfsObj:PutUtfString("markName", name)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    local errCode =  t["errorCode"]
    if errCode ~= nil then
        UIUtil.ShowTipsId(errCode) 
    else
        DataCenter.WorldFavoDataManager:OnAddAllianceMark(t)
    end
end

WorldAddAllianceMarkMessage.OnCreate = OnCreate
WorldAddAllianceMarkMessage.HandleMessage = HandleMessage

return WorldAddAllianceMarkMessage