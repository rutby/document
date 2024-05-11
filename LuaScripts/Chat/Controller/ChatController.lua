--[[
    这个类是聊天界面的消息交互监听 
    用户发送消息 说话 或者其他操作都会触发这个类的监听

    通过观察者模式达到与界面交互解耦的目的
]]

local ChatController = BaseClass("ChatController")
local rapidjson = require "rapidjson"
local ChatMessageHelper = require "Chat.Other.ChatMessageHelper"

function ChatController:__init()
	--防止登录的时候初始化多次
	self.inited = false
	-- NOTE: 因为EventManager里面是个弱表，所以这里需要缓存一份临时的BindCallback
	self.__event_handlers = {}
end

-- 添加监听
-- 仿照UIBaseContainer
function ChatController:AddListener(msg_name, callback)
	local bindFunc = function(...) callback(self, ...) end
	self.__event_handlers[msg_name] = bindFunc
	EventManager:GetInstance():AddListener(msg_name, bindFunc)
end

function ChatController:RemoveListener(msg_name, callback)
	local bindFunc = self.__event_handlers[msg_name]
	if not bindFunc then
		Logger.LogError(msg_name, " not register")
		return
	end
	self.__event_handlers[msg_name] = nil
	EventManager:GetInstance():RemoveListener(msg_name, bindFunc)
end


----初始化--------
function ChatController:Init()
	if self.inited  then
		return
	end
	
	ChatPrint("ChatController:Init")
	self.inited = true

	local Event = self
	local ChatEventId = ChatInterface.getEventEnum()
	
	Event:AddListener(ChatEventId.CHAT_BLOCK_COMMAND, self.OnChatBlock)
	Event:AddListener(ChatEventId.CHAT_UNBLOCK_COMMAND, self.OnChatUnblock)
	Event:AddListener(ChatEventId.CHAT_BAN_COMMAND, self.OnChatBan)
	Event:AddListener(ChatEventId.CHAT_UNBAN_COMMAND, self.OnChatUnBan)
	Event:AddListener(ChatEventId.REPORT_CHAT_COMMAND, self.onReportChatMsg)
	Event:AddListener(ChatEventId.REPORT_CUSTUM_HEAD_PIC_COMMAND, self.onReportChatHeadPic)
	Event:AddListener(ChatEventId.SEARCH_PLAYER_COMMAND, self.OnSearchPlayer)
	Event:AddListener(ChatEventId.ROOM_INVITE_COMMAND, self.OnRoomInvite)
	Event:AddListener(ChatEventId.ROOM_KICK_COMMAND, self.OnRoomKick)
	Event:AddListener(ChatEventId.QUIT_ROOM_COMMAND, self.OnQuitRoom)
	Event:AddListener(ChatEventId.CHAT_ROOM_CHANGE_NAME_COMMAND, self.OnChangeRoomName)
	Event:AddListener(ChatEventId.GET_REDPACKET_COMMAND, self.OnGetRedPacket)
	Event:AddListener(ChatEventId.GET_REDPACKET_STATUS_COMMAND, self.OnGetRedPacketStatus)
	Event:AddListener(ChatEventId.CHAT_ROOM_DISMISS, self.OnRoomDismiss)

	Event:AddListener(ChatEventId.CHAT_ROOM_CREATE_COMMAND, self.OnChatRoomCreate)
	Event:AddListener(ChatEventId.CHAT_TEMP_ROOM_CREATE_COMMAND, self.OnChatTempRoomCreate)
	Event:AddListener(ChatEventId.CHAT_REQUEST_HISTORY_MSG_COMMAND, self.ChatRoomRequestHistoryMsg)
	Event:AddListener(ChatEventId.CHAT_SEND_ROOM_MSG_UP_COMMAND, self.OnChatMsgUp)
	Event:AddListener(ChatEventId.CHAT_SEND_ROOM_MSG_COMMAND, self.OnChatSendMsg)
	--Event:AddListener(ChatEventId.CHAT_SEND_TEMP_ROOM_MSG_COMMAND, self.OnChatSendPersonTempMsg)
	--Event:AddListener(ChatEventId.CHAT_UPDATE_ALLIANCE_ROOM, self.OnUpdateAllianceRoom)
	Event:AddListener(ChatEventId.CHAT_TRANSLATE, self.OnChatTranslate)
	Event:AddListener(ChatEventId.CHAT_ROOM_OPEN_BY_GROUP, self.OnChatRoomOpenByGroup)
	Event:AddListener(ChatEventId.CHAT_ROOM_OPEN_BY_ID, self.OnChatRoomOpenById)
	--语音
	Event:AddListener(ChatEventId.CHAT_SEND_VOICE_MSG, self.OnChatSendVoiceMsg)
	Event:AddListener(ChatEventId.CHAT_VOICE_PLAY, self.OnChatVoicePlay)
	
	Event:AddListener(ChatEventId.CHAT_RESEND_ROOM_MSG_COMMAND, self.OnChatReSendMsg)
	Event:AddListener(ChatEventId.CHAT_SET_INFO, self.OnSetUserInfo)
	Event:AddListener(ChatEventId.CHAT_SHARE_COMMAND, self.OnChatShare)
	Event:AddListener(ChatEventId.CHAT_SHARE_EXECUTE_CMD, self.OnExecuteChatEvent)
	--Event:AddListener(ChatEventId.CHAT_PRIVATE_TALK, self.OnChatPrivateTalk)
	
	Event:AddListener(ChatEventId.CHAT_ROOM_PIN, self.OnRoomPin)
	--Event:AddListener(ChatEventId.CHAT_ROOM_UNPIN, self.OnRoomUnpin)
	Event:AddListener(ChatEventId.CHAT_ROOM_SEL, self.OnRoomSel)
	
	Event:AddListener(ChatEventId.CHAT_VIEW_CLOSE, self.OnUIViewClose)
	
	
	
	-- 加入联盟，退出联盟消息
	Event:AddListener(EventId.AllianceApplySuccess, self.OnRefreshAlliance)
	Event:AddListener(EventId.AllianceCreateSuccess, self.OnRefreshAlliance)
	Event:AddListener(EventId.AllianceInitOK, self.OnRefreshAlliance)
	Event:AddListener(EventId.AllianceQuitOK, self.OnRefreshAlliance)
	Event:AddListener(EventId.RefreshAllianceArmsUI, self.OnRefreshCrossServer)
	Event:AddListener(EventId.EnterDragonWorld, self.OnRefreshDragonServer)
	Event:AddListener(EventId.QuitDragonWorld, self.OnRefreshDragonServer)
