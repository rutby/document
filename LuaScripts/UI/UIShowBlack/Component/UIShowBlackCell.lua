local UIShowBlackCell = BaseClass("UIShowBlackCell", UIBaseContainer)
local base = UIBaseContainer

local this_path = ""

-- 创建
function UIShowBlackCell:OnCreate()
	base.OnCreate(self)
	self:ComponentDefine()
	self:DataDefine()
end

-- 销毁
function UIShowBlackCell:OnDestroy()
	self:ComponentDestroy()
	self:DataDestroy()
	base.OnDestroy(self)
end

-- 显示
function UIShowBlackCell:OnEnable()
	base.OnEnable(self)
end

-- 隐藏
function UIShowBlackCell:OnDisable()
	base.OnDisable(self)
end

--控件的定义
function UIShowBlackCell:ComponentDefine()
	self.des_text = self:AddComponent(UITextMeshProUGUIEx, this_path)
	self.anim = self:AddComponent(UIAnimator, this_path)
end

--控件的销毁
function UIShowBlackCell:ComponentDestroy()
end

--变量的定义
function UIShowBlackCell:DataDefine()
	self.param = {}
end

--变量的销毁
function UIShowBlackCell:DataDestroy()
	self.param = {}
end

-- 全部刷新
function UIShowBlackCell:ReInit(param)
	self.param = param
	self.des_text:SetText(param.des)
end

function UIShowBlackCell:DoShowAnim() 
	self.anim:Play("UIShowBlackCellShow",0,0)
end

return UIShowBlackCell