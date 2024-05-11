local UISettingSetClear = BaseClass("UISettingSetClear", UIBaseContainer)
local base = UIBaseContainer
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
	self.title_name:SetLocalText(100244) 
	self:ShowCells()
end


local function ShowCells(self)
	for k,v in ipairs(SettingSetClearTypeSort) do
		self:AddOneCell(v)
	end
end

local function AddOneCell(self,setType)
	local temp = self.param.cell:GameObjectSpawn(self.transform)
	temp.name = tostring(setType)
	local cell = self:AddComponent(UISettingBtnCell, temp.name)
	local param = UISettingBtnCell.Param.New()
	param.setType = setType
	temp:SetActive(true)
	cell:ReInit(param)
end


UISettingSetClear.OnCreate = OnCreate
UISettingSetClear.OnDestroy = OnDestroy
UISettingSetClear.OnEnable = OnEnable
UISettingSetClear.OnDisable = OnDisable
UISettingSetClear.ComponentDefine = ComponentDefine
UISettingSetClear.ComponentDestroy = ComponentDestroy
UISettingSetClear.DataDefine = DataDefine
UISettingSetClear.DataDestroy = DataDestroy
UISettingSetClear.ReInit = ReInit
UISettingSetClear.ShowCells = ShowCells
UISettingSetClear.AddOneCell = AddOneCell

return UISettingSetClear