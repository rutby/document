
local LeaveWorldMessage = BaseClass("ItemUseMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
    self.sfsObj:PutInt("worldId", LuaEntry.Player:GetCurWorldId())
end

local function HandleMessage(self, t)

end

LeaveWorldMessage.OnCreate = OnCreate
LeaveWorldMessage.HandleMessage = HandleMessage

return LeaveWorldMessage