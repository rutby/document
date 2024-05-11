--[[
	聊天翻译系统
]]

local TranslateManager = BaseClass("TranslateManager")
local rapidjson = require "rapidjson"

-- 翻译地址
local TRANS_URL = "http://10.7.88.22:83/client.php"
local TRANS_CHANNEL	= "ds"

function TranslateManager:__init()
	self.version = ChatInterface.getVersionName()
	
	--if ChatInterface.isDebug() then
		--TRANS_URL = "http://10.7.88.22:83/client.php"
	--else
		TRANS_URL = "http://translate-ds.metapoint.club/client.php"
	--end
	
	local isMiddleEast = false; -- GlobalData::shared()->isMiddleEast();
	if isMiddleEast then
		TRANS_URL = "http://translate-ds.metapoint.club/client.php"
	end
		
	---聊天----
	self:ClearDatas()
end

function TranslateManager:ClearDatas()
    self.reqChatDataList = {}		-- 当前正在请求翻译的聊天chatData列表
end

function TranslateManager:GetLangString(str)
    if not str then 
        str = ""
    end 
	if str == "zh-CN" or str == "zh_CN" or str == "zh-Hans" or str == "zh-CHS" or str == "cn" then 
        return "zh-Hans"
    elseif str == "zh-TW" or str == "zh_TW" or str == "zh-Hant" or str == "zh-CHT" or str == "tw" then 
        return "zh-Hant"
    end
    return str
end

-- 制作post参数，老规矩
function TranslateManager:MakePostParam(srcLang, targetLang, content)
	--local timeStamp = math.floor(ChatInterface.getServerTime())
	local tarL = self:GetLangString(targetLang)
	
	local oriL = srcLang -- "auto"--self:GetLangString(originLang);
	local pUid = ChatInterface.getPlayerUid();
	local sid = ChatInterface.getSelfServerId();
	local ui = pUid .. "," .. sid .. "," .. self.version
	local translateKey = ChatInterface.getTranslateKey()
	
	-- 聊天频道
	local channel = TRANS_CHANNEL

	-- 这里的sig计算等放到了C#
	local t = {}
	t["sc"] = tostring(content)
	t["sf"] = tostring(oriL)
	t["tf"] = tostring(tarL)
	t["ch"] = tostring(channel)
	t["ui"] = tostring(ui)
	t["scene"] = tostring(channel)
	t["uid"] = tostring(pUid)
	t["tk"] = tostring(translateKey)

	return t
	
end

-- 开始翻译一个聊天（异步）
function TranslateManager:TranslateLang(chatData)
	
    local player = ChatInterface.getPlayer()
	local oriLang = chatData.originalLang
	local targetLang = ChatInterface.getLanguageName() -- "US" -- 这个应该是目前玩家选择的游戏语言！

	-- 组合翻译参数
	local urlParams = self:MakePostParam(oriLang, targetLang, chatData.msg)
	
	-- 插入到正在翻译列表
	table.insert(self.reqChatDataList, chatData)
	
	-- 开始http post翻译
	CS.ChatService.Instance:RequestTranslate(TRANS_URL, urlParams, 
		function (ok, text)
			-- 每次回来直接删除
			table.removebyvalue(self.reqChatDataList, chatData)
			
			self:onTranslateCallback(chatData, ok, text)
		end)
		
	return
end

--[[
翻译回调  服务器返回消息
]]

function TranslateManager:onTranslateCallback(chatData, ok, responseString)

	ChatPrint(responseString)
	--     --result = "{\"code\":0,\"originalLang\":\"EN\",\"targetLang\":\"zh_CN\",\"translateMsg\":\"你好！\"}";
	
	local ret = false
	if not string.IsNullOrEmpty(responseString) then
		local data = rapidjson.decode(responseString)
		if not data or data.code ~= 0 then
		else
			chatData.translateMsg = data.translateMsg
			chatData.translatedLang = data.targetLang
			ret = true
		end
	end
	
	-- 这里先模拟OK
	if ret == true then
		chatData:setIsTranslating(0)
		chatData:setTranslationMsg(chatData.translateMsg)
		ChatManager2:GetInstance().DB:InsertChatInfo(chatData, nil)
	else 
		chatData:setIsTranslating(-1)
	end
	
	-- 翻译完成通知
	EventManager:GetInstance():Broadcast(ChatInterface.getEventEnum().CHAT_UPDATE_ROOM_MSG, chatData)
	
end


--[[
	data 为 ChatMessage
]]
function TranslateManager:DoTranslate(chatData)
	--ChatPrint("准备去翻译-----------------:" .. data.seqId .. "--:" .. data.roomId)
	
	local myLang = self:GetLangString(ChatInterface.getLanguageName())
	
	-- 没有翻译过，或者翻译的目标语言和我当前的语言不一致
	if string.IsNullOrEmpty(chatData.translateMsg) --[[and chatData.originalLang ~= myLang]] then
		ChatPrint("去服务器翻译")
		-- 去服务器翻译
		self:TranslateLang(chatData)
	end
end

return TranslateManager