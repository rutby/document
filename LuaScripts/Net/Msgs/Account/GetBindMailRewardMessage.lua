---
--- Created by zzl
--- DateTime: 
---
local GetBindMailRewardMessage = BaseClass("GetBindMailRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
    base.OnCreate(self)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    DataCenter.AccountManager:SaveBindAccountReward(t)
end

GetBindMailRewardMessage.OnCreate = OnCreate
GetBindMailRewardMessage.HandleMessage = HandleMessage

return GetBindMailRewardMessage