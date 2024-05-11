---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2023/11/6 18:07
---

local GetSuggestionBoxInfoMessage = BaseClass("GetSuggestionBoxInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
    base.OnCreate(self)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    if t["errorCode"] == nil then
        DataCenter.OpinionManager:HandleGetInfo(t)
    end
end

GetSuggestionBoxInfoMessage.OnCreate = OnCreate
GetSuggestionBoxInfoMessage.HandleMessage = HandleMessage

return GetSuggestionBoxInfoMessage