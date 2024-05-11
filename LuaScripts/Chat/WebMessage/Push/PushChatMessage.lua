--[[
	
	聊天推送消息
]]

local WebSocketBaseMessage = require("Chat.WebMessage.Config.WebSocketBaseMessage")
local PushChatMessage = BaseClass("PushChatMessage", WebSocketBaseMessage)


--[[
    下面的代码，逻辑不应该在这里处理，但是先在这里特殊处理下
    1. A.B.C 三个用户，A将B踢出联盟，AB均显示正常，但是C此时不会收到任何通知。此时C在线的情况下应该收到类似：push.al.event事件，参数t=4则为离开
    2. A.B.C 三个用户，A调整了B的联盟等级。然后ABC在聊天界面中联盟列表界面看到的B的等级信息不是最新的。
        1. 此时ABC均没有收到任何关于B等级信息发生变化的通知
        2. 游戏启动的时候回调用这个命令：chat.room.invitee 获取联盟用户列表，但是返回信息中B对应的lastUpdateTime的值没发生变化，导致客户端检测后判断这个用户的信息不需要更新
        3. 用户信息更新的逻辑是：当用户的信息发生变化时改变服务器中存储的这个用户的lastUpdateTime字段。客户端在对比本地存储和服务器返回的这个字段后，在决定是否去重新请求这个用户的最新用户信息

    -- 由于服务器暂时没时间处理以上两个问题
    但是理论上，这个应该在C++里面处理，不应该在lua中处理。
    先在这里打个补丁。记录下，将处理逻辑写在这里的原因。因为写在这里有些突兀，不符合整体逻辑
]]

local function handleAllianceEvent(tabData)
    if type(tabData) ~= "table" then 
        return
    end

    local extraData = tabData.extra
    if not extraData then 
        return
    end 

    local post = 0
    if extraData.post then 
        post = checknumber(extraData.post)
    end 
    
    -- 联盟相关的信息
    if post == 2 then
        local isReload = false
        local isRemove = false
        local dialog = extraData.dialog
        if dialog == '115184' or dialog == '115185' then
            -- 调整等级的消息 则重新获取这个用户的信息
            isReload = true
        elseif dialog == '115187' then
            -- 踢出联盟的消息 则在联盟列表中移除这个用户
            isRemove = true
        end
        local name = nil
        local msgarr = extraData.msgarr
        if msgarr ~= nil and #msgarr > 0 then
            name = msgarr[1]
        end
        if name ~= nil then
            local uid = ChatManager2:GetInstance().User:getUIDWithUserName(name)
            if uid ~= nil then
                if isReload then
                    ChatManager2:GetInstance().User:requestUserInfo({uid})
                end
    
                if isRemove then
                    ChatManager2:GetInstance().Room:GetAllianceRoomData():removeMembers({uid})
                end
            end
        end
    end
 end


local function OnCreate(self, tbl)

end

local function HandleMessage(self, serverData)
    -- self.super.HandleMessage(self, serverData)
    -- ChatPrint("%s,%s", msg.cmd, msg.result.status)

    if serverData.data == nil then
		print("push chat error!!!")
		return 
	end
	
	-- 联盟动态也走这里
	local roomMgr = ChatManager2:GetInstance().Room
	local userMgr = ChatManager2:GetInstance().User
    handleAllianceEvent(serverData.data)
    
	local chatData = roomMgr:CreateChatMessage()
    chatData:onParseServerData(serverData.data)
	
	-- 如果有senderInfo的话，就需要处理一下；头像更新之类的
	if serverData.data.senderInfo then
		userMgr:__processSenderInfo(serverData.data.sender, serverData.data.senderInfo)
	end
		
	-- 如果是自己发送的，那么就做Update，是因为之前UI就是这么处理的。
	--if chatData:isMySendChat() then		
	--	roomMgr:UpdateSendingChat(chatData)
	--	
	--	-- 这里要更新一下，否则红点会有问题
	--	-- 因为自己的消息发送时间一开始是客户端模拟的，不够精确，
	--	-- 所以这里必须要使用服务器回来的时间
	--	local room = roomMgr:GetRoomData(chatData.roomId)
	--	if room then
	--		if room.lastMsgTime < chatData:getServerTime() then
	--			room.lastMsgTime = chatData:getServerTime()
	--		end
	--	end		
	--	EventManager:GetInstance():Broadcast(ChatInterface.getEventEnum().CHAT_UPDATE_ROOM_CLICK_TIME, chatData.roomId)
	--else
        if (chatData.post ~= PostType.Text_Normal and
                chatData.post ~= PostType.Text_ChatRoomSystemMsg and
                chatData.post ~= PostType.Text_MemberJoin and
                chatData.post ~= PostType.Text_MemberQuit and
                chatData.post ~= PostType.Text_FightReport and
                chatData.post ~= PostType.Text_FBAlliance_missile_share and
                chatData.post ~= PostType.Text_Formation_Fight_Share and
                chatData.post ~= PostType.Text_MailScoutResultShare and
                chatData.post ~= PostType.Text_AllianceTaskShare and
                chatData.post ~= PostType.Text_Formation_Share and
                chatData.post ~= PostType.Text_ChampionBattleReportShare and
                chatData.post ~= PostType.RedPackge and
                chatData.post ~= PostType.Text_PointShare and
                chatData.post ~= PostType.Text_AllianceRecruitShare and
                chatData.post ~= PostType.Text_BattleReportContentShare and
                chatData.post ~= PostType.Text_ScoutReportContentShare and
                chatData.post ~= PostType.Text_ScoutAlertContentShare and
				chatData.post ~= PostType.Text_ActMonsterTowerHelp and
                chatData.post ~= PostType.Text_MsgShare and
                chatData.post ~= PostType.Text_Missile_Attack) then
            return
        end
        if ChatManager2:GetInstance().Restrict:isInRestrictList(chatData.senderUid, RestrictType.BLOCK) then
            return
        end
		roomMgr:AddChat(chatData, true)
		if chatData.extra and chatData.extra.redPackets then
			SFSNetwork.SendMessage(MsgDefines.GetAllianceRedPacket)
		end
		EventManager:GetInstance():Broadcast(ChatInterface.getEventEnum().CHAT_RECIEVE_ROOM_MSG, chatData)
	--end

end

PushChatMessage.OnCreate = OnCreate
PushChatMessage.HandleMessage = HandleMessage

return PushChatMessage
