--[[
	邮件显示内容解析
]]
local rapidjson = require "rapidjson"
local MailShowHelper = {}
local Localization = CS.GameEntry.Localization
local base64 = require "Framework.Common.base64"
local MailParseHelper = require "DataCenter.MailData.MailParseHelper"

-- 返回邮件图标
function MailShowHelper.GetMailIcon(mailInfo)
	if (mailInfo == nil) then
		return ""
	end
	local mailType = mailInfo["type"]
	if mailType == MailType["NEW_FIGHT"] or mailType == MailType.SHORT_KEEP_FIGHT_MAIL then
		if (mailInfo:GetMailExt():IsExistMonsterBattle()) then
			return "icon_battle_pve"
		end
		return "icon_battle_win"
	elseif mailType == MailType.NEW_FIGHT_ARENA or mailType == MailType.NEW_FIGHT_MINECAVE then
		if (mailInfo:GetMailExt():IsExistMonsterBattle()) then
			return "icon_battle_pve"
		end
		return "icon_battle_win"
	elseif mailType == MailType.MAIL_SCOUT_RESULT or mailType == MailType.MAIL_SCOUT_ALERT then
		return "icon_scout"
	elseif mailType == MailType.MARCH_DESTROY_MAIL then
		return "icon_battle_win"
	end
	return ""
end

-- 返回邮件的标题
function MailShowHelper.GetMainTitle(mailInfo, senderUid)
	if (mailInfo == nil) then
		return ""
	end
	local mailType = mailInfo["type"]
	if mailType == MailType["NEW_COLLECT_MAIL"] then
		return Localization:GetString("310121")
	elseif mailType == MailType.MONSTER_COLLECT_REWARD then
		return Localization:GetString("310173")
	elseif mailType == MailType.MARCH_DESTROY_MAIL then
		return MailShowHelper.GetMailMainTitle_DestroyBuild(mailInfo)
	elseif mailType == MailType["NEW_FIGHT"] or mailType == MailType.SHORT_KEEP_FIGHT_MAIL then
		return MailShowHelper.GetMailMainTitle_NewFight(mailInfo)
	elseif mailType == MailType.NEW_FIGHT_MINECAVE then
		return Localization:GetString("302207")
	elseif mailType == MailType.NEW_FIGHT_ARENA then
		return Localization:GetString("372255")
	elseif mailType == MailType.MAIL_EXPLORE then
		return MailShowHelper.GetMailMainTitle_Explore(mailInfo)
	elseif mailType == MailType.MAIL_ALLIANCE_ALL then
		return MailShowHelper.GetMailMailTitle_AllianceAll(mailInfo)
	elseif mailType == MailType.MAIL_PRESIDENT_SEND then
		return MailShowHelper.GetMailMailTitle_PresidentAll(mailInfo)
	elseif mailType == MailType.ALLIANCE_CITY_RANK then
		return MailShowHelper.GetMailMainTitle_DestroyRankList(mailInfo)
	elseif mailType == MailType.COLLECT_OVER_FLOW_MAIL then
		return Localization:GetString("312083")
	elseif mailType == MailType.MAIL_SCOUT_RESULT then
		return Localization:GetString("300617")
	elseif mailType == MailType.MAIL_SCOUT_ALERT then
		if mailInfo.isChat then
			return Localization:GetString("310178")
		else
			return Localization:GetString("311111")
		end
	elseif mailType == MailType.ELITE_FIGHT_MAIL then
		return MailShowHelper.GetMailMainTitle_EliteFight(mailInfo, senderUid)
	elseif mailType == MailType.PLACE_ALLIANCE_BUILD_MAIL then
		return MailShowHelper.GetMailMainTitle_AllianceBuild(mailInfo)
	elseif mailType == MailType.MIGRATE_APPLY then
		return MailShowHelper.GetMailMainTitle_MigrateApply(mailInfo)
	elseif mailType == MailType.NEW_FIGHT_BLACK_KNIGHT then
		return Localization:GetString(GameDialogDefine.BLACK_KNIGHT_MAIL)
	elseif mailType == MailType.NEW_FIGHT_EXPEDITIONARY_DUEL then
		return Localization:GetString(GameDialogDefine.EXPEDITIONARY_DUEL_MAIL)
	else
		return mailInfo:GetMailTitle()
	end