end

function ChatController:Release()

	ChatPrint("ChatController:Release")
	
	local Event = self
	local ChatEventId = ChatInterface.getEventEnum()
	
	Event:RemoveListener(ChatEventId.CHAT_BLOCK_COMMAND, self.OnChatBlock)
	Event:RemoveListener(ChatEventId.CHAT_UNBLOCK_COMMAND, self.OnChatUnblock)
	Event:RemoveListener(ChatEventId.CHAT_BAN_COMMAND, self.OnChatBan)
	Event:RemoveListener(ChatEventId.CHAT_UNBAN_COMMAND, self.OnChatUnBan)
	Event:RemoveListener(ChatEventId.REPORT_CHAT_COMMAND, self.onReportChatMsg)
	Event:RemoveListener(ChatEventId.REPORT_CUSTUM_HEAD_PIC_COMMAND, self.onReportChatHeadPic)
	Event:RemoveListener(ChatEventId.SEARCH_PLAYER_COMMAND, self.OnSearchPlayer)
	Event:RemoveListener(ChatEventId.ROOM_INVITE_COMMAND, self.OnRoomInvite)
	Event:RemoveListener(ChatEventId.ROOM_KICK_COMMAND, self.OnRoomKick)
	Event:RemoveListener(ChatEventId.QUIT_ROOM_COMMAND, self.OnQuitRoom)
	Event:RemoveListener(ChatEventId.CHAT_ROOM_CHANGE_NAME_COMMAND, self.OnChangeRoomName)
	Event:RemoveListener(ChatEventId.GET_REDPACKET_COMMAND, self.OnGetRedPacket)
	Event:RemoveListener(ChatEventId.GET_REDPACKET_STATUS_COMMAND, self.OnGetRedPacketStatus)
	Event:RemoveListener(ChatEventId.CHAT_ROOM_DISMISS, self.OnRoomDismiss)

	Event:RemoveListener(ChatEventId.CHAT_ROOM_CREATE_COMMAND, self.OnChatRoomCreate)
	Event:RemoveListener(ChatEventId.CHAT_TEMP_ROOM_CREATE_COMMAND, self.OnChatTempRoomCreate)
	Event:RemoveListener(ChatEventId.CHAT_REQUEST_HISTORY_MSG_COMMAND, self.ChatRoomRequestHistoryMsg)
	Event:RemoveListener(ChatEventId.CHAT_SEND_ROOM_MSG_UP_COMMAND, self.OnChatMsgUp)
	Event:RemoveListener(ChatEventId.CHAT_SEND_ROOM_MSG_COMMAND, self.OnChatSendMsg)
	--Event:AddListener(ChatEventId.CHAT_SEND_TEMP_ROOM_MSG_COMMAND, self.OnChatSendPersonTempMsg)
	--Event:RemoveListener(ChatEventId.CHAT_UPDATE_ALLIANCE_ROOM, self.OnUpdateAllianceRoom)
	Event:RemoveListener(ChatEventId.CHAT_TRANSLATE, self.OnChatTranslate)
	Event:RemoveListener(ChatEventId.CHAT_ROOM_OPEN_BY_GROUP, self.OnChatRoomOpenByGroup)
	Event:RemoveListener(ChatEventId.CHAT_ROOM_OPEN_BY_ID, self.OnChatRoomOpenById)
	--语音
	Event:RemoveListener(ChatEventId.CHAT_SEND_VOICE_MSG, self.OnChatSendVoiceMsg)
	Event:RemoveListener(ChatEventId.CHAT_VOICE_PLAY, self.OnChatVoicePlay)

	Event:RemoveListener(ChatEventId.CHAT_RESEND_ROOM_MSG_COMMAND, self.OnChatReSendMsg)
	Event:RemoveListener(ChatEventId.CHAT_SET_INFO, self.OnSetUserInfo)
	Event:RemoveListener(ChatEventId.CHAT_SHARE_COMMAND, self.OnChatShare)
	Event:RemoveListener(ChatEventId.CHAT_SHARE_EXECUTE_CMD, self.OnExecuteChatEvent)
	--Event:AddListener(ChatEventId.CHAT_PRIVATE_TALK, self.OnChatPrivateTalk)

	Event:RemoveListener(ChatEventId.CHAT_ROOM_PIN, self.OnRoomPin)
	--Event:AddListener(ChatEventId.CHAT_ROOM_UNPIN, self.OnRoomUnpin)
	Event:RemoveListener(ChatEventId.CHAT_ROOM_SEL, self.OnRoomSel)

	Event:RemoveListener(ChatEventId.CHAT_VIEW_CLOSE, self.OnUIViewClose)

	-- 加入联盟，退出联盟消息
	Event:RemoveListener(EventId.AllianceApplySuccess, self.OnRefreshAlliance)
	Event:RemoveListener(EventId.AllianceCreateSuccess, self.OnRefreshAlliance)
	Event:RemoveListener(EventId.AllianceInitOK, self.OnRefreshAlliance)
	Event:RemoveListener(EventId.AllianceQuitOK, self.OnRefreshAlliance)
	Event:RemoveListener(EventId.RefreshAllianceArmsUI, self.OnRefreshCrossServer)
	Event:RemoveListener(EventId.EnterDragonWorld, self.OnRefreshDragonServer)
	Event:RemoveListener(EventId.QuitDragonWorld, self.OnRefreshDragonServer)
	self.inited = false
