local UIGuideArrowFingerType = BaseClass("UIGuideArrowFingerType", UIBaseContainer)
local base = UIBaseContainer

-- 创建
function UIGuideArrowFingerType:OnCreate()
	base.OnCreate(self)
	self:ComponentDefine()
	self:DataDefine()
end

-- 销毁
function UIGuideArrowFingerType:OnDestroy()
	self:ComponentDestroy()
	self:DataDestroy()
	base.OnDestroy(self)
end

-- 显示
function UIGuideArrowFingerType:OnEnable()
	base.OnEnable(self)
end

-- 隐藏
function UIGuideArrowFingerType:OnDisable()
	base.OnDisable(self)
end

--控件的定义
function UIGuideArrowFingerType:ComponentDefine()
	self.finger_anim = self.gameObject:GetComponentInChildren(typeof(CS.UnityEngine.Animator), true)
end

--控件的销毁
function UIGuideArrowFingerType:ComponentDestroy()
	self.finger_anim = nil
end

--变量的定义
function UIGuideArrowFingerType:DataDefine()
	self.param = {}
end

--变量的销毁
function UIGuideArrowFingerType:DataDestroy()
	self.param = nil
end

-- 全部刷新
function UIGuideArrowFingerType:ReInit(param)
	self.param = param
	if param.position ~= nil then
		self:SetPosition(param.position)
	end
	--旋转
	self.transform.localRotation = Quaternion.Euler(0, 0, self.param.arrowDirection or 0)
	if self.finger_anim ~= nil then
		if param.animSpeed ~= nil then
			self.finger_anim.speed = param.animSpeed
		else
			self.finger_anim.speed = 1
		end
	end
end

--播放抬起
function UIGuideArrowFingerType:PlayUp()
	if self.finger_anim ~= nil then
		self.finger_anim:Play("V_xinshouzhiyin_taiqi_anim",0,0)
	end
end

--播放落下
function UIGuideArrowFingerType:PlayDown()
	if self.finger_anim ~= nil then
		self.finger_anim:Play("V_xinshouzhiyin_anxia_anim",0,0)
	end
end

--播放循环点击
function UIGuideArrowFingerType:PlayLoop()
	if self.finger_anim ~= nil then
		self.finger_anim:Play("V_xinshouzhiyin_loop_anim",0,0)
	end
end

return UIGuideArrowFingerType