---
--- Created by shimin
--- DateTime: 2022/2/21 14:24
---二次确认管理器，读取和保存今日不在弹出/不在弹出的接口
---
local SecondConfirmManager = BaseClass("SecondConfirmManager")

local function __init(self)
	
end

local function __delete(self)
	
end

--获取今日是否可以弹出二次确认框
local function GetTodayCanShowSecondConfirm(self,showType)
	local time = Setting:GetPrivateString(showType,"")
	if time ~= "" then
		return not UITimeManager:GetInstance():IsSameDayForServer(tonumber(time),UITimeManager:GetInstance():GetServerSeconds())
	end
	return true
end

--设置今日不可以弹出二次确认框
local function SetTodayNoShowSecondConfirm(self,showType,isNoShow)
	if isNoShow then
		Setting:SetPrivateString(showType,tostring(UITimeManager:GetInstance():GetServerSeconds()))
	else
		Setting:SetPrivateString(showType,"")
	end
end

--获取是否可以弹出二次确认框
function SecondConfirmManager:GetCanShowSecondConfirm(showType)
	local time = Setting:GetPrivateString(showType, "")
	if time ~= "" then
		return false
	end
	return true
end

--设置不可以弹出二次确认框
function SecondConfirmManager:SetNoShowSecondConfirm(showType, isNoShow)
	if isNoShow then
		Setting:SetPrivateString(showType, tostring(UITimeManager:GetInstance():GetServerSeconds()))
	else
		Setting:SetPrivateString(showType, "")
	end
end

SecondConfirmManager.__init = __init
SecondConfirmManager.__delete = __delete
SecondConfirmManager.GetTodayCanShowSecondConfirm = GetTodayCanShowSecondConfirm
SecondConfirmManager.SetTodayNoShowSecondConfirm = SetTodayNoShowSecondConfirm

return SecondConfirmManager