end

--更新玩家信息
function ChatController:OnSetUserInfo()
	SFSNetwork.SendMessage(MsgDefines.GetNewUserInfo, LuaEntry.Player.uid)
	ChatPrint("OnSetUserInfo")
	ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.UserSetInfo, ChatInterface.getLastUpdateTime())
end

--邀请玩家加入
function ChatController:OnRoomInvite(param)
	local roomId = param.roomId
	local uidArr = param.uidArr  
	
	if string.IsNullOrEmpty(roomId) or #uidArr == 0 then
		ChatPrint("OnRoomInvite 参数不对")
		return
	end
	
	ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.RoomInviteRoom, roomId, uidArr)
end

--聊天室踢人
function ChatController:OnRoomKick(param)
	local roomId = param.roomId
	local uidArr = param.uidArr 
	
	if string.IsNullOrEmpty(roomId) or #uidArr == 0 then
		ChatPrint("OnRoomKick 参数不对")
		return
	end
	
	ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.RoomKickRoom, roomId, uidArr)
end

--成员退出聊天室
function ChatController:OnQuitRoom(roomId)
	ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.RoomQuitRoom, roomId)
end

--更改聊天室名字
function ChatController:OnChangeRoomName(param)
	local roomId = param.roomId
	local roomName = param.roomName 
	ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.RoomChangeRoomName, roomId, roomName)
end

--领取红包
function ChatController:OnGetRedPacket(param)
	local redPacketId 	= param.redPacketId
	local serverId 		= param.serverId 
	local isViewOnly 	= param.isViewOnly
	local command = require("Chat.NetMessage.RedPacketsGetCommand").create(redPacketId,serverId,isViewOnly)
	if command then 
    	command:send()
	end
end
--查看红包状态
function ChatController:OnGetRedPacketStatus(param)
	local redPacketId 	= param.redPacketId
	local serverId 		= param.serverId
	local command = require("Chat.NetMessage.GetRedPacketStatusCommand").create(redPacketId,serverId)
	if command then 
    	command:send()
	end
end


--举报聊天信息
function ChatController:onReportChatMsg(chatData)
	local content = "" 
	local type = 0 
	if chatData.post == PostType.Text_Audio_Message then 
		type = 6
		content = chatData:getMediaInfo("audio")
	else 
		content = chatData.msg
	end 

	local param = {}
	param.reportUid = chatData.senderUid
	param.type = type
	param.content = content
	param.msgCreateTime = chatData:getServerTime() / 1000

	ChatInterface.getUserManagerInst():recordChatMsg(param.reportUid)
	local command = require("Chat.NetMessage.ReportPlayChatCommand").create(param)
    command:send()
end

--举报头像
function ChatController:onReportChatHeadPic(uid)
	ChatManager2:GetInstance().User:recordUserHead(uid)
	ChatManager2:GetInstance().Net:SendSFSMessage(ChatMsgDefines.ReportPicVer, uid)
end

---屏蔽消息回调
function ChatController:OnChatBlock(uid)
	if ChatManager2:GetInstance().Restrict:isInRestrictList(uid, RestrictType.BLOCK) then
		UIUtil.ShowTips(ChatInterface.getString("141026"))
	else
		if ChatManager2:GetInstance().Restrict:isReachShieldLimit() then
			UIUtil.ShowTips(ChatInterface.getString("290009"))
		else
			ChatManager2:GetInstance().Net:SendSFSMessage(ChatMsgDefines.ChatLock, uid)
		end
		
	end
	
end

---解除屏蔽消息回调
function ChatController:OnChatUnblock(uid)
	ChatManager2:GetInstance().Net:SendSFSMessage(ChatMsgDefines.ChatUnlock, uid)
end

--禁言
function ChatController:OnChatBan(param)
	local uid = param.uid 
	local time = param.time 
	ChatManager2:GetInstance().Restrict:addBanList(uid)
	ChatManager2:GetInstance().Net:SendSFSMessage(ChatMsgDefines.ChatBan, uid, time)
end

