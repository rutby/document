--[[
    这个类是聊天消息的数据结构
	注意：入库的属性，不要做true和false，用1和0表示
]]

local ChatMessage = BaseClass("ChatMessage")
local rapidjson = require "rapidjson"
local ChatMessageHelper = require "Chat.Other.ChatMessageHelper"

function ChatMessage:__init()
	self.appId   = ""	  
	self.roomId  = ""	  -- 房间id
	self.group   = ""
	self.type = 0		-- 具体的类型分类，服务器也没有枚举，譬如type=4就表示踢人
	  
	--self.isNew 		   = false  -- 是否是新消息 应该和提示红点有关系
    self.isTranslating = 0  -- 正在翻译
    self.isTranslationFailed = 0  -- 翻译失败

	self._id = 0
	self.seqId = 1000  -- 服务器消息序号 
	self.senderUid  = "" -- 存储ChatUserInfo的uid
	self.senderName = ""
	-- self.channelType = 0 -- 聊天频道类型  0 国家 1 联盟 2 邮件 3 聊天室  4备用
	self.serverTime  = 0 -- 发送时的服务器时间 单位毫秒 对应后台传回来的createTime 作用于更新信息创建时间。针对别的玩家
	self.sendLocalTime = 0 -- 发送者本地时间   单位秒  主要用于发送聊天回包通过此字段查找数据库聊天数据更新数据用
	self.post = 		0 -- 消息类型
	self.msg 	= 		"" -- 消息体
	self.originalLang = "" -- 源语言国别类型
	
	self.translateMsg = "" -- 翻译信息
	self.translatedLang = "" -- 翻译的语言国别类型
	self.sendState 		= SendStateType.OK  -- 发送状态，0正在发送，1发送成功，2发送失败
	self.attachmentId   = "" -- msg 会根据这个字段进行拼接显示内容
	self.media 			= "" -- 媒体资源
	self.msgMask 		= "" -- 处理过的消息体，例如：处理过屏蔽字的消息
	self.extra			= nil
	self.attachmentMsg	= nil -- 显示的消息，如果没有解析过的话是nil
	self.interactLike = 0 --点赞数
	self.interactDisLike = 0 --踩数
end

function ChatMessage:isMyChat()
	return (not self:isSystemOrFestivalRedPack()) and self.senderUid == ChatInterface.getPlayerUid();
end

function ChatMessage:isMySendChat()
	return self:isMyChat() and (not self:isSystemChat()) and (not self:isRedPack());
end

function ChatMessage:isRedPack()
	return self.post == PostType.RedPackge
end

function ChatMessage:isSystemOrFestivalRedPack()
    if self:isRedPack() then 
        local msgType = self:getChatMessageType()
        return msgType ~= ChatMessageType.COMMON;
    else 
        return false
    end
end
--是否显示翻译按钮
function ChatMessage:isShowTranslateBtn()
    if string.find(self.media, "photo") then 
        return false
    end 
    if self.post == PostType.Text_Normal then 
        return true
    end 
    return false
end

function ChatMessage:isSystemChat()
	return self.post ~= PostType.Text_Normal and self.post ~= PostType.RedPackge and self.post ~= PostType.Text_Audio_Message
end

function ChatMessage:isVoiceChat()
	return self.post == PostType.VOICE;
end

function ChatMessage:setTranslationMsg(translateMsg)
	self.translateMsg = translateMsg
end

function ChatMessage:getTranslationMsg()
	return self.translateMsg
end

function ChatMessage:setOriginalLang(originalLang)
	self.originalLang = originalLang
end

function ChatMessage:setTranslatedLang(translatedLang)
	self.translatedLang = translatedLang
end

function ChatMessage:setSendState(sendingState)
	self.sendState = sendingState
end

-- 这个参数必须是-1, 0, 1
function ChatMessage:setIsTranslating(isTranslating)
	
	if isTranslating == true then
		self.isTranslating = 1
	elseif isTranslating == false then
		self.isTranslating = 0
	else
		self.isTranslating = isTranslating
	end
end

-- 是否正在翻译中
function ChatMessage:IsTranslating()
	if self.isTranslating == 1 then
		return true
	end
	
	return false
end

function ChatMessage:IsTranslatError()
	if self.isTranslating == -1 then
		return true
	end

	return false
end

---设置聊天序号
function ChatMessage:setSeqId(sequenceId)
	self.seqId = sequenceId
end

function ChatMessage:getSeqId()
	return self.seqId
end

