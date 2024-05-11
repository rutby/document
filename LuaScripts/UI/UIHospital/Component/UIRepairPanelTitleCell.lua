local UIRepairPanelTitleCell = BaseClass("UIRepairPanelTitleCell", UIBaseContainer)
local base = UIBaseContainer

local Param = DataClass("Param", ParamData)
local ParamData =  {
	index,
	des,
}

local this_path = ""

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
	self.des_text = self:AddComponent(UITextMeshProUGUIEx, this_path)
end

--控件的销毁
local function ComponentDestroy(self)
	self.des_text = nil
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
	self.des_text:SetText(param.des)
end

UIRepairPanelTitleCell.OnCreate = OnCreate
UIRepairPanelTitleCell.OnDestroy = OnDestroy
UIRepairPanelTitleCell.Param = Param
UIRepairPanelTitleCell.OnEnable = OnEnable
UIRepairPanelTitleCell.OnDisable = OnDisable
UIRepairPanelTitleCell.ComponentDefine = ComponentDefine
UIRepairPanelTitleCell.ComponentDestroy = ComponentDestroy
UIRepairPanelTitleCell.DataDefine = DataDefine
UIRepairPanelTitleCell.DataDestroy = DataDestroy
UIRepairPanelTitleCell.ReInit = ReInit

return UIRepairPanelTitleCell