--[[
	聊天组类别

	现在只有普通聊天室（关键词：custom），工会聊天室（force）, 战区（就是国家--country），联盟(alliance)，以及个人邮件。语言聊天室（language），势力聊天室（warzone）,已经关闭了。
]]

ChatGroupType = 
{
    GROUP_COUNTRY  = "country",	  --战区
    GROUP_ALLIANCE = "alliance",  --联盟
    GROUP_WARZONE  = "warzone",   --没用了
    GROUP_CROSS_SERVER = "custom_crossbattle_",--跨服联盟战争
    GROUP_DRAGON_SERVER = "custom_starwar_",--巨龙聊天
    GROUP_EDEN_CAMP = "custom_eden_camp_",--伊甸园阵营
    GROUP_CUSTOM   = "custom",	  --自定义聊天室
    GROUP_FORCE    = "force", 	  --现在的伊甸园用的一个聊天室，俗称公会
    GROUP_MAILCHAT = "mailChat",  --邮件聊天
    GROUP_QUEST    = "quest",     --任务
    GROUP_RADAR    = "radar",     --警报
    GROUP_TMPRoom  = "tmpRoom",   --临时房间列表
    GROUP_AL_AUTO_INVITE = "alAutoInvite",--联盟自动邀请
}

ChatGroupId = 
{
	[ChatGroupType.GROUP_COUNTRY]  	= 0, 
	[ChatGroupType.GROUP_ALLIANCE] 	= 1,
    [ChatGroupType.GROUP_EDEN_CAMP] 	= 2,
    [ChatGroupType.GROUP_DRAGON_SERVER] 	= 3,
    [ChatGroupType.GROUP_CROSS_SERVER] 	= 4,
    [ChatGroupType.GROUP_WARZONE] 	= 5, 
	[ChatGroupType.GROUP_CUSTOM]    = 6, 
	[ChatGroupType.GROUP_FORCE] 	= 7,
	[ChatGroupType.GROUP_MAILCHAT] 	= 8,
    [ChatGroupType.GROUP_QUEST]     = 9,
    [ChatGroupType.GROUP_RADAR]     = 10,
}

ChatGroupTypeImg = 
{
    [ChatGroupType.GROUP_COUNTRY] = "UIchat_tabicon_world02",
    [ChatGroupType.GROUP_ALLIANCE] = "UIchat_tabicon_alliance02",
    [ChatGroupType.GROUP_RADAR] = "UIchat_tabicon_rader",
}