--解除禁言
function ChatController:OnChatUnBan(uid)
	ChatManager2:GetInstance().Restrict:removeRestrictUser(uid, RestrictType.BAN)
	ChatManager2:GetInstance().Net:SendSFSMessage(ChatMsgDefines.ChatUnban, uid)
end

--[[
	是否pin住
	目前只能pin一个，所以这样处理一下；
	如果isPin = true，表示取消pin
	如果isPin = false，表示设置pin，设置pin的时候要把其他的取消掉！
]] 
function ChatController:OnRoomPin(roomId)

	local roomDatas = ChatManager2:GetInstance().Room:GetRoomDatas()
	for k, v in pairs(roomDatas) do
		if v.roomId == roomId then
			local b = v:IsPin()
			v:SetPin(not b)
		else
			v:SetPin(false)
		end
	end
end

-- 房间最后点击，如果到目前点击的时间时有新消息，那么就要入库
function ChatController:OnRoomSel(roomId)
	local roomData = ChatManager2:GetInstance().Room:GetRoomData(roomId)
	if roomData then
		roomData:SetLastClickTime()
	end
end

-- UI关闭
-- 每次关闭UI的时候处理一下保存数据库的操作吧；否则有些操作太频繁
function ChatController:OnUIViewClose()
	--每次关闭UI检查一下是否要退出跨服聊天
	self:OnRefreshCrossServer()
end

-- 搜索玩家列表
-- param.key 类型
-- param.page 页面
function ChatController:OnSearchPlayer(param)
	ChatManager2:GetInstance().Net:SendSFSMessage(ChatMsgDefines.SearchPlayer, param)
end

---创建房间消息回调
-- param.type 类型
-- param.name 名称
-- param.members 用户列表数组或者用;分割的字符串
function ChatController:OnChatRoomCreate(param)
	if param.type == 0 then
		SFSNetwork.SendMessage(MsgDefines.ChatRoomCreate, param)
	else
		ChatManager2:GetInstance().Net:SendSFSMessage(ChatMsgDefines.ChatRoomCreate, param)
	end
end

--房主解散聊天室
function ChatController:OnRoomDismiss(roomId)

	if string.IsNullOrEmpty(roomId) then
		-- ChatPrint("ChatRoomDismissCommand 参数不对")
		return
	end

	--ChatManager2:GetInstance().Net:SendSFSMessage(ChatMsgDefines.ChatRoomDismiss, roomId)
	SFSNetwork.SendMessage(MsgDefines.ChatRoomDismiss, roomId)
end

--创建个人聊天临时房间
function ChatController:OnChatTempRoomCreate(param)
	--ChatManager2:GetInstance().Room:addTempRoomData(param)
end

---请求历史消息
function ChatController:ChatRoomRequestHistoryMsg(roomId)
	if type(roomId) ~= "string" then 
		printError("ChatRoomRequestHistoryMsg roomId is not string type!!")
		return 
	end 
	
	ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.HistoryRoomV2, roomId)
end

--[[
	聊天分享，通过EventManager:GetInstance():Broadcast(ChatInterface.getEventEnum().CHAT_SHARE_COMMAND, share)
	参数是一个table，不同的分享类型参数不同
	具体可以参考ShareEncode.lua中相关函数的注解
]] 
function ChatController:OnChatShare(param)
	
	local attachmentId = ChatMessageHelper.getAttachmentId(param)
	if attachmentId == nil then
		ChatPrint("share message error!")
		return
	end
	
	-- 消息参数
	local p = {}
	p.post = param.post
	p.lang = ChatManager2:GetInstance().Translate:GetLangString(ChatInterface.getLanguageName())
	p.msg = "?"
	p.attachmentId = attachmentId
	
	local SFSNetwork = ChatManager2:GetInstance().Net
	local channelType = ChatMessageHelper.getChannelFromRoomId(param.roomId, param.post)
	
	if channelType == ChatShareChannel.TO_COUNTRY then
		SFSNetwork:SendSFSMessage(ChatMsgDefines.ChatShareCountry, p)
	elseif channelType == ChatShareChannel.TO_ALLIANCE then
		SFSNetwork:SendSFSMessage(ChatMsgDefines.ChatShareAlliance, p)
	elseif channelType == ChatShareChannel.TO_PERSON then
		p.roomId = param.roomId
		SFSNetwork:SendSFSMessage(ChatMsgDefines.ChatSharePerson, p)
	elseif channelType == ChatShareChannel.TO_COUNTRY_LANG then
		p.chatType = 3
		if string.find(p.lang,"zh") then
			p.langRoomLang = "zh-Hant"
		end
		SFSNetwork:SendSFSMessage(ChatMsgDefines.ChatShareCountry, p)
	end
end