end

function MailShowHelper.GetMailMainTitle_DestroyRankList(mailInfo)
	local mailExt =  mailInfo:GetMailExt();
	if mailExt ~= nil then
		return mailExt:GetTitle()
	end
	return ""
end

function MailShowHelper.GetMailMainTitle_DestroyBuild(mailInfo)
	local mailExt =  mailInfo:GetMailExt();
	if mailExt ~= nil then
		return mailExt:GetTitle()
	end
	return ""
end

function MailShowHelper.GetMailMainTitle_AllianceBuild(mailInfo)
	local mailExt =  mailInfo:GetMailExt();
	if mailExt ~= nil then
		return mailExt:GetTitle()
	end
	return ""
end

function MailShowHelper.GetMailMainTitle_MigrateApply(mailInfo)
	local mailExt =  mailInfo:GetMailExt();
	if mailExt ~= nil then
		return mailExt:GetTitle()
	end
	return ""
end

function MailShowHelper.GetMailMailTitle_EliteFightMail(mailInfo)
	return Localization:GetString("302022")
end

function MailShowHelper.GetMailMainTitle_NewFight(mailInfo)
	local dialogId = MailShowHelper.GetMailMainTitle_NewFight_ForShare(mailInfo)
	return Localization:GetString(dialogId)
end

function MailShowHelper.GetMailMainTitle_NewFight_ForShare(mailInfo)
	local resultState = mailInfo:GetMailExt():GetBattleResultStatus()
	local dialogId = ""
	if (resultState == FightResult.SELF_WIN) then
		if (mailInfo:GetMailExt():IsMyAttackCity()) then
			dialogId = "311107"
		elseif mailInfo:GetMailExt():IsMyProtectCity() then
			dialogId = "311109"
		else
			dialogId = "311105"
		end
	elseif resultState == FightResult.OTHER_WIN then

		if (mailInfo:GetMailExt():IsMyAttackCity()) then
			dialogId = "311108"
		elseif mailInfo:GetMailExt():IsMyProtectCity() then
			dialogId = "311110"
		else
			dialogId = "311106"
		end
	else
		dialogId = "311132"
	end
	return dialogId
end

function MailShowHelper.GetMailMainTitle_Explore(mailInfo)
	local isWin = mailInfo:GetMailExt():GetExploreWin()
	local name = mailInfo:GetMailExt():GetName()
	if (isWin) then
		return Localization:GetString("140057", name)
	else
		return Localization:GetString("140058", name)
	end
end

function MailShowHelper.GetMailMailTitle_AllianceAll(mailInfo)
	return mailInfo.fromName
end

function MailShowHelper.GetMailMailTitle_PresidentAll(mailInfo)
	return mailInfo.fromName
end

