---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by guqu.
--- DateTime: 2020/9/3 18:19
---
local DesertForceServerRankMessage = BaseClass("DesertForceServerRankMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization
local function OnCreate(self)
    base.OnCreate(self)
    self.sfsObj:PutInt("ismerge",0)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    local errCode =  t["errorCode"]
    if errCode ~= nil then
        UIUtil.ShowTipsId(errCode) 
    else
        DataCenter.DesertDataManager:SetDesertRankList(t)
    end
end

DesertForceServerRankMessage.OnCreate = OnCreate
DesertForceServerRankMessage.HandleMessage = HandleMessage

return DesertForceServerRankMessage