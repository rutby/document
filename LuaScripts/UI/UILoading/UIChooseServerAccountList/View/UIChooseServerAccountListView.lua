---------------------------------------------------------------------
-- aps (C) CompanyName, All Rights Reserved
-- Created by: AuthorName
-- Date: 2021-07-30 11:36:39
---------------------------------------------------------------------

-- To edit this template in: Data/Config/Template.lua
-- To disable this template, check off menuitem: Options-Enable Template File

---@class UIChooseServerAccountListView
local UIChooseServerAccountListView =BaseClass("UIChooseServerAccountListView", UIBaseView)
local AccountListManager = require "DataCenter.AccountData.AccountListManager"
local AccountServerItem = require "UI.UILoading.UIChooseServerAccountList.Controller.UIChooseServertAccountItem"

local base = UIBaseView
local traContentChapterPath = "Root/ScrollView/Viewport/Content"
local accountItemPath = "UIChooseServertAccountItem"
local closeBtnPath = "Root/ButtonClose"
local search_path = "Root/Head/Search"

local function OnCreate(self)
	base.OnCreate(self)
	self.traContentChapter = self:AddComponent(UIBaseContainer,traContentChapterPath)
	self.accountItem = self.transform:Find(accountItemPath).gameObject
	self.accountItem:GameObjectCreatePool();
	self.closeBtnPath = self:AddComponent(UIButton,closeBtnPath)
	self.closeBtnPath:SetOnClick(function ()
			self.ctrl:CloseSelf()
		end)
	
	self.search_input = self:AddComponent(UIInput, search_path)
	self.search_input:SetOnValueChange(function() self:OnSearch() end)
	self.searchText = ""
end

local function InitView(self)
	--CS.AccountListManager.Instance():LoadAcountInfos();
	--local accountList = CS.AccountListManager.Instance():GetAcountInfos()
	self.traContentChapter:RemoveComponents(AccountServerItem)
	DataCenter.AccountListManager:LoadAcountInfos()
	local accountList = DataCenter.AccountListManager:GetAccountInfos()
	
	if not string.IsNullOrEmpty(self.searchText) then
		local list = {}
		for _, account in ipairs(accountList) do
			if "s" .. account.serverid == string.lower(self.searchText) or
			   string.contains(string.lower(tostring(account.nickname)), string.lower(self.searchText)) or
			   string.contains(string.lower(tostring(account.gameUid)), string.lower(self.searchText)) or
			   "lv" .. account.newLevel == string.lower(self.searchText)
			then
				table.insert(list, account)
			end
		end
		accountList = list
	end
	
	print("accountList count=".. #accountList)
	self.accountItem.gameObject:GameObjectRecycleAll()
	for i=#accountList,1,-1 do
		local accountInfo = accountList[i]
		if accountInfo.ip==nil or accountInfo.ip=="" then
			local serverInfo = CS.GameEntry.Network:GetServerInfo(accountInfo.serverid);
			if serverInfo~=nil then
				accountInfo.ip = serverInfo.ip
				accountInfo.port = serverInfo.port
				accountInfo.zone = serverInfo.zone
			end	
		end
		local item = self.accountItem:GameObjectSpawn(self.traContentChapter.transform)
		local param ={}
		param.Data = accountList[i]
		local nameStr ="item:"..tostring(i)
		item.name = nameStr
		local cell = self.traContentChapter:AddComponent(AccountServerItem,nameStr,param)
	end
end

local function OnDestroy(self)
	for _, v in ipairs(self.traContentChapter.transform) do
		CS.UnityEngine.GameObject.Destroy(v.gameObject)
	end
	self.traContentChapter = nil
	self.accountItem = nil
	self.closeBtnPath = nil
	self.search_input = nil
	self.searchText = nil
	base.OnDestroy(self)
end

local function OnEnable(self)
	base.OnEnable(self)
	self:InitView()
end

local function OnDisable(self)
	base.OnDisable(self)
end
local function OnClose(self)
	self.ctrl:CloseSelf()
end
local function OnAccountRefresh(self)
	self:InitView()
end

local function OnAddListener(self)
	base.OnAddListener(self)
	self:AddUIListener(EventId.LF_AccountListView_Close, self.OnClose)
	self:AddUIListener(EventId.LF_AccountListView_Refresh, self.OnAccountRefresh)
	
end

local function OnRemoveListener(self)
	base.OnRemoveListener(self)
	self:RemoveUIListener(EventId.LF_AccountListView_Close,self.OnClose)
	self:RemoveUIListener(EventId.LF_AccountListView_Refresh, self.OnAccountRefresh)
end

local function OnSearch(self)
	self.searchText = self.search_input:GetText()
	self:InitView()
end

UIChooseServerAccountListView.OnAddListener=OnAddListener
UIChooseServerAccountListView.OnRemoveListener=OnRemoveListener
UIChooseServerAccountListView.InitView = InitView
UIChooseServerAccountListView.OnCreate = OnCreate
UIChooseServerAccountListView.OnDestroy = OnDestroy
UIChooseServerAccountListView.OnEnable = OnEnable
UIChooseServerAccountListView.OnDisable = OnDisable
UIChooseServerAccountListView.OnClose = OnClose
UIChooseServerAccountListView.OnAccountRefresh=OnAccountRefresh
UIChooseServerAccountListView.OnSearch = OnSearch

return UIChooseServerAccountListView