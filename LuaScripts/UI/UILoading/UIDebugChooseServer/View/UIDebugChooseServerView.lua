---------------------------------------------------------------------
-- aps (C) CompanyName, All Rights Reserved
-- Created by: AuthorName
-- Date: 2021-07-29 12:11:44
---------------------------------------------------------------------

-- To edit this template in: Data/Config/Template.lua
-- To disable this template, check off menuitem: Options-Enable Template File

---@class UIDebugChooseServerView
local UIDebugChooseServerView = BaseClass("UIDebugChooseServerView",UIBaseView)
local base = UIBaseView
local continueBtnPath="Panel/LeftGameObject/continue"
--local changeBtnPath="Panel/LeftGameObject/change"
local newServerBtnPath="Panel/LeftGameObject/NewServer"
local historyAccountBtnPath="Panel/LeftGameObject/HistoryAccount"
local ipInputPath="Panel/LeftGameObject/Inputs/Ip/InputField1"
local portInputPath="Panel/LeftGameObject/Inputs/Port/InputField2"
local zoneInputPath="Panel/LeftGameObject/Inputs/Zone/InputField3"
local uidInuptPath="Panel/LeftGameObject/Inputs/Uid/InputField4"
local setting_content_path = "Panel/Scroll View/Viewport/Content"

local DebugServerItem = require "UI.UILoading.UIDebugChooseServer.Controller.DebugServerItem"
local AccountListManager = require "DataCenter.AccountData.AccountListManager"

local serverItems={}

local Setting = CS.GameEntry.Setting
local SettingKeys = CS.GameDefines.SettingKeys

local function OnCreate(self)
	base.OnCreate(self)
	if not table.IsNullOrEmpty(self.userData) then
		self.ctrl:SetParam(self.userData[1])
	end
	--CS.AccountListManager.Instance():LoadAcountInfos();
	--DataCenter.AccountListManager:LoadAcountInfos()
	
	self.continueBtn = self:AddComponent(UIButton, continueBtnPath)
	--self.changeBtn = self:AddComponent(UIButton, changeBtnPath)
	self.newServerBtn = self:AddComponent(UIButton, newServerBtnPath)
	self.historyAccountBtn = self:AddComponent(UIButton, historyAccountBtnPath)
	self.ipInput = self:AddComponent(UITMPInput, ipInputPath)
	self.portInput= self:AddComponent(UITMPInput, portInputPath)
	self.zoneInput= self:AddComponent(UITMPInput, zoneInputPath)
	self.uidInput= self:AddComponent(UITMPInput, uidInuptPath)
	--要克隆的Item
	self._serverCell = self.transform:Find("DebugServerItem").gameObject
	self._serverCell:GameObjectCreatePool();
	self._serverListRoot = self.transform:Find(setting_content_path);
	self.setting_content = self:AddComponent(UIBaseContainer,setting_content_path)
	self.continueBtn:SetOnClick(function ()
			self:OnContinueClick()
		end)

	--self.changeBtn:SetOnClick(function ()
			--self:OnChangeClick()
		--end)
	self.newServerBtn:SetOnClick(function ()
		UIUtil.ShowMessage("确定开始新游戏吗？", 2, 
				GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL,
				function()
					self:OnNewServerClick()
				end, 
				function()
				end)
		end)
	self.historyAccountBtn:SetOnClick(function ()
			self:OnShowHistoryAccount()
		end)
	
	self:InitView(OnCallBack)
end

local function InitView(self,OnCallBack)
	local serverKey = SettingKeys.LAST_SERVER_KEY
	local lastServerID = Setting:GetInt(serverKey, 0)
	self._lastServer=CS.GameEntry.Network:GetServerInfo(lastServerID)
	if self._lastServer~=nil then
		self.ipInput:SetText(self._lastServer.ip)
	    if self._lastServer.port==0 then
			self.portInput:SetText("")
	    else
			self.portInput:SetText(self._lastServer.port)
		end
		self.zoneInput:SetText(self._lastServer.zone)
	else
		self.ipInput:SetText("")
		self.portInput:SetText("")
		self.zoneInput:SetText("")
	end
	self.uidInput:SetText(Setting:GetString(SettingKeys.GAME_UID, ""))
	local serverList = CS.GameEntry.Network.ServerList
	local index=0
	self.setting_content:RemoveComponents(DebugServerItem)
	self._serverCell.gameObject:GameObjectRecycleAll()
	for i=0,serverList.Length-1 do
		local item = self._serverCell:GameObjectSpawn(self._serverCell.transform)
		item.transform:SetParent(self._serverListRoot)
		item.name = serverList[i].name
		item:SetActive(true)
		item.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
		local param={}
		if self._lastServer~=nil and self._lastServer.ip==serverList[i].ip then
			param.isOn=true
		else
			param.isOn=false
		end
		param.Data = serverList[i]
		param.ChooseServer =function()
			self:OnChooseServer(param)
		end
		local cell = self.setting_content:AddComponent(DebugServerItem,item.name,param)
		if self.firstItemData==nil then
		   self.firstItemData = param
		end
	end
end

local function OnShowHistoryAccount(self)
	--UIChooseServerAccountList
	UIManager:GetInstance():OpenWindow(UIWindowNames.UIChooseServerAccountList)
	
end