function MailShowHelper.GetMailSubTitle(mailInfo)
	if (mailInfo == nil) then
		return ""
	end
	local mailType = mailInfo["type"]
	if mailType == MailType["NEW_FIGHT"] or mailType == MailType.NEW_FIGHT_ARENA or mailType == MailType.NEW_FIGHT_MINECAVE or mailType == MailType.SHORT_KEEP_FIGHT_MAIL then
		return MailShowHelper.GetMailSubTitle_NewFight(mailInfo)
	elseif mailType == MailType["NEW_COLLECT_MAIL"] or
			mailType == MailType["GIFT_BUY_EXCHANGE"] or 
			mailType == MailType.MONSTER_COLLECT_REWARD or
			mailType == MailType.NEW_FIGHT_BLACK_KNIGHT or
			mailType == MailType.NEW_FIGHT_EXPEDITIONARY_DUEL or
			mailType == MailType.COLLECT_OVER_FLOW_MAIL then
		return "" -- 资源采集不做子标题
	elseif mailType == MailType.MAIL_PICK_GARBAGE then
		return MailShowHelper.GetMailSubTitle_PickGarbage(mailInfo)
	elseif mailType == MailType.MAIL_EXPLORE then
		return MailShowHelper.GetMailSubTitle_Explore(mailInfo)
	elseif mailType == MailType.ALLIANCE_CITY_OCCUPIED_REWARD then
		return MailShowHelper.GetMailSubTitle_Neutral(mailInfo)
	elseif mailType == MailType.MARCH_DESTROY_MAIL then
		return MailShowHelper.GetMailSubTitle_DestroyBuild(mailInfo)
	elseif mailType == MailType.MAIL_ALLIANCE_ALL then
		return MailShowHelper.GetMailSubTitle_AllianceAll(mailInfo)
	elseif mailType == MailType.MAIL_PRESIDENT_SEND then
		return MailShowHelper.GetMailSubTitle_PresidentAll(mailInfo)
	elseif mailType == MailType.ELITE_FIGHT_MAIL then
		return MailShowHelper.GetMailSubTitle_EliteFightMail(mailInfo)
	elseif mailType == MailType.MAIL_ALLIANCE_INVITE then
		return MailShowHelper.GetMailSubTitle_AllianceInvite(mailInfo)
	elseif mailType == MailType.MAIL_SCOUT_RESULT then
		return MailShowHelper.GetMailSubTitle_ScoutResult(mailInfo)
	elseif mailType == MailType.MAIL_SCOUT_ALERT then
		return MailShowHelper.GetMailSubTitle_ScoutAlert(mailInfo)
	else
		return mailInfo:GetMailSubTitle()
	end
end

function MailShowHelper.GetMailSummary( mailInfo, withoutlink, senderUid)
	if (mailInfo == nil) then
		return ""
	end
	local mailType = mailInfo["type"]
	if mailType == MailType.NEW_FIGHT_ARENA or mailType == MailType.NEW_FIGHT_MINECAVE then
		return MailShowHelper.GetMailSummary_NewFight(mailInfo, withoutlink, senderUid)
	elseif mailType == MailType.NEW_FIGHT or mailType == MailType.SHORT_KEEP_FIGHT_MAIL then
		return MailShowHelper.GetMailSummary_NewFight(mailInfo, withoutlink)
	elseif mailType == MailType["MARCH_DESTROY_MAIL"] then
		return MailShowHelper.GetMailSummary_DestroyBuild(mailInfo, withoutlink)
	elseif mailType == MailType.ELITE_FIGHT_MAIL then
		return MailShowHelper.GetMailSummary_EliteFight(mailInfo, withoutlink)
	else
		return MailShowHelper.GetMailSubTitle(mailInfo)
	end
end

--302071=八强赛第{0}轮{1}
--302072=四强赛第{0}轮{1}
--302073=决赛第{0}轮{1}
--302074=第一场
--302075=第二场
--302076=第三场
function MailShowHelper.GetMailSubTitle_EliteFightMail(mailInfo)
	local mailExt =  mailInfo:GetMailExt()
	local phaseStr = ""
	if mailExt == nil then
		return phaseStr
	end
	if mailExt.phase == Activity_ChampionBattle_Elite_Stage_State.GROUP_QUARTER_PHASE then
		phaseStr = "308048";
	elseif mailExt.phase == Activity_ChampionBattle_Elite_Stage_State.GROUP_SEMI_PHASE then
		phaseStr = "308049";
	elseif mailExt.phase == Activity_ChampionBattle_Elite_Stage_State.GROUP_FINAL_PHASE then
		phaseStr = "308050";
	elseif mailExt.phase == Activity_ChampionBattle_Elite_Stage_State.QUARTER_PHASE then
		phaseStr = "302071";
	elseif mailExt.phase == Activity_ChampionBattle_Elite_Stage_State.SEMI_PHASE then
		phaseStr = "302072";
	elseif mailExt.phase == Activity_ChampionBattle_Elite_Stage_State.FINAL_PHASE then
		phaseStr = "302073";
	else
		return Localization:GetString("302047")
	end

	return Localization:GetString(phaseStr, mailExt.round, "")
end

function MailShowHelper.GetMailSubTitle_AllianceInvite(mailInfo)
	local content = mailInfo:GetMailBody()
	
end

function MailShowHelper.GetMailSubTitle_DestroyBuild(mailInfo)
	local mailExt =  mailInfo:GetMailExt();
	if mailExt ~= nil then
		return mailExt:GetName()
	end
	return ""
