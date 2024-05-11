local UISimpleAnimation = BaseClass("UISimpleAnimation", UIBaseContainer)
local base = UIBaseContainer
local SimpleAnimation = typeof(CS.SimpleAnimation)

local function OnCreate(self, ...)
	base.OnCreate(self)
	self.simpleAnimation = self.gameObject:GetComponent(SimpleAnimation)
end

local function OnDestroy(self)
	self.simpleAnimation = nil
	base.OnDestroy(self)
end

local function Play(self,name)
	self.simpleAnimation:Play(name)
end

local function Enable(self,value)
	self.simpleAnimation.enabled = value
end

--做动画并返回动画时间
local function PlayAnimationReturnTime(self,animName)
	local anim = self.simpleAnimation:GetState(animName)
	if anim == nil then
		return false
	end
	
	self.simpleAnimation:Play(animName)
	return true, self.simpleAnimation:GetClipLength(animName)
end

--不做动画返回动画时间
local function GetAnimationReturnTime(self,animName)
	local anim = self.simpleAnimation:GetState(animName)
	if anim == nil then
		return false
	end

	return true, self.simpleAnimation:GetClipLength(animName)
end

local function IsPlaying(self,animName)
	local anim = self.simpleAnimation:GetState(animName)
	if anim == nil then
		return false
	end
	return self.simpleAnimation:IsPlaying(animName)
end

local function Stop(self)
	self.simpleAnimation:Stop()
end


UISimpleAnimation.OnCreate = OnCreate
UISimpleAnimation.OnDestroy = OnDestroy
UISimpleAnimation.Play = Play
UISimpleAnimation.Enable = Enable
UISimpleAnimation.PlayAnimationReturnTime = PlayAnimationReturnTime
UISimpleAnimation.GetAnimationReturnTime = GetAnimationReturnTime
UISimpleAnimation.IsPlaying = IsPlaying
UISimpleAnimation.Stop = Stop
return UISimpleAnimation