local function OnChangeClick(self)
	local ip=self.ipInput:GetText()
	local port = self.portInput:GetText()
	local zone = self.zoneInput:GetText()
	local uid = self.uidInput:GetText()
	if ip=="" or port=="" or zone== "" then
	     return
	end
	port = tonumber(port);
	if self._lastServer~=nil then
		Setting:SetInt(SettingKeys.LAST_SERVER_KEY, tonumber(self._lastServer.id));
	end
	Setting:SetString(SettingKeys.GAME_UID, uid);
	Setting:SetString(SettingKeys.SERVER_IP, ip);
	Setting:SetInt(SettingKeys.SERVER_PORT, port);
	Setting:SetString(SettingKeys.SERVER_ZONE, zone);
	
	if CS.GameEntry.Network.IsConnected==false then
		self.ctrl:GoContinue(ip,port,zone,uid)
	else
		if CS.CommonUtils.IsDebug()==false then
			Setting:SetString(SettingKeys.SERVER_IP, ip);
			Setting:SetInt(SettingKeys.SERVER_PORT, port);
			Setting:SetString(SettingKeys.SERVER_ZONE, zone);
		end
		CS.ApplicationLaunch.Instance:ReloadGame()
	end
end

local function OnContinueClick(self)
	self:OnChangeClick()
	--if self._lastServer==nil then
		--self.ctrl:CloseSelf()
		--return
	--end
	--if CS.GameEntry.Network.IsConnected==false then
		--self.ctrl:GoContinue(self.ipInput:GetText(),self.portInput:GetText(),self.zoneInput:GetText(),self.uidInput:GetText())
	--end
end

local function OnNewServerClick(self)
	if self.firstItemData==nil then
		return
	end
	self:OnChooseServer(self.firstItemData)
	local ip = self.ipInput:GetText()
	local port = self.portInput:GetText()
	local zone= self.zoneInput:GetText()
	if ip=="" or port=="" or zone=="" then
		return
	end
	port = tonumber(port)
	local uid = ""
	if self._lastServer~=nil then
		Setting:SetInt(SettingKeys.LAST_SERVER_KEY, tonumber(self._lastServer.id))
	end
	
	Setting:SetString(SettingKeys.GAME_UID, uid)
	Setting:SetInt(SettingKeys.SERVER_PORT, port)
	Setting:SetInt(SettingKeys.SERVER_IP, ip)
	Setting:SetString(SettingKeys.SERVER_ZONE, zone)
	
	if CS.GameEntry.Network.IsConnected==false then
		self.ctrl:GoContinue(ip,port,zone,uid)
	else
		if CS.CommonUtils.IsDebug()==false then
		   Setting:SetString(SettingKeys.SERVER_IP, ip);
		   Setting:SetInt(SettingKeys.SERVER_PORT, port);
		   Setting:SetString(SettingKeys.SERVER_ZONE, zone);
			CS.ApplicationLaunch.Instance:ReloadGame()
		end
	end
end

local function OnChooseServer(self,param)
	self.ipInput:SetText(param.Data.ip)
	self.portInput:SetText(param.Data.port)
	self.zoneInput:SetText(param.Data.zone)
	self._lastServer=param.Data
end

local function OnDestroy(self)
	base.OnDestroy(self)
	self.continueBtn = nil
	--self.changeBtn =nil
	self.newServerBtn = nil
	self.historyAccountBtn = nil
	self.ipInput = nil
	self.portInput= nil
	self.zoneInput= nil
	self.uidInput= nil
	self.firstItemData=nil
	self._lastServer=nil
end

local function OnEnable(self)
	base.OnEnable(self)
end

local function OnDisable(self)
	base.OnDisable(self)
end

local function OnGetHistoryAccountData(self,param)
	local accountInfo = param.Data
	if accountInfo==nil then
		return
	end
	self.ipInput:SetText(accountInfo.ip)
	self.portInput:SetText(accountInfo.port)
	self.zoneInput:SetText(accountInfo.zone)
	self.uidInput:SetText(accountInfo.gameUid)
	if self._lastServer~=nil then
		self._lastServer.id = accountInfo.serverid
	end
	Setting:SetInt(SettingKeys.LAST_SERVER_KEY, accountInfo.serverid)
end

local function OnAddListener(self)
	base.OnAddListener(self)
	self:AddUIListener(EventId.LF_Account_History, self.OnGetHistoryAccountData)
end

local function OnRemoveListener(self)
	base.OnAddListener(self)
	self:RemoveUIListener(EventId.LF_Account_History, self.OnGetHistoryAccountData)
end

UIDebugChooseServerView.OnCreate = OnCreate
UIDebugChooseServerView.OnDestroy = OnDestroy
UIDebugChooseServerView.OnEnable = OnEnable
UIDebugChooseServerView.OnDisable = OnDisable
UIDebugChooseServerView.InitView=InitView
UIDebugChooseServerView.ChooseServer=ChooseServer
UIDebugChooseServerView.OnChooseServer=OnChooseServer
UIDebugChooseServerView.OnNewServerClick=OnNewServerClick
UIDebugChooseServerView.OnContinueClick=OnContinueClick
UIDebugChooseServerView.OnChangeClick=OnChangeClick
UIDebugChooseServerView.OnShowHistoryAccount=OnShowHistoryAccount
UIDebugChooseServerView.OnAddListener=OnAddListener
UIDebugChooseServerView.OnRemoveListener=OnRemoveListener
UIDebugChooseServerView.OnGetHistoryAccountData=OnGetHistoryAccountData
return UIDebugChooseServerView