end

function MailShowHelper.GetMailSummary_DestroyBuild(mailInfo, withoutlink)
	local mailExt =  mailInfo:GetMailExt();
	if mailExt ~= nil then
		return mailExt:GetSummary(withoutlink)
	end
	return ""
end

function MailShowHelper.GetMailSubTitle_AllianceAll(mailInfo)
	return Localization:GetString("141064") .. mailInfo:GetMailTitle()
end

function MailShowHelper.GetMailSubTitle_PresidentAll(mailInfo)
	return Localization:GetString(GameDialogDefine.PRESIDENT_MAIL) .. mailInfo:GetMailTitle()
end

function MailShowHelper.GetMailSubTitle_NewFight_ForShare(mailInfo)
	local param = {}
	local targetName = mailInfo:GetMailExt():GetTargetName_ForShare()
	if (mailInfo:GetMailExt():IsMyAttackCity()) then
		local roundItem = mailInfo:GetMailExt():GetFightReportByRoundIndex(1)
		if (roundItem ~= nil) then
			local username = roundItem:GetForceTargetName()
			local targetName1 = mailInfo:GetMailExt():GetBuildingName_ForShare( false )
			param["dialogId"] = "311114"
			param["param1"] = username
			param["param2"] = targetName1
			return param
		end
	elseif mailInfo:GetMailExt():IsMyProtectCity() then
		local targetName1 = mailInfo:GetMailExt():GetBuildingName_ForShare( true )
		param["dialogId"] = "311135"
		param["param1"] = targetName1
		param["param2"] = targetName
		return param
	else
		local dialogId = ""
		local resultState = mailInfo:GetMailExt():GetBattleResultStatus()
		if resultState == FightResult.SELF_WIN then
			dialogId = "311097"
		elseif resultState == FightResult.DRAW then
			dialogId = GameDialogDefine.FIGHT_WITH_SOMEONE
		else
			dialogId = "311098"
		end
		param["dialogId"] = dialogId
		param["param1"] = targetName
		return param
	end
	return param
end

function MailShowHelper.GetMailContent_ScoutAlert(mailInfo)
	if mailInfo.tabBody == nil or mailInfo.tabBody.b == nil or mailInfo.tabBody.b.content == nil or mailInfo.tabBody.b.content.dialog == nil then
		return ""
	end
	local tempContent = DeepCopy(mailInfo.tabBody.b.content)
	tempContent.dialog.id = "310180"
	return MailParseHelper:DecodeMessage(tempContent)
end

