--[[
	ChatMessage 辅助类
	注意这里的self，多半指chatData

	这个Helper主要用来处理分享消息
	1。分享消息是把相关的数据打包成一个字符串然后传给服务器
	然后再根据字符串进行解析；
	2。如果是声音或者图片的话，就把数据上传到CDN服务器
	然后把拉取的uri发出去
	3。从理论上来讲，外界不需要关心如何打包这个字符串
	外界应该穿一个数据相关的table，然后由这个类提供一个打包函数
	解包也一样，由这个类处理，然后返回用户相关的table。
	调用方和聊天维护人员约定好table中的具体数据即可
]]

local ChatMessageHelper = {}
local rapidjson = require "rapidjson"
local Localization = CS.GameEntry.Localization

local ShareEncode = require "Chat.Other.ShareEncode"
local ShareDecode = require "Chat.Other.ShareDecode"
local ShareExecute = require "Chat.Other.ShareExecute"

-- 获取显示相关的字条颜色
local function getColorString(self, vColorDefine, str, isFullMsg)
	if isFullMsg == false then
		return str
	end

	local colorStr = ""
	if vColorDefine == 1 then --WHITE:Red:227 green:227 blue:227
		colorStr = "<text color=FFFFFF>"
	elseif vColorDefine == 2 then --GREEN:Red:36 green:255 blue:0
		colorStr = "<text color=24FF00>"
	elseif vColorDefine == 3 then --BLUE:Red:0 green:132 blue:255
		colorStr = "<text color=0084FF>"
	elseif vColorDefine == 4 then --PURPLE:Red:246 green:0 blue:255
		colorStr = "<text color=F600FF>"
	elseif vColorDefine == 5 then --ORANGE:Red:255 green:138 blue:0
		colorStr = "<text color=FF8A00>"
	elseif vColorDefine == 6 then --GOLDEN:Red:255 green:210 blue:0
		colorStr = "<text color=FFFFFF>"
	elseif vColorDefine == 7 then --RED:Red:255 green:0 blue:0
		colorStr = "<text color=FFFFFF>"
	elseif vColorDefine == 8 then --8-11为VIP文字的显示颜色  :Red:255 green:243 blue:190
		colorStr = "<text color=FFFFFF>"
	elseif vColorDefine == 9 then --:Red:236 green:236 blue:236
		colorStr = "<text color=FFFFFF>"
	elseif vColorDefine == 10 then --:Red:255 green:243 blue:190
		colorStr = "<text color=FFFFFF>"
	elseif vColorDefine == 11 then --:Red:196 green:240 blue:255
		colorStr = "<text color=FFFFFF>"
	else --WHITE:Red:255 green:255 blue:255
		colorStr = "<text color=FFFFFF>"
	end
	return string.format("%s%s%s", colorStr, str, "</color>")
end


local function getAllianceGatherMessage(self)
	local name = ""
	if self.attachmentId then
		local paraArr = string.split(self.attachmentId, "|")
		if #paraArr >= 6 then
			local isBoss = paraArr[1]
			if isBoss == "1" then
				local monsterName = _lang(paraArr[5])
				local strLevel = string.format("LV%s", paraArr[6])
				name = string.format("%s\u{00A0}%s", monsterName, strLevel)
			else
				name = paraArr[5]
				name = String.replace(name, " ", "\u{00A0}")
			end
		end
	end
	return _lang("138199", name)
end

local function getAllianceMarkMessage(self)
	if self.attachmentId then
		local paraArr = string.split(self.attachmentId, "|")
		if #paraArr >= 5 then
			if paraArr[1] == "1" then
				return _lang("138440")
			elseif paraArr[1] == "2" then
				return _lang("138481")
			elseif paraArr[1] == "3" then
				return _lang("138482")
			end
		end
	end
	return ""
end


--新的地块战斗战报分享
local function handleNewFightReportShare(self, extraData)
	if extraData.dialog and extraData.msgarr then
		local msgarr = extraData.msgarr
		if #msgarr > 0 then
			local nameString = ""
			for _,namesStr in ipairs(msgarr) do
				if nameString ~= "" then
					nameString = nameString .. "||" .. namesStr
				else
					nameString = namesStr
				end
			end
			local dialogString = extraData.dialog
			if dialogString ~= "" and  nameString ~= ""  then
				dialogString = dialogString .. "||" .. nameString
			end
			local attachmentID = extraData.reportUid and extraData.reportUid or ""
			if extraData.mailType then
				attachmentID = attachmentID .. "#" .. extraData.mailType
			end
			if  attachmentID ~= "" then
				self.attachmentId = attachmentID .. "__" .. dialogString
			end
		end
	end
end

--新联盟转盘分享
local function handleAllianceCommonShare(self, extraData)
	local dialogKey = extraData.dialog
	if dialogKey then
		local array = extraData.msgarr
		if array then
			local nameStr = "";
			if table.count(array) > 0 then
				for _,nameString in pairs(array) do
					if nameStr ~= "" then
						nameStr = nameStr .. "||"
					end
					nameStr = nameStr .. nameString
				end
				if dialogKey ~= "" then
					self.attachmentId = string.format("%s||%s",dialogKey,nameStr)
				end
			end
		end
	end
end


local function handleEquipShare(self, extraData)
	--equipId__dailog||color||name
	local  equipIdString = extraData.equipId
	if equipIdString then
		local nameString 	= ""
		local colorString 	= "1"
		if extraData.dialog then
			local dialog = extraData.dialog
			if not string.IsNullOrEmpty(dialog) then
				dialog = dialog .. "||" .. colorString .. "||" .. nameString
			end

			if string.len(equipIdString) > 0 then
				self.attachmentId = equipIdString .. "__" .. dialog
			end
		end

	end
