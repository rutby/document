--[[

	聊天模块初始化

	非功能性需求注意点
	1、前后台切换、断线重连、切号、重登时要保证数据的正确性 如:屏蔽信息，禁言信息，红包状态信息，聊天数据,玩家信息

	前后台切换导致的问题：网络断开或者包没及时解析的问题
	断线重连的问题：从断开到连接时消息同步的问题
	切号带来的问题：老号缓存数据要清除，以免产生数据混乱的问题
	重登带来的问题：其他玩家发的数据要及时同步更新

	2、数据库增删改查性能不能受到影响

	3、要保证可移植性，可同步给其他项目使用,代码要结构清晰，可读性好，不能和引擎或者游戏类直接调用

]]

require "Chat.Constant.SendStateType"
require "Chat.Constant.ChatGroupType"
require "Chat.Constant.ChatMessageType"
require "Chat.Constant.PostType"
require "Chat.Constant.RestrictType" 
require "Chat.Constant.ChatConstant"
require "Chat.WebMessage.Config.ChatMsgDefines"

-- 聊天对外接口，请使用此接口操作
ChatInterface = require "Chat.ChatInterface"

-- 聊天管理器，请不要使用；
ChatManager2 = require "Chat.ChatManager2"

function ChatPrint(fmt, ...)
	--local arg= {...}
	--if #arg == 0 then
	--	print("[chat]" .. tostring(fmt))
	--	return
	--end
	--
	--print("[chat]" .. string.format(fmt, ...))
	--return
end





