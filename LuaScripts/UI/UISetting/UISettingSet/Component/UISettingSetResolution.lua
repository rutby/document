local UISettingSetResolution = BaseClass("UISettingSetResolution", UIBaseContainer)
local base = UIBaseContainer
local UISettingInputCell = require "UI.UISetting.UISettingSet.Component.UISettingInputCell"
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
	self.title_name:SetText("性能设置")
	self:ShowCells()
end


local function ShowCells(self)
	for k,v in ipairs(SettingSetResolutionTypeSort) do
		self:AddOneCell(v)
	end
end

local function AddOneCell(self,setType)
	local temp = self.param.cell:GameObjectSpawn(self.transform)
	temp.name = tostring(setType)
	local cell = self:AddComponent(UISettingInputCell, temp.name)
	local param = UISettingInputCell.Param.New()
	param.setType = setType
	temp:SetActive(true)
	cell:ReInit(param)
end


UISettingSetResolution.OnCreate = OnCreate
UISettingSetResolution.OnDestroy = OnDestroy
UISettingSetResolution.OnEnable = OnEnable
UISettingSetResolution.OnDisable = OnDisable
UISettingSetResolution.ComponentDefine = ComponentDefine
UISettingSetResolution.ComponentDestroy = ComponentDestroy
UISettingSetResolution.DataDefine = DataDefine
UISettingSetResolution.DataDestroy = DataDestroy
UISettingSetResolution.ReInit = ReInit
UISettingSetResolution.ShowCells = ShowCells
UISettingSetResolution.AddOneCell = AddOneCell

return UISettingSetResolution