end

local function handleTurnTableShare(self, extraData)
	if extraData.lotteryInfo and extraData.dialog then
		local lotteryInfoString = extraData.lotteryInfo
		local dialog = extraDic.dialog
		local attachmentID = ""
		if not string.IsNullOrEmpty(lotteryInfoString)  then
			attachmentID = lotteryInfoString
			if not string.IsNullOrEmpty(dialog) then
				attachmentID = attachmentID .. "__" .. dialog
			end
			self.attachmentId = attachmentID
		end
	end
end

local function handleFightReport(self, extraData)
	--战报
	-- attachmentID__Dialog||Name1||Name2...
	local msgarr = extraData.msgarr
	local dialogString = extraData.dialog
	if dialogString and msgarr and table.count(msgarr) > 0 then
		local nameString = ""
		for _,namesStr in pairs(msgarr) do
			if nameString ~= "" then
				nameString = nameString .. "||" .. namesStr
			else
				nameString = nameString .. namesStr
			end
		end

		if dialogString ~= "" and nameString ~= "" then
			dialogString = dialogString .. "||" .. nameString
		end
		local attachmentID = ""
		if extraData.reportUid then
			attachmentID = extraData.reportUid
		elseif extraData.teamUuid then
			attachmentID = extraData.teamUuid
		end
		if attachmentID ~= "" then
			self.attachmentId = attachmentID .. "__" .. dialogString
		end
	end
end

--处理红包逻辑
function ChatMessageHelper:handleRedPacket(extraData)
	if extraData.redPackets and extraData.server then
		local redPacketsId = extraData.redPackets
		local serverId = extraData.server
		local attachmentId = redPacketsId .. "_" .. serverId
  
		-- if ([[ChatServiceController chatServiceControllerSharedManager].redPackgeMsgGotArray containsObject:ns_attachmentId]) {
		--     ns_attachmentId = [NSString stringWithFormat:@"%@|0", ns_attachmentId];
		-- } else {
		--     ns_attachmentId = [NSString stringWithFormat:@"%@|1", ns_attachmentId];
		-- }
		self.attachmentId = attachmentId .. "|1";
		-- 由于老版本没有区分红包类型，普通红包redPackectSysType==0不处理
		-- 系统红包:红包id_serverid|status|redPackectSysType
		-- 普通红包:红包id_serverid|status
		if extraData.dialog and extraData.msgarr then
			if extraData.redPackectSysType then
				self.attachmentId = string.format("%s|%s",self.attachmentId,extraData.redPackectSysType)
			else
				self.attachmentId = string.format("%s|1",self.attachmentId)
			end

			local name = extraData.dialog
			local msgArr = extraData.msgarr
			if table.count(msgArr) == 2 then
				self.msg = ChatInterface.getString(name,msgArr[1],msgArr[2])
			else
				self.msg = ChatInterface.getString(name)
			end
		end
	end
end

--战斗消息
local function getFightMessage(self, isFullMsg)
	local showString = ""
	local attachmentId = self.attachmentId
	local attachmentIDArray = string.split(attachmentId, "__")
	if #attachmentIDArray > 1 then
		local dialogString = attachmentIDArray[2]
		local dialogArray = string.split(dialogString, "||")
		local dialogKey = dialogArray[1]
		if #dialogArray == 2 then
			local name1 = dialogArray[2];
			if name1 == "200637" or name1 == "200639" or name1 == "200640" then
				name1 = ChatInterface.getString(name1)
			end
			showString = ChatInterface.getString(dialogKey, name1)
		elseif #dialogArray == 3 then
			local name1 = dialogArray[2];
			local name2 = dialogArray[3];
			local n = checknumber(name2)
			if not n then
				name1 = "(" .. name1 .. ")"
				local name2Arr = string.split(name2, " ")
				local keyStr = ""
				for i = 1, #name2Arr, 1 do
					keyStr = keyStr .. name2Arr[i]
				end
				name2 = ChatInterface.getString(keyStr)
				showString = ChatInterface.getString(dialogKey, name1 .. name2)
			else
				showString = ChatInterface.getString(dialogKey, name2)
			end
		else
			showString = self:getMaskMsg()
		end
	end
	-- if not isChannelCell then
	--     showString = showString .. "<image scale=0.45>#UI_liaotian_battlereport.png</image>"
	-- else
	--     showString = showString
	-- end
	showString = showString
	return showString
end


--装备分享消息
local function getEquipMessage(self, isFullMsg)
	local showString = ""
	local attachmentId = self.attachmentId
	local attachmentIDArray = string.split(attachmentId, "__")
	if #attachmentIDArray > 1 then
		local dialogString = attachmentIDArray[2]
		local dialogArray = string.split(dialogString, "||")
		if #dialogArray == 3 then
			local equipKey = dialogArray[3]
			local changeTextString = ChatInterface.getString(equipKey)
			changeTextString = getColorString(checknumber(dialogArray[2]), changeTextString, isFullMsg)
			local dialogKey = dialogArray[1]
			if dialogKey ~= "" then
				showString = ChatInterface.getString(dialogKey, changeTextString)
			else
				showString = ChatInterface.getString("111660", changeTextString)
			end
		else
			local equipInfo = string.split(msg, "|")
			if #equipInfo >= 2 then
				local changeTextString = equipInfo[2]
				if changeTextString ~= "" then
					changeTextString = ChatInterface.getString(changeTextString)
				end
				changeTextString = getColorString(checknumber(equipInfo[1]), changeTextString, isFullMsg)
				showString = ChatInterface.getString("111660", changeTextString)
				if isFullMsg then
					showString = showString .. "<image scale=0.55>#UI_liaotian_equip_share.png</image>"
				else
					showString = showString
				end
			else
				showString = ChatInterface.getString("111660")
			end
		end
	end

	return showString
