---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2022/2/25 15:47
---


local GetAlMemberRecommendListMessage = BaseClass("GetAlMemberRecommendListMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
    base.OnCreate(self)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    local errCode =  t["errorCode"]
    if errCode ~= nil then
        UIUtil.ShowTipsId(errCode)
    else
        DataCenter.AllianceMemberDataManager:UpdateAlMemberRecommendList(t) 
    end
end

GetAlMemberRecommendListMessage.OnCreate = OnCreate
GetAlMemberRecommendListMessage.HandleMessage = HandleMessage

return GetAlMemberRecommendListMessage