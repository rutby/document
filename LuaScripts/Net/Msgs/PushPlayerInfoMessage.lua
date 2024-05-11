--[[
	推送玩家信息
]]

local PushPlayerInfoMessage = BaseClass("PushPlayerInfo", SFSBaseMessage)

local function OnCreate(self)

end

local function HandleMessage(self, t)
	LuaEntry.Player:UpdatePlayerInfo(t)
end

PushPlayerInfoMessage.OnCreate = OnCreate
PushPlayerInfoMessage.HandleMessage = HandleMessage

return PushPlayerInfoMessage