function ChatController:OnExecuteChatEvent(chatMsg)
	ChatMessageHelper.executeChatData(chatMsg)
	
	--[[
	local senderUid = chatMsg.senderUid
	ChatPrint("打印出来聊天参数chatMsg.post="..chatMsg.post)
    if chatMsg.post == PostType.Text_Formation_Fight_Share then
        local attachmentIdArr = string.split(chatMsg.attachmentId, "__")
		if #attachmentIdArr >= 2 then
			local formationInfoArr = string.split(attachmentIdArr[1], "#")
			if #formationInfoArr >= 2 then
				local reportUid = formationInfoArr[1]
				local mailType = formationInfoArr[2]
				local systemMailCmd = require("Mail.NetMessage.MailGetCommand").create(reportUid, tonumber(mailType), senderUid)
				if systemMailCmd then 
					systemMailCmd:send()
				end
			end
        end
    elseif chatMsg.post == PostType.Text_PointShare or chatMsg.post == PostType.Text_Favour_Point_Share then
    	--local unlock = CS.LFFunctionUnlockController.Instance:CheckFunctionUnlock(CS.LFFunctionUnlockController.GotoWorldType);
    	--if not unlock then 
    	--	local  unlockInfo = CS.LFFunctionUnlockController.Instance:GetFunctionUnlockInfo(CS.LFFunctionUnlockController.GotoWorldType);
    	--	if unlockInfo and unlockInfo.all_unlock_quest.Count > 0 then 
        --        local localization = CS.LF.LuaGameEntry.GetLocalization()
        --        --local nameKey = GameEntry.DataTable:GetString(CS.LFDefines.TableName.Quest, unlockInfo.unlock_quest, "title");
		--		local nameKey = CS.LF.LuaHelper.Table:GetString(CS.LFDefines.TableName.Quest, unlockInfo.all_unlock_quest[0], "title");
        --        --120024=完成任务“{0}”后将开启
        --        local tipMessage = localization:GetString("120024",localization:GetString(nameKey))
        --        CS.UIUtils.ShowMessage(tipMessage);
        --    end
    	--	return
    	--end 
    	--分享坐标 : para attachmentId : title(_lang())|[allianceAbbr]|Name|serverId|posX|posY
    	EventManager:GetInstance():Broadcast(ChatInterface.getEventEnum().LF_CloseChatView,true)
		if (string.IsNullOrEmpty(chatMsg.attachmentId)) then
			return
		end
		local attachJson = rapidjson.decode(chatMsg.attachmentId)
		local _x = tonumber(attachJson.x) or 0
		local _y = tonumber(attachJson.y) or 0
		local pointId = SceneUtils.TilePosToIndex(CS.UnityEngine.Vector2Int(_x, _y))
		GoToUtil.MoveToWorldPoint(pointId)
    elseif chatMsg.post == PostType.Text_AllianceInvite then 
    	--分享联盟邀请 : para attachmentId : 联盟名字|战力|成员数量|联盟图标name|msg|联盟id|操作类型（0 立即加入，1需要申请）
    	local isInAlliance = AllianceManager:isInAlliance()
    	if chatMsg:isMyChat() then 
    		if isInAlliance then 
    			CS.UIUtils.ShowTips("310100") -- 自己的联盟
    		else 
    			CS.UIUtils.ShowTips("138158") -- 目标联盟不存在
    		end 
    		return
    	end 

    	local attachmentIdArr = string.split(chatMsg.attachmentId, "|")
		if #attachmentIdArr == 7 then
			--如果自己已经在联盟了直接返回
	    	if AllianceManager:isInAlliance() then 
	    		local operationType = tonumber(attachmentIdArr[7])
	    		if operationType == 0 then 
	    			CS.UIUtils.ShowTips("138161")  -- 已在联盟中无法加入
	    		elseif operationType == 1 then  
	    			CS.UIUtils.ShowTips("138160")  -- 已在联盟中无法申请
	    		end 
	    		return 
	    	end 

			EventManager:GetInstance():Broadcast(ChatInterface.getEventEnum().LF_CloseChatView,true)
			EventManager:GetInstance():Broadcast(AllianceEventId.GET_ALLIANCE_INFO_BY_UID,attachmentIdArr[6])
			-- local param = {
	  --           allianceId = attachmentIdArr[6],
	  --           language = "",
	  --           applyType = 1
	  --       }
	  --       Event:notify(AllianceEventId.APPLY_ALLIANCE, param)
        end
	elseif chatMsg.post == PostType.Text_AllianceRedPack then
		AllianceRedPackManager.RegisterChatData(1, chatMsg)
		EventManager:GetInstance():Broadcast(AllianceEventId.ALLIANCE_REDPACK_STATUS, chatMsg.uuid, chatMsg.senderServerId)
	elseif chatMsg.post == PostType.Text_AllianceWelcome then
		local limitTime = GameEntry.DataConfig:GetInt("alliance_chat_config", "k1")
		limitTime = limitTime * 60 + chatMsg:getCreateTime()
		if CS.LF.LuaGameEntry.GetTimer():GetServerTimeSeconds() <= limitTime then
			local welcomeText = chatMsg:getRandomWelcome()
			local roomId = RoomManager:GetCurrentRoomId()
			local tempRoomData = RoomManager:getTempRoomData()
			if string.IsNullOrEmpty(roomId) and tempRoomData then
				EventManager:GetInstance():Broadcast(CS.EventId.CHAT_SEND_TEMP_ROOM_MSG_COMMAND, _lang(welcomeText))
			else
				EventManager:GetInstance():Broadcast(CS.EventId.CHAT_SEND_ROOM_MSG_COMMAND, _lang(welcomeText))
			end
			EventManager:GetInstance():Broadcast(CS.EventId.CHAT_MOVETOBOTTOM)
		else
			CS.UIUtils.ShowTips("310103")
		end
	elseif chatMsg.post == PostType.Text_AllianceGather then
		if chatMsg:CheckGatherValid() then
			local param = chatMsg.attachmentId
			CS.LF.LuaGameEntry.GetUI():OpenUIForm(CS.LFDefines.UIAssets.LFWorldGather, "Default", param);
			EventManager:GetInstance():Broadcast(ChatInterface.getEventEnum().LF_CloseChatView,true)
		else
			CS.UIUtils.ShowTips("138191")
		end
	elseif chatMsg.post == PostType.Text_AllianceProduceMine then
		if chatMsg.attachmentId then
			local paraArr = string.split(chatMsg.attachmentId, "|")
			if #paraArr < 1 then
				logErrorWithTag("ChatController", "Para error")
				return
			end
			local pointId = paraArr[1];
			if string.IsNullOrEmpty(pointId) then
				return
			end
			local point = tonumber(pointId)
			CS.LF.LuaInterfaceCommon.GoToWorldAndMoveTo(point)
		end
	elseif chatMsg.post == PostType.Text_AllianceMark then
		if chatMsg.attachmentId then
			local paraArr = string.split(chatMsg.attachmentId, "|")
			if #paraArr >= 5 then
				local pointIdStr = paraArr[4]
				local pointId = tonumber(pointIdStr)
				CS.UIUtils.GoToWorldAndDoAct(function()
                    CS.WorldUtils.WorldMoveToPos(pointId)
                    EventManager:GetInstance():Broadcast(ChatInterface.getEventEnum().LF_CloseChatView,true)
                end)
			end
		end
	elseif chatMsg.post == PostType.Text_NewServerActivity or chatMsg.post == PostType.Text_NewServerActivity_New then
		--开服活动聊天分享
		ChatPrint("打印出来聊天参数paraArr"..chatMsg.attachmentId)
		
		local attachmentIDArray = string.split(chatMsg.attachmentId, "|")		
		local actId = attachmentIDArray[1]     
		local dialogId = nil
		local actInfo = ActivityDataManager:GetActivityDataById(actId)
		if actInfo ~= nil then
			local openState = ActivityDataManager:getActivityIsOpen(actId)
			if openState then
				ActivityControllerInst:SendGetAllActivityInfo()
		
				Invoke:DelayCall(function()
					OpenGameUI("LFActivityTable" , "Default" , actId)	
				end, 0.35)  
				EventManager:GetInstance():Broadcast(ChatInterface.getEventEnum().LF_CloseChatView,true)
			else
				CS.UIUtils.ShowTips("370346")
			end
		else
			CS.UIUtils.ShowTips("370361")
		end
	elseif chatMsg.post == PostType.Text_ShareHeroTenGet then
		local userInfo =  ChatInterface.getUserManagerInst():getChatUserInfo(chatMsg.senderUid)
        if userInfo then 
			local param = userInfo.userName.."|"..chatMsg.attachmentId;
			-- 英雄招募十次分享
			CS.LF.LuaGameEntry.GetUI():OpenUIForm(CS.LFDefines.UIAssets.LFRecruitRewardPreview, "Dialog", param);
		end
	elseif chatMsg.post == PostType.Text_StartWar or chatMsg.post == PostType.Text_EndWar then
	    local cityId = chatMsg.cityId
		if cityId then
			local zoneId = tostring(cityId)
			local cityPosStrs = CS.LF.LuaHelper.Table:GetIntArray(TableName.WorldCity, zoneId, "cityPos")
			if cityPosStrs.Length >= 2 then
				CS.UIUtils.GoToWorldAndDoAct(function()
					local pos = CS.UnityEngine.Vector2Int(tonumber(cityPosStrs[0]),tonumber(cityPosStrs[1]))
					local index = CS.WorldUtils.TilePosToIndex(pos)
					CS.WorldUtils.WorldMoveToPos(index)
					GameEntry.UI:CloseByGroup("Default")
					EventManager:GetInstance():Broadcast(ChatInterface.getEventEnum().LF_CloseChatView,true)
				end)
			end
		end
    end
	]]