end

--聊天集结消息
local function getAllianceRallyMsg(self)
	local showString = ""
	local attachmentId = self.attachmentId
	local attachmentIDArray = string.split(attachmentId, "__")
	if #attachmentIDArray > 1 then
		local dialogString = attachmentIDArray[2]
		local dialogArray = string.split(dialogString, "||")
		if #dialogArray >= 2 then
			local userNameString = dialogArray[2]
			local dialogKey = dialogArray[1]
			if dialogKey ~= "" then
				showString = ChatInterface.getString(dialogKey, userNameString)
			else
				showString = ChatInterface.getString("132118", changeTextString)
			end
		end
	end
	return showString
end

--使用道具分享消息
local function getUseItemMsg(self)
	local showString = ""
	local attachmentId = self.attachmentId
	local attachmentIDArray = string.split(attachmentId, "||")
	if #attachmentIDArray > 3 then
		local dialogKey = attachmentIDArray[1]
		local name = attachmentIDArray[2]
		local itemName = ""
		local para = attachmentIDArray[3]
		local paramsArr = string.split(para, "X")
		if #paramsArr == 2 then
			local itemNameStr = LuaCommon:getNameById(paramsArr[1])
			itemName = string.format("%s X%s", itemNameStr, paramsArr[2])
		end
		local rewardStr = LuaCommon:getUseShareRewardStr(attachmentIDArray[4])
		showString = ChatInterface.getString(dialogKey, name, itemName, rewardStr)
	end
	return showString
end

--新末日投资分享
local function getSevenDayMsg(self)
	local showString = ""
	local attachmentIDArray = string.split(self.attachmentId, "||")
	if #attachmentIDArray == 2 then
		local dialogKey = attachmentIDArray[1]
		local nameStr = ChatInterface.getString(attachmentIDArray[2])
		showString = ChatInterface.getString(dialogKey, nameStr)
	elseif #attachmentIDArray == 3 then
		local dialogKey = attachmentIDArray[1]
		local nameStr = ChatInterface.getString(attachmentIDArray[3])
		showString = ChatInterface.getString(dialogKey, attachmentIDArray[2], nameStr)
	else
		showString = msg
	end
	return showString
end

--联盟导弹信息
local function getAllianceMissileMsg(self)
	local showString = ""
	local attachmentId = self.attachmentId
	local attachmentIDArray = string.split(attachmentId, "||")
	if #attachmentIDArray == 4 then
		local dialogKey = attachmentIDArray[1]
		local posStrArr = string.split(attachmentIDArray[4], ":")
		local posStr = ""
		for i = 1, #posStrArr, 1 do
			posStr = posStr .. posStrArr[i]
		end
		showString = ChatInterface.getString(dialogKey, attachmentIDArray[2], attachmentIDArray[3], posStr)
	else
		showString = msg
	end
	return showString
end

--末日导弹信息
local function getDommsdayMissileMsg(self)
	local showString = ""
	local attachmentIDArray = string.split(self.attachmentId, "|")
	local dialogKey = attachmentIDArray[1]
	local normalStr = ""
	local count = #attachmentIDArray
	if count <= 4 then
		showString = msg
	else
		if attachmentIDArray[2] ~= "" then
			normalStr = string.format("(#%s %s:%s)", attachmentIDArray[2], attachmentIDArray[3], attachmentIDArray[4])
		else
			normalStr = string.format("(%s:%s)", attachmentIDArray[3], attachmentIDArray[4])
		end
		local nameStr = attachmentIDArray[5]
		showString = ChatInterface.getString(dialogKey, nameStr, normalStr)
	end
	return showString
end

--送花消息
local function getSendFlowerMsg(self)
	local showString = ""
	local attachmentIDArray = string.split(self.attachmentId, "|")
	if #attachmentIDArray == 3 then
		local dialogKey = attachmentIDArray[1]
		local p1 = attachmentIDArray[2]
		local p2 = attachmentIDArray[3]
		showString = ChatInterface.getString(dialogKey, p1, p2)
	elseif #attachmentIDArray == 2 then
		local dialogKey = attachmentIDArray[1]
		local p1 = attachmentIDArray[2]
		showString = ChatInterface.getString(dialogKey, p1)
	else
		showString = ChatInterface.getString("90823263")
	end
	return showString
end

local function GetHeroQuality(quality)
	if quality then
		local qualityStrs = {"150534", "150535", "150536", "150537", "150538", "150539", "150540", "150541", "150542"}
		quality = tonumber(quality)
		local qStr = qualityStrs[quality -1]
		if qStr then
			return _lang(qStr)
		end
	end
	return ""
end

