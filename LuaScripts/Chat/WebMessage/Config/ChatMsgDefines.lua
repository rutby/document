
--[[
	这里包含着所有WebSocket的消息的定义
]]

ChatMsgDefines = 
{
	-------------------------------------------------------------
	-- 发送给SmartFox Server的消息
	GetUserInfoMulti = "get.user.info.multi", 	-- 获取玩家信息
	ChatBan   = "chat.ban", 				-- 聊天禁言
	ChatUnban = "chat.unban",				-- 解除禁言
	ChatLock	= "chat.lock",				-- 屏蔽玩家
	ChatUnlock	= "chat.unlock",				-- 解除屏蔽玩家
	GetChatBlockList = "chat.shield.list",--屏蔽列表
	ReportPicVer      = "report.picVer",			--举报头像
	ChatReport = "chat.report",				--举报聊天消息
	ChatRoomInvitee  = "chat.room.invitee", 		--获取联盟成员协议
	SearchPlayer      = "search.player",			--搜索玩家
	--GetRedPack     = "get.red.pack",			--领取红包
	RedPacketsRvdId= "redPackets.rvd.id",  		--获取红包ids 登录时调用更新本地缓存
	--RedPacketsStatus = "redPackets.status",	--获取红包状态
	ChatRoomCreate	= "chat.room.mk.v2",		-- 创建房间
	ChatRoomDismiss  = "chat.room.dismiss",		--解散房间

	ChatShareCountry  = "chat.country",	    --往国家频道发送消息（分享）
	ChatShareAlliance = "al.msg",			    --往联盟频道发送消息（分享）
	ChatSharePerson   = "chat.room.send",		--往私聊频道发送消息（分享）
	-- 发送给SmartFox Server的消息
	-------------------------------------------------------------
	
	
	UserSetInfo = "user.setInfo",
	SetSwitchFlag = "user.setSwitchFlag",		--发送联盟聊天开关值
	
	RoomJoinMulti = "room.joinMulti",			--加入房间必须传入Group
	HistoryRoomsV2 = "history.roomsv2",		--每个房间push N条历史记录 
	HistoryRoomV2 = "history.roomv2", -- 单个房间push N条历史记录	BY_TIME
	ChatRoom = "chat.room",			 --发送消息
	ChatUpRoom = "chat.up",     --发送点赞消息
	RoomLeave = "room.leave",					--退出房间
	RoomInviteRoom  = "room.inviteCustomRoom", -- 聊天室我邀请玩家
	RoomQuitRoom = "room.quitCustomRoom", 	--  成员退出聊天室
	RoomKickRoom = "room.kickCustomRoom", 	--  聊天室我（群主）移除玩家
	RoomChangeRoomName = "room.changeCustomRoomName", -- 修改聊天室名称
	GetCustomRoomList  = "room.getCustomRoomList", -- 获取聊天室列表
	
	
	LoginSuccess = "login.success",
	AnotherLogin = "another.login",
	PushChatRoom = "push.chat.room",				-- push房间内的消息
	PushChatRoomUp = "push.chat.up.room",
	PushChatRoomCreate = "push.chatroom.create",    -- 推送玩家创建聊天室
	PushRoomInvite = "push.room.invite",   	   -- 推送玩家邀请玩家
	PushRoomQuit   = "push.room.quit", 		   -- 推送玩家离开聊天室
	PushRoomDismiss =  "push.room.dismiss",  	--  推送玩家解散聊天室
	PushRoomKick   = "push.room.kick",			--	推送群主移除玩家
	PushRoomChangeName =  "push.room.changename", -- 推送聊天室改名
	PushChatBan 	   = "push.chat.ban",			--聊天禁言推送
}