end

--发送消息
function ChatController:OnChatSendMsg(msgTable)
	ChatManager2:GetInstance():SendChatMsg(msgTable)
end
function ChatController:OnChatMsgUp(msgTable)
	ChatManager2:GetInstance():SendChatUpMsg(msgTable)
end

function ChatController:OnChatReSendMsg(chatData)
	ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.ChatRoom, chatData)
end

--[[
	data 为 ChatMessage
]]
function ChatController:OnChatTranslate(chatData)
	ChatManager2:GetInstance().Translate:DoTranslate(chatData)
end

function ChatController:OnChatRoomOpenByGroup(group)
	if group == ChatGroupType.GROUP_ALLIANCE and not ChatInterface.isInAlliance() then 
		return 
	end 
	local localization = CS.LF.LuaGameEntry.GetLocalization()
	local room = RoomManager:GetRoomDataByGroup(group)
	if room then 
		RoomManager:SetCurrentRoomId(room.roomId)
		if room.group == ChatGroupType.GROUP_ALLIANCE or room.group == ChatGroupType.GROUP_COUNTRY then 
			CS.LF.LuaGameEntry.GetUI():OpenUIForm(CS.GameDefines.UIAssets.UIChatMain, "UIResourcePopUp");
		else 
			ChatPrint("通过CHAT_ROOM_OPEN_BY_GROUP打开的聊天室是不确定的，因为可能存在多个聊天室，请使用CHAT_ROOM_OPEN_BY_ID指定RoomId")
			CS.LF.LuaGameEntry.GetUI():OpenUIForm(CS.GameDefines.UIAssets.UIChatRoom, "UIResourcePopUp");
		end 
	else 
		if group == ChatGroupType.GROUP_ALLIANCE then 
			UIUtil.ShowMessage(localization:GetString("290028"));
		elseif group == ChatGroupType.GROUP_CUSTOM then
			UIUtil.ShowMessage(localization:GetString("290020"),localization:GetString("290027"));
		else 
			ChatPrint("%s is not exist!", group)
		end 
	end
