--[[
    加入房间
    只有加入房间才会收到推送？所以我们一开始就加入到所有房间？
	但是从代码看，如果是custom的房间，不会加入的
	从调试看，理论上只加入了 test_country_1 世界频道
]]

local WebSocketBaseMessage = require("Chat.WebMessage.Config.WebSocketBaseMessage")
local JoinRoomMultiCommand = BaseClass("JoinRoomMultiCommand", WebSocketBaseMessage)

local function create(self)
	
	local roomTbl = {}
	local rooms = ChatManager2:GetInstance().Room:GetRoomDatas()
	for _,roomData in pairs(rooms) do
		if roomData.group ~= ChatGroupType.GROUP_CUSTOM then
			if roomData.group == ChatGroupType.GROUP_CROSS_SERVER then
				local data = {
					id = roomData.roomId,
					group = "custom"
				}
				table.insert(roomTbl,data)
			elseif roomData.group == ChatGroupType.GROUP_DRAGON_SERVER then
				local data = {
					id = roomData.roomId,
					group = "custom"
				}
				table.insert(roomTbl,data)
			elseif roomData.group == ChatGroupType.GROUP_EDEN_CAMP then
				local data = {
					id = roomData.roomId,
					group = "custom"
				}
				table.insert(roomTbl,data)
			else
				local data = {
					id = roomData.roomId,
					group = roomData.group
				}
				table.insert(roomTbl,data)
			end
		elseif roomData.group == ChatGroupType.GROUP_CUSTOM and string.find(roomData.roomId, "lang") then
			local data = {
				id = roomData.roomId,
				group = roomData.group
			}
			table.insert(roomTbl,data)
		end
	end
	
	return roomTbl
end

local function createAlliance(self)
		
	local roomTbl = {}
	local data = {
		id = ChatManager2:GetInstance().Room:GetAllianceRoomId(),
		group = "alliance"
	}
	table.insert(roomTbl, data)
	return roomTbl
end

local function createCrossServer(self)

	local roomTbl = {}
	local data = {
		id = ChatManager2:GetInstance().Room:GetCrossServerRoomId(),
		group = "custom"
	}
	table.insert(roomTbl, data)
	return roomTbl
end
local function createEdenCamp(self)

	local roomTbl = {}
	local data = {
		id = ChatManager2:GetInstance().Room:GetEdenCampRoomId(),
		group = "custom"
	}
	table.insert(roomTbl, data)
	return roomTbl
end
local function createDragonServer(self)

	local roomTbl = {}
	local data = {
		id = ChatManager2:GetInstance().Room:GetDragonServerRoomId(),
		group = "custom"
	}
	table.insert(roomTbl, data)
	return roomTbl
end

local function OnCreate(self, groupId)
	if groupId ~=nil and groupId == ChatGroupType.GROUP_ALLIANCE then
		self.tableData.rooms = createAlliance()
	elseif groupId~=nil and groupId == ChatGroupType.GROUP_CROSS_SERVER then
		self.tableData.rooms = createCrossServer()
	elseif groupId~=nil and groupId == ChatGroupType.GROUP_DRAGON_SERVER then
		self.tableData.rooms = createDragonServer()
	elseif groupId~=nil and groupId == ChatGroupType.GROUP_EDEN_CAMP then
		self.tableData.rooms = createEdenCamp()
	else
		self.tableData.rooms = create()
	end
end

local function HandleMessage(self, msg)

    if msg.result.status then 
		ChatManager2:GetInstance().Room:requestMultiRoomLatestMsg(msg.result.id)
    end

end

JoinRoomMultiCommand.OnCreate = OnCreate
JoinRoomMultiCommand.HandleMessage = HandleMessage

return JoinRoomMultiCommand