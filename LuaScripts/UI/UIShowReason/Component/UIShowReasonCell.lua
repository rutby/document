--- Created by shimin.
--- DateTime: 2023/12/25 17:41
--- 点击原始时间界面cell
local UIShowPowerCell = BaseClass("UIShowPowerCell", UIBaseContainer)
local base = UIBaseContainer

local left_text_path = "left_text"
local right_text_path = "right_text"

-- 创建
function UIShowPowerCell:OnCreate()
	base.OnCreate(self)
	self:ComponentDefine()
	self:DataDefine()
end

-- 销毁
function UIShowPowerCell:OnDestroy()
	self:ComponentDestroy()
	self:DataDestroy()
	base.OnDestroy(self)
end

-- 显示
function UIShowPowerCell:OnEnable()
	base.OnEnable(self)
end

-- 隐藏
function UIShowPowerCell:OnDisable()
	base.OnDisable(self)
end


--控件的定义
function UIShowPowerCell:ComponentDefine()
	self.left_text = self:AddComponent(UITextMeshProUGUIEx, left_text_path)
	self.right_text = self:AddComponent(UITextMeshProUGUIEx, right_text_path)
end

--控件的销毁
function UIShowPowerCell:ComponentDestroy()
end

--变量的定义
function UIShowPowerCell:DataDefine()
	self.param = {}
end

--变量的销毁
function UIShowPowerCell:DataDestroy()
	self.param = {}
end

-- 全部刷新
function UIShowPowerCell:ReInit(param)
	self.param = param
	self.left_text:SetText(self.param.leftDes)
	self.right_text:SetText(self.param.rightDes)
end

return UIShowPowerCell