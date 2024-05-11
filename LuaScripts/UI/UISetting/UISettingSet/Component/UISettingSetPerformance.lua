local UISettingSetPerformance = BaseClass("UISettingSetPerformance", UIBaseContainer)
local base = UIBaseContainer
local UISettingSliderCell = require "UI.UISetting.UISettingSet.Component.UISettingSliderCell"
local UISettingPartSliderCell = require "UI.UISetting.UISettingSet.Component.UISettingPartSliderCell"
local UISettingBtnCell = require "UI.UISetting.UISettingSet.Component.UISettingBtnCell"
local Localization = CS.GameEntry.Localization

local title_name_path = "TitleBg/TitleName"

-- 创建
local function OnCreate(self)
	base.OnCreate(self)
	self:ComponentDefine()
	self:DataDefine()
end

-- 销毁
local function OnDestroy(self)
	self:ComponentDestroy()
	self:DataDestroy()
	base.OnDestroy(self)
end

-- 显示
local function OnEnable(self)
	base.OnEnable(self)
end

-- 隐藏
local function OnDisable(self)
	base.OnDisable(self)
end


--控件的定义
local function ComponentDefine(self)
	self.title_name = self:AddComponent(UITextMeshProUGUIEx, title_name_path)
end

--控件的销毁
local function ComponentDestroy(self)
	self.title_name = nil
end

--变量的定义
local function DataDefine(self)
	self.param = {}
end

--变量的销毁
local function DataDestroy(self)
	self.param = nil
end

-- 全部刷新
local function ReInit(self,param)
	self.param = param
	self.title_name:SetLocalText(280005) 
	self:ShowCells()
end


local function ShowCells(self)
	for k,v in ipairs(SettingSetPerformanceTypeSort) do
		self:AddOneCell(v)
	end
end

local function AddOneCell(self,setType)
	if CS.SceneManager.IsInPVE() then
		if setType ~= SettingSetType.PveResetPos then
			return
		end
	end
	
	if (setType == SettingSetType.Monster or setType == SettingSetType.DebugChooseServer) then
		local isOn = CS.CommonUtils.IsDebug()
		if LuaEntry.Player:GetGMFlag() == 0 and not isOn then
			return
		end
	end
	if (setType == SettingSetType.SendNotice) then
		if LuaEntry.Player:GetGMFlag() == 0 then
			return
		end
	end
	if (setType == SettingSetType.SetGoogleAdsReward or setType == SettingSetType.SetUnityAdsReward) then
		if LuaEntry.Player:GetGMFlag() == 0 then
			return
		end
	end
	if setType == SettingSetType.UseLuaLoading then
		local isOn = CS.CommonUtils.IsDebug()
		if not isOn then
			return
		end
	end
	if setType == SettingSetType.SetUseContentSizeFitter then
		local isOn = CS.CommonUtils.IsDebug()
		if not isOn then
			return
		end
	end
	if setType == SettingSetType.PveShowHp then
		if LuaEntry.Player:GetGMFlag() == 0 and not CS.CommonUtils.IsDebug() then
			return
		end
	end
	if setType == SettingSetType.PveOldDetect then
		if LuaEntry.Player:GetGMFlag() == 0 and not CS.CommonUtils.IsDebug() then
			return
		end
	end
	if (setType == SettingSetType.ShowTroopAttackEffect or setType == SettingSetType.ShowTroopBloodNum
			or setType == SettingSetType.ShowTroopGunAttackEffect or setType == SettingSetType.ShowTroopDamageAttackEffect
			or setType == SettingSetType.ShowTroopDestroyIcon or setType == SettingSetType.ShowTroopHead or setType == SettingSetType.ShowTroopName) then
		local isOn = CS.CommonUtils.IsDebug()
		if not isOn then
			return
		end
	end
	if setType == SettingSetType.ShaderLod then
		local temp = self.param.cell1:GameObjectSpawn(self.transform)
		temp.name = tostring(setType)
		local cell = self:AddComponent(UISettingPartSliderCell, temp.name)
		local param = UISettingPartSliderCell.Param.New()
		param.setType = setType
		temp:SetActive(true)
		cell:ReInit(param)
	elseif setType == SettingSetType.PveResetPos then
		local temp = self.param.cell2:GameObjectSpawn(self.transform)
		temp.name = tostring(setType)
		local cell = self:AddComponent(UISettingBtnCell, temp.name)
		local param = UISettingBtnCell.Param.New()
		param.setType = setType
		temp:SetActive(CS.SceneManager.IsInPVE())
		cell:ReInit(param)
	else
		local temp = self.param.cell:GameObjectSpawn(self.transform)
		temp.name = tostring(setType)
		local cell = self:AddComponent(UISettingSliderCell, temp.name)
		local param = UISettingSliderCell.Param.New()
		param.setType = setType
		temp:SetActive(true)
		cell:ReInit(param)
	end
end


UISettingSetPerformance.OnCreate = OnCreate
UISettingSetPerformance.OnDestroy = OnDestroy
UISettingSetPerformance.OnEnable = OnEnable
UISettingSetPerformance.OnDisable = OnDisable
UISettingSetPerformance.ComponentDefine = ComponentDefine
UISettingSetPerformance.ComponentDestroy = ComponentDestroy
UISettingSetPerformance.DataDefine = DataDefine
UISettingSetPerformance.DataDestroy = DataDestroy
UISettingSetPerformance.ReInit = ReInit
UISettingSetPerformance.ShowCells = ShowCells
UISettingSetPerformance.AddOneCell = AddOneCell

return UISettingSetPerformance