-- 红包内容
local function getAllianceRedPackMessage(chatMessage)
	if chatMessage.params_al == nil then
		return ""
	end
	local ret = ""
	local userName = chatMessage.userName
	userName = String.replace(userName, " ", "\u{00A0}")
	if chatMessage.typ == RedPackageType.LevelUp then
		if #chatMessage.params_al >= 1 then
			local level = chatMessage.params_al[1]
			ret = _lang("138205", userName, level)        -- 恭喜[{0}]的避难所成功升至{1}级
		end
	elseif chatMessage.typ == RedPackageType.Hero_Quality_4 then
		if #chatMessage.params_al >= 1 then
			local heroId = chatMessage.params_al[1]
			--local config = GameEntry.DataTable:GetDataRow(TableName.Heroes, tostring(heroId))
			local config = CS.LF.LuaHelper.Table:GetDataRow(TableName.Heroes, heroId);
			if config then
				local nameKey = config:GetString("name")
				local nameStr = _lang(nameKey)
				local colorStr = CS.LF.LuaHelper.Table:GetString(CS.LFDefines.TableName.HeroQuality, 4, "color")
				nameStr = CS.HeroListUtil.AddColor(nameStr, colorStr)
				ret = _lang("138206", userName, nameStr)  -- 恭喜[{0}]获得了极品英雄[{1}]
			end
		end
	elseif chatMessage.typ == RedPackageType.Hero_Quality_7 then
		if #chatMessage.params_al >= 1 then
			local heroId = chatMessage.params_al[1]
			--local quality = chatMessage.params_al[2]
			--local config = GameEntry.DataTable:GetDataRow(TableName.Heroes, tostring(heroId))
			local config = CS.LF.LuaHelper.Table:GetDataRow(TableName.Heroes, heroId);
			if config then
				local nameKey = config:GetString("name")
				local nameStr = _lang(nameKey)
				local colorStr = CS.LF.LuaHelper.Table:GetString(CS.LFDefines.TableName.HeroQuality, 7, "color")
				nameStr = CS.HeroListUtil.AddColor(nameStr, colorStr)
				ret = _lang("138207", userName, nameStr, chatMessage:GetHeroQuality(7)) -- 恭喜[{0}]成功将英雄[{1}]提升至{2}品质
			end
		end
	end
	return ret
end

-- 招募十连抽分享消息
local function getShareHeroTenGetMessage(chatMessage)
	--Debug.LogError("招募参数:"..chatMessage.attachmentId);
	local ret = "";

	if chatMessage.attachmentId then
		local paraArr = string.split(chatMessage.attachmentId, "|")
		if #paraArr >= 1 then
			local recruitName = paraArr[1];
			local names = "";
			for i = 2, #paraArr do
				local config = CS.LF.LuaHelper.Table:GetDataRow(TableName.Heroes, paraArr[i]);
				--Debug.LogError("config = "..tostring(config));
				if config ~= nil then
					--Debug.LogError("quality_min = "..config:GetString("quality_min"));
					if config:GetInt("quality_min") >= 4 then
						local nameKey = config:GetString("name");
						local nameStr = _lang(nameKey);
						local colorStr = CS.LF.LuaHelper.Table:GetString(CS.LFDefines.TableName.HeroQuality, 4, "color")
						nameStr = CS.HeroListUtil.AddColor(nameStr, colorStr);
						if names ~= "" then
							names = names..", ";
						end
						names = names..nameStr;
					end
				end
			end
			if chatMessage.msg == "0" then
				ret = _lang("162164", recruitName)..names;
			else
				ret = _lang("162164", _lang(chatMessage.msg))..names;
			end
		end
	end
	
	return ret
end


-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------


-- 联盟红包
-- FIXME: 这个做的时候一定要修改一下！！太乱了！
function ChatMessageHelper:handleAllianceRedPacket(chatMessage, extraData)
	local redPackInfo = extraData.redPackAllianceInfo
	if redPackInfo then
		chatMessage.coinType = redPackInfo.coinType
		chatMessage.coinNum = redPackInfo.coinNum
		chatMessage.remain = redPackInfo.remain
		chatMessage.params_al = redPackInfo.params
		chatMessage.typ = redPackInfo.type
		chatMessage.userName = redPackInfo.userName
		chatMessage.uuid = redPackInfo.uuid
		chatMessage.allianceId = redPackInfo.allianceId
		chatMessage.total = redPackInfo.total
		chatMessage.name = redPackInfo.name
		chatMessage.startTime = redPackInfo.startTime
		chatMessage.endTime = redPackInfo.endTime
		chatMessage.desc = redPackInfo.desc
		chatMessage.senderServerId = redPackInfo.serverId
	end
	chatMessage.userLang = extraData.userLang
end