end

--
function ChatController:OnChatRoomOpenById(roomId)
		
	local RoomManager = ChatManager2:GetInstance().Room
	local roomData = RoomManager:GetRoomData(roomId)
	if not roomData then 
		ChatPrint("%s is not exist!", roomId);
		return 
	end 
		RoomManager:SetCurrentRoomId(roomData.roomId)

	--if roomData.group == ChatGroupType.GROUP_ALLIANCE or roomData.group == ChatGroupType.GROUP_COUNTRY then 
		--CS.LF.LuaGameEntry.GetUI():OpenUIForm(CS.GameDefines.UIAssets.UIChatMain, "UIResourcePopUp");
	--else 
		--CS.LF.LuaGameEntry.GetUI():OpenUIForm(CS.GameDefines.UIAssets.UIChatRoom, "UIResourcePopUp");
	--end 
end
 
--发送语音消息
function ChatController:OnChatSendVoiceMsg(voiceRecordParam)
	local playerUid = ChatInterface.getPlayerUid()
	local senderInfo = {
		userName = ChatInterface.getPlayerName(),
		lastUpdateTime = ChatInterface.getLastUpdateTime()
	}

	local chatData = {
        sender = playerUid,
        senderInfo = senderInfo,
        group = RoomManager:GetCurrentRoomData().group,
        roomId = RoomManager:GetCurrentRoomId(),
        msg = "90800185",
        sendTime = CS.LF.LuaGameEntry.GetTimer():GetServerTimeSeconds(),
        extra = {post = PostType.VOICE},
        --isNew = true,
    };

	self:UploadAndSendVoiceMsg({
		param = voiceRecordParam,
		data  = chatData
	});
end
--播放语音
function ChatController:OnChatVoicePlay(chatData)
	if chatData.extra and not string.IsNullOrEmpty(chatData.extra.media) then 
		local media = rapidjson.decode(chatData.extra.media);
		local ret , url ,cacheKey =  CS.UrlUtils.GenCustomVoiceMsgUrl(media.audio)
		if ret then 
			CS.DynamicResourceManager.Instance:LoadMultimediaFromUrl(url, CS.AudioType.MPEG, self.OnDownloadAudio, "Audio", cacheKey);
		end 
                   
	end 
end

---下载语音回调开始播放
function ChatController:OnDownloadAudio(key,clip)
	---appid为100013的是Unity的ds包，都为mp3格式
    ---appid为100002时，如果是LS的客户端发送的语音，则无法识别，因为是acc格式，此时sample为0
    ---如果是LS3D或者是LS3DDEBUG的客户端发送的语音，为mp3格式；
    if clip and clip.samples > 0 then 
    	ChatPrint(string.format("Play: len = {0}, channels = {1}, samples = {2}, frequency = {3}", clip.length, clip.channels, clip.samples, clip.frequency));
    	CS.MicrophoneController.Instance:Play(clip);
    end 
end
	
---上传语音消息
function ChatController:UploadAndSendVoiceMsg(voiceMsgInfo)
	local playerUid = ChatInterface.getPlayerUid()
	ChatPrint(info.param.filePath);
	local uploadName = CS.Path.GetFileNameWithoutExtension(info.param.filePath);
	ChatPrint(uploadName)
	local url = string.format("%s/%s/%s/%s/%s/fsafmpoewfmawpofmom",
            CS.UrlUtils.GetAudioUrl(),
            CS.ChatService.UPLOAD_AUDIO_URL,
            CS.ChatService.APP_ID,
            playerUid,
            uploadName);
	ChatPrint(url)
	local form = CS.UnityEngine.WWWForm();
    form:AddBinaryData("file", info.param.bytedata, uploadName);

    CS.WebRequestManager.Instance:Post(url, form, OnUploadAudio, 0, 0, info);
end


function ChatController:OnUploadAudio(www,err,voiceMsgInfo)
	if www.isDone and voiceMsgInfo then 
		if err then
			UIUtil.ShowTips("81000705");
			printError(www.error .. "\n" .. voiceMsgInfo.param.filePath);
		else 
			local filename = www.downloadHandler.text;
            local duration = voiceMsgInfo.param.duration.ToString();

            if CS.File.Exists(voiceMsgInfo.param.filePath) then 
                -- rename local file
                CS.File.Move(voiceMsgInfo.param.filePath, CS.Path.GetDirectoryName(voiceMsgInfo.param.filePath) .. "/" .. filename);
            end 

            local media = {
                audio = filename,
                duration = duration,
            };

            voiceMsgInfo.data.extra.media = rapidjson.encode(media)
            print(voiceMsgInfo.data.extra.media);
            EventManager:GetInstance():Broadcast(ChatInterface.getEventEnum().CHAT_SEND_ROOM_MSG_COMMAND, voiceMsgInfo.data)
		end 
	end 
