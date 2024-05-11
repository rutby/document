--- Created by shimin.
--- DateTime: 2023/12/20 19:08
--- 提升战力界面界面cell
local UIShowPowerCell = BaseClass("UIShowPowerCell", UIBaseContainer)
local base = UIBaseContainer

local this_path = ""
local power_text_path = "bg/power_text"
local power_value_text_path = "bg/power_value_text"

local CloseTime = 1

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
	self.anim = self:AddComponent(UIAnimator, this_path)
	self.power_text = self:AddComponent(UITextMeshProUGUIEx, power_text_path)
	self.power_value_text = self:AddComponent(UITextMeshProUGUIEx, power_value_text_path)
end

--控件的销毁
function UIShowPowerCell:ComponentDestroy()
end

--变量的定义
function UIShowPowerCell:DataDefine()
	self.param = {}
	self.close_timer_callback = function() 
		self:OnCloseTimerCallBack()
	end
	self.anim_timer_callback = function()
		self:OnAnimTimerCallBack()
	end
end

--变量的销毁
function UIShowPowerCell:DataDestroy()
	self:DeleteCloseTimer()
	self:DeleteAnimTimer()
	self.param = {}
end

-- 全部刷新
function UIShowPowerCell:ReInit(param)
	self.param = param
	self:Refresh()
end

function UIShowPowerCell:Refresh()
	self:SetAnchoredPositionXY(0, 0)
	self.power_text:SetLocalText(GameDialogDefine.POWER)
	self.power_value_text:SetText("+" .. string.GetFormattedSeperatorNum(self.param.power))
	local ret, time = self.anim:PlayAnimationReturnTime("show")
	if ret then
		self:AddAnimTimer(time)
	end
	self:ShowBombEffect()
end

function UIShowPowerCell:ShowBombEffect()
	----获取不到坐标，不显示特效
	--local pos = UIUtil.GetUIMainSavePos(UIMainSavePosType.Power)
	--if pos ~= nil then
	--	self:GameObjectInstantiateAsync(UIAssets.UIShowPowerFinishEffect, function(request)
	--		if request.isError then
	--			return
	--		end
	--		local go = request.gameObject
	--		go:SetActive(true)
	--		local layer = UIManager:GetInstance():GetLayer(UILayer.UIResource.Name)
	--		go.transform:SetParent(layer.transform)
	--		go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
	--		go.transform:SetAsLastSibling()
	--		go.transform.position = pos
	--		self:AddCloseTimer()
	--	end)
	--end
end

function UIShowPowerCell:DeleteCloseTimer()
	if self.closeTimer ~= nil then
		self.closeTimer:Stop()
		self.closeTimer = nil
	end
end

function UIShowPowerCell:AddCloseTimer()
	self:DeleteCloseTimer()
	self.closeTimer = TimerManager:GetInstance():GetTimer(CloseTime, self.close_timer_callback, self, true, false, false)
	self.closeTimer:Start()
end

function UIShowPowerCell:OnCloseTimerCallBack()
	self:DeleteCloseTimer()
end

function UIShowPowerCell:DeleteAnimTimer()
	if self.anim_timer ~= nil then
		self.anim_timer:Stop()
		self.anim_timer = nil
	end
end

function UIShowPowerCell:AddAnimTimer(time)
	self:DeleteAnimTimer()
	self.anim_timer = TimerManager:GetInstance():GetTimer(time, self.anim_timer_callback, self, true, false, false)
	self.anim_timer:Start()
end

function UIShowPowerCell:OnAnimTimerCallBack()
	self:DeleteAnimTimer()
	self.view:CloseOne()
end


return UIShowPowerCell