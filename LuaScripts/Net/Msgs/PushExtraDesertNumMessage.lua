---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2023/1/13 11:17
---
local PushExtraDesertNumMessage = BaseClass("PushExtraDesertNumMessage", SFSBaseMessage)
local base = SFSBaseMessage
local function OnCreate(self)
    base.OnCreate(self)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    if t["extraDesertNum"]~=nil then
        local extraDesertNum = t["extraDesertNum"]
        local add = t["add"]
        local total = extraDesertNum
        LuaEntry.Player:SetExtraDesertNum(total)
    end
end

PushExtraDesertNumMessage.OnCreate = OnCreate
PushExtraDesertNumMessage.HandleMessage = HandleMessage

return PushExtraDesertNumMessage