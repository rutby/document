--[[
    获取联盟成员协议
]]

local GetInviteeCommand = BaseClass("GetInviteeCommand", SFSBaseMessage)

local function OnCreate(self, param)
    self.super.OnCreate(self)

    self.sfsObj:putPPutUtfStringaram("allianceId", ChatInterface.getAllianceId())

end

local function HandleMessage(self, msg)
    self.super.HandleMessage(self)

	if msg.params == nil or msg.params.invitee == nil then 
		return 
	end 

	local members = msg.params.invitee
    local memberArr = {}
    local uids = {}
	local userMgr = ChatManager2:GetInstance().User
	
    for key , member in pairs(members) do 
        local uid = member.uid
        table.insert(memberArr,uid)
        if not string.IsNullOrEmpty(uid) then 
            local time = member.lastUpdateTime == "" and "0" or member.lastUpdateTime
            local tempUser = userMgr:getChatUserInfo(uid)
	        if tempUser == nil or checknumber(tempUser.lastUpdateTime) < checknumber(time) then 
                table.insert(uids,uid)
	        end
        end 
    end

    
    local roomData = ChatManager2:GetInstance().Room:GetRoomDataByGroup(ChatGroupType.GROUP_ALLIANCE)
    if  roomData  then 
        roomData:addMembers(memberArr)
    end

    userMgr:requestUserInfo(uids)
    -- todo 有可能打开创建房间界面了 此协议还没有返回 所以最好发送个消息通知界面更新
    
end


GetInviteeCommand.OnCreate = OnCreate
GetInviteeCommand.HandleMessage = HandleMessage

----------------------------------------------------------------
-- 兼容代码
local function OnSend(param)
    SFSNetwork.SendMessage(MsgDefines.CHAT_ROOM_INVITEE, param)
end

function GetInviteeCommand.create()
    local ret = {}
    ret.send = OnSend
    return ret
end
----------------------------------------------------------------

return GetInviteeCommand