end

--获取联盟成员uid
function ChatController:GetAllianceMember()
	ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.ChatRoomInvitee)	
end

function ChatController:GetRedPacketInfos()
	ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.RedPacketsRvdId)
end

-- 根据联盟变更刷新联盟
function ChatController:OnRefreshAlliance()

	local chatInst = ChatManager2:GetInstance()
	if (chatInst:IsInitOK() == false) then
		ChatPrint("OnRefreshAlliance but not initok")
		return 
	end
	
	local refresh = false
	local roomMgr = ChatManager2:GetInstance().Room
	local Net = ChatManager2:GetInstance().Net
	local room = roomMgr:GetRoomDataByGroup(ChatGroupType.GROUP_ALLIANCE)
	local inAlliance = ChatInterface.isInAlliance()

	ChatPrint("OnRefreshAlliance")
	
	-- 如果 old room id != new room id，离开旧房间
	local nowRoomId = roomMgr:GetAllianceRoomId()
	if room ~= nil and nowRoomId ~= room.roomId then
		Net:SendMessage(ChatMsgDefines.RoomLeave, room.roomId)
		roomMgr:RemoveAllianceRoom()
		room = nil
		refresh = true
	end
	
	-- 然后根据是否有联盟判断
	if inAlliance == true then
		if room == nil then
			room = roomMgr:AddAllianceRoom()
			if room then
				-- 创建之后就去服务器请求联盟消息
				Net:SendMessage(ChatMsgDefines.RoomJoinMulti, ChatGroupType.GROUP_ALLIANCE)
				self:ChatRoomRequestHistoryMsg(room.roomId)
				refresh = true
			end
		end
	else
		if room ~= nil then
			Net:SendMessage(ChatMsgDefines.RoomLeave, room.roomId)
			roomMgr:RemoveAllianceRoom()
			refresh = true
		end
	end

	if refresh then
		EventManager:GetInstance():Broadcast(ChatInterface.getEventEnum().CHAT_REFRESH_CHANNEL)
	end
end

function ChatController:OnRefreshCrossServer()
	local chatInst = ChatManager2:GetInstance()
	if (chatInst:IsInitOK() == false) then
		return
	end

	local refresh = false
	local roomMgr = ChatManager2:GetInstance().Room
	local Net = ChatManager2:GetInstance().Net
	local room = roomMgr:GetRoomDataByGroup(ChatGroupType.GROUP_CROSS_SERVER)
	local inCanCross = ChatInterface.isCrossServerOpen()
	
	local nowRoomId = roomMgr:GetCrossServerRoomId()
	if room ~= nil and nowRoomId ~= room.roomId then
		Net:SendMessage(ChatMsgDefines.RoomLeave, room.roomId)
		roomMgr:RemoveCrossServerRoom()
		room = nil
		refresh = true
	end

	-- 然后根据是否有联盟判断
	if inCanCross == true then
		if room == nil then
			room = roomMgr:AddCrossServerRoom()
			if room then
				-- 创建之后就去服务器请求联盟消息
				Net:SendMessage(ChatMsgDefines.RoomJoinMulti, ChatGroupType.GROUP_CROSS_SERVER)
				self:ChatRoomRequestHistoryMsg(room.roomId)
				refresh = true
			end
		end
	else
		if room ~= nil then
			Net:SendMessage(ChatMsgDefines.RoomLeave, room.roomId)
			roomMgr:RemoveCrossServerRoom()
			refresh = true
		end
	end

	if refresh then
		EventManager:GetInstance():Broadcast(ChatInterface.getEventEnum().CHAT_REFRESH_CHANNEL)
	end
end

function ChatController:OnRefreshDragonServer()
	local chatInst = ChatManager2:GetInstance()
	if (chatInst:IsInitOK() == false) then
		return
	end
	
	
	local refresh = false
	local roomMgr = ChatManager2:GetInstance().Room
	local Net = ChatManager2:GetInstance().Net
	local room = roomMgr:GetRoomDataByGroup(ChatGroupType.GROUP_DRAGON_SERVER)
	local inCanCross = ChatInterface.isDragonServerOpen()

	local nowRoomId = roomMgr:GetDragonServerRoomId()
	if room ~= nil and nowRoomId ~= room.roomId then
		Net:SendMessage(ChatMsgDefines.RoomLeave, room.roomId)
		roomMgr:RemoveDragonSeverRoom()
		room = nil
		refresh = true
	end

	-- 然后根据是否有联盟判断
	if inCanCross == true then
		if room == nil then
			room = roomMgr:AddDragonRoom()
			if room then
				-- 创建之后就去服务器请求联盟消息
				Net:SendMessage(ChatMsgDefines.RoomJoinMulti, ChatGroupType.GROUP_DRAGON_SERVER)
				self:ChatRoomRequestHistoryMsg(room.roomId)
				refresh = true
			end
		end
	else
		if room ~= nil then
			Net:SendMessage(ChatMsgDefines.RoomLeave, room.roomId)
			roomMgr:RemoveDragonSeverRoom()
			refresh = true
		end
	end

	if refresh then
		EventManager:GetInstance():Broadcast(ChatInterface.getEventEnum().CHAT_REFRESH_CHANNEL)
	end
end
return ChatController
