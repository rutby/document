local UISettingSetSound = BaseClass("UISettingSetSound", UIBaseContainer)
local base = UIBaseContainer
local UISettingSliderCell = require "UI.UISetting.UISettingSet.Component.UISettingSliderCell"
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
	self.title_name:SetLocalText(280015) 
	self:ShowCells()
end


local function ShowCells(self)
	for k,v in ipairs(SettingSetSoundTypeSort) do
		self:AddOneCell(v)
	end
end

local function AddOneCell(self,setType)
	if CS.SceneManager.IsInPVE() then
		if setType ~= SettingSetType.Sound and
		   setType ~= SettingSetType.Vibrate then
			return
		end
	end
	
	local temp = self.param.cell:GameObjectSpawn(self.transform)
	temp.name = tostring(setType)
	local cell = self:AddComponent(UISettingSliderCell, temp.name)
	local param = UISettingSliderCell.Param.New()
	param.setType = setType
	temp:SetActive(true)
	cell:ReInit(param)
end


UISettingSetSound.OnCreate = OnCreate
UISettingSetSound.OnDestroy = OnDestroy
UISettingSetSound.OnEnable = OnEnable
UISettingSetSound.OnDisable = OnDisable
UISettingSetSound.ComponentDefine = ComponentDefine
UISettingSetSound.ComponentDestroy = ComponentDestroy
UISettingSetSound.DataDefine = DataDefine
UISettingSetSound.DataDestroy = DataDestroy
UISettingSetSound.ReInit = ReInit
UISettingSetSound.ShowCells = ShowCells
UISettingSetSound.AddOneCell = AddOneCell

return UISettingSetSound