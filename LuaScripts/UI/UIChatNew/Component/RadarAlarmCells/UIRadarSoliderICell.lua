local UIRadarSoliderICell = BaseClass("UIRadarSoliderICell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization


--top

local top_soliderNum_text_path = "Icon/lv"
local icon_path = "Icon"
local level_text_path = "count"


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
	self.top_soliderNum_text= self:AddComponent(UITextMeshProUGUIEx, top_soliderNum_text_path)
	self.level_text= self:AddComponent(UITextMeshProUGUIEx, level_text_path)
	self.icon= self:AddComponent(UIImage, icon_path)
end

--控件的销毁
local function ComponentDestroy(self)
	self.top_soliderNum_text= nil
	self.level_text= nil
	self.icon= nil
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
	self.top_soliderNum_text:SetText("x"..string.GetFormattedSeperatorNum(param.total))
	if param.armyId ~= nil then
		local template = DataCenter.ArmyTemplateManager:GetArmyTemplate(self.param.armyId)
		if template ~= nil then
			self.icon:LoadSprite(string.format(LoadPath.SoldierIcons, template.icon))
		end
		self.level_text:SetText(RomeNum[template.show_level])
	end
end

--param.total = ArmyInfo.Soldiers[i].total
--param.armyId = ArmyInfo.Soldiers[i].armsId

UIRadarSoliderICell.OnCreate = OnCreate
UIRadarSoliderICell.OnDestroy = OnDestroy
UIRadarSoliderICell.OnEnable = OnEnable
UIRadarSoliderICell.OnDisable = OnDisable
UIRadarSoliderICell.ComponentDefine = ComponentDefine
UIRadarSoliderICell.ComponentDestroy = ComponentDestroy
UIRadarSoliderICell.DataDefine = DataDefine
UIRadarSoliderICell.DataDestroy = DataDestroy
UIRadarSoliderICell.ReInit = ReInit

return UIRadarSoliderICell