-- 邮件内容中的摘要
--[[
内容 只是建筑
进攻
胜利311099	战胜了<color=#C80700>{0}</color>的{1} XXX    战胜了小明的lv4储水罐
失败311100	未战胜<color=#C80700>{0}</color>的{1} XX
-------------------------------------------------------------------
防守
胜利311101	击退了<color=#C80700>{0}</color>对我方{1}的攻击   击退了小明对我方lv4储水罐的攻击
失败311102	<color=#C80700>{0}</color>攻击了我方的{1}   小明攻击了我方的lv4储水罐
]]
function MailShowHelper.GetMailSummary_NewFight(mailInfo, withoutlink, senderUid)
	local battleFightPt = mailInfo:GetMailExt():GetBattleFightPointId()
	local battleServerId = mailInfo:GetMailExt():GetBattleServerId()
	local battleWorldId = mailInfo:GetMailExt():GetBattleWorldId()
	local strLink = ""
	if battleFightPt>0 then
		local battleFightV2Pt = SceneUtils.IndexToTilePos(battleFightPt, ForceChangeScene.World)
		local strBattlePt = " ( " .. tostring(battleFightV2Pt.x) .. "," .. tostring(battleFightV2Pt.y) .. " ) "
		local link = {
			action = "Jump",
			pointId = battleFightPt,
			server = battleServerId,
			worldId = battleWorldId,
		}
		local json = rapidjson.encode(link)
		json = base64.encode(json)
		strLink = "<link=" .. json .. "><u>" .. strBattlePt .. "</u></link>"
		if (withoutlink) then
			strLink = ""
		end
	end
	local attackSideName = mailInfo:GetMailExt():GetAttackSideName()
	local defendSideName = mailInfo:GetMailExt():GetDefendSideName()
	local dialogId = ""
	local resultState = mailInfo:GetMailExt():GetBattleResultStatus(senderUid)
	if resultState == FightResult.SELF_WIN then
		if (mailInfo:GetMailExt():IsMyAttackCity()) then
			local roundItem = mailInfo:GetMailExt():GetFightReportByRoundIndex(1)
			if (roundItem ~= nil) then
				local targetName1 = mailInfo:GetMailExt():GetBuildingName( false )
				return Localization:GetString(GameDialogDefine.MAIL_ATTACK_CITY_SUB_TITLE, attackSideName, defendSideName, targetName1) .. strLink
			end
		elseif mailInfo:GetMailExt():IsMyProtectCity() then
			local sBuildingName = mailInfo:GetMailExt():GetBuildingName( true )
			return Localization:GetString(GameDialogDefine.MAIL_PROTECT_CITY_SUB_TITLE, attackSideName, defendSideName, sBuildingName) .. strLink
		else
			dialogId = "311097"
		end
	elseif resultState == FightResult.DRAW then
		if (mailInfo:GetMailExt():IsMyAttackCity()) then
			local roundItem = mailInfo:GetMailExt():GetFightReportByRoundIndex(1)
			if (roundItem ~= nil) then
				local targetName1 = mailInfo:GetMailExt():GetBuildingName( false )
				return Localization:GetString(GameDialogDefine.MAIL_ATTACK_CITY_SUB_TITLE, attackSideName, defendSideName, targetName1) .. strLink
			end
		elseif mailInfo:GetMailExt():IsMyProtectCity() then
			local sBuildingName = mailInfo:GetMailExt():GetBuildingName( true )
			return Localization:GetString(GameDialogDefine.MAIL_PROTECT_CITY_SUB_TITLE, attackSideName, defendSideName, sBuildingName) .. strLink
		else
			dialogId = GameDialogDefine.FIGHT_WITH_SOMEONE
		end
	else
		if (mailInfo:GetMailExt():IsMyAttackCity()) then
			local roundItem = mailInfo:GetMailExt():GetFightReportByRoundIndex(1)
			if (roundItem ~= nil) then
				local targetName1 = mailInfo:GetMailExt():GetBuildingName( false )
				return Localization:GetString(GameDialogDefine.MAIL_ATTACK_CITY_SUB_TITLE, attackSideName, defendSideName, targetName1) .. strLink
			end
		elseif mailInfo:GetMailExt():IsMyProtectCity() then
			local sBuildingName = mailInfo:GetMailExt():GetBuildingName( true )
			return Localization:GetString(GameDialogDefine.MAIL_ATTACK_CITY_SUB_TITLE, attackSideName, defendSideName, sBuildingName) .. strLink
		else
			dialogId = "311098"
		end
	end
		local targetName = mailInfo:GetMailExt():GetTargetName(senderUid)
		return Localization:GetString(dialogId, targetName)..strLink
	end

function MailShowHelper.GetMailSubTitle_NewFight(mailInfo)
	local targetName = mailInfo:GetMailExt():GetTargetName()
	local dialogId = ""
	if (mailInfo:GetMailExt():IsMyAttackCity()) then
		local roundItem = mailInfo:GetMailExt():GetFightReportByRoundIndex(1)
		if (roundItem ~= nil) then
			local username = roundItem:GetForceTargetName()
			local targetName1 = mailInfo:GetMailExt():GetBuildingName( false )
			return Localization:GetString("311114", username, targetName1)
		end
	elseif mailInfo:GetMailExt():IsMyProtectCity() then
		local selfBuildingName = mailInfo:GetMailExt():GetBuildingName( true )
		return Localization:GetString("311135", selfBuildingName, targetName)
	else
		local resultState = mailInfo:GetMailExt():GetBattleResultStatus()
		if resultState == FightResult.SELF_WIN then
			dialogId = "311097"
		elseif resultState == FightResult.DRAW then
			dialogId = GameDialogDefine.FIGHT_WITH_SOMEONE
		else
			dialogId = "311098"
		end
	end
	return Localization:GetString(dialogId, targetName)
