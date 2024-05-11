---
--- 账号
--- Created by shimin.
--- DateTime: 2020/10/21 18:00
---
local PinManager = BaseClass("PinManager")
local Localization = CS.GameEntry.Localization
--本地缓存登录过的账号
local function __init(self)
	self.param = {}
end

local function __delete(self)
	self.param = nil
end

local function SetParam(self,param)
	self.param = param
end


local function PinOldPwdCheckHandle(self,message)
	if message["errorCode"] == nil then
		if message["success"] then
			EventManager:GetInstance():Broadcast(EventId.PinInputNext)
		else
			EventManager:GetInstance():Broadcast(EventId.PinInputReset)
		end
	else
		UIUtil.ShowTips(Localization:GetString(message["errorCode"]))
		EventManager:GetInstance():Broadcast(EventId.ServerError,MsgDefines.PinOldPwdCheck)
		EventManager:GetInstance():Broadcast(EventId.PinInputReset)
	end
end

local function PinSetPwdHandle(self,message)
	if message["errorCode"] == nil then
		if message["success"] then
			LuaEntry.Player.pinPwdStatus = PinPwdStatus.Have
			if self.param.isOnlyChangePwd then
				UIUtil.ShowTipsId(280091) 
			end
			EventManager:GetInstance():Broadcast(EventId.PinInputClose)
		else
			EventManager:GetInstance():Broadcast(EventId.PinInputReset)
		end
	else
		UIUtil.ShowTips(Localization:GetString(message["errorCode"]))
		EventManager:GetInstance():Broadcast(EventId.ServerError,MsgDefines.PinOldPwdCheck)
		EventManager:GetInstance():Broadcast(EventId.PinInputReset)
	end
end

local function PinPwdCheckHandle(self,message)
	if message["errorCode"] == nil then
		CS.ApplicationLaunch.Instance.Loading:OnAuthSuccess()
	else
		UIUtil.ShowTips(Localization:GetString(message["errorCode"]))
		EventManager:GetInstance():Broadcast(EventId.ServerError,MsgDefines.PinOldPwdCheck)
		EventManager:GetInstance():Broadcast(EventId.PinInputReset)
	end
end

local function PinPwdCheckFrequencyHandle(self,message)
	if message["errorCode"] == nil then
		if message["success"] then
			LuaEntry.Player.pinPwdCheckFrequency = self.param.state
		end
	else
		UIUtil.ShowTips(Localization:GetString(message["errorCode"]))
	end
end


local function PinPwdForgetHandle(self,message)
	if message["errorCode"] == nil then
		if message["success"] then
			UIUtil.ShowTipsId(280089) 
		end
	else
		UIUtil.ShowTips(Localization:GetString(message["errorCode"]))
	end
end

PinManager.__init = __init
PinManager.__delete = __delete
PinManager.PinOldPwdCheckHandle = PinOldPwdCheckHandle
PinManager.PinSetPwdHandle = PinSetPwdHandle
PinManager.SetParam = SetParam
PinManager.PinPwdCheckHandle = PinPwdCheckHandle
PinManager.PinPwdCheckFrequencyHandle = PinPwdCheckFrequencyHandle
PinManager.PinPwdForgetHandle = PinPwdForgetHandle

return PinManager