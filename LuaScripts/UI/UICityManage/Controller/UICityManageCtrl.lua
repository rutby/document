local UICityManageCtrl = BaseClass("UICityManageCtrl", UIBaseCtrl)

local function CloseSelf(self)
	UIManager.Instance:DestroyWindow(UIWindowNames.UICityManage,{anim = true,UIMainAnim = UIMainAnimType.ChangeAllShow})
end

local function CloseAll(self)
	UIManager.Instance:DestroyWindow(UIWindowNames.UICityManage)
	UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPlayerInfo)
end

local function Close(self)
	UIManager.Instance:DestroyWindowByLayer(UILayer.Normal, false)
end

local function GetAllCityManageData(self)
	local retTb = {}
	local conf = DataCenter.CityManageDataManager:GetAllCityManageData()
	for i, group in ipairs(conf) do
		local groupContent = {}
		for j, buff in ipairs(group) do
			if buff.id == CityManageBuffType.GolloesFever or buff.id == CityManageBuffType.GolloesGuard then
				local timeInfo = DataCenter.StatusManager:GetBuffTimeInfo(buff.status)
				if timeInfo and timeInfo.endTime ~= nil and timeInfo.totalTime ~= nil then
					table.insert(groupContent, buff)
				end
			else
				if buff.id == CityManageBuffType.WarGuard then
					--if LuaEntry.Player.serverType ~= ServerType.EDEN_SERVER then
						table.insert(groupContent, buff)
					--end
				elseif buff.id == CityManageBuffType.EdenWarGuard then
					--if LuaEntry.Player.serverType == ServerType.EDEN_SERVER then
					--	table.insert(groupContent, buff)
					--end
				else
					table.insert(groupContent, buff)
				end
				
				
			end
		end
		if #groupContent > 0 then
			table.insert(retTb, groupContent)
		end
	end
	return retTb
end




UICityManageCtrl.CloseSelf = CloseSelf
UICityManageCtrl.CloseAll = CloseAll
UICityManageCtrl.Close = Close
UICityManageCtrl.GetAllCityManageData = GetAllCityManageData

return UICityManageCtrl