end

function MailShowHelper.GetMailSubTitle_ScoutResult(mailInfo)
	local extData = mailInfo:GetMailExt():GetExtData()
	local targetId = ""
	if extData.targetType == "ALLIANCE_CITY" then
		targetId = extData.targetAllianceCity.city_id.value
	elseif extData.targetType == "DESERT" then
		targetId = extData.targetDesert.des_id.value
	elseif extData.targetType == "ALLIANCE_BULID" then
		targetId = extData.targetAllianceBuild.buildId.value
	end
	local targetName = MailParseHelper:DecodeScout({ target = extData.targetType,targetId= targetId })
	if not string.IsNullOrEmpty(targetName) then
		local playerName = ""
		if extData.targetType == "ALLIANCE_CITY" and extData.targetAllianceCity then
			if not string.IsNullOrEmpty(extData.targetAllianceCity.abbr) then
				playerName = playerName .. "[" .. extData.targetAllianceCity.abbr .. "]"
			end

			playerName = playerName .. extData.targetAllianceCity.name
		elseif extData.targetUser then
			if not string.IsNullOrEmpty(extData.targetUser.abbr) then
				playerName = playerName .. "[" .. extData.targetUser.abbr .. "]"
			end
			playerName = playerName .. extData.targetUser.name
		end
		return Localization:GetString("311104", playerName, targetName)
	else
		return Localization:GetString("300618", extData.targetUser.abbr, extData.targetUser.name)
	end
end

function MailShowHelper.GetMailSubTitle_ScoutAlert(mailInfo)
	local contents = rapidjson.decode(mailInfo.contents) or {}
	if contents.b == nil or contents.b.content == nil or contents.b.content.dialog == nil then
		return ""
	end
	local targetName, playerName = "", ""
	for _, v in ipairs(contents.b.content.dialog.params) do
		if v.scout ~= nil then
			targetName = MailParseHelper:DecodeScout(v.scout)
		elseif v.user ~= nil then
			if not string.IsNullOrEmpty(v.user.abbr) then
				playerName = playerName .. "[" .. v.user.abbr .. "]"
			end
			if not string.IsNullOrEmpty(v.user.name) then
				playerName = playerName .. v.user.name
			end
		end
	end
	if targetName == "" or playerName == "" then
		return ""
	end
	if mailInfo.isChat then
		return Localization:GetString("310179", playerName)
	else
		return Localization:GetString("311103", playerName, targetName)
	end
end

function MailShowHelper.GetMailSubTitle_PickGarbage(mailInfo)
	local mailExt =  mailInfo:GetMailExt();
	if mailExt ~= nil then
		return mailExt:GetName()
	end
	return ""
end

function MailShowHelper.GetMailSubTitle_Neutral(mailInfo)
	local tabHeader = mailInfo["tabHeader"] or {}
	local h = tabHeader["h"] or {}
	local subTitle = h["subTitle"] or {}
	local dialog = subTitle["dialog"] or {}
	local dialogId = dialog["id"]
	local params = dialog["params"] or {}
	local strPos = ""
	-- 坐标
	if (table.count(params) > 0) then
		local point = params[1]["point"] or {}
		local server = point["server"] or 0
		local x = point["x"] or 0
		local y = point["y"] or 0
		if DataCenter.AccountManager:GetServerTypeByServerId(server) == ServerType.DRAGON_BATTLE_FIGHT_SERVER then
			strPos = Localization:GetString("376134",x, y)
		else
			strPos = Localization:GetString("128005", server, x, y)
		end
		
	end
	-- 中立城名字
	local contents = mailInfo["contents"] or ""
	contents = rapidjson.decode(contents) or {}
	local b = contents["b"] or {}
	local content = b["content"] or {}
	local dialog = content["dialog"] or {}
	local params = dialog["params"] or {}
	local name = ""
	if (table.count(params) > 0) then
		local oneParam = params[1] or {}
		local worldAllianceCity = oneParam["worldAllianceCity"] or {}
		local cityId = worldAllianceCity["id"] or 0
		name = worldAllianceCity["cityName"]or ""
		if name == nil or name =="" then
			name = GetTableData(TableName.WorldCity, cityId, "name")
			name = Localization:GetString(name)
		end
	end
	if (dialogId ~= nil) then
		return Localization:GetString(dialogId, strPos, name)
	else
		return ""
	end