function ChatMessage:getLikeNum()
	return self.interactLike
end

function ChatMessage:getDisLikeNum()
	return self.interactDisLike
end

--获取聊天消息类型 普通0、系统(普通1、节日2)
function ChatMessage:getChatMessageType()
    local msgType = ChatMessageType.COMMON
    if self.post == PostType.RedPackge then 
        local arr = string.split(self.attachmentId, "|")
        if #arr == 3 then 
            msgType = checknumber(arr[3])
        end 
    elseif self.post == PostType.Text_Use_Item_Share or 
		self.post == PostType.Text_AreaMsg or 
		self.post == PostType.Text_FBAllianceGift_Share then 
        msgType = ChatMessageType.System
    end
    return msgType
end

function ChatMessage:getSenderInfo()
	local userInfo = ChatManager2:GetInstance().User:getChatUserInfo(self.senderUid, false)
	return userInfo
end

----获取聊天玩家的名字----
function ChatMessage:getSenderName()
	local name = ""
    local msgType = self:getChatMessageType()
    if msgType == ChatMessageType.COMMON then
        local userInfo = self:getSenderInfo()
        if userInfo then 
            name = userInfo.userName
            --local crossFightSrcServerId = checknumber(userInfo.crossFightSrcServerId)
            --local serverId = crossFightSrcServerId <= 0 and checknumber(userInfo.serverId) or crossFightSrcServerId
            --local myServerId = ChatInterface.getSelfServerId()
            --if serverId ~= 0 and myServerId ~= serverId and  self.group == ChatGroupType.GROUP_COUNTRY  then
            --    name = name .. " #" .. serverId
            --end
        end
    elseif msgType == ChatMessageType.SYSTEM then 
        name = ChatInterface.getString("310002") -- 系统（凯瑟琳）
    elseif msgType == ChatMessageType.FESTIVAL then 
        name = ChatInterface.getString("100347") -- 节日大使
    end 
    
    return name;
end

---获取聊天玩家带联盟的名字
function ChatMessage:getSenderNameWithAlliance()
	
	local msgType = self:getChatMessageType()
	if msgType == ChatMessageType.COMMON then
		-- 联盟频道不显示[abbr]name
		if self.group ~= ChatGroupType.GROUP_ALLIANCE then
		    local userInfo = self:getSenderInfo()
		    if userInfo and not string.IsNullOrEmpty(userInfo.allianceSimpleName) then 
		        return string.format("[%s]%s", userInfo.allianceSimpleName, self:getSenderName())
		    end
		end
	end
	
    return self:getSenderName()
end

-- 消息条目的服务器时间，单位毫秒，是一个浮点数
function ChatMessage:getServerTime()
	return self.serverTime
end

-- 返回创建的秒。是一个整数
function ChatMessage:getCreateTime()
	local t = self:getServerTime() / 1000
	return math.ceil(t)
end