ChatMsgMap = 
{
	-------------------------------------------------------------
	-- 发送给SmartFox Server的消息
	[ChatMsgDefines.ChatBan] = "Chat.NetMessage.ChatBanCommand",
	[ChatMsgDefines.ChatUnban] = "Chat.NetMessage.ChatUnBanCommand",
	[ChatMsgDefines.ChatLock] = "Chat.NetMessage.ChatLockCommand",
	[ChatMsgDefines.ChatUnlock] = "Chat.NetMessage.ChatUnLockCommand",
	[ChatMsgDefines.GetChatBlockList] = "Chat.NetMessage.GetChatBlockListCommand",
	[ChatMsgDefines.ReportPicVer] = "Chat.NetMessage.ReportCustomHeadPicCommand",
	[ChatMsgDefines.ChatReport] = "Chat.NetMessage.ReportPlayChatCommand",
	[ChatMsgDefines.ChatRoomInvitee] = "Chat.NetMessage.GetInviteeCommand",
	[ChatMsgDefines.SearchPlayer] = "Chat.NetMessage.SearchPlayerCommand",
	--[ChatMsgDefines.GetRedPack] = "Chat.NetMessage.RedPacketsGetCommand",
	[ChatMsgDefines.RedPacketsRvdId] = "Chat.NetMessage.RedPacketUidsGetCommand",
	--[ChatMsgDefines.RedPacketsStatus] = "Chat.NetMessage.GetRedPacketStatusCommand",
	[ChatMsgDefines.ChatRoomCreate] = "Chat.NetMessage.CreateChatRoomCommand",
	[ChatMsgDefines.ChatRoomDismiss] = "Chat.NetMessage.ChatRoomDismissCommand",
	[ChatMsgDefines.GetUserInfoMulti] = "Chat.NetMessage.GetMultiUserInfoCommand",
	[ChatMsgDefines.ChatShareCountry]  = "Chat.NetMessage.ChatShareCommand",	    --��������������������
	[ChatMsgDefines.ChatShareAlliance] = "Chat.NetMessage.ChatShareCommand",		--��������������������
	[ChatMsgDefines.ChatSharePerson]   = "Chat.NetMessage.ChatShareCommand",		--������������������
	-- 发送给SmartFox Server的消息
	--------------------------------------------------------------
	
	
	
	[ChatMsgDefines.UserSetInfo] = "Chat.WebMessage.SetUserInfoCommand",
	[ChatMsgDefines.SetSwitchFlag] = "Chat.WebMessage.SetSwitchFlagCommand",
	[ChatMsgDefines.GetCustomRoomList] = "Chat.WebMessage.GetCustomRoomListCommand",
	
	
	[ChatMsgDefines.RoomJoinMulti] = "Chat.WebMessage.JoinRoomMultiCommand",
	[ChatMsgDefines.HistoryRoomV2] = "Chat.WebMessage.GetHistoryMsgsByTimeCommand",
	[ChatMsgDefines.HistoryRoomsV2] = "Chat.WebMessage.GetHistoryMsgsCommand",
	
	[ChatMsgDefines.ChatRoom] = "Chat.WebMessage.ChatRoomSendMsgCommand",
	[ChatMsgDefines.ChatUpRoom] = "Chat.WebMessage.ChatRoomUpCommand",
	[ChatMsgDefines.RoomLeave] = "Chat.WebMessage.LeaveRoomCommand",
	[ChatMsgDefines.RoomInviteRoom] = "Chat.WebMessage.ChatRoomInviteCommand",
	[ChatMsgDefines.RoomQuitRoom] = "Chat.WebMessage.ChatRoomQuitCommand",
	[ChatMsgDefines.RoomKickRoom] = "Chat.WebMessage.ChatRoomKickCommand",
	[ChatMsgDefines.RoomChangeRoomName] = "Chat.WebMessage.ChangeRoomNameCommand",
	


	[ChatMsgDefines.LoginSuccess] = "Chat.WebMessage.Push.PushLoginSuccess",
	[ChatMsgDefines.AnotherLogin] = "Chat.WebMessage.Push.PushAnotherLoginMessage",
	[ChatMsgDefines.PushChatRoom] = "Chat.WebMessage.Push.PushChatMessage",
	[ChatMsgDefines.PushChatRoomUp] = "Chat.WebMessage.Push.PushChatUpMessage",
	[ChatMsgDefines.PushChatRoomCreate] = "Chat.WebMessage.Push.PushRoomCreateMessage",
	[ChatMsgDefines.PushRoomInvite] = "Chat.WebMessage.Push.PushRoomInviteMessage",
	[ChatMsgDefines.PushRoomQuit] = "Chat.WebMessage.Push.PushRoomQuitMessage",
	[ChatMsgDefines.PushRoomDismiss] = "Chat.WebMessage.Push.PushRoomDismissMessage",
	[ChatMsgDefines.PushRoomKick] = "Chat.WebMessage.Push.PushRoomKickMessage",
	[ChatMsgDefines.PushRoomChangeName] = "Chat.WebMessage.Push.PushRoomChangeNameMessage",
	[ChatMsgDefines.PushChatBan] = "Chat.WebMessage.Push.PushChatBanMessage",

}



