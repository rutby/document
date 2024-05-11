local UIBubbleBuildCell = BaseClass("UIBubbleBuildCell", UIBaseContainer)
local base = UIBaseContainer

local btn_go_path = "btn_go"
local root_path = "btn_go/root"
local icon_img_path = "btn_go/root/bg/icon_img"
local icon_bg_path = "btn_go/root/bg"
local time_bg_path = "btn_go/root/bg/time_bg"
local time_path = "btn_go/root/bg/time_bg/time"
local fill_path = "btn_go/root/bg/fill"

local AnimName =
{
	Enter = "EnterBubble",
	Hide = "HideBubble",
	Normal = "NormalBubble",
}

-- 创建
function UIBubbleBuildCell:OnCreate()
	base.OnCreate(self)
	self:ComponentDefine()
	self:DataDefine()
end

-- 销毁
function UIBubbleBuildCell:OnDestroy()
	self:ComponentDestroy()
	self:DataDestroy()
	base.OnDestroy(self)
end

-- 显示
function UIBubbleBuildCell:OnEnable()
	base.OnEnable(self)
end

-- 隐藏
function UIBubbleBuildCell:OnDisable()
	base.OnDisable(self)
end

--控件的定义
function UIBubbleBuildCell:ComponentDefine()
	self.btn = self:AddComponent(UIButton, btn_go_path)
	self.btn:SetOnClick(function()
		SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
		self:OnBtnClick()
	end)
	self.auto_adjust = self.transform:GetComponent(typeof(CS.AutoAdjustScreenPos))
	self.anim = self:AddComponent(UIAnimator, root_path)
	self.icon_img = self:AddComponent(UIImage, icon_img_path)
	self.icon_bg = self:AddComponent(UIImage, icon_bg_path)
	self.time_bg = self:AddComponent(UIBaseContainer, time_bg_path)
	self.time_text = self:AddComponent(UITextMeshProUGUIEx, time_path)
	self.fill = self:AddComponent(UIImage, fill_path)
	self.fill:SetFillAmount(0)
end

--控件的销毁
function UIBubbleBuildCell:ComponentDestroy()
end

--变量的定义
function UIBubbleBuildCell:DataDefine()
	self.param = {}
	self.isShow = false
	self.show_time_callback = function() 
		self:ShowTimeCallBack()
	end
end

--变量的销毁
function UIBubbleBuildCell:DataDestroy()
	self:DeleteTimer()
	self:DeleteShowTimer()
	self.param = {}
	self.isShow = false
end

-- 全部刷新
function UIBubbleBuildCell:ReInit(param)
	self.param = param
	self:Refresh()
end

function UIBubbleBuildCell:Refresh()
	self:DeleteShowTimer()
	self.auto_adjust:Init(self.param.worldPos)
	if self.param.bgName ~= nil then
		self.icon_bg:SetActive(true)
		self.icon_bg:SetLocalScale(self.param.bgScale or ResetScale)
		self.icon_bg:LoadSprite(self.param.bgName, nil, function()
			self.icon_bg:SetNativeSize()
		end)
	else
		self.icon_bg:SetActive(false)
	end
	
	if self.param.iconName == "" or self.param.iconName == nil then
		self.icon_img:SetActive(false)
	else
		self.icon_img:SetLocalScale(self.param.iconScale)
		self.icon_img:LoadSprite(self.param.iconName, nil, function()
			self.icon_img:SetActive(true)
			self.icon_img:SetNativeSize()
		end)
	end
	if self.isShow then
		self.anim:Play(AnimName.Normal, 0, 0)
	else
		local ret, time = self.anim:PlayAnimationReturnTime(AnimName.Enter)
		if ret then
			self:AddShowTimer(time)
		end
		self.isShow = true
	end

	if self.param.timerAction then
		self.time_bg:SetActive(true)
		self:AddTimer()
		self:TimerAction()
	else
		self.time_bg:SetActive(false)
	end

	if self.param.progressTimerAction then
		self.time_bg:SetActive(true)
		self.fill:SetFillAmount(0)
		self:AddProgressTimer()
		self:ProgressTimerAction()
	else
		self.fill:SetFillAmount(0)
	end
end

function UIBubbleBuildCell:OnBtnClick()
	if self.param.callBack ~= nil then
		self.param.callBack(self.param)
	end
end

function UIBubbleBuildCell:AddTimer()
	self:DeleteTimer()
	self.timer = TimerManager:GetInstance():GetTimer(1, self.TimerAction, self, false, false, false)
	self.timer:Start()
end

function UIBubbleBuildCell:DeleteTimer()
	if self.timer then
		self.timer:Stop()
		self.timer = nil
	end
end

function UIBubbleBuildCell:TimerAction()
	if self.param.timerAction then
		self.param.timerAction(self.time_text)
	end
end

function UIBubbleBuildCell:AddShowTimer(time)
	if self.showTimer == nil then
		self.showTimer = TimerManager:GetInstance():GetTimer(time, self.show_time_callback, self, true, false, false)
		self.showTimer:Start()
	end
end

function UIBubbleBuildCell:DeleteShowTimer()
	if self.showTimer ~= nil then
		self.showTimer:Stop()
		self.showTimer = nil
	end
end

function UIBubbleBuildCell:ShowTimeCallBack()
	self:DeleteShowTimer()
	self.anim:Play(AnimName.Normal, 0, 0)
end

function UIBubbleBuildCell:AddProgressTimer()
	self:DeleteProgressTimer()
	self.progressTimer = TimerManager:GetInstance():GetTimer(1, self.ProgressTimerAction, self, false, false, false)
	self.progressTimer:Start()
end

function UIBubbleBuildCell:DeleteProgressTimer()
	if self.progressTimer then
		self.progressTimer:Stop()
		self.progressTimer = nil
	end
end

function UIBubbleBuildCell:ProgressTimerAction()
	if self.param.progressTimerAction then
		self.param.progressTimerAction(self.fill, self.time_text)
	end
end

function UIBubbleBuildCell:GetArrowPosition()
	return self.icon_img:GetPosition()
end

function UIBubbleBuildCell:SetInView(isInView)
	if self.isInView == isInView then
		return
	end
	self.isInView = isInView
	self.btn:SetActive(isInView)
end

return UIBubbleBuildCell