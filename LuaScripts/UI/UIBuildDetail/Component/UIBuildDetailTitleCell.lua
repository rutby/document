local UIBuildDetailTitleCell = BaseClass("UIBuildDetailTitleCell", UIBaseContainer)
local base = UIBaseContainer

local name_text_path = "name_text"
-- 创建
function UIBuildDetailTitleCell:OnCreate()
	base.OnCreate(self)
	self:ComponentDefine()
	self:DataDefine()
end

-- 销毁
function UIBuildDetailTitleCell:OnDestroy()
	self:ComponentDestroy()
	self:DataDestroy()
	base.OnDestroy(self)
end

-- 显示
function UIBuildDetailTitleCell:OnEnable()
	base.OnEnable(self)
end

-- 隐藏
function UIBuildDetailTitleCell:OnDisable()
	base.OnDisable(self)
end


--控件的定义
function UIBuildDetailTitleCell:ComponentDefine()
	self.name_text = self:AddComponent(UITextMeshProUGUIEx, name_text_path)
end

--控件的销毁
function UIBuildDetailTitleCell:ComponentDestroy()
end

--变量的定义
function UIBuildDetailTitleCell:DataDefine()
	self.param = {}
end

--变量的销毁
function UIBuildDetailTitleCell:DataDestroy()
	self.param = {}
end

-- 全部刷新
function UIBuildDetailTitleCell:ReInit(param)
	self.param = param
	self:Refresh()
end

function UIBuildDetailTitleCell:Refresh()
	if self.param.visible then
		self:SetActive(true)
		self.name_text:SetText(self.param.des)
	else
		self:SetActive(false)
	end
end

return UIBuildDetailTitleCell