-- 这段代码已经不知道什么原因了
-- 可能是有些消息没有seqId。。。
function ChatMessageHelper:onParseExtraData(chatMessage, extraData)
	if not extraData then 
		return
	end 
	
	chatMessage.extra = extraData

	chatMessage.seqId  = extraData.seqId
	
	if extraData.post then 
		chatMessage.post = checknumber(extraData.post)
	end 

	if extraData.allianceId then --加入联盟
		chatMessage.attachmentId = extraData.allianceId
	elseif extraData.reportUid then --侦查分享
		chatMessage.attachmentId = extraData.reportUid
	elseif extraData.detectReportUid then 
		chatMessage.attachmentId = extraData.detectReportUid
	elseif extraData.equipId then --装备分享
		chatMessage.attachmentId = extraData.equipId
	elseif extraData.teamUuid then --集结消息
		chatMessage.attachmentId = extraData.teamUuid
	elseif extraData.lotteryInfo then --转盘分享
		chatMessage.attachmentId = extraData.lotteryInfo
	elseif extraData.attachmentId then 
		chatMessage.attachmentId = extraData.attachmentId
	elseif extraData.shamoInfo then --沙漠分享
		chatMessage.attachmentId = extraData.shamoInfo
	elseif extraData.media then 
		chatMessage.media = extraData.media
	end 

	if chatMessage.post == PostType.RedPackge then 
		 self:handleRedPacket(extraData)
	elseif chatMessage.post == PostType.Text_FightReport or chatMessage.post == PostType.Text_InvestigateReport or chatMessage.post == PostType.Text_SayHello then
		chatMessage:handleFightReport(extraData)
    elseif chatMessage.post == PostType.Text_Formation_Fight_Share then 
		local a = 1
        --chatMessage:handleNewFightReportShare(extraData)
	elseif chatMessage.post == PostType.Text_Formation_Share then

	elseif chatMessage.post == PostType.Text_MsgShare then
		
	elseif chatMessage.post == PostType.Text_ChampionBattleReportShare then

	elseif chatMessage.post == PostType.Text_TurntableShare then
		chatMessage:handleTurnTableShare(extraData)
    elseif chatMessage.post == PostType.Text_EquipShare then 
    	chatMessage:handleEquipShare(extraData)
    elseif chatMessage.post == PostType.Text_PointShare or chatMessage.post == PostType.Text_Favour_Point_Share then 
    	if extraData.attachmentId then 
            chatMessage.attachmentId = extraData.attachmentId
        end
    elseif chatMessage.post == PostType.Text_AllianceTaskHelper then 
    	if  extraData.attachmentId then 
            chatMessage.attachmentId = extraData.attachmentId
        end
    elseif chatMessage.post == PostType.Text_AllianceCreated or chatMessage.post == PostType.Text_AllianceAdded or chatMessage.post == PostType.Text_AllianceInvite then 
    	chatMessage.attachmentId = extraData.attachmentId
    elseif chatMessage.post == PostType.Text_Media then
    	if extraData.media then 
    		chatMessage.media = extraData.media
    	end 
    elseif chatMessage.post == PostType.Text_ScienceMaxShare then 
    	if extraData.scienceType then 
            local dialogKey = extraData.dialog and extraData.dialog or "79010354" --79010354  我在基地-科技中心处研究完成了“{0}”，激活了属性：{1} ；快去看看吧！
            chatMessage.attachmentId = string.format("%s__%s",extraData.scienceType,dialogKey)
        end
    elseif chatMessage.post == PostType.Text_AllianceCommonShare or chatMessage.post == PostType.Text_SevenDayNewShare or chatMessage.post == PostType.Text_AllianceAttackMonsterShare then 
        chatMessage:handleAllianceCommonShare(extraData)
    elseif chatMessage.post == PostType.Text_StartWar or chatMessage.post == PostType.Text_EndWar then
        chatMessage.cityId = extraData.cityId
        chatMessage.alAbbr = extraData.alAbbr
    elseif chatMessage.post == PostType.Text_AllianceRedPack then
        self:handleAllianceRedPacket(chatMessage, extraData)
    elseif chatMessage.post == PostType.Text_AllianceWelcome then
        chatMessage.extraContent = extraData.msgarr
    elseif chatMessage.post == PostType.Text_AllianceTransfer then
        chatMessage.extraContent = extraData.msgarr
    elseif chatMessage.post == PostType.Text_AllianceMemberInOut then
        local tmp = {}
        tmp.typ = tostring(extraData.smallType)
        tmp.msgarr = extraData.msgarr
        chatMessage.extraContent = tmp
    else
    	local attachMentID = ""
    	local dialogKey = extraData.dialog
	    if dialogKey then
	        local array = extraData.msgarr
            local nameStr = "";
	        if array then 
                for _,nameString in pairs(array) do
                    if nameStr ~= "" then 
                        nameStr = nameStr .. "||"
                    end
                    nameStr = nameStr .. nameString
                end
	        end
	        if dialogKey ~= "" and nameStr ~= "" then
	            attachMentID = string.format("%s||%s",dialogKey,nameStr) 
	        else
	            attachMentID = dialogKey;
	        end
	    end
	    if string.len(chatMessage.attachmentId) > 0 then 
	        if attachMentID ~= "" then 
	            chatMessage.attachmentId = string.format("%s__%s",chatMessage.attachmentId,attachMentID) 
	        end
	    else
	        chatMessage.attachmentId = attachMentID;
        end
	end 

	-- ChatPrint("post = %d,attachmentId = %s",chatMessage.post ,chatMessage.attachmentId)
end 


--[[
	!!!
	获取消息体在聊天框中应该显示的字符串
]]
function ChatMessageHelper:getMessageWithExtra(chatMessage, isFullMsg)
	
    local post = chatMessage.post or 0
	local showMessage = ""
	
	if post > 0 and post~= PostType.Text_MsgGm then
		-- 如果已经处理过的话
		if not string.IsNullOrEmpty(chatMessage.attachmentMsg) then
			showMessage = chatMessage.attachmentMsg
		else
			-- 从json解析出param，有些可能没有json
			local param = {}
			if not string.IsNullOrEmpty(chatMessage.attachmentId) then
				param = rapidjson.decode(chatMessage.attachmentId)
			end
			
			showMessage = ShareDecode.Decode(chatMessage, param or {}, isFullMsg)
			chatMessage.attachmentMsg = showMessage
		end
	else
		showMessage = chatMessage:getMaskMsg()
	end
	
    return showMessage
end 


