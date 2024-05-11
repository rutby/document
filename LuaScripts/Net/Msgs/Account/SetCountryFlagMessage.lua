---
--- Created by shimin.
--- DateTime: 2020/9/25 19:11
---
local SetCountryFlagMessage = BaseClass("SetCountryFlagMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, nation)
    base.OnCreate(self)
    self.sfsObj:PutUtfString("flag", nation)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    if t["result"] then
        LuaEntry.Player.countryFlag = t["flag"]
        EventManager:GetInstance():Broadcast(EventId.CountryFlagChanged)
    end
end

SetCountryFlagMessage.OnCreate = OnCreate
SetCountryFlagMessage.HandleMessage = HandleMessage

return SetCountryFlagMessage