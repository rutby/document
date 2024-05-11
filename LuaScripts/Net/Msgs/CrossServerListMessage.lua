--[[
	请求服务器列表消息
]]

local CrossServerListMessage = BaseClass("CrossServerListMessage", SFSBaseMessage)

local function OnCreate(self)

end

local function HandleMessage(self, t)
	--DataCenter.AllWorldsManager:onServerList(t)
end

CrossServerListMessage.OnCreate = OnCreate
CrossServerListMessage.HandleMessage = HandleMessage

return CrossServerListMessage