
ChatChannelShowMinLevel = 3

--分享到聊天的频道类型
ChatShareChannel = {
	TO_COUNTRY  = 0,  -- 国家
	TO_ALLIANCE = 1,  -- 联盟
	TO_PERSON   = 2,  -- 私聊
    TO_COUNTRY_LANG = 3,-- 同语言频道
}

-- 联盟红包类型
RedPackageType = {
    LevelUp = 1,            -- 主世界等级提升
    Hero_Quality_4 = 2,     -- 第一次获得紫英雄
    Hero_Quality_7 = 3,     -- 第一次合成金
}

-- 联盟红包领取状态
RedPackageState = {
    AlreadyGet = 0, -- 已领取
    Valid = 1,      -- 未获取
    Cost_All = 2,   -- 领取完
    TimeOut = 3,    -- 超时
}

-- 聊天事件
ChatEventEnum = {
    CHAT_BLOCK_COMMAND = 100001, -- 屏蔽

    CHAT_UNBLOCK_COMMAND = 100002, -- 解除屏蔽
    CHAT_ROOM_CREATE_COMMAND = 100003, -- 创建房间
    CHAT_TEMP_ROOM_CREATE_COMMAND = 100004,-- 创建临时房间
    CHAT_SEND_TEMP_ROOM_MSG_COMMAND = 100005, -- 发送个人临时消息
    CHAT_REQUEST_HISTORY_MSG_COMMAND = 100006, -- 请求房间历史消息
    CHAT_SEND_ROOM_MSG_COMMAND = 100007, -- 发送消息
    CHAT_UPDATE_ALLIANCE_ROOM = 100008, -- 更新联盟房间
    GOTO_WORLD_POSITION = 100009, -- 世界位置
    CHAT_TRANSLATE = 100010, -- 翻译
    CHAT_ROOM_OPEN_BY_GROUP = 100011, -- 打开房间根据组
    CHAT_ROOM_OPEN_BY_ID = 100012, -- 打开房间根据id
    CHAT_SEND_VOICE_MSG = 100013, -- 发送语音
    CHAT_VOICE_PLAY = 100014, -- 播放
    CHAT_RESEND_ROOM_MSG_COMMAND = 100015, -- 重新发送
    CHAT_SET_INFO = 100016,-- 更新玩家信息
    CHAT_UPDATE_ROOM_MSG = 100017, -- 更新房间信息
    CHAT_SEND_ROOM_MSG_SUCCESS = 100018, -- 发送房间消息成功

    CHAT_SEND_ROOM_MSG_FAILURE = 100019, -- 发送房间消息失败
    CHAT_RECIEVE_ROOM_MSG = 100020, -- 接收房间消息成功
    CHAT_CHECK_UI_MAIN_RED_POINT = 100021,-- 检测主UI聊天的红点
    CHAT_REMOVE_ROOM_MSG_COMMAND = 100022, -- 移除房间消息
    CHAT_ROOM_CHANGE_NAME_COMMAND = 100023, -- 更改房间名字
    CHAT_ROOM_UPDATE_MEMBER = 100024, -- 更新房间成员
    ROOM_INVITE_COMMAND = 100025, -- 邀请玩家加入
    QUIT_ROOM_COMMAND = 100026, -- 成员退出聊天室
    CHAT_ROOM_INVITE_SEARCH_PLAYER_RESULT = 100027, -- 搜索玩家结果
    CHAT_REQUEST_HISTORY_MSG_RESULT = 100028, -- 获取历史消息结果
    CHAT_ROOM_INVITE_PLAYER_RESULT = 100029, -- 邀请玩家结果
    CHAT_LOGIN_SUCCESS = 100030, -- 聊天登录成功
    CHAT_UPDATE_ROOM_LIST_LASTMSG = 100031, -- 房间列表更新最新消息
    CHAT_ROOM_CHANGE = 100032, -- 房间选中切换
    CHAT_UPDATE_ROOM_HISTORY_MSG = 100033, -- 更新房间历史信息
    CHAT_BAN_COMMAND = 100034, -- 禁言
    CHAT_UNBAN_COMMAND = 100035, -- 解除禁言
    REPORT_CHAT_COMMAND = 100036, -- 举报聊天信息
    REPORT_CUSTUM_HEAD_PIC_COMMAND = 100037, -- 举报玩家头像
    SEARCH_PLAYER_COMMAND = 100038, -- 搜索玩家
    ROOM_KICK_COMMAND = 100039, -- 聊天室踢人
    GET_REDPACKET_COMMAND = 100040, --  领取红包
    GET_REDPACKET_STATUS_COMMAND = 100041, -- 查看红包状态
    CHAT_ROOM_DISMISS = 100042, -- 房间解散
    CHAT_REFRESH_CHANNEL = 100043, -- 刷新房间列表
	CHAT_UPDATE_ROOM_CLICK_TIME = 100044, -- 更新房间点击时间
	
    CHAT_UPDATE_ROOM_NAME = 100045, -- 更新房间名称
    ROOM_KICK_PLAYER_RESULT = 100046, -- 聊天室踢人结果
    CHAT_ROOM_CREATE_RESULT = 100047, -- 创建房间的结果
    CHAT_VOICE_QUEUE = 100048, -- 播放语音队列
    CLOSE_CHAT_UI = 100049, -- 关闭chat view
    CHAT_SHOW_CONTENT_TIPS = 100050, -- 
    CHAT_HIDE_CONTENT_TIPS = 100051, -- 隐藏悬浮菜单
    CHAT_LEAVE_ROOM_MSG = 100052,
    CHAT_ADD_MEMBER_CHANGE = 100053, -- 添加或删除聊天室人员发生变动
    --CHAT_UPDATE_MSG_USERINFO = 100054, -- 更新信息发送者信息
    CHAT_SHARE_COMMAND = 100055,  -- 聊天分享
	CHAT_SHARE_EXECUTE_CMD = 100056, -- 聊天点击
    --CHAT_INFO_LIKE = 100056,  -- 聊天点赞
    CHAT_MOVETOBOTTOM = 100057,-- 聊天消息滑动到最底下
    CHAT_PRIVATE_TALK = 100058,-- 聊天发送个人消息
	CHAT_ROOM_PIN = 100059,-- 设置room成pin状态
	CHAT_ROOM_UNPIN = 100060,-- 设置room成unpin状态
	CHAT_ROOM_SEL = 100061, -- 选择房间，用来设置最后一次打开房间的时间
	CHAT_VIEW_CLOSE = 100062,	-- 关闭UI界面
    CHAT_REFRESH_ALL_UNREADNUM = 100063, -- 刷新未读红点总数
    CHAT_ENTER_ROOM_OK = 100064,  -- 进入房间成功
	CHAT_ERROR_OR_DISCONNECT = 100065, -- 聊天出错或者断开

    -- 界面点击
    LF_ChatCellSelect = 100101,
    LF_UpdateChatData = 100102,
    LF_SlidingCell = 100103,
    LF_ChatOpenView = 100104,
    LF_OnSendClick = 100105,
    LF_CloseChatView = 100106,
    LF_ChangeInputFieldState = 100107,
    LF_ChatCloseCommanderTips = 100108,
    LF_UPDATE_UIMAIN_CHAT_MSG = 100109,
    LF_Enum_UpdateRoomOperateInfo = 100110,
    CHAT_TALK_TO_PRIVATE = 100111, --私聊,点击其他玩家头像,进行聊天
    CHAT_SEND_ROOM_MSG_UP_COMMAND =100112,--为某条消息点赞
    UPDATE_USER_MSG =100113,--消息刷新
}



