local UIAllianceCityCtrl = BaseClass("UIAllianceCityCtrl", UIBaseCtrl)

local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
	UIManager.Instance:DestroyWindow(UIWindowNames.UIAllianceCity)
end

local function Close(self)
	UIManager.Instance:DestroyWindowByLayer(UILayer.Normal, false)
end

local function GetMyAllianceCities(self)
	local myAlId = LuaEntry.Player.allianceId
	local myAlCities = DataCenter.WorldAllianceCityDataManager:GetCitiesByAlId(myAlId)
	return myAlCities
end

local function GetAllianceCityBuff(self, cityId)
	local buffDes = ""
	local buffAddNum = ""
	local cityTemplate = LocalController:instance():getLine(TableName.WorldCity, cityId)
	local retStr = ""
	if cityTemplate then
		local buffConf = cityTemplate:getValue("buff")
		if buffConf~=nil then
			local buffArr = string.split(buffConf, "|")
			for i, buff in ipairs(buffArr) do
				local buffStr = string.split(buff,";")
				if #buffStr>1 then
					local effectId = tonumber(buffStr[1])
					local value = tonumber(buffStr[2])
					local nameStr = GetTableData(TableName.EffectNumDesc, effectId, 'des')
					buffDes = nameStr --加成类型
	
					local type = toInt(GetTableData(TableName.EffectNumDesc, effectId, 'type'))
					if type == EffectLocalTypeInEffectDesc.Num then
						buffAddNum = string.GetFormattedSeperatorNum(value)
					elseif type == EffectLocalTypeInEffectDesc.Percent then
						buffAddNum = string.GetFormattedPercentStr(value/100)
					elseif type == EffectLocalTypeInEffectDesc.Thousandth then
						buffAddNum = string.GetFormattedThousandthStr(value/1000)
					end
				end
				local tempStr = Localization:GetString(buffDes) .. "+" .. buffAddNum
				if i ~= 1 then
					retStr = retStr .. "\n"
				end
				retStr = retStr .. tempStr
			end
		end
	end
	return retStr
	--return buffDes, buffAddNum
end

local function GetPointIdByCityId(self, cityId)
	local cityData = LocalController:instance():getLine(TableName.WorldCity,cityId)
	local cityLoc = string.split(cityData.location, "|")
	local v2 = CS.UnityEngine.Vector2Int(tonumber(cityLoc[1]), tonumber(cityLoc[2]))
	local pointIndex = SceneUtils.TilePosToIndex(v2)
	return pointIndex
end

local function JumpToTargetPoint(self, worldPos)
	UIManager:GetInstance():DestroyWindow(UIWindowNames.UIAllianceMainTable)
	self:CloseSelf()
	GoToUtil.GotoWorldPos(worldPos)
end

local function RequestGiveUpAlCity(self, cityId, isCancel)
	SFSNetwork.SendMessage(MsgDefines.GiveUpAlCity, tonumber(cityId),isCancel)
end

UIAllianceCityCtrl.CloseSelf = CloseSelf
UIAllianceCityCtrl.Close = Close
UIAllianceCityCtrl.GetMyAllianceCities = GetMyAllianceCities
UIAllianceCityCtrl.GetAllianceCityBuff = GetAllianceCityBuff
UIAllianceCityCtrl.GetPointIdByCityId = GetPointIdByCityId
UIAllianceCityCtrl.JumpToTargetPoint = JumpToTargetPoint
UIAllianceCityCtrl.RequestGiveUpAlCity = RequestGiveUpAlCity

return UIAllianceCityCtrl