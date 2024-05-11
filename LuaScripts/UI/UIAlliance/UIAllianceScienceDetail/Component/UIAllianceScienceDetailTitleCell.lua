local UIAllianceScienceDetailTitleCell = BaseClass("UIAllianceScienceDetailTitleCell", UIBaseContainer)
local base = UIBaseContainer

local name_text_path = "name_text"
-- 创建
function UIAllianceScienceDetailTitleCell:OnCreate()
	base.OnCreate(self)
	self:ComponentDefine()
	self:DataDefine()
end

-- 销毁
function UIAllianceScienceDetailTitleCell:OnDestroy()
	self:ComponentDestroy()
	self:DataDestroy()
	base.OnDestroy(self)
end

-- 显示
function UIAllianceScienceDetailTitleCell:OnEnable()
	base.OnEnable(self)
end

-- 隐藏
function UIAllianceScienceDetailTitleCell:OnDisable()
	base.OnDisable(self)
end


--控件的定义
function UIAllianceScienceDetailTitleCell:ComponentDefine()
	self.name_text = self:AddComponent(UITextMeshProUGUIEx, name_text_path)
end

--控件的销毁
function UIAllianceScienceDetailTitleCell:ComponentDestroy()
end

--变量的定义
function UIAllianceScienceDetailTitleCell:DataDefine()
	self.param = {}
end

--变量的销毁
function UIAllianceScienceDetailTitleCell:DataDestroy()
	self.param = {}
end

-- 全部刷新
function UIAllianceScienceDetailTitleCell:ReInit(param)
	self.param = param
	self:Refresh()
end

function UIAllianceScienceDetailTitleCell:Refresh()
	if self.param.visible then
		self:SetActive(true)
		self.name_text:SetText(self.param.des)
	else
		self:SetActive(false)
	end
end

return UIAllianceScienceDetailTitleCell