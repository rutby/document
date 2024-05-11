

local UIChooseServerAccountItem =  BaseClass("UIChooseServerAccountItem",UIBaseContainer)
local AccountListManager = require "DataCenter.AccountData.AccountListManager"

local base = UIBaseContainer

local server_path = "Server"
local name_path = "Name"
local uid_path = "Uid"
local level_path = "Level"
local time_path = "Time"
local receive_path = "Receive"
local delete_path = "Delete"
local copy_path = "Copy"

local function OnCreate(self,param)
	base.OnCreate(self)
	self.server_text = self:AddComponent(UITextMeshProUGUIEx, server_path)
	self.name_text = self:AddComponent(UITextMeshProUGUIEx, name_path)
	self.uid_text = self:AddComponent(UITextMeshProUGUIEx, uid_path)
	self.level_text = self:AddComponent(UITextMeshProUGUIEx, level_path)
	self.time_text = self:AddComponent(UITextMeshProUGUIEx, time_path)
	self.receive_btn = self:AddComponent(UIButton, receive_path)
	self.delete_btn = self:AddComponent(UIButton, delete_path)
	self.copy_btn = self:AddComponent(UIButton, copy_path)
	
	self:SetData(param)
end

local function SetData(self,param)
	local accountData = param.Data
	
	self.server_text:SetText("#" .. accountData.serverid)
	self.name_text:SetText(accountData.nickname)
	self.uid_text:SetText(accountData.gameUid)
	self.level_text:SetText("Lv." .. accountData.newLevel)
	self.time_text:SetText(accountData.time and UITimeManager:GetInstance():TimeStampToTimeForLocal(toInt(accountData.time)) or "")
	
	self.receive_btn:SetOnClick(function()
		UIUtil.ShowTips("Selected UID: " .. accountData.gameUid)
		EventManager:GetInstance():Broadcast(EventId.LF_Account_History, param)
		EventManager:GetInstance():Broadcast(EventId.LF_AccountListView_Close)
	end)
	self.delete_btn:SetOnClick(function()
		UIUtil.ShowTips("Deleted UID: " .. accountData.gameUid)
		DataCenter.AccountListManager:DeleteAcountInfo(accountData.serverid, accountData.gameUid)
		EventManager:GetInstance():Broadcast(EventId.LF_AccountListView_Refresh)
	end)
	self.copy_btn:SetOnClick(function()
		UIUtil.ShowTips("Copied UID: " .. accountData.gameUid)
		CS.UnityEngine.GUIUtility.systemCopyBuffer = tostring(accountData.gameUid)
	end)
end

local function OnEnable(self)
	base.OnEnable(self)
end

local function OnDisable(self)
	base.OnDisable(self)
end

local function OnDestroy(self)
	self.server_text = nil
	self.name_text = nil
	self.uid_text = nil
	self.level_text = nil
	self.receive_btn = nil
	self.delete_btn = nil
	base.OnDestroy(self)
end

UIChooseServerAccountItem.OnCreate= OnCreate
UIChooseServerAccountItem.OnDestroy = OnDestroy
UIChooseServerAccountItem.OnEnable = OnEnable
UIChooseServerAccountItem.OnDisable = OnDisable
UIChooseServerAccountItem.SetData = SetData

return UIChooseServerAccountItem