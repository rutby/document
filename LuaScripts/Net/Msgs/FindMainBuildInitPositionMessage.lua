---
--- Created by shimin.
--- DateTime: 2021/10/25 23:53
---
local FindMainBuildInitPositionMessage = BaseClass("FindMainBuildInitPositionMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, serverId)
    base.OnCreate(self)
    local sid = serverId
    if serverId==nil then
        sid = LuaEntry.Player:GetSelfServerId()
    end
    self.sfsObj:PutInt("serverId",sid)
end

local function HandleMessage(self, message)
    base.HandleMessage(self, message)
    DataCenter.BuildManager:FindMainBuildInitPositionHandle(message)
end

FindMainBuildInitPositionMessage.OnCreate = OnCreate
FindMainBuildInitPositionMessage.HandleMessage = HandleMessage

return FindMainBuildInitPositionMessage