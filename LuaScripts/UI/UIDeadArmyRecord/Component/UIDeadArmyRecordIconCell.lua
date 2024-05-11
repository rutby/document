--- 查看死亡士兵记录界面每一个士兵图标cell
--- Created by shimin.
--- DateTime: 2023/1/31 21:05
---
local UIDeadArmyRecordIconCell = BaseClass("UIDeadArmyRecordIconCell", UIBaseContainer)
local base = UIBaseContainer

local num_text_path = "content_main_tips_new"
local icon_path = "Icon"
local icon_level_text_path = "Icon/UISoldier_img_levelbg/LevelText"

-- 创建
function UIDeadArmyRecordIconCell:OnCreate()
	base.OnCreate(self)
	self:ComponentDefine()
	self:DataDefine()
end

-- 销毁
function UIDeadArmyRecordIconCell:OnDestroy()
	self:ComponentDestroy()
	self:DataDestroy()
	base.OnDestroy(self)
end

-- 显示
function UIDeadArmyRecordIconCell:OnEnable()
	base.OnEnable(self)
end

-- 隐藏
function UIDeadArmyRecordIconCell:OnDisable()
	base.OnDisable(self)
end

--控件的定义
function UIDeadArmyRecordIconCell:ComponentDefine()
	self.num_text = self:AddComponent(UIText, num_text_path)
	self.icon = self:AddComponent(UIImage, icon_path)
	self.icon_level_text = self:AddComponent(UIText, icon_level_text_path)
end

--控件的销毁
function UIDeadArmyRecordIconCell:ComponentDestroy()
end

--变量的定义
function UIDeadArmyRecordIconCell:DataDefine()
	self.param = {}
end

--变量的销毁
function UIDeadArmyRecordIconCell:DataDestroy()
	self.param = {}
end

-- 全部刷新
function UIDeadArmyRecordIconCell:ReInit(param)
	self.param = param
	local template = DataCenter.ArmyTemplateManager:GetArmyTemplate(self.param.armyId)
	if template ~= nil then
		self.icon:LoadSprite(string.format(LoadPath.SoldierIcons, template.icon))
		self.icon_level_text:SetText(RomeNum[template.show_level])
	end
	self.num_text:SetText("x" .. self.param.count)
end

return UIDeadArmyRecordIconCell