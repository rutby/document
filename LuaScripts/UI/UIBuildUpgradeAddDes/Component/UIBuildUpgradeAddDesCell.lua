local UIBuildUpgradeAddDesCell = BaseClass("UIBuildUpgradeAddDesCell", UIBaseContainer)
local base = UIBaseContainer

local Param = DataClass("Param", ParamData)
local ParamData =  {
	leftDes,
	rightDes,
}

local left_text_path = "LeftText"
local right_text_path = "RightText"

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
	self.left_text = self:AddComponent(UIText, left_text_path)
	self.right_text = self:AddComponent(UIText, right_text_path)
end

--控件的销毁
local function ComponentDestroy(self)
	self.left_text = nil
	self.right_text = nil
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
	if param ~= nil then
		self.left_text:SetText(param.leftDes)
		self.right_text:SetText(param.rightDes)
	end
end

UIBuildUpgradeAddDesCell.OnCreate = OnCreate
UIBuildUpgradeAddDesCell.OnDestroy = OnDestroy
UIBuildUpgradeAddDesCell.Param = Param
UIBuildUpgradeAddDesCell.OnEnable = OnEnable
UIBuildUpgradeAddDesCell.OnDisable = OnDisable
UIBuildUpgradeAddDesCell.ComponentDefine = ComponentDefine
UIBuildUpgradeAddDesCell.ComponentDestroy = ComponentDestroy
UIBuildUpgradeAddDesCell.DataDefine = DataDefine
UIBuildUpgradeAddDesCell.DataDestroy = DataDestroy
UIBuildUpgradeAddDesCell.ReInit = ReInit

return UIBuildUpgradeAddDesCell