end

function MailShowHelper.GetMailSubTitle_Explore(mailInfo)
	return ""
end

function MailShowHelper.GetMailMainTitle_EliteFight(mailInfo)
	local ext = mailInfo:GetMailExt()
	if ext == nil or ext._fightRoundList == nil then
		return ""
	end
	
	local uid1 = ""
	local uid2 = ""
	local score1 = 0
	local score2 = 0
	for _, round in ipairs(ext._fightRoundList) do
		if round._otherArmyResult._isDefeat then
			score1 = score1 + 1
		else
			score2 = score2 + 1
		end
		if uid1 == "" or uid2 == "" then
			uid1 = tostring(round._selfInfo.uid)
			uid2 = tostring(round._otherInfo.uid)
		end
	end
	--local resultStr = ""
	--if score1 > score2 then
	--	resultStr = (uid2 == senderUid and Localization:GetString("390187") or Localization:GetString("390186"))
	--elseif score1 < score2 then
	--	resultStr = (uid1 == senderUid and Localization:GetString("390187") or Localization:GetString("390186"))
	--end
	--return resultStr .. " " .. Localization:GetString("302113") .. " " .. score1 .. " : " .. score2
	return Localization:GetString("302113") .. " " .. score1 .. " : " .. score2
end

function MailShowHelper.GetMailSummary_EliteFight(mailInfo)
	local ext = mailInfo:GetMailExt()
	if ext == nil or ext._fightRoundList == nil then
		return ""
	end
	
	--标题
	local langId = "302047";
	local fightType = ext.phase;
	
	if fightType == Activity_ChampionBattle_Elite_Stage_State.GROUP_QUARTER_PHASE then
		langId = "308048";
	elseif fightType == Activity_ChampionBattle_Elite_Stage_State.GROUP_SEMI_PHASE then
		langId = "308049";
	elseif fightType == Activity_ChampionBattle_Elite_Stage_State.GROUP_FINAL_PHASE then
		langId = "308050";
	elseif fightType == Activity_ChampionBattle_Elite_Stage_State.QUARTER_PHASE then
		langId = "302031";
	elseif fightType == Activity_ChampionBattle_Elite_Stage_State.SEMI_PHASE then
		langId = "302067";
	elseif fightType == Activity_ChampionBattle_Elite_Stage_State.FINAL_PHASE then
		langId = "302068";
	end

	-- 玩家名
	local firstRound = ext._fightRoundList[1]
	if firstRound == nil or
	   firstRound._selfArmyResult == nil or firstRound._selfArmyResult._armyObj == nil or
	   firstRound._otherArmyResult == nil or firstRound._otherArmyResult._armyObj == nil then
		return ""
	end
	local selfAbbr = firstRound._selfArmyResult._armyObj.alAbbr or ""
	local selfName = firstRound._selfArmyResult._armyObj.name or ""
	local otherAbbr = firstRound._otherArmyResult._armyObj.alAbbr or ""
	local otherName = firstRound._otherArmyResult._armyObj.name or ""
	
	local name1 = ""
	if selfAbbr ~= "" then
		name1 = string.format("[%s]%s", selfAbbr, selfName)
	else
		name1 = selfName
	end
	local name2 = ""
	if otherAbbr ~= "" then
		name2 = string.format("[%s]%s", otherAbbr, otherName)
	else
		name2 = otherName
	end
	
	return Localization:GetString("302114", Localization:GetString(langId)) .. "\n" .. Localization:GetString("302115", name1, name2)
end

-- 返回邮件的创建时间-- 相对时间
function MailShowHelper.GetRelativeCreateTime(mail)
	return UITimeManager:GetInstance():GetMailShowTime(mail.createTime)
end
-- 返回绝对时间
function MailShowHelper.GetAbstractCreateTime(mail)
	return UITimeManager:GetInstance():TimeStampToTimeForLocal(mail.createTime)
end

