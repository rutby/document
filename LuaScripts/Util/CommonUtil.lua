---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2021/6/29 15:34
---
local CommonUtil = {}
local Vibrator = CS.Vibrator
local ResourceManager = CS.GameEntry.Resource
local PlayerPrefs = CS.UnityEngine.PlayerPrefs
local Localization = CS.GameEntry.Localization

local LastVibratorTime = 0
local VibratorDuringTime = 200
local useLuaWorldPoint = false
local assetDict = {}

local function SendErrorMessageToServer(curTime, delayTime, errorMsg)
    if LuaEntry.DataConfig:CheckSwitch("bug_report") ==  true then
        CS.PostEventLog.Record("ClientErrorMsg",errorMsg)
        --SFSNetwork.SendMessage(MsgDefines.ClientLog,curTime, delayTime, errorMsg)
    end
end

local function GetIsUseLoadAsync()
    return false
end

local function GetTimeDiamondCost(remainSec, useK4)
    if remainSec <= 0 then
        return 0
    end
    if remainSec < 1 then
        return 1
    end
    local costNum = 1
    local k1 = LuaEntry.DataConfig:TryGetNum("cd_gold","k1")
    local k2 = LuaEntry.DataConfig:TryGetNum("cd_gold","k2")
    local k3 = LuaEntry.DataConfig:TryGetNum("cd_gold","k3")
    if useK4 == true then
        local k4 = LuaEntry.DataConfig:TryGetNum("cd_gold","k4")
        if k4 == 0 then
            k4 = 1
        end
        costNum = math.floor(tonumber(k4) * remainSec*tonumber(k3)/(tonumber(k1)*Mathf.Pow(remainSec/3600,(tonumber(k2)/100))))
    else
        costNum = math.floor(remainSec*tonumber(k3)/(tonumber(k1)*Mathf.Pow(remainSec/3600,(tonumber(k2)/100))))
    end
    if costNum<=0 then
        costNum = 1
    end
    return costNum
end

local function GetResourceDescriptionByType (resourceType)
    local template = DataCenter.ResourceTemplateManager:GetResourceTemplate(resourceType)
    if template ~= nil then
        return CS.GameEntry.Localization:GetString(template.description)
    end
    return ""
end

local function GetResOrItemCount(resOrItemId)
    if resOrItemId > ResourceType.None and resOrItemId < ResourceType.Max then
        if resOrItemId == ResourceType.Gold then
            return LuaEntry.Player.gold
        end
        
        return LuaEntry.Resource:GetCntByResType(resOrItemId)
    end
    
    return DataCenter.ItemData:GetItemCount(resOrItemId)
end

local function GetResOrItemIcon(resOrItemId)
    resOrItemId = tonumber(resOrItemId)
    if resOrItemId > ResourceType.None and resOrItemId < ResourceType.Max then
        assert(DataCenter.ResourceManager:GetResourceIconByType(resOrItemId) ~= nil, 'GetResOrItemIcon res icon is nil! resOrItemId:' .. tostring(resOrItemId))
        return DataCenter.ResourceManager:GetResourceIconByType(resOrItemId) or ''
    end
    
    local template = DataCenter.ItemTemplateManager:GetItemTemplate(resOrItemId)
    assert(template ~= nil, 'GetResOrItemIcon template is nil! resOrItemId:' .. tostring(resOrItemId))
    
    return string.format(LoadPath.ItemPath, template and template.icon or '')
end



--获取种类
local function GetBuildBaseType(id)
    return id - id % BuildLevelCap
end

--获取等级
local function GetBuildLv(id)
    return id % BuildLevelCap
end

--获取种类
local function GetScienceBaseType(id)
    return id - id % ScienceLevelCap
end

--获取等级
local function GetScienceLv(id)
    return id % ScienceLevelCap
end

local function GetDetectEventQualityColor(quality)
    if quality == DetectEventColor.DETECT_EVENT_WHITE then
        return DetectEventWhiteColor
    elseif quality == DetectEventColor.DETECT_EVENT_GREEN then
        return DetectEventGreenColor
    elseif quality == DetectEventColor.DETECT_EVENT_BLUE then
        return DetectEventBlueColor
    elseif quality == DetectEventColor.DETECT_EVENT_PURPLE then
        return DetectEventPurpleColor
    elseif quality == DetectEventColor.DETECT_EVENT_ORANGE then
        return DetectEventOrangeColor
    elseif quality == DetectEventColor.DETECT_EVENT_GOLDEN then
        return DetectEventGoldenColor
    elseif quality == DetectEventColor.DETECT_EVENT_RED then
        return DetectEventRedColor
    end
    return DetectEventWhiteColor
end

local function GetDetectEventQualityName(quality)
    if quality == DetectEventColor.DETECT_EVENT_WHITE then
        return GameDialogDefine.QUALITY_NAME_WHITE
    elseif quality == DetectEventColor.DETECT_EVENT_GREEN then
        return GameDialogDefine.QUALITY_NAME_GREEN
    elseif quality == DetectEventColor.DETECT_EVENT_BLUE then
        return GameDialogDefine.QUALITY_NAME_BLUE
    elseif quality == DetectEventColor.DETECT_EVENT_PURPLE then
        return GameDialogDefine.QUALITY_NAME_PURPLE
    elseif quality == DetectEventColor.DETECT_EVENT_ORANGE then
        return GameDialogDefine.QUALITY_NAME_ORANGE
    elseif quality == DetectEventColor.DETECT_EVENT_GOLDEN then
        return GameDialogDefine.QUALITY_NAME_GOLDEN
    elseif quality == DetectEventColor.DETECT_EVENT_RED then
        return GameDialogDefine.QUALITY_NAME_RED
    end
    logErrorWithTag("GetQualityName", "Undefined quality_"..quality)
    return ""
end

--得到中间点的连接方向（用于连路特效）
local function GetDirByPos(lastPos,curPos,nextPos)
    if (lastPos == nil or (lastPos.x == 0 and lastPos.y == 0)) and (nextPos == nil or (nextPos.x == 0 and nextPos.y == 0)) then
        return ConnectDirection.Right, ConnectDirection.LeftToRight
    elseif lastPos == nil or (lastPos.x == 0 and lastPos.y == 0) then
        if nextPos.x == curPos.x then
            if nextPos.y < curPos.y then
                return ConnectDirection.Down, ConnectDirection.TopToDown
            else
                return ConnectDirection.Top, ConnectDirection.DownToTop
            end
        else
            if nextPos.x < curPos.x then
                return ConnectDirection.Left, ConnectDirection.RightToLeft
            else
                return ConnectDirection.Right, ConnectDirection.LeftToRight
            end
        end
    elseif nextPos == nil or (nextPos.x == 0 and nextPos.y == 0) then
        if lastPos.x == curPos.x then
            if lastPos.y > curPos.y then
                return ConnectDirection.Top, ConnectDirection.TopToDown
            else
                return ConnectDirection.Down, ConnectDirection.DownToTop
            end
        else
            if lastPos.x > curPos.x then
                return ConnectDirection.Right, ConnectDirection.RightToLeft
            else
                return ConnectDirection.Left, ConnectDirection.LeftToRight
            end
        end
    else
        if lastPos.x == curPos.x then
            if lastPos.y > curPos.y then
                if nextPos.x == curPos.x then
                    if nextPos.y < curPos.y then
                        return ConnectDirection.TopToDown, ConnectDirection.TopToDown
                    else
                        return ConnectDirection.Top, ConnectDirection.DownToTop
                    end
                elseif nextPos.x > curPos.x then
                    return ConnectDirection.TopToRight, ConnectDirection.TopToRight
                else
                    return ConnectDirection.TopToLeft, ConnectDirection.TopToLeft
                end
            else
                if nextPos.x == curPos.x then
                    if nextPos.y > curPos.y then
                        return ConnectDirection.DownToTop, ConnectDirection.DownToTop
                    else
                        return ConnectDirection.Down, ConnectDirection.TopToDown
                    end
                elseif nextPos.x > curPos.x then
                    return ConnectDirection.DownToRight, ConnectDirection.DownToRight
                else
                    return ConnectDirection.DownToLeft, ConnectDirection.DownToLeft
                end
            end
        elseif lastPos.x > curPos.x then
            if nextPos.y == curPos.y then
                if nextPos.x < curPos.x then
                    return ConnectDirection.RightToLeft, ConnectDirection.RightToLeft
                else
                    return ConnectDirection.Right, ConnectDirection.LeftToRight
                end
            elseif nextPos.y > curPos.y then
                return ConnectDirection.RightToTop, ConnectDirection.RightToTop
            else
                return ConnectDirection.RightToDown, ConnectDirection.RightToDown
            end
        else
            if nextPos.y == curPos.y then
                if nextPos.x > curPos.x then
                    return ConnectDirection.LeftToRight, ConnectDirection.LeftToRight
                else
                    return ConnectDirection.Left, ConnectDirection.RightToLeft
                end
            elseif nextPos.y > curPos.y then
                return ConnectDirection.LeftToTop, ConnectDirection.LeftToTop
            else
                return ConnectDirection.LeftToDown, ConnectDirection.LeftToDown
            end
        end
    end

    return ConnectDirection.Right, ConnectDirection.LeftToRight
end

--是否满足科技条件
local function CheckIsScienceEnough(scienceId,scienceLv)
    if scienceId==nil or scienceLv == nil then
        return true
    else
        return DataCenter.ScienceManager:GetScienceLevel(scienceId)>=scienceLv
    end
end
--是否满足建筑条件
local function CheckIsBuildEnough(buildId,buildLv)
    if buildId==nil or buildLv == nil then
        return true
    else
        return DataCenter.BuildManager:IsExistBuildByTypeLv(buildId,buildLv)
    end
end
--是否满足资源道具条件
local function CheckIsResourceGoodsEnough(needGoodsId,needGoodsNum)
    if needGoodsId ==nil or needGoodsNum == nil then
        return true
    else
        local cnt = 0
        return needGoodsNum <= cnt
    end
end
--是否满足资源条件
local function CheckIsResourceEnough(needResourceType,needResourceNum)
    if needResourceType==nil or needResourceNum == nil then
        return true
    else
        local totalNum = needResourceNum
        return totalNum <= LuaEntry.Resource:GetCntByResType(needResourceType)
    end
end

--钻石抵资源换算
local function GetResGoldByType(type,num)
    local ret = 0
    local a = 0
    local b = 0
    local c = 0
    local d = 0
    local k = 0
    local cost_k1 = LuaEntry.DataConfig:TryGetNum("resource_cost", "k1")
    local cost_k2 = LuaEntry.DataConfig:TryGetNum("resource_cost", "k2")
    local cost_k3 = LuaEntry.DataConfig:TryGetNum("resource_cost", "k3")
    local cost_k4 = LuaEntry.DataConfig:TryGetNum("resource_cost", "k4")
    if type == ResourceType.Oil then
        d = LuaEntry.DataConfig:TryGetNum("resource_num3", "k2")
    elseif type == ResourceType.Metal then
        d = LuaEntry.DataConfig:TryGetNum("resource_num3", "k4")
    elseif type == ResourceType.Electricity then
        d = LuaEntry.DataConfig:TryGetNum("resource_num3", "k5")
    elseif type == ResourceType.Money then
        d = LuaEntry.DataConfig:TryGetNum("resource_num3", "k6")
        k = LuaEntry.DataConfig:TryGetNum("resource_num3", "k7")
    elseif type == ResourceType.Water then
        d = LuaEntry.DataConfig:TryGetNum("resource_num3", "k8")
    elseif type == ResourceType.Wood then
        d = LuaEntry.DataConfig:TryGetNum("resource_num3", "k9")
    elseif type == ResourceType.FLINT then
        d = LuaEntry.DataConfig:TryGetNum("resource_num3", "k10")
    elseif type == ResourceType.Food then
        d = LuaEntry.DataConfig:TryGetNum("resource_num3", "k11")
    elseif type == ResourceType.Plank then
        d = LuaEntry.DataConfig:TryGetNum("resource_num3", "k12")
    elseif type == ResourceType.Steel then
        d = LuaEntry.DataConfig:TryGetNum("resource_num3", "k13")
    end
    local curNum = num*d
    if curNum<=cost_k1 then
        a = LuaEntry.DataConfig:TryGetNum("resource_num1", "k1")
        b = LuaEntry.DataConfig:TryGetNum("resource_num1", "k2")
        c = LuaEntry.DataConfig:TryGetNum("resource_num1", "k3")
   elseif curNum>cost_k1 and curNum<=cost_k2 then
        a = LuaEntry.DataConfig:TryGetNum("resource_num1", "k4")
        b = LuaEntry.DataConfig:TryGetNum("resource_num1", "k5")
        c = LuaEntry.DataConfig:TryGetNum("resource_num1", "k6")
    elseif curNum>cost_k2 and curNum<=cost_k3 then
        a = LuaEntry.DataConfig:TryGetNum("resource_num1", "k7")
        b = LuaEntry.DataConfig:TryGetNum("resource_num1", "k8")
        c = LuaEntry.DataConfig:TryGetNum("resource_num1", "k9")
    elseif curNum>cost_k3 and curNum<=cost_k4 then
        a = LuaEntry.DataConfig:TryGetNum("resource_num1", "k10")
        b = LuaEntry.DataConfig:TryGetNum("resource_num1", "k11")
        c = LuaEntry.DataConfig:TryGetNum("resource_num1", "k12")
    elseif curNum>cost_k4 then
        a = LuaEntry.DataConfig:TryGetNum("resource_num2", "k1")
        b = LuaEntry.DataConfig:TryGetNum("resource_num2", "k2")
        c = LuaEntry.DataConfig:TryGetNum("resource_num2", "k3")
    end
    if type == ResourceType.Money then
        ret = math.floor(Mathf.Pow(curNum,b)*k*a+c) 
    else
        ret = math.floor(Mathf.Pow(curNum,b)*a+c)
    end
    ret = math.max(ret,1)
    return ret
end

local function GetNameByParams(msgId,paramList)
    if msgId==nil or msgId=="" then
        return ""
    end
    local num = 0
    local text = ""
    if paramList~=nil then
        num = #paramList
    end
    if num<1 then
        text = CS.GameEntry.Localization:GetString(msgId)
    elseif num ==1 then
        text = CS.GameEntry.Localization:GetString(msgId,paramList[1])
    elseif num ==2 then
        text = CS.GameEntry.Localization:GetString(msgId,paramList[1],paramList[2])
    elseif num ==3 then
        text = CS.GameEntry.Localization:GetString(msgId,paramList[1],paramList[2],paramList[3])
    elseif num ==4 then
        text = CS.GameEntry.Localization:GetString(msgId,paramList[1],paramList[2],paramList[3],paramList[4])
    elseif num ==5 then
        text = CS.GameEntry.Localization:GetString(msgId,paramList[1],paramList[2],paramList[3],paramList[4],paramList[5])
    elseif num ==6 then
        text = CS.GameEntry.Localization:GetString(msgId,paramList[1],paramList[2],paramList[3],paramList[4],paramList[5],paramList[6])
    elseif num ==7 then
        text = CS.GameEntry.Localization:GetString(msgId,paramList[1],paramList[2],paramList[3],paramList[4],paramList[5],paramList[6],paramList[7])
    elseif num ==8 then
        text = CS.GameEntry.Localization:GetString(msgId,paramList[1],paramList[2],paramList[3],paramList[4],paramList[5],paramList[6],paramList[7],paramList[8])    
    end
    return text
end

local function GetResourceNameByType(resourceType)
    return DataCenter.ResourceManager:GetResourceNameByType(resourceType)
end

local function CopyTextToClipboard(content)
    local te = CS.UnityEngine.TextEditor()
    te.text = content
    te:OnFocus()
    te:Copy()
end

-- 获取所有active = true的节点集合
local function GetNodeActivePaths(obj, parentName, tblActive, tblInactive)

	local fullName
	if string.IsNullOrEmpty(parentName) then
		fullName = obj.name
	else
		fullName = parentName .. '/' .. obj.name
	end

	if obj.activeSelf then
		if tblActive then
			tblActive[#tblActive+1] = fullName
		end
	else
		if tblInactive then
			tblInactive[#tblInactive+1] = fullName
		end
	end

	local nodeRoot = obj.transform
	local childCount = nodeRoot.childCount
	for i = 0, childCount - 1 do
		local child = nodeRoot:GetChild(i).gameObject

		GetNodeActiveNames(child, fullName, tbl)
	end
end

-- 根据路径设置所有的节点为true
local function SetNodeActivePaths(obj, tblActive, tblInactive)
	for k,v in ipairs(tblActive) do
		local t = obj.transform:Find(v)
		if t then
			t:SetActive(true)
		end
	end
	
	for k,v in ipairs(tblInactive) do
		local t = obj.transform:Find(v)
		if t then
			t:SetActive(false)
		end
	end
	
end


--钻石抵资源换算
local function GetItemGoldByItemId(itemId,num)
    local ret = 0
    local goods = DataCenter.ItemTemplateManager:GetItemTemplate(itemId)
    if goods ~= nil and goods.price > 0 then
        ret = goods.price * num
    end
    ret = math.max(ret, 1)
    return ret
end

local function GetValueWithLocalType(value, localType)
    if localType == EffectLocalType.Num then
        return string.GetFormattedSeperatorNum(value)
    elseif localType == EffectLocalType.Time then
        return UITimeManager:GetInstance():SecondToFmtString(value)
    elseif localType == EffectLocalType.Percent then
        return value .. "%"
    elseif localType == EffectLocalType.Dialog then
        return Localization:GetString(value)
    elseif localType == EffectLocalType.PositiveNum then
        return "+" .. string.GetFormattedSeperatorNum(value)
    elseif localType == EffectLocalType.NegativeNum then
        return "-" .. string.GetFormattedSeperatorNum(value)
    elseif localType == EffectLocalType.PositiveTime then
        return "+" .. UITimeManager:GetInstance():SecondToFmtString(value)
    elseif localType == EffectLocalType.NegativeTime then
        return "-" .. UITimeManager:GetInstance():SecondToFmtString(value)
    elseif localType == EffectLocalType.PositivePercent then
        return "+" .. value .. "%"
    elseif localType == EffectLocalType.NegativePercent then
        return "-" .. value .. "%"
    else
        return value
    end
end

local function GetEffectReasonDesc(reasonType)
    if reasonType == EffectReasonType.Science then
        return 100025
    elseif reasonType == EffectReasonType.Building then
        return 310148
    elseif reasonType == EffectReasonType.Hero then
        return 100275
    elseif reasonType == EffectReasonType.VIP then
        return 320293
    elseif reasonType == EffectReasonType.MONTH_CARD then
        return 320243
    elseif reasonType == EffectReasonType.PLAYER_LEVEL then
        return 120987
    elseif reasonType == EffectReasonType.Hero_Station then
        return 110179
    elseif reasonType == EffectReasonType.Science_Activity then
        return 100374 -- 其他
    elseif reasonType == EffectReasonType.Alliance_Science then
        return 390148
    elseif reasonType == EffectReasonType.World_Alliance_City then
        return 300724
    elseif reasonType == EffectReasonType.Status then
        return 100162
    elseif reasonType == EffectReasonType.Tank then
        return 131200
    elseif reasonType == EffectReasonType.Career then
        return 395000
    elseif reasonType == EffectReasonType.Alliance_Career then
        return 395003
    else
        return 100374 -- 其他
    end
end

--播放游戏BGM
local function PlayGameBgMusic(bgm)
    if bgm ~= nil and bgm ~= "" then
        SoundUtil.PlayBGMusicByName(bgm)
    else
        if LuaEntry.Player.serverType == ServerType.DRAGON_BATTLE_FIGHT_SERVER then
            return
        end
        local guideBgmName =  DataCenter.GuideManager:GetGuideBgmName()
        if guideBgmName ~= nil and guideBgmName ~= "" then
            SoundUtil.PlayBGMusicByName(guideBgmName)
        elseif DataCenter.BuildManager:IsInNewUserWorld() then
            if LuaEntry.Player.serverType == ServerType.EDEN_SERVER and SceneUtils.GetIsInWorld() then
                SoundUtil.PlayBGMusicByName(SoundAssets.Music_bg_eden_war)
            else
                SoundUtil.PlayMainSceneBGMusic()
            end
        else
            if LuaEntry.Player.serverType == ServerType.EDEN_SERVER and SceneUtils.GetIsInWorld() then
                SoundUtil.PlayBGMusicByName(SoundAssets.Music_bg_eden_war)
            else
                SoundUtil.PlayMainSceneBGMusic()
            end

        end
    end
end

--震动手机统一接口
local function VibratorLightImpact()
    if CS.SceneManager.IsInPVE() then
        if DataCenter.BattleLevel:IsAutoPlay() then
            return
        end
    end
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local durTime = curTime - LastVibratorTime
    if durTime >= VibratorDuringTime then
        LastVibratorTime = curTime
        Vibrator.LightImpact()
    end
end

local function GetAllProxy()
    local list = {}
    if (CS.CommonUtils.IsDebug()) then
        local oneData = {}
        oneData.lineName = "direct"
        oneData.lineUrl = CS.GameEntry.Network.GameServerUrl
        oneData.port = CS.GameEntry.Network.GameServerPort
        table.insert(list, oneData)
    else
        local zoneStr = Setting:GetString(SettingKeys.SERVER_ZONE, "");
        local arr = string.split(zoneStr, "S")
        if #arr >= 2 then
            local zoneId = arr[2]
            local port = CommonUtil.GetPortId(zoneId)
            for i = 1, #ProxyList do
                local oneData = {}
                oneData.lineName = ProxyName[i]
                oneData.lineUrl = ProxyList[i]
                oneData.port = port
                table.insert(list, oneData)
            end
        end

    end
    return list
end

local function GetAllCheckVersionUrl()
    local list = {}
    for i = 1,#CheckVersionUrlList do
        local oneData = {}
        oneData.line = CheckVersionUrlList[i].cv
        table.insert(list, oneData)
    end
    return list
end

local function GetAllCDNUrlList()
    local list = {}
    for i = 1,#CDNUrlList do
        local oneData = {}
        oneData.line = CDNUrlList[i]
        table.insert(list, oneData)
    end
    return list
end

local function GetDebugCDNUrlList()
    local list = {}
    for i = 1,#DebugCDNUrlList do
        local oneData = {}
        oneData.line = DebugCDNUrlList[i]
        table.insert(list, oneData)
    end
    return list
end
local function GetPortId(zoneId)
    if tonumber(zoneId) == 1 then
        return 8088
    elseif tonumber(zoneId)>=9001 then
        return 10500-9000+tonumber(zoneId)
    else
        return 8100+tonumber(zoneId)
    end 
    
end

local function GetIsUseNetRaw()
    --local gmFlag = CS.GameEntry.Setting:GetInt(SettingKeys.GM_FLAG,0)
    --return gmFlag ==1
    return false
end

local function GetOwnCountByCommonCostType(needType, itemId)
    if needType == CommonCostNeedType.Resource then
        return LuaEntry.Resource:GetCntByResType(itemId)
    elseif needType == CommonCostNeedType.Goods then
        return DataCenter.ItemData:GetItemCount(itemId)
    end
end

local function MarchErrorLog(message)
    local errCode = message["errorCode"]
    if errCode~=nil then
        if errCode == "110274" then
			local uuid = message["formationUuid"]
			if uuid~=nil then
				SFSNetwork.SendMessage(MsgDefines.FormationMarchTime,uuid)
			end
        end
    end
end

local function CheckIsLessThanTargetVersion(targetVersion)
    local curVersion = CS.GameEntry.Sdk.Version
    local strTargetVersion = string.split(targetVersion,".")
    local strLocalVersion = string.split(curVersion,".")
    local isLess = false
    for i = 1, #strTargetVersion do
        if isLess == false then
            if strLocalVersion[i]~=nil then
                if tonumber(strTargetVersion[i]) > tonumber(strLocalVersion[i]) then
                    isLess = true
                end
            end
        end
    end
    return isLess
end

--是否可以使用钻石购买资源
local function CanUseGoldByResourceType(resourceType)
    return resourceType ~= ResourceType.Oil and resourceType ~= ResourceType.FLINT
end

--获取排行显示图片路径和显示文字
--前三iconName不为nil showName为nil
--rank == 0 或者 == nil iconName 为nil  showName为 "未上榜"
--其他 iconName 为nil  showName为 rank
local function GetRankImgAndShowText(rank)
    local iconName = nil
    local showName = nil
    local bgName = nil
    if rank == nil or rank <= 0 then
        -- showName = CS.GameEntry.Localization:GetString(GameDialogDefine.UN_RANK)
        showName = "999+"
    elseif rank <= SpecialRankNum then
        iconName = string.format("Assets/Main/Sprites/UI/UIAlliance/rank/UIalliance_rankingbg0%s.png", rank)
        bgName = string.format("Assets/Main/Sprites/UI/UIArena/arena_img_columns0%s.png", rank)
    else
        showName = tostring(rank)
        bgName = "Assets/Main/Sprites/UI/UIArena/arena_img_columns04.png"
    end
    return iconName, showName, bgName
end

-- 获取一个资源的占用负重
local function GetResourceWeight(resourceType)
    local k = "k" .. (resourceType + 1)
    local w = LuaEntry.DataConfig:TryGetNum("res_weight", k)
    if resourceType == ResourceType.Money then
        w = w * (1 - LuaEntry.Effect:GetGameEffect(EffectDefine.APS_MONEY_WEIGHT_PERCENT) / 100)
    elseif resourceType == ResourceType.Electricity then
        w = w * (1 - LuaEntry.Effect:GetGameEffect(EffectDefine.APS_ELECTRICITY_WEIGHT_PERCENT) / 100)
    end
    return w
end

local function IsXCity()
    if CS.GameEntry.Sdk:GetPackageName() == "com.readygo.xcity.gp" then
        return true
    end
    return false
end

local function LoadAsset(path, name, type, callback)
    if path == nil then
        if callback then
            callback(nil)
        end
    end
    local key = name .. "_" .. path
    if assetDict[key] then
        if callback then
            callback(assetDict[key].asset)
        end
    else
        Logger.Log("CommonUtil LoadAsset: path = " .. path .. ", name = " .. name)
        local ok = pcall(function()
            assetDict[key] = ResourceManager:LoadAssetAsync(path, type)
            assetDict[key].completed = function(_)
                if callback then
                    callback(assetDict[key].asset)
                end
            end
        end)
        if not ok then
            Logger.LogError("CommonUtil LoadAsset failed: path = " .. path .. ", name = " .. name)
            if callback then
                callback(nil)
            end
        end
    end
end

local function UnloadAsset(path, name)
    if path == nil then
        return
    end
    local key = name .. "_" .. path
    if assetDict[key] then
        Logger.Log("CommonUtil UnloadAsset: path = " .. path .. ", name = " .. name)
        ResourceManager:UnloadAsset(assetDict[key])
        assetDict[key] = nil
    end
end

local function PlayerPrefsGetBool(key,default)
    local uidKey=string.format("%s%s",LuaEntry.Player.uid,key)
    return PlayerPrefs.GetInt(uidKey,default and 1 or 0) == 1
end

local function PlayerPrefsSetBool(key,value)
    local uidKey=string.format("%s%s",LuaEntry.Player.uid,key)
    PlayerPrefs.SetInt(uidKey,value and 1 or 0)
end

local function PlayerPrefsGetInt(key,default)
    local uidKey=string.format("%s%s",LuaEntry.Player.uid,key)
    return PlayerPrefs.GetInt(uidKey,default)
end

local function PlayerPrefsSetInt(key,value)
    local uidKey=string.format("%s%s",LuaEntry.Player.uid,key)
    PlayerPrefs.SetInt(uidKey,value)
end

local function PlayerPrefsGetFloat(key,default)
    local uidKey=string.format("%s%s",LuaEntry.Player.uid,key)
    return PlayerPrefs.GetFloat(uidKey,default)
end

local function PlayerPrefsSetFloat(key,value)
    local uidKey=string.format("%s%s",LuaEntry.Player.uid,key)
    PlayerPrefs.SetFloat(uidKey,value)
end

local function PlayerPrefsGetString(key,default)
    local uidKey=string.format("%s%s",LuaEntry.Player.uid,key)
    return PlayerPrefs.GetString(uidKey,default)
end

local function PlayerPrefsSetString(key,value)
    local uidKey=string.format("%s%s",LuaEntry.Player.uid,key)
    PlayerPrefs.SetString(uidKey,value)
end

local function PlayerPrefsGetTable(key,default)
    local uidKey=string.format("%s%s",LuaEntry.Player.uid,key)
    local str = PlayerPrefs.GetString(uidKey)
    if string.IsNullOrEmpty(str) then
        return default
    else
        return rapidjson.decode(str)
    end
end

local function PlayerPrefsSetTable(key,value)
    local uidKey=string.format("%s%s",LuaEntry.Player.uid,key)
    local str =  rapidjson.encode(value)
    PlayerPrefs.SetString(uidKey,str)
end

local function PlayerPrefsGetLong(key,default)
    local uidKey=string.format("%s%s",LuaEntry.Player.uid,key)
    return tonumber(PlayerPrefs.GetString(uidKey,tostring(default)))
end

local function PlayerPrefsSetLong(key,value)
    local uidKey=string.format("%s%s",LuaEntry.Player.uid,key)
    PlayerPrefs.SetString(uidKey,tostring(value))
end

local function IsArabic()
    return Localization.Language == CS.GameFramework.Localization.Language.Arabic
end

-- 这里包一层，主要是为了防止json解析出错！而导致的程序异常情况！！
local function JsonDecode(text)
    local rapidjson = require "rapidjson"
    local ok, ret = xpcall(rapidjson.decode, debug.traceback, text)
    if ok then
        return ret
    else
        Logger.LogError("JsonDecode error: ", text)
        return {}
    end
end

local function IsUseLuaWorldPoint()
    return useLuaWorldPoint
end
local function SetIsUseLuaWorldPoint(value)
    useLuaWorldPoint = value
end

function CommonUtil.OnDisConnect()
    CrossServerUtil.OnDisConnect()
    DataCenter.VitaManager:SetDoTimeAction(false)
end
CommonUtil.GetTimeDiamondCost = GetTimeDiamondCost
CommonUtil.GetResourceDescriptionByType = GetResourceDescriptionByType
CommonUtil.GetResOrItemCount = GetResOrItemCount
CommonUtil.GetResOrItemIcon = GetResOrItemIcon
CommonUtil.GetScienceBaseType = GetScienceBaseType
CommonUtil.GetScienceLv = GetScienceLv
CommonUtil.GetBuildBaseType = GetBuildBaseType
CommonUtil.GetBuildLv = GetBuildLv
CommonUtil.GetDetectEventQualityColor = GetDetectEventQualityColor
CommonUtil.GetDetectEventQualityName = GetDetectEventQualityName
CommonUtil.GetDirByPos = GetDirByPos
CommonUtil.CheckIsScienceEnough = CheckIsScienceEnough
CommonUtil.CheckIsBuildEnough = CheckIsBuildEnough
CommonUtil.CheckIsResourceGoodsEnough = CheckIsResourceGoodsEnough
CommonUtil.CheckIsResourceEnough = CheckIsResourceEnough
CommonUtil.GetResGoldByType = GetResGoldByType
CommonUtil.GetNameByParams = GetNameByParams
CommonUtil.GetResourceNameByType = GetResourceNameByType
CommonUtil.CopyTextToClipboard = CopyTextToClipboard
CommonUtil.GetNodeActivePaths = GetNodeActivePaths
CommonUtil.GetItemGoldByItemId = GetItemGoldByItemId
CommonUtil.SendErrorMessageToServer = SendErrorMessageToServer
CommonUtil.GetValueWithLocalType = GetValueWithLocalType
CommonUtil.GetEffectReasonDesc = GetEffectReasonDesc
CommonUtil.PlayGameBgMusic = PlayGameBgMusic
CommonUtil.VibratorLightImpact = VibratorLightImpact
CommonUtil.GetAllProxy = GetAllProxy
CommonUtil.GetAllCheckVersionUrl = GetAllCheckVersionUrl
CommonUtil.GetAllCDNUrlList =GetAllCDNUrlList
CommonUtil.GetDebugCDNUrlList =GetDebugCDNUrlList
CommonUtil.GetPortId =GetPortId
CommonUtil.GetIsUseNetRaw = GetIsUseNetRaw
CommonUtil.GetOwnCountByCommonCostType = GetOwnCountByCommonCostType
CommonUtil.MarchErrorLog = MarchErrorLog
CommonUtil.CheckIsLessThanTargetVersion = CheckIsLessThanTargetVersion
CommonUtil.CanUseGoldByResourceType = CanUseGoldByResourceType
CommonUtil.GetRankImgAndShowText = GetRankImgAndShowText
CommonUtil.GetResourceWeight = GetResourceWeight
CommonUtil.IsXCity = IsXCity
CommonUtil.GetIsUseLoadAsync = GetIsUseLoadAsync
CommonUtil.LoadAsset = LoadAsset
CommonUtil.UnloadAsset = UnloadAsset

CommonUtil.PlayerPrefsGetBool = PlayerPrefsGetBool
CommonUtil.PlayerPrefsSetBool = PlayerPrefsSetBool
CommonUtil.PlayerPrefsGetInt = PlayerPrefsGetInt
CommonUtil.PlayerPrefsSetInt = PlayerPrefsSetInt
CommonUtil.PlayerPrefsGetFloat = PlayerPrefsGetFloat
CommonUtil.PlayerPrefsSetFloat = PlayerPrefsSetFloat
CommonUtil.PlayerPrefsGetString = PlayerPrefsGetString
CommonUtil.PlayerPrefsSetString = PlayerPrefsSetString
CommonUtil.PlayerPrefsGetTable = PlayerPrefsGetTable
CommonUtil.PlayerPrefsSetTable = PlayerPrefsSetTable
CommonUtil.PlayerPrefsGetLong = PlayerPrefsGetLong
CommonUtil.PlayerPrefsSetLong = PlayerPrefsSetLong
CommonUtil.JsonDecode = JsonDecode
CommonUtil.IsArabic = IsArabic
CommonUtil.IsUseLuaWorldPoint = IsUseLuaWorldPoint
CommonUtil.SetIsUseLuaWorldPoint =SetIsUseLuaWorldPoint
return ConstClass("CommonUtil", CommonUtil)