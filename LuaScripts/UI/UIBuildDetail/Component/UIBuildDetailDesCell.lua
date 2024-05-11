local UIBuildDetailDesCell = BaseClass("UIBuildDetailDesCell", UIBaseContainer)
local base = UIBaseContainer

local name_text_path = "name_text"
-- 创建
function UIBuildDetailDesCell:OnCreate()
	base.OnCreate(self)
	self:ComponentDefine()
	self:DataDefine()
end

-- 销毁
function UIBuildDetailDesCell:OnDestroy()
	self:ComponentDestroy()
	self:DataDestroy()
	base.OnDestroy(self)
end

-- 显示
function UIBuildDetailDesCell:OnEnable()
	base.OnEnable(self)
end

-- 隐藏
function UIBuildDetailDesCell:OnDisable()
	base.OnDisable(self)
end


--控件的定义
function UIBuildDetailDesCell:ComponentDefine()
	self.name_text = self:AddComponent(UITextMeshProUGUIEx, name_text_path)
end

--控件的销毁
function UIBuildDetailDesCell:ComponentDestroy()
end

--变量的定义
function UIBuildDetailDesCell:DataDefine()
	self.param = {}
end

--变量的销毁
function UIBuildDetailDesCell:DataDestroy()
	self.param = {}
end

-- 全部刷新
function UIBuildDetailDesCell:ReInit(param)
	self.param = param
	self:Refresh()
end

function UIBuildDetailDesCell:Refresh()
	if self.param.visible then
		self:SetActive(true)
		self.name_text:SetText(self.param.des)
	else
		self:SetActive(false)
	end
end

return UIBuildDetailDesCell