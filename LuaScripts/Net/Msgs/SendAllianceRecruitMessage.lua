---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2022/7/5 19:07
---SendAllianceRecruitMessage


local SendAllianceRecruitMessage = BaseClass("SendAllianceRecruitMessage", SFSBaseMessage)
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
        
    end
end

SendAllianceRecruitMessage.OnCreate = OnCreate
SendAllianceRecruitMessage.HandleMessage = HandleMessage

return SendAllianceRecruitMessage