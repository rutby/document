--[[
	ShareDecode 
	主要用来做AttachmentId的解码
	1。将json解析成参数table
	2。通过参数解析成要显示的字符串 
	3。消息分成两种，完整消息和简短消息
]]
local MailParseHelper = require "DataCenter.MailData.MailParseHelper"
local rapidjson = require "rapidjson"
local Localization = CS.GameEntry.Localization
local ShareDecode = {}
local MailInfo = require "DataCenter.MailData.MailInfo"

--世界坐标分享:
local function Decode_PointShare(chatData, t, isFullMsg)

    if t.x == nil or t.y == nil then
        return nil
    end

    local showMessage = ""

    if not string.IsNullOrEmpty(t.msg) then
        showMessage = t.msg
    else
        local uname = nil
        if not string.IsNullOrEmpty(t.uname) then
            if string.IsNullOrEmpty(t.abbr) then
                local nameArr = string.split(t.uname, ";")
                if #nameArr > 1 then
                    uname = Localization:GetString(nameArr[2])
                else
                    uname = t.uname
                end
            else
                uname = "[" .. t.abbr .. "]" .. t.uname
            end
        end
        local oname = nil
        if not string.IsNullOrEmpty(t.oname) then
            if t.olv then
                oname = Localization:GetString(GameDialogDefine.LEVEL_NUMBER, t.olv) .. Localization:GetString(t.oname)
            else
                oname = Localization:GetString(t.oname)
            end
        end
        if uname ~= nil and oname ~= nil then
            showMessage = Localization:GetString(GameDialogDefine.POSITION_DESC, uname, oname)
        else
            if uname ~= nil then
                showMessage = uname
            end
            if oname ~= nil then
                showMessage = oname
            end
        end
    end

    if t.sid then
        --showMessage = showMessage .. "(#" .. t.sid .. " X:" .. t.x .. " Y:" .. t.y .. ")"
        if DataCenter.AccountManager:GetServerTypeByServerId(t.sid) == ServerType.DRAGON_BATTLE_FIGHT_SERVER then
            showMessage = showMessage .. " ( " .. Localization:GetString("376134",t.x, t.y) .. " ) "
        else
            showMessage = showMessage .. " ( " .. Localization:GetString(GameDialogDefine.POSITION_COORDINATE_CROSS, t.sid, t.x, t.y) .. " ) "
        end
        
    else
        showMessage = showMessage .. " ( " .. Localization:GetString(GameDialogDefine.POSITION_COORDINATE, t.x, t.y) .. " ) "
    end
    return showMessage
end


local function Decode_AllianceTaskShare(chatData, t, isFullMsg)
    local ret = {}
    ret.taskName = Localization:GetString(t.taskName)
    ret.curProg = t.curProg
    ret.maxProg = t.maxProg
    return ret.taskName
end

local function Decode_AllianceRecruitShare(chatData, t, isFullMsg)
    local strTip = t.recruitTip
    return strTip
end

local function Decode_MailScoutResultShare(chatData, t, isFullMsg)
    local showMessage = ""
    if not string.IsNullOrEmpty(t.msg) then
        showMessage = MailParseHelper:DecodeMessage(t.msg)
    end
    return showMessage
end


-- 联盟招募世界分享:
local function Decode_AllianceInvite(chatData, t, isFullMsg)
    if t.abbr and t.name then
        return "[" .. t.abbr .. "]" .. t.name .. "  " .. Localization:GetString("390157")
    end

    return Localization:GetString("390157")
end


-- 联盟等级调整联盟分享:
local function Decode_AllianceRankChange(chatData, t, isFullMsg)

    if t.uname == nil or t.new == nil or t.old == nil or t.selfRank == nil or t.selfName == nil then
        return nil
    end

    --390159=我将{0}的权限等级由R{1}调整为了R{2}，希望他能为联盟做出更多的贡献。
    --390160=我将{0}的权限等级由R{1}调整为了R{2}，希望他不要气馁，继续努力。

    local dlgId = "390159"
    if t.new < t.old then
        dlgId = "390160"
    end

    return Localization:GetString(dlgId, t.selfName, t.selfRank, t.uname, t.old, t.new)
end

-- 联盟等级调整联盟分享:
local function Decode_AllianceMemberJoin(chatData, t, isFullMsg)
    if not t.name then
        return nil
    end

    return Localization:GetString("128132", t.name)
end

-- 联盟等级调整联盟分享:
local function Decode_AllianceMemberQuit(chatData, t, isFullMsg)
    if t.name == nil then
        return nil
    end

    return Localization:GetString("390180", t.name)
end

-- 联盟官职调整
local function Decode_AllianceOfficialChange(chatData, t, isFullMsg)

    if t.uname == nil then
        return nil
    end

    local m = t.uname .. " " .. Localization:GetString("390068")

    return m
end
local function IsGmMode(roomId)
    local roomMgr = ChatManager2:GetInstance().Room
    local roomData = roomMgr:GetRoomData(roomId)
    if (roomData ~= nil and roomData:IsGmRoom()) then
        return true
    end
    return false
end

-- 聊天室系统消息
-- 譬如：xxx加入房间之类的
-- 这个消息在初始化的时候解析过，理论上应该在这里解析
local function Decode_ChatRoomSystem(chatData, t, isFullMsg)

    local senderUid = chatData.senderUid
    local playerUid = ChatInterface.getPlayerUid()
    ---当前玩家是否是操作者
    local isOperator = senderUid == playerUid
    local operatorName = ""

    if (isOperator == true) then
        operatorName = ChatInterface.getString("290018")
    else
        if string.IsNullOrEmpty(chatData.senderName) then
            local uinfo = ChatManager2:GetInstance().User:getChatUserInfo(senderUid, false)
            if uinfo then
                operatorName = uinfo.userName
            end
        else
            operatorName = chatData.senderName
        end
    end

    -- 有可能是同时操作多个人，所以这里处理一下
    local hintType = chatData.type
    local isInMemberArr = false
    local memberName = ""
    if not string.IsNullOrEmpty(chatData.msg) then
        if hintType ~= 5 then
            local userList = rapidjson.decode(chatData.msg)
            if not table.IsNullOrEmpty(userList) then
                for key, value in pairs(userList) do
                    local username = checkstring(value.userName)
                    if (key == playerUid) then
                        username = ChatInterface.getString("290018"); -- 你
                        isInMemberArr = true
                    end

                    -- 发送者不加进来
                    if (key ~= senderUid) then
                        if string.IsNullOrEmpty(memberName) then
                            memberName = username
                        else
                            memberName = memberName .. ", " .. username;
                        end
                    end
                end
            end
        end
    end

    local hintMsg = ""
    if hintType == 1 or hintType == 2 then
        hintMsg = ChatInterface.getString("290019", memberName, operatorName); -- {1}将{0}加入聊天
        if (IsGmMode(chatData.roomId)) then
            hintMsg = ChatInterface.getString("121050")
        end
    elseif hintType == 3 then
        hintMsg = ChatInterface.getString("290026", operatorName); -- {0}退出了聊天室。
    elseif hintType == 4 then
        if (IsGmMode(chatData.roomId)) then
            hintMsg = ChatInterface.getString("121051")
        else
            if isInMemberArr and not isOperator then
                hintMsg = ChatInterface.getString("290013", operatorName); -- 您已被{0}移出聊天
            else
                hintMsg = ChatInterface.getString("290024", memberName, operatorName); -- {1}将{0}移出聊天
            end
        end
    elseif hintType == 5 then
        hintMsg = chatData.msg
        hintMsg = ChatInterface.getString("290022", operatorName, hintMsg); -- {0}将聊天室名称修改为{1}
    end

    return hintMsg
end

local eNoticeType = {
    ATTACK_NEUTRAL = 0, --0 攻击中立
    ATTACK_OTHER = 1, -- 攻击他人
    OCCUPY_FIRST_NEUTRAL = 2, -- 首占中立
    OCCUPY_NEUTRAL = 3, -- 攻占中立
    OCCUPY_OTHER = 4, -- 攻占他人
    OCCUPY_THRONE =5, --5 攻占王座
}

local function Decode_Sub_ATTACK_NEUTRAL(tabCityInfo)
    local cityId = tabCityInfo.cityId or 0
    local alAbbr = tabCityInfo.alAbbr or ""
    local name = tabCityInfo.cityName or ""
    if name==nil or name=="" then
        name = GetTableData(TableName.WorldCity, cityId, 'name')
        name = Localization:GetString(name)
    end
    local strPos = GetTableData(TableName.WorldCity, cityId, 'location')
    local cityLv = GetTableData(TableName.WorldCity, cityId, "level")
    local levelStr = "Lv."..tostring(cityLv)
    local tabPos = string.split(strPos, '|')
    if (table.count(tabPos) ~= 2) then
        return ""
    end
    strPos = " ( ".."X:"..tabPos[1] .. "," .. "Y:"..tabPos[2].." ) "
    local nameStr = name..strPos
    return Localization:GetString("121053", alAbbr, levelStr, nameStr)
end

local function Decode_Sub_ATTACK_OTHER(tabCityInfo)
    local cityId = tabCityInfo.cityId or 0
    local oldAlAbbr = tabCityInfo.oldAlAbbr or ""
    local alAbbr = tabCityInfo.alAbbr or ""
    local name = tabCityInfo.cityName or ""
    if name==nil or name=="" then
        name = GetTableData(TableName.WorldCity, cityId, 'name')
        name = Localization:GetString(name)
    end
    local strPos = GetTableData(TableName.WorldCity, cityId, 'location')
    local cityLv = GetTableData(TableName.WorldCity, cityId, "level")
    local levelStr = "Lv."..tostring(cityLv)
    local tabPos = string.split(strPos, '|')
    if (table.count(tabPos) ~= 2) then
        return ""
    end
    strPos = " ( ".."X:"..tabPos[1] .. "," .. "Y:"..tabPos[2].." ) "
    local nameStr = name..strPos
    return Localization:GetString("121052", alAbbr, oldAlAbbr, levelStr, nameStr)
end

local function Decode_Sub_OCCUPY_FIRST_NEUTRAL(tabCityInfo)
    local cityId = tabCityInfo.cityId or 0
    local alAbbr = tabCityInfo.alAbbr or ""
    local name = tabCityInfo.cityName or ""
    if name==nil or name=="" then
        name = GetTableData(TableName.WorldCity, cityId, 'name')
        name = Localization:GetString(name)
    end
    local strPos = GetTableData(TableName.WorldCity, cityId, 'location')
    local cityLv = GetTableData(TableName.WorldCity, cityId, "level")
    local levelStr = "Lv."..tostring(cityLv)
    local tabPos = string.split(strPos, '|')
    if (table.count(tabPos) ~= 2) then
        return ""
    end
    strPos = " ( ".."X:"..tabPos[1] .. "," .. "Y:"..tabPos[2].." ) "
    local nameStr = name..strPos
    return Localization:GetString("126000", alAbbr, levelStr, nameStr)
end

local function Decode_Sub_OCCUPY_NEUTRAL(tabCityInfo)
    local cityId = tabCityInfo.cityId or 0
    local alAbbr = tabCityInfo.alAbbr or ""
    local name = tabCityInfo.cityName or ""
    if name==nil or name=="" then
        name = GetTableData(TableName.WorldCity, cityId, 'name')
        name = Localization:GetString(name)
    end
    local strPos = GetTableData(TableName.WorldCity, cityId, 'location')
    local cityLv = GetTableData(TableName.WorldCity, cityId, "level")
    local levelStr = "Lv."..tostring(cityLv)
    local tabPos = string.split(strPos, '|')
    if (table.count(tabPos) ~= 2) then
        return ""
    end
    strPos = " ( ".."X:"..tabPos[1] .. "," .. "Y:"..tabPos[2].." ) "
    local nameStr = name..strPos
    return Localization:GetString("121055", alAbbr, levelStr, nameStr)
end

local function Decode_Sub_OCCUPY_OTHER(tabCityInfo)
    local cityId = tabCityInfo.cityId or 0
    local oldAlAbbr = tabCityInfo.oldAlAbbr or ""
    local alAbbr = tabCityInfo.alAbbr or ""
    local name = tabCityInfo.cityName or ""
    if name==nil or name=="" then
        name = GetTableData(TableName.WorldCity, cityId, 'name')
        name = Localization:GetString(name)
    end
    local strPos = GetTableData(TableName.WorldCity, cityId, 'location')
    local cityLv = GetTableData(TableName.WorldCity, cityId, "level")
    local levelStr = "Lv."..tostring(cityLv)
    local tabPos = string.split(strPos, '|')
    if (table.count(tabPos) ~= 2) then
        return ""
    end
    strPos = " ( ".."X:"..tabPos[1] .. "," .. "Y:"..tabPos[2].." ) "
    local nameStr = name..strPos
    return Localization:GetString("126001", alAbbr, oldAlAbbr, levelStr, nameStr)
end

local function Decode_NeutralAttack(chatData, t, isFullMsg) 
    local extra = chatData.extra or {}
    local allianceCityInfo = extra.allianceCityInfo or ""
    local tabCityInfo = rapidjson.decode(allianceCityInfo)
    if (tabCityInfo == nil) then
        return ""
    end
    local noticeType = tabCityInfo.noticeType or 0
    if (noticeType == eNoticeType.ATTACK_NEUTRAL) then
        return Decode_Sub_ATTACK_NEUTRAL(tabCityInfo);
    elseif noticeType == eNoticeType.ATTACK_OTHER then
        return Decode_Sub_ATTACK_OTHER(tabCityInfo)
    elseif noticeType == eNoticeType.OCCUPY_FIRST_NEUTRAL then
         return Decode_Sub_OCCUPY_FIRST_NEUTRAL(tabCityInfo)
    elseif noticeType == eNoticeType.OCCUPY_NEUTRAL then
        return Decode_Sub_OCCUPY_NEUTRAL(tabCityInfo)
    elseif noticeType == eNoticeType.OCCUPY_OTHER then
        return Decode_Sub_OCCUPY_OTHER(tabCityInfo)
    elseif noticeType == eNoticeType.OCCUPY_THRONE then
        return Decode_Sub_OCCUPY_OTHER(tabCityInfo)
    end
end

local function Decode_ChampionBattle_ReportS_hare(chatData, t , isFullMsg)
    if t == nil or t.para == nil then
        return ""
    end
    if t['para']['contentDialogId1'] ~= nil then
        local dialogId1 = t['para']['contentDialogId1']
        local dialogId2 = t['para']['contentDialogId2']
        local dialogId3 = t['para']['contentDialogId3']
        local contentName1 = t['para']['contentName1'] or ""
        local contentName2 = t['para']['contentName2'] or ""
        
        local str = Localization:GetString(dialogId1, Localization:GetString(dialogId2)).."\n"..Localization:GetString(dialogId3, contentName1, contentName2)
        return str or ""
    end
    return t["para"]["msg"] or ""
end

local function Decode_Text_Formation_Fight_Share(chatData, t , isFullMsg)
    if (chatData["param"] ~= nil) then
        return chatData["param"]["msg"] or ""
    end
    local attachmentId = chatData["attachmentId"] or ""
    local tabAttach = rapidjson.decode(attachmentId) or {}
    local tabParam = tabAttach["para"] or {}
    local dialogId = tabParam["dialogId"]
    if (dialogId == nil) then
        return ""
    end
    local param1 = tabParam["param1"]
    if ( param1 ~= nil ) then
        if (type(param1) == "table") then
            if (param1["eventId"]~=nil) then
                param1 = Localization:GetString(param1["name"],param1["eventId"])
            else
                local name = Localization:GetString(param1["name"]) or ""
                local level = ""
                if (param1["level"] ~= nil) then
                    level = Localization:GetString("300665", param1["level"])
                end

                if (param1["abbr"] ~= nil) then
                    param1 = "[" .. param1["abbr"] .. "]" .. level .. " " .. name
                else
                    param1 = level .. " " .. name
                end
            end
        end
    else
        param1 = ""
    end
    local param2 = tabParam["param2"]
    if ( param2 ~= nil ) then
        if (type(param2) == "table") then
            if (param2["eventId"]~=nil) then
                param2 = Localization:GetString(param2["name"],param2["eventId"])
            else
                local name = Localization:GetString(param2["name"]) or ""
                local level = ""
                if (param2["level"] ~= nil) then
                    level = Localization:GetString("300665", param2["level"])
                end
                if (param2["abbr"] ~= nil) then
                    param2 = "[" .. param2["abbr"] .. "]" .. level .. " " .. name
                else
                    param2 = level .. " " .. name
                end
            end
        end
    else
        param2 = ""
    end
    local a = Localization:GetString(dialogId, param1, param2)
    return Localization:GetString(dialogId, param1, param2)
end

local function Decode_ShareBattleReportContent(chatData,t,isFullMsg)
    local mailInfo = MailInfo.New()
    local message = {}
    local reportContent = t.reportContent or ""
    if reportContent ==nil or reportContent == "" then
        return ""
    end
    message.contents = "{\"b\":{},\"obj\":{\"battleContent\":\""..t.reportContent.."\"}}"
    message.type = t.mailType
    message.title = "{\"h\":{}}"
    message.uid = 0
    if t.createTime ~= nil and t.createTime > 0 then
        message.createTime = t.createTime
    else
        local pb_BattleReport = {}
        if t.mailType == MailType.ELITE_FIGHT_MAIL then
            pb_BattleReport = PBController.ParsePb1(t.reportContent, "protobuf.DeliteReport") or {}
        elseif t.mailType == MailType.NEW_FIGHT or t.mailType == MailType.SHORT_KEEP_FIGHT_MAIL then
            pb_BattleReport = PBController.ParsePb1(t.reportContent, "protobuf.BattleReport") or {}
        end
        message.createTime = pb_BattleReport.startTime
    end
    mailInfo:ParseBaseData(message)
    mailInfo.isChat = true
    return MailShowHelper.GetMailSummary(mailInfo, true)
end

local function Decode_ShareScoutReportContent(chatData,t,isFullMsg)
    local mailInfo = MailInfo.New()
    local message = {}
    local reportContent = t.reportContent or ""
    message.contents = "{\"b\":{},\"obj\":{\"scoutContent\":\""..reportContent.."\"}}"
    message.type = t.mailType
    message.title = "{\"h\":{}}"
    message.uid = 0
    message.createTime = t.createTime or 0
    mailInfo:ParseBaseData(message)
    mailInfo.isChat = true
    return MailShowHelper.GetMailSummary(mailInfo, true)
end

local function Decode_ShareScoutAlertContent(chatData,t,isFullMsg)
    local mailInfo = MailInfo.New()
    local message = {}
    message.contents = t.content
    message.type = t.mailType
    message.title = "{\"h\":{}}"
    message.uid = 0
    message.createTime = t.createTime or 0
    mailInfo:ParseBaseData(message)
    mailInfo.isChat = true
    return MailShowHelper.GetMailSummary(mailInfo, true)
end

local function Decode_SharePlayerFormation(chatData,t,isFullMsg)
    return Localization:GetString("110184")
end

local function Decode_AllianceRedPacket(chatData,t,isFullMsg)
    local buildId = GetTableData(TableName.SysRedPacket,chatData.extra.reasonId,"building")
    local lvConfig = GetTableData(TableName.SysRedPacket,chatData.extra.reasonId,"level")
    return Localization:GetString(chatData.msg, chatData.senderName, 
            Localization:GetString(GetTableData(DataCenter.BuildTemplateManager:GetTableName(), buildId + lvConfig,"name")), lvConfig)
end

local function Decode_Text_ActMonsterTowerHelp(chatData,t,isFullMsg)
    return Localization:GetString("372472")
end

local function Decode_Text_MsgShare(chatData, t , isFullMsg)
    local param = t
    if param~=nil and param.dialogId~=nil and param.dialogId~="" then
        local msgList = {}
        local num =  param.dialogParamNum
        for i = 1,num do
            local a = param.unUseDialogParamList[i]
            if a~=nil and a~="" then
                table.insert(msgList,a)
            else
                local b = param.useDialogParamList[i]
                if b~=nil and b~="" then
                    b = Localization:GetString(b)
                else
                    b = ""
                end
                table.insert(msgList,b)
            end
        end
        return Localization:GetString(param.dialogId,SafeUnpack(msgList))
    else
        return ""
    end
    --if t.playerName and t.num and t.resourceType then
    --    return Localization:GetString("390888",t.playerName,t.num,DataCenter.RewardManager:GetNameByType(ResTypeToReward[t.resourceType]))
    --end
end

local function Decode_Missile_Attack(chatData, t)
    local extra = chatData.extra or {}
    local name = extra.targetName or ""
    local posStr = ""
    if not string.IsNullOrEmpty(extra.targetPointId) and not string.IsNullOrEmpty(extra.targetServer) then
        local t = SceneUtils.IndexToTilePos(tonumber(extra.targetPointId), ForceChangeScene.World)
        if DataCenter.AccountManager:GetServerTypeByServerId(extra.targetServer) == ServerType.DRAGON_BATTLE_FIGHT_SERVER then
            posStr = " ( " .. Localization:GetString("376134",t.x, t.y) .. " ) "
        else
            posStr = " ( " .. Localization:GetString(GameDialogDefine.POSITION_COORDINATE_CROSS, extra.targetServer, t.x, t.y) .. " ) "
        end
        
    end
    return Localization:GetString("309010", name, posStr)
end
-- 分享解码相关的表格
local DecodeTable = {
    [PostType.Text_PointShare] = Decode_PointShare,
    [PostType.Text_AllianceInvite] = Decode_AllianceInvite,
    [PostType.Text_AllianceRankChange] = Decode_AllianceRankChange,
    [PostType.Text_AllianceOfficialChange] = Decode_AllianceOfficialChange,
    [PostType.Text_MemberJoin] = Decode_AllianceMemberJoin,
    [PostType.Text_MemberQuit] = Decode_AllianceMemberQuit,
    [PostType.Text_FBAlliance_missile_share] = Decode_NeutralAttack,
    [PostType.Text_AllianceTaskShare] = Decode_AllianceTaskShare,
    [PostType.Text_AllianceRecruitShare] = Decode_AllianceRecruitShare,
    [PostType.Text_Formation_Fight_Share] = Decode_Text_Formation_Fight_Share,
    [PostType.Text_ChampionBattleReportShare] = Decode_ChampionBattle_ReportS_hare,

    [PostType.Text_BattleReportContentShare] = Decode_ShareBattleReportContent,
    [PostType.Text_ScoutReportContentShare] = Decode_ShareScoutReportContent,
    [PostType.Text_ScoutAlertContentShare] = Decode_ShareScoutAlertContent,
    [PostType.Text_ChatRoomSystemMsg] = Decode_ChatRoomSystem,
    [PostType.Text_Formation_Share] = Decode_SharePlayerFormation,
    [PostType.RedPackge] = Decode_AllianceRedPacket,
    [PostType.Text_MailScoutResultShare] = Decode_MailScoutResultShare,
    [PostType.Text_MsgShare] = Decode_Text_MsgShare,
    [PostType.Text_ActMonsterTowerHelp] = Decode_Text_ActMonsterTowerHelp,
    [PostType.Text_Missile_Attack] = Decode_Missile_Attack,
}




-- 进行消息封装，最终封装成json格式
function ShareDecode.Decode(chatData, param, isFullMsg)

    -- 解析显示文本
    local f = DecodeTable[chatData.post]
    local showMessage = nil

    -- 返回类型相关的参数表格
    if f then
        showMessage = f(chatData, param, isFullMsg)
    else
        ChatPrint("share decode not found! type : " .. chatData.post)
    end

    if string.IsNullOrEmpty(showMessage) then
        showMessage = Localization:GetString("120035")
        local postId = "PostType:" .. chatData.post
        print(">>>版本不支持: " .. tostring(postId))
    end
    
    return showMessage
end

return ShareDecode