function MailShowHelper.TryShareMail(mailInfo)
	if mailInfo == nil then
		return
	end
	
	local share_param = {}
	share_param.mailType = mailInfo.type
	share_param.name = ""
	
	if mailInfo.type == MailType.MAIL_SCOUT_RESULT then
		local msg = ""
		local subTitle = mailInfo:GetMailHeader()
		if subTitle and subTitle["h"] and subTitle["h"]["subTitle"] then
			msg = subTitle["h"]["subTitle"]
		end
		share_param.msg = msg
		share_param.uid = mailInfo.uid
		share_param.toUser = mailInfo.toUser
		share_param.createTime = mailInfo.createTime
		
		local content = mailInfo:GetScoutContent()
		if content ~= "" then
			-- new
			share_param.postType = PostType.Text_ScoutReportContentShare
			share_param.reportContent = content
		else
			-- old
			share_param.postType = PostType.Text_MailScoutResultShare
		end
		
		UIManager:GetInstance():OpenWindow(UIWindowNames.UIPositionShare, {anim = true}, share_param)
	elseif mailInfo.type == MailType.MAIL_SCOUT_ALERT then
		share_param.uid = mailInfo.uid
		share_param.toUser = mailInfo.toUser
		share_param.createTime = mailInfo.createTime
		share_param.content = mailInfo.contents
		share_param.postType = PostType.Text_ScoutAlertContentShare
		UIManager:GetInstance():OpenWindow(UIWindowNames.UIPositionShare, {anim = true}, share_param)
	else
		local para = MailShowHelper.GetMailSubTitle_NewFight_ForShare(mailInfo)
		local result = ShareFightMailResultState.Fail
		local resultState = mailInfo:GetMailExt():GetBattleResultStatus()
		if resultState == FightResult.SELF_WIN then
			result = ShareFightMailResultState.Win
		elseif resultState == FightResult.DRAW then
			result = ShareFightMailResultState.Draw
		end
		local toUser = mailInfo.toUser
		para["mailId"] = mailInfo.uid .. "#" .. mailInfo.type .. "#" .. toUser .. "#" .. result
		para["title"] = MailShowHelper.GetMailMainTitle_NewFight_ForShare(mailInfo)
		para.mailUid = mailInfo.uid
		share_param.msg = MailShowHelper.GetMailSummary(mailInfo, true)
		share_param.para = para
		local switchOn = LuaEntry.DataConfig:CheckSwitch("battle_report_new")
		local content = mailInfo:GetBattleContent()
		if content ~= "" and switchOn ==false then
			-- new
			share_param.postType = PostType.Text_BattleReportContentShare
			share_param.reportContent = content
		else
			-- old
			share_param.postType = PostType.Text_Formation_Fight_Share
		end
	end
	
	UIManager:GetInstance():OpenWindow(UIWindowNames.UIPositionShare, {anim = true}, share_param)
end

-- 获取获得黑骑士分数
function MailShowHelper.GetScore(mailInfo, uuid)
	local result = 0
	local ext = mailInfo:GetMailExt()
	if ext ~= nil then
		local resources = ext:GetFightResItemArr(uuid)
		if resources ~= nil then
			for k,v in pairs(resources) do
				if k == ResourceType.BlackKnight then
					result = v
					break
				end
			end
		end
	end
	return result
end

-- 获取第几轮名字，多组，分割
function MailShowHelper.GetBlackKnightRoundName(mailInfo, needDialog)
	local result = ""
	local ext = mailInfo:GetMailExt()
	if ext ~= nil then
		local roundList = {}
		local list = ext:GetMonsterIds()
		for k, v in ipairs(list) do
			local round = DataCenter.MonsterTemplateManager:GetTableValue( v, "round")
			if round ~= nil then
				table.insert(roundList, round)
			end
		end
		if roundList[2] ~= nil then
			table.sort(roundList, function(a,b) 
				return a < b
			end)
		end

		for k, v in ipairs(roundList) do
			if k == 1 then
				result = result .. v
			else
				result = result .. "," .. v
			end
			
		end

		if needDialog then
			result = Localization:GetString(GameDialogDefine.TURN_WITH, result)
		end
	end
	return result
end


return MailShowHelper