-- 通过roomid返回频道类型
function ChatMessageHelper.getChannelFromRoomId(roomId, post)
	
	-- 有一些固有类型
	--if post == PostType.Text_AllianceInvite then
		--return ChatShareChannel.TO_COUNTRY
	--end
	
	local chatData = ChatManager2:GetInstance().Room:GetRoomData(roomId)
	if chatData then
		if chatData:isWorldRoom() then
			return ChatShareChannel.TO_COUNTRY
		elseif chatData:isAllianceRoom() then
			return ChatShareChannel.TO_ALLIANCE
		elseif chatData:isLangRoom() then
			return ChatShareChannel.TO_COUNTRY_LANG
		else
			return ChatShareChannel.TO_PERSON
		end
	end
end

-- 获取到分享消息
function ChatMessageHelper.getAttachmentId(param)
	return ShareEncode.Encode(param)
end

-- 获取到分享消息
--function ChatMessageHelper.getShowMessage(chatData, isFullMsg)
	--local param = rapidjson.decode(chatData.attachmentId)
	--return ShareDecode.Decode(chatData, param, isFullMsg)
--end

function ChatMessageHelper.getShowParam(chatData)
	local param = rapidjson.decode(chatData.attachmentId)
	return param
end

-- 点击聊天框的处理
function ChatMessageHelper.executeChatData(chatData)
	local param = rapidjson.decode(chatData.attachmentId)
	ShareExecute.Execute(chatData, param)
end