---解析服务器数据
function ChatMessage:onParseServerData(tabData)
    if type(tabData) ~= "table" then 
        return
    end
    self.roomId = tabData.roomId
    self.group = tabData.group
    self.appId = tabData.appId
    self.post  = 0
	 
    if tabData.msg then 
    	self.msg = tabData.msg 
    end

	if tabData.interact~=nil then
		self.interactLike = tabData.interact.like
		self.interactDisLike =tabData.interact.dislike
	end

    ChatMessageHelper:onParseExtraData(self, tabData.extra)

    if tabData.seqId then 
    	self.seqId = tabData.seqId
    end 

    --if tabData.isNew then 
    	--self.isNew = tabData.isNew
    --end

    if tabData.sendState then
        self.sendState = tabData.sendState 
    end
    self.senderUid = tabData.sender 
    local sendTime = tabData.sendTime 
	
    if string.len(sendTime) == 13 then 
    	self.sendLocalTime = math.floor(sendTime/1000)
    else
    	self.sendLocalTime = sendTime 
    end 
	
    if tabData.serverTime then
		if isInteger(tabData.serverTime) and string.len(tabData.serverTime) == 10 then
			self.serverTime = tabData.serverTime * 1000
		else
			self.serverTime = tabData.serverTime
		end
	end 

	-- 目前这个信息处于废弃状态
	-- 如果需要传递originalLang的话。
	-- 可以填充两个地方之一：senderinfo.lang 或者 extra.'userLang'
	-- 因为翻译通过这个originalLang去判断的话，不是很靠谱
	-- 譬如：菲律宾玩家用的英文手机，也用的英语游戏语言；但是他们还是习惯的输入菲律宾语言
	if tabData.originalLang then 
		if string.IsNullOrEmpty(tabData.originalLang) then
			local t = 0
		end
        self.originalLang = tabData.originalLang
    end 
    
	if tabData.translationMsg then 
		self.translateMsg = tabData.translationMsg
	end
	
	-- 自定义频道的一些特殊操作，譬如踢人，加入等
	if tabData.type and checknumber(tabData.type) > 0 and tostring(self.group) == ChatGroupType.GROUP_CUSTOM then
		self.type = tabData.type
		self.post = PostType.Text_ChatRoomSystemMsg
	end
		
    if tabData.msg_mask then 
        self.msgMask = tabData.msg_mask
    elseif tabData.msgMask then
        self.msgMask = tabData.msgMask
    else
        self.msgMask = ChatManager2:GetInstance().Filter:filterSensitiveWord(self.msg)
    end 
	
	-- 这个地方接收一下senderInfo的信息
	-- 因为senderInfo有点基本信息，异步请求人物信息需要时间
	-- 这里就是为了弥补时间差而做的一个小的修正
	local uinfo = ChatManager2:GetInstance().User:getChatUserInfo(self.senderUid, false)
	if tabData.senderInfo then
		if uinfo then
			if (toInt(uinfo.lastUpdateTime) >= toInt(tabData.senderInfo.lastUpdateTime)) then
				self.senderName = uinfo.userName
			else
				if not string.IsNullOrEmpty(tabData.senderInfo.userName) then
					uinfo.userName = tabData.senderInfo.userName
				end
				if not string.IsNullOrEmpty(tabData.senderInfo.abbr) then
					uinfo.allianceSimpleName = tabData.senderInfo.abbr
				end
			end
		end
	else
		if uinfo then
			self.senderName = uinfo.userName
		end
	end
	
end

function ChatMessage:isSystemMsg()
    return self.post == PostType.Text_ChatRoomSystemMsg
end

function ChatMessage:getMaskMsg()
    if string.IsNullOrEmpty(self.msgMask)  then 
        self.msgMask = ChatManager2:GetInstance().Filter:filterSensitiveWord(self.msg)
    end
    return self.msgMask
end

-- 获取选项信息
-- isFullMsg表示是否为完整消息；
-- 完整消息：显示在聊天中的消息；
-- 不完整消息：显示在主UI下面的展示消息
function ChatMessage:getMessageWithExtra(isFullMsg)
	
	if isFullMsg ~= false then
		isFullMsg = true
	end
	
    return ChatMessageHelper:getMessageWithExtra(self, isFullMsg)
end

-- 获取消息中携带的参数table
function ChatMessage:getMessageParam()
	return ChatMessageHelper.getShowParam(self)
end

-- 检测是否为系统消息，是系统消息的话，有SYS标志。貌似目前没怎么用
function ChatMessage:CheckSYS()
    if self.post == PostType.Text_AllianceMemberInOut then
        return true
    end
    return false
end

function ChatMessage:CheckHide()
    -- 红包过期消息不显示
    --if self.post == PostType.Text_AllianceRedPack and (self.endTime / 1000) < ChatInterface.getServerTime() then
    --    return true
    --end
    --if self.post == PostType.Text_AllianceWelcome then
    --    if self.senderUid == ChatInterface:getPlayerUid() then
    --        return true
    --    end
    --    local limitTime = LuaEntry.DataConfig:TryGetNum("alliance_chat_config", "k1")
    --    limitTime = limitTime * 60 + self:getCreateTime()
    --    if CS.LF.LuaGameEntry.GetTimer():GetServerTimeSeconds() > limitTime then
    --        return true
    --    end
    --elseif self.post == PostType.Text_AllianceGather then
    --    return not self:CheckGatherValid()
    --end
    --if self.group == ChatGroupType.GROUP_ALLIANCE then
        --local alInfo = AllianceManager:getAllianceInfo()
        --if alInfo then
            --if self.createTime < (alInfo.jointime / 1000 + 150) then
                --return true
            --end
        --end
    --end
    return false
end

function ChatMessage:getMediaInfo(key)
    if string.IsNullOrEmpty(self.media) then 
        return ""
    end 
    local mediaStr = ""
    local mediaJson = rapidjson.decode(self.media)
    if mediaJson[key] then 
        mediaStr = mediaJson[key]
    end 
    return mediaStr
end

return ChatMessage





