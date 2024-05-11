--- Created by shimin.
--- DateTime: 2024/1/23 16:01
--- 数字暴击特效
local UINumHitEffect = BaseClass("UINumHitEffect", UIBaseContainer)
local base = UIBaseContainer

local left_text_path = "HitText1"
local right_text_path = "HitText2"

local CloseTime = 1

-- 创建
function UINumHitEffect:OnCreate()
	base.OnCreate(self)
	self:ComponentDefine()
	self:DataDefine()
end

-- 销毁
function UINumHitEffect:OnDestroy()
	self:ComponentDestroy()
	self:DataDestroy()
	base.OnDestroy(self)
end

-- 显示
function UINumHitEffect:OnEnable()
	base.OnEnable(self)
end

-- 隐藏
function UINumHitEffect:OnDisable()
	base.OnDisable(self)
end


--控件的定义
function UINumHitEffect:ComponentDefine()
	self.left_text = self:AddComponent(UITextMeshProUGUIEx, left_text_path)
	self.right_text = self:AddComponent(UITextMeshProUGUIEx, right_text_path)
end

--控件的销毁
function UINumHitEffect:ComponentDestroy()
end

--变量的定义
function UINumHitEffect:DataDefine()
	self.param = {}
	self.close_timer_callback = function()
		self:OnCloseTimerCallBack()
	end
end

--变量的销毁
function UINumHitEffect:DataDestroy()
	self:DeleteCloseTimer()
	self.param = {}
end

-- 全部刷新
function UINumHitEffect:ReInit(param)
	self.param = param
	self:SetActive(true)
	self.left_text:SetLocalText(GameDialogDefine.CRITICAL_STRIKE)
	self.right_text:SetLocalText(GameDialogDefine.X_WITH, self.param.num)
	self.transform.position = self.param.pos
	self:AddCloseTimer()
end

function UINumHitEffect:DeleteCloseTimer()
	if self.closeTimer ~= nil then
		self.closeTimer:Stop()
		self.closeTimer = nil
	end
end

function UINumHitEffect:AddCloseTimer()
	self:DeleteCloseTimer()
	self.closeTimer = TimerManager:GetInstance():GetTimer(CloseTime, self.close_timer_callback, self, true, false, false)
	self.closeTimer:Start()
end

function UINumHitEffect:OnCloseTimerCallBack()
	self:DeleteCloseTimer()
	self:SetActive(false)
end


return UINumHitEffect