--[[
local showString = ""
if post == PostType.Text_AllianceCreated or
post == PostType.Text_AllianceAdded or
post == PostType.Text_AllianceInvite then

showString = ChatInterface.getString("390494")

elseif post == PostType.Text_FightReport or
post == PostType.Text_InvestigateReport or
post == PostType.Text_Formation_Fight_Share or
post == PostType.Text_FBScoutReport_Share then

showString = getFightMessage(chatMessage, isFullMsg)

elseif post == PostType.Text_EquipShare then

showString = getEquipMessage(chatMessage, isFullMsg)

elseif post == PostType.Text_AllianceRally then

showString = chatMessage:getAllianceRallyMsg()

elseif post == PostType.Text_AllianceTask then
-- 没有联盟任务，暂时跳过

elseif post == PostType.RedPackge then
showString = msg

elseif post == PostType.Text_ChatRoomSystemMsg or
post == PostType.Text_ChatWarnningSysMsg then

showString = msg
if showString == "110022139" then
showString = ChatInterface.getString("110022139")
end

elseif post == PostType.Text_AD_Msg then
showString = msg

elseif post == PostType.Text_Create_EquipShare then
if isFullMsg then
showString = "<text color=FFFFFF>" .. msg .. "</color>"
else
showString = msg
end

elseif post == PostType.Text_Create_New_EquipShare then
local attachmentIDArray = string.split(attachmentId, "|")
if #attachmentIDArray == 2 then
--local colorStr = self:getTextColorWithDefine(tonumber(attachmentIDArray[1]))
local equipKey  = attachmentIDArray[2]
showString = ChatInterface.getString("79010902", ChatInterface.getString(equipKey))
if isFullMsg then
showString = showString .. "<image scale=0.55>#UI_liaotian_equip_share.png</image>"
else
showString = showString
end
end

elseif post == PostType.Text_GoTo_Medal_Share then
local attachmentIDArray = string.split(attachmentId, "|")
if #attachmentIDArray > 1 then

local dialogKey = attachmentIDArray[1]
local name = attachmentIDArray[2]
showString = ChatInterface.getString(dialogKey, name)
if isFullMsg then
showString = showString .. "<image scale=0.55>#UI_liaotian_equip_share.png</image>"
else
showString = showString
end
end

elseif post == PostType.Text_Use_Item_Share then
showString = getUseItemMsg(self)

elseif post == PostType.Text_PointShare or post == PostType.Text_Favour_Point_Share then
showString = getSharePointMsg(chatMessage, isFullMsg)

elseif post == PostType.Text_AllianceTaskHelper then
-- 跳过

elseif post == PostType.Text_FBActivityhero_Share then
local messageArray = string.split(msg, ";")
if #messageArray == 3 then
local colorStr = getColorString(checknumber(messageArray[3]), ChatInterface.getString(messageArray[2]), isFullMsg)
showString = ChatInterface.getString(messageArray[1], colorStr)
else
showString = ChatInterface.getString("105110")
end

elseif post == PostType.Text_FBFormation_Share then
local attachmentIDArray = string.split(attachmentId, "|")
local dialogKey = attachmentIDArray[1]
if #attachmentIDArray > 1 then
local name = attachmentIDArray[2]
showString = ChatInterface.getString(dialogKey, name)
if isFullMsg then
showString = showString .. "<image scale=0.55>#UI_liaotian_formation_share.png</image>"
else
showString = showString
end
end

elseif post == PostType.NotCanParse then
showString = ChatInterface.getString("105110")

elseif post == PostType.Text_AllianceCommonShare or
post == PostType.Text_SevenDayNewShare or
post == PostType.Text_AllianceAttackMonsterShare then
showString = getSevenDayMsg(chatMessage)

elseif post == PostType.Text_AllianceArmsRaceShare then
local attachmentIDArray = string.split(attachmentId, "|")
if #attachmentIDArray == 2 then
local dialogKey = attachmentIDArray[1]
local numStr = attachmentIDArray[2]
showString = ChatInterface.getString(dialogKey, numStr)
else
showString = msg
end

elseif post == PostType.Text_FBAlliance_missile_share then
showString = getAllianceMissileMsg(chatMessage)

elseif post == PostType.Text_EnemyPutDownPointShare then
local attachmentIDArray = string.split(attachmentId, "|")
if #attachmentIDArray == 3 then
local dialogKey = attachmentIDArray[1]
local allianceStr = attachmentIDArray[3]
showString = ChatInterface.getString(dialogKey, allianceStr)
else
showString = msg
end

elseif post == PostType.Text_FBAllianceGift_Share then
local attachmentIDArray = string.split(attachmentId, "||")
if #attachmentIDArray >= 2 then
local dialogKey = attachmentIDArray[1]
local allianceStr = attachmentIDArray[2]
showString = ChatInterface.getString(dialogKey, ChatInterface.getString(allianceStr))
else
showString = msg
end

elseif post == PostType.Text_Dommsday_Missile_Share then
showString = getDommsdayMissileMsg(chatMessage)

elseif post == PostType.Text_Send_Flower then
showString = getSendFlowerMsg(chatMessage)

elseif chatMessage.post == PostType.Text_StartWar or chatMessage.post == PostType.Text_EndWar then
local info = getCityWarInfo(chatMessage)
if info then
local name =  _lang(info.name)
name = "<color=#8C4120>" .. name .. "</color>"
if chatMessage.post == PostType.Text_StartWar then
showString = _lang(chatMessage.msg, info.cityLv, name)
else
local abbr = "<color=#8C4120>" .. chatMessage.alAbbr .. "</color>"
showString = _lang(chatMessage.msg, abbr, info.cityLv, name)
end
if isFullMsg then
showString = "<color=#443b2b>" .. showString .. "</color>"
end
end

elseif post == PostType.Text_AllianceRedPack then
showString = getAllianceRedPackMessage(chatMessage)

elseif post == PostType.Text_AllianceWelcome then
if chatMessage.extraContent and #chatMessage.extraContent >= 1 then
local userName = String.replace(chatMessage.extraContent[1], " ", "\u{00A0}")
showString = _lang("138200", userName)
end

elseif post == PostType.Text_AllianceTransfer then
if chatMessage.extraContent and #chatMessage.extraContent >= 1 then
local userName = String.replace(chatMessage.extraContent[1], " ", "\u{00A0}")
showString = _lang("138195", _lang("136428"), userName)
end

elseif post == PostType.Text_AllianceMemberInOut then
if chatMessage.extraContent then
local typ = chatMessage.extraContent.typ
local msgarr = chatMessage.extraContent.msgarr
local userName = msgarr[1]
if typ == "1" then
if #msgarr >= 1 then
userName = String.replace(userName, " ", "\u{00A0}")
showString = _lang("138196", userName)      -- 加入
end
elseif typ == "2" then
if #msgarr >= 1 then
userName = String.replace(userName, " ", "\u{00A0}")
showString = _lang("138197", userName)      -- 离开
end
elseif typ == "3" then
if #msgarr >= 2 then
userName = String.replace(userName, " ", "\u{00A0}")
local operName = String.replace(msgarr[2], " ", "\u{00A0}")
showString = _lang("138198", userName, operName)      -- 被请离
end
end
end

elseif post == PostType.Text_AllianceRankChange or post == PostType.Text_AllianceOfficialChange or post == PostType.Text_AllianceOfficialSet or post == PostType.Text_AllianceOfficialCancel then
showString = getAllianceOPChangeMessage(chatMessage)

elseif post == PostType.Text_AllianceGather then
showString = getAllianceGatherMessage(chatMessage)

elseif chatMessage.post == PostType.Text_AllianceMark then
showString = getAllianceMarkMessage(chatMessage)

elseif chatMessage.post == PostType.Text_NewServerActivity then
-- ChatPrint("打印出来聊天参数attachmentId="..attachmentId)
local attachmentIDArray = string.split(attachmentId, "|")
local actId = attachmentIDArray[1]
local nameKey = ""
local goodsNameKey = attachmentIDArray[2]
------------------------------
local rewardName = goodsNameKey
if #attachmentIDArray == 4 then
local type = tonumber(attachmentIDArray[4])
local rewardarr = string.split(goodsNameKey , ";")
if #rewardarr > 1 then --钻石
rewardName = _lang("100804").."X"..rewardarr[2]
else
if type == 1 then--道具
local itemInfo = ItemUtil.genItemInfo(rewardarr[1],1)
if itemInfo ~= nil then
rewardName = _lang(itemInfo.name)
end
elseif type == 2 then--英雄
local name ,_, quality = ItemUtil.getHeroInfo(rewardarr[1])
local colorStr = CS.LF.LuaHelper.Table:GetString(CS.LFDefines.TableName.HeroQuality, quality , "color")
rewardName = CS.HeroListUtil.AddColor(name, colorStr)
end
end
end
------------------------------
local dialogId = 370354
if #attachmentIDArray >= 3 then
dialogId = attachmentIDArray[3]
end
local activity_panel_table = CS.LF.LuaHelper.Table:GetDataRow(TableName.ActivityPanel, actId)
if activity_panel_table ~= nil then
nameKey = _lang(activity_panel_table:GetString("name"))
end
showString = _lang(dialogId, nameKey , rewardName)
-- ChatPrint(actId..",id,"..nameKey..",打印出来聊天参数showString="..showString.."===="..rewardName..",dialogId="..dialogId..",goodsNameKey="..goodsNameKey)

elseif chatMessage.post == PostType.Text_NewServerActivity_New then
-- ChatPrint("Text_NewServerActivity_New打印出来聊天参数attachmentId="..attachmentId)
local attachmentIDArray = string.split(attachmentId, "|")
local actId = attachmentIDArray[1]
local nameKey = ""
local rewardName = attachmentIDArray[2]
if #attachmentIDArray >= 4 then
local type = tonumber(attachmentIDArray[4])
if type == RewardType.GOODS then--道具
local itemInfo = ItemUtil.genItemInfo(rewardName,1)
if itemInfo ~= nil then
rewardName = CS.HeroListUtil.AddColor(_lang(itemInfo.name), ItemUtil:GetQualityColor(itemInfo.quality))
end
elseif type == RewardType.HERO then--英雄
local name ,_, quality = ItemUtil.getHeroInfo(rewardName)
local colorStr = CS.LF.LuaHelper.Table:GetString(CS.LFDefines.TableName.HeroQuality, quality , "color")
rewardName = CS.HeroListUtil.AddColor(name, colorStr)
elseif type == RewardType.GOLD or type == RewardType.MONEY or RewardType.EXP or RewardType.DIAMOND then
local rewardarr = string.split(rewardName , "=")
if #rewardarr > 1 then
local name = CS.CommonUtils.GetPropById(rewardarr[1], "name", CS.LFDefines.TableName.Res_type)
if name ~= nil then
rewardName = _lang(name).."X"..rewardarr[2]
end
end
end
end
local dialogId = attachmentIDArray[3]
local activity_panel_table = CS.LF.LuaHelper.Table:GetDataRow(TableName.ActivityPanel, actId)
if activity_panel_table ~= nil then
nameKey = _lang(activity_panel_table:GetString("name"))
end
showString = _lang(dialogId, nameKey , rewardName)
-- ChatPrint(actId..",id,"..nameKey..",打印出来聊天参数showString="..showString.."===="..rewardName..",dialogId="..dialogId..",goodsNameKey="..goodsNameKey)

elseif chatMessage.post == PostType.Text_ShareHeroTenGet then
showString = getShareHeroTenGetMessage(chatMessage)

elseif chatMessage.post == PostType.Text_AllianceProduceMine then
local arr = string.split(attachmentId, '|')
if #arr < 2 then
logErrorWithTag("ChatMessageHelper", "Para error")
return
end
showString = _lang("303124", _lang(arr[2]))

else
local exist = false
for k, v in pairs(PostType) do
if chatMessage.post == v then
exist = true
break
end
end
if not exist then
-- 老版本针对无法识别类型
showString = _lang("162177")
end
end

if showString == nil then
showString = Localization:GetString("120035")
end

if showString == "" then
showString = msg
end

chatMessage.extraMsg = showString
]]





--function ChatMessage:getCityWarInfo()
	--local info = nil
	--if self.cityId then
		--info = {}
		--local zoneId = tostring(self.cityId)
		--local nameKey = GetTableData(TableName.WorldCity, zoneId, "name")
		--local cityLv = GetTableData(TableName.WorldCity, zoneId, "cityLv")
		--info.name = nameKey
		--info.cityLv = cityLv
	--end
	--return info
--end




---- RedPackageState
--function ChatMessage:GetRedPackStatus()
	--local ret = AllianceRedPackManager.GetRecord(self.uuid)
	--if ret then
		--return checknumber(ret.status)
	--end
	--return 1
--end

---- 集结是否有效
--function ChatMessage:CheckGatherValid()
	--if self.attachmentId then
		--local paraArr = string.split(self.attachmentId, "|")
		--if #paraArr >= 3 then
			--local pointId = paraArr[2]
			--local finishTimeStr = paraArr[3]
			--local finishTime = tonumber(finishTimeStr)
			--if CS.LF.LuaGameEntry.GetTimer():GetServerTimeSeconds() < finishTime then
				--local ownerId = ""
				--if #paraArr >= 7 then
					--ownerId = paraArr[7]
				--end
				--if CS.UIUtils.CheckExitGather(ownerId, pointId) then
					--return true
				--end
			--end
		--end
	--end
	--return false
--end

--function ChatMessage:getClickText()
	--if self.post == PostType.Text_AllianceGather then
		--if not self:CheckGatherValid() then
			--return _lang("138191")
		--end
		--return _lang("138157")
	--elseif self.post == PostType.Text_ShareHeroTenGet then
		--return _lang("138157")
	--end
	--return ""
--end

--function ChatMessage:getAllianceInfoType()
	--if self.post == PostType.Text_AllianceRedPack then
		--return 1
	--elseif self.post == PostType.Text_AllianceWelcome then
		--return 2
	--elseif self.post == PostType.Text_AllianceGather or self.post == PostType.Text_ShareHeroTenGet then
		--return 3
	--end
	--return 5
--end



--function ChatMessage:AllianceRedPackEncodeToJson(tbl)
	--tbl.coinType = self.coinType
	--tbl.coinNum = self.coinNum
	--tbl.remain = self.remain
	--tbl.params_al = self.params_al
	--tbl.typ = self.typ
	--tbl.userName = self.userName
	--tbl.uuid = self.uuid
	--tbl.allianceId = self.allianceId
	--tbl.total = self.total
	--tbl.name = self.name
	--tbl.startTime = self.startTime
	--tbl.endTime = self.endTime
	--tbl.desc = self.desc
	--tbl.senderServerId = self.senderServerId
	--tbl.userLang = self.userLang
--end


return ChatMessageHelper


