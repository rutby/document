--[[
	邮件翻译系统
]]

local MailTranslateManager = BaseClass("MailTranslateManager")
local rapidjson = require "rapidjson"
local Localization = CS.GameEntry.Localization

-- 翻译地址
local TRANS_URL = "http://10.7.88.22:83/client.php"
local TRANS_CHANNEL	= "ds"

function MailTranslateManager:__init()
	self.translatingList = {}
	
	self.version = ChatInterface.getVersionName()
	
	TRANS_URL = "http://translate-ds.metapoint.club/client.php"
	
	local isMiddleEast = false; -- GlobalData::shared()->isMiddleEast();
	if isMiddleEast then
		TRANS_URL = "http://app1.im.medrickgames.com:8083/v3/client.php"
	end
		
	self:ClearDatas()
end

function MailTranslateManager:ClearDatas()
	self.translatingList = {}
end

function MailTranslateManager:GetLangString(str)
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
function MailTranslateManager:MakePostParam(srcLang, targetLang, content)
	--local timeStamp = math.floor(ChatInterface.getServerTime())
	local tarL = self:GetLangString(targetLang)
	
	local oriL = srcLang -- "auto"--self:GetLangString(originLang);
	local pUid = LuaEntry.Player.uid
	local sid = LuaEntry.Player.serverId
	local ui = pUid .. "," .. sid .. "," .. self.version
	local translateKey = LuaEntry.Player.translateKey-- ChatInterface.getTranslateKey()
	
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

function MailTranslateManager:TranslateMail(origInfo)
	if not origInfo then
		return false
	end
	local oriLang = ""
	local targetLang = Localization:GetLanguageName()
	local strMsg = origInfo:GetMailMessage()
	local urlParams = self:MakePostParam(oriLang, targetLang, strMsg)
	table.insert(self.translatingList, origInfo)

	CS.ChatService.Instance:RequestTranslate(TRANS_URL, urlParams,
			function (ok, text)
				table.removebyvalue(self.translatingList, origInfo)
				self:onTranslateCallback(origInfo, ok, text)
			end)
	return true
end

--[[
翻译回调  服务器返回消息
]]
function MailTranslateManager:onTranslateCallback(origInfo, ok, responseString)
	--     --result = "{\"code\":0,\"originalLang\":\"EN\",\"targetLang\":\"zh_CN\",\"translateMsg\":\"你好！\"}";
	
	local ret = false
	if not string.IsNullOrEmpty(responseString) then
		local data = rapidjson.decode(responseString)
		if not data or data.code ~= 0 then
		else
			origInfo.translateMsg = data.translateMsg
			origInfo.translatedLang = data.targetLang
			ret = true
		end
	end
	
	-- db操作
	if ret == true then
		DataCenter.MailDataManager:SetMailTranslated(origInfo.uid, origInfo.translateMsg, origInfo.translatedLang)
		EventManager:GetInstance():Broadcast(EventId.ChangeShowTranslatedStatus, origInfo)
	end
	
	-- 翻译完成通知
	--EventManager:GetInstance():Broadcast(EventId.ChangeShowTranslatedStatus, origInfo)
end

--
----[[
--	data 为 ChatMessage
--]]
--function MailTranslateManager:DoTranslate(chatData)
--	--ChatPrint("准备去翻译-----------------:" .. data.seqId .. "--:" .. data.roomId)
--	
--	local myLang = self:GetLangString(ChatInterface.getLanguageName())
--	
--	-- 没有翻译过，或者翻译的目标语言和我当前的语言不一致
--	if string.IsNullOrEmpty(chatData.translateMsg) --[[and chatData.originalLang ~= myLang]] then
--		ChatPrint("去服务器翻译")
--		-- 去服务器翻译
--		self:TranslateLang(chatData)
--	end
--end

return MailTranslateManager