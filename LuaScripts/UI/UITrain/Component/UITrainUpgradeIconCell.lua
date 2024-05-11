local UITrainUpgradeIconCell = BaseClass("UITrainUpgradeIconCell", UIBaseContainer)
local base = UIBaseContainer

local this_path = ""
local name_text_path = "name_text"
local level_text_path = "UISoldier_img_levelbg/level_text"

-- 创建
function UITrainUpgradeIconCell:OnCreate()
	base.OnCreate(self)
	self:ComponentDefine()
	self:DataDefine()
end

-- 销毁
function UITrainUpgradeIconCell:OnDestroy()
	self:ComponentDestroy()
	self:DataDestroy()
	base.OnDestroy(self)
end

-- 显示
function UITrainUpgradeIconCell:OnEnable()
	base.OnEnable(self)
end

-- 隐藏
function UITrainUpgradeIconCell:OnDisable()
	base.OnDisable(self)
end

--控件的定义
function UITrainUpgradeIconCell:ComponentDefine()
	self.icon = self:AddComponent(UIImage, this_path)
	self.name_text = self:AddComponent(UITextMeshProUGUIEx, name_text_path)
	self.level_text = self:AddComponent(UITextMeshProUGUIEx, level_text_path)
end

--控件的销毁
function UITrainUpgradeIconCell:ComponentDestroy()
end

--变量的定义
function UITrainUpgradeIconCell:DataDefine()
	self.id = 0
end

--变量的销毁
function UITrainUpgradeIconCell:DataDestroy()
	self.id = 0
end

-- 全部刷新
function UITrainUpgradeIconCell:ReInit(id)
	self.id = id
	self:Refresh()
end

function UITrainUpgradeIconCell:Refresh()
	local template = DataCenter.ArmyTemplateManager:GetArmyTemplate(self.id)
	if template ~= nil then
		self.icon:LoadSprite(string.format(LoadPath.SoldierIcons, template.icon))
		self.level_text:SetText(RomeNum[template.show_level])
		self.name_text:SetLocalText(template.name)
	end
end

return UITrainUpgradeIconCell