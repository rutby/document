
local UIMoreInformationCtrl = BaseClass("UIMoreInformationCtrl", UIBaseCtrl)

local mainTabLan = {
	main_1 = 100644,
	main_2 = 100069,
	main_3 = 100276,
	main_4 = 100068,
}

local mainTabIcon1 = {
	main_1 = "Assets/Main/Sprites/UI/UIMoreInformation/Common_btn_CP_unchecked",
	main_2 = "Assets/Main/Sprites/UI/UIMoreInformation/Common_btn_Military_unchecked",
	main_3 = "Assets/Main/Sprites/UI/UIMoreInformation/Common_btn_Battle_unchecked",
	main_4 = "Assets/Main/Sprites/UI/UIMoreInformation/Common_btn_Life_unchecked",
}

local mainTabIcon2 = {
	main_1 = "Assets/Main/Sprites/UI/UIMoreInformation/Common_btn_CP",
	main_2 = "Assets/Main/Sprites/UI/UIMoreInformation/Common_btn_Military",
	main_3 = "Assets/Main/Sprites/UI/UIMoreInformation/Common_btn_Battle",
	main_4 = "Assets/Main/Sprites/UI/UIMoreInformation/Common_btn_Life",
}

--之前的战力和战斗统计
local specialType = 1

local function CloseSelf(self)
	UIManager:GetInstance():DestroyWindow(UIWindowNames.UIMoreInformation)
end

local function GetTabBtnData(self, uuid)
	local tmp = {}
	local isSelf = uuid == LuaEntry.Player.uid
	tmp[specialType] = 1
	if isSelf then
		LocalController:instance():visitTable(TableName.EffectNumDesc, function(id, lineData)
			local tab = lineData.tab
			if not string.IsNullOrEmpty(tab) then
				local vec = string.split(tab, ",")
				if #vec >= 3 then
					local mainTab = toInt(vec[1])
					--3先隐藏
					if mainTab ~= 3 then
						tmp[mainTab] = 1
					end
				end
			end
		end)
	end
	local result = {}
	for k, v in pairs(tmp) do
		local data = {}
		data.tabType = k
		data.nameStr = mainTabLan["main_"..k]
		data.icon = mainTabIcon2["main_"..k]
		data.unselectIcon = mainTabIcon1["main_"..k]
		table.insert(result, data)
	end
	
	table.sort(result, function (k, v)
		return k.tabType < v.tabType
	end)
	return result
end

local function GetTabData(self, uid, tabType)
	local isSelf = uid == LuaEntry.Player.uid
	if not isSelf and tabType ~= specialType then
		return {}
	end
	local result = {}
	local addSubType = function(subType, subTypeName, mainType)
		if result[subType] == nil then
			result[subType] = {}
			result[subType].subType = subType
			result[subType].mainType = mainType
			result[subType].nameStr = subTypeName
			result[subType].effectList = {}
			result[subType].isShow = self:GetTitleOpenState(mainType, subType)
		end
	end
	local addEffect = function(subType, effectName, effectValue, prefix)
		if result[subType] ~= nil then
			local effect = {}
			effect.nameStr = effectName
			effectValue = effectValue or "0"
			if not string.IsNullOrEmpty(prefix) then
				effect.valueStr = prefix..effectValue
			else
				effect.valueStr = effectValue
			end
			table.insert(result[subType].effectList, effect)
		end
	end
	local info = self:GetPlayerInfo(uid)
	if tabType == specialType then
		addSubType(1, 100644, specialType)
		addEffect(1, 110155, string.GetFormattedSeperatorNum(info.buildingPower))
		addEffect(1, 110156, string.GetFormattedSeperatorNum(info.sciencePower))
		addEffect(1, 110157, string.GetFormattedSeperatorNum(info.armyPower))
		addEffect(1, 110158, string.GetFormattedSeperatorNum(info.heroPower))

		if isSelf then
			addSubType(2, 129067, specialType)
			addEffect(2, 110159, string.GetFormattedSeperatorNum(info.playerMaxPower))
			addEffect(2, 390186, string.GetFormattedSeperatorNum(info.battleWin))
			addEffect(2, 390187, string.GetFormattedSeperatorNum(info.battleLose))
			addEffect(2, 310131, string.GetFormattedSeperatorNum(info.armyDead))
			addEffect(2, 110160, string.GetFormattedSeperatorNum(info.scoutCount))
		end
	else
		LocalController:instance():visitTable(TableName.EffectNumDesc, function(id, lineData)
			local tab = lineData.tab
			if not string.IsNullOrEmpty(tab) then
				local vec = string.split(tab, ",")
				if #vec >= 3 then
					local mainTab = toInt(vec[1])
					if mainTab == tabType then
						local subType = toInt(vec[2])
						local subTypeName = toInt(vec[3])
						addSubType(subType, subTypeName, mainTab)
						
						local boost = toInt(lineData.boost)
						local effectName = lineData.des
						local effectType = lineData.type
						local effectValue = LuaEntry.Effect:GetGameEffect(lineData.id)
						if boost > 0 then
							effectValue = effectValue + LuaEntry.Effect:GetGameEffect(boost)
						end
						local valueStr = UIUtil.GetEffectNumByType(effectValue, effectType)
						addEffect(subType, effectName, valueStr, "+")
					end
				end
			end
		end)
	end
	return result
end

local function GetUserInfo(self, uuid)
	local userInfo = {}
	local info = self:GetPlayerInfo(uuid)
	if info ~= nil then
		userInfo.uid = uuid
		userInfo.pic = info.pic
		userInfo.picVer = info.picVer
		userInfo.name = info.name
		userInfo.power = info.power
		userInfo.armyKill = info.armyKill
	end
	return userInfo
end

local function GetPlayerInfo(self, uid)
	if self.playerInfo == nil then
		self.playerInfo = DataCenter.PlayerInfoDataManager:GetPlayerDataByUid(uid)
	end
	return self.playerInfo
end

local function GetTitleOpenState(self, mainType, subType)
	local key = LuaEntry.Player.uuid.."_"..mainType.."_"..subType
	local value = CS.GameEntry.Setting:GetBool(key, true)
	return value
end

local function SetTitleOpenState(self, mainType, subType, state)
	local key = LuaEntry.Player.uuid.."_"..mainType.."_"..subType
	CS.GameEntry.Setting:SetBool(key, state)
end

UIMoreInformationCtrl.CloseSelf = CloseSelf
UIMoreInformationCtrl.GetTabBtnData = GetTabBtnData
UIMoreInformationCtrl.GetTabData = GetTabData
UIMoreInformationCtrl.GetUserInfo = GetUserInfo
UIMoreInformationCtrl.GetPlayerInfo = GetPlayerInfo
UIMoreInformationCtrl.GetTitleOpenState = GetTitleOpenState
UIMoreInformationCtrl.SetTitleOpenState = SetTitleOpenState

return UIMoreInformationCtrl