--- Created by shimin.
--- DateTime: 2024/1/23 11:40
--- 运兵车升级属性提示界面cell
local UIGarageRefitUpgradeTipCell = BaseClass("UIGarageRefitUpgradeTipCell", UIBaseContainer)
local base = UIBaseContainer

local left_text_path = "left_text"
local right_text_path = "right_text"
local desc_text_path = "desc_text"

-- 创建
function UIGarageRefitUpgradeTipCell:OnCreate()
	base.OnCreate(self)
	self:ComponentDefine()
	self:DataDefine()
end

-- 销毁
function UIGarageRefitUpgradeTipCell:OnDestroy()
	self:ComponentDestroy()
	self:DataDestroy()
	base.OnDestroy(self)
end

-- 显示
function UIGarageRefitUpgradeTipCell:OnEnable()
	base.OnEnable(self)
end

-- 隐藏
function UIGarageRefitUpgradeTipCell:OnDisable()
	base.OnDisable(self)
end


--控件的定义
function UIGarageRefitUpgradeTipCell:ComponentDefine()
	self.left_text = self:AddComponent(UITextMeshProUGUIEx, left_text_path)
	self.right_text = self:AddComponent(UITextMeshProUGUIEx, right_text_path)
	self.desc_text = self:AddComponent(UITextMeshProUGUIEx, desc_text_path)
end

--控件的销毁
function UIGarageRefitUpgradeTipCell:ComponentDestroy()
end

--变量的定义
function UIGarageRefitUpgradeTipCell:DataDefine()
	self.param = {}
end

--变量的销毁
function UIGarageRefitUpgradeTipCell:DataDestroy()
	self.param = {}
end

-- 全部刷新
function UIGarageRefitUpgradeTipCell:ReInit(param)
	self.param = param
	if self.param.visible then
		self:SetActive(true)
		self.left_text:SetText(self.param.leftDes)
		self.right_text:SetText(self.param.rightDes)
		self.desc_text:SetText(self.param.desc)
	else
		self:SetActive(false)
	end
end

return UIGarageRefitUpgradeTipCell