---
--- 账号
--- Created by shimin.
--- DateTime: 2020/10/13 14:21
---
local AccountManager = BaseClass("AccountManager")
local Setting = CS.GameEntry.Setting
local Localization = CS.GameEntry.Localization
local RolesInfo = require "DataCenter.AccountData.RolesInfo"
--本地缓存登录过的账号
local function __init(self)
	self.allAccount = {}
	self.param = {}
	self.bindReward = {}	--绑定账号奖励
	--self:InitData()
	self.rolesList = {}        --自己所有的角色
	self.serverList = {}
	self.checkServerList = {}
	self.maxServerId = 0
end

local function __delete(self)
	self.allAccount = nil
	self.param = nil
	self.bindReward = nil
	self.rolesList = nil
	self.serverList = nil
end

--初始化所有账号信息
local function InitData(self, message)
	local user = message["user"]
	self:InitAccountList()
	self:InitAccountBind(user)
	SFSNetwork.SendMessage(MsgDefines.GetBindMailReward)
end

local function InitAccountBind(self, user)
	Setting:SetString(SettingKeys.GP_USERID, "")
	Setting:SetString(SettingKeys.FB_USERID, "")
	Setting:SetString(SettingKeys.GAME_ACCOUNT, "")

	if user == nil then
		return
	end
	Setting:SetPrivateInt(SettingKeys.ACCOUNT_STATUS, user["az_account_status"])

	if user["email"] then
		Setting:SetString(SettingKeys.GAME_ACCOUNT, user["email"])

		if user["bindFlag"] then
			Setting:SetString(SettingKeys.GAME_ACCOUNT, user["email"])
			if self.param.pwd ~= "" and self.param.pwd ~= nil then
				Setting:SetString(SettingKeys.GAME_PWD, self.param.pwd) --设置当前账户密码
			end

			self:AddSelfAccount()
		else
			Setting:SetString(SettingKeys.GAME_ACCOUNT, "")
			Setting:SetString(SettingKeys.GAME_PWD, "")
			Setting:SetPrivateInt(SettingKeys.ACCOUNT_STATUS, AccountBandState.UnBand)
		end

	end

	if user["googlePlay"] ~= nil then
		Setting:SetString(SettingKeys.GP_USERID, user["googlePlay"])

	end
	if user["faceBook"] ~= nil then
		Setting:SetString(SettingKeys.FB_USERID, user["faceBook"])

	end
end


local function InitAccountList(self)
	self.allAccount = {}
	local strAccount = Setting:GetString(SettingKeys.ACCOUNT_LIST, "")
	if strAccount ~= nil and strAccount ~= "" then
		local list = string.split(strAccount,"|")
		if list ~= nil then
			for _, v in ipairs(list) do
				local one = AccountInfo.New()
				local ret = one:ParseFromString(v)
				if ret then
					self.allAccount[one.account] = one
				end
			end
		end
	end
end

--添加账号
local function AddAccount(self,accountInfo)
	if accountInfo == nil then
		return
	end

	local one = self:GetAccount(accountInfo.account)
	if not accountInfo:IsEqual(one) then
		self.allAccount[accountInfo.account] = accountInfo
		self:WriteCache()
	end
end

local function GetAccount(self,account)
	return self.allAccount[account]
end

--写入账号
local function WriteCache(self)
	local strAccount = ""
	for _,v in pairs(self.allAccount) do
		if v.account ~= nil then
			if strAccount ~= "" then
				strAccount = strAccount .. "|"
			end

			strAccount = strAccount .. v:ToString()
		end
	end
	Setting:SetString(SettingKeys.ACCOUNT_LIST, strAccount)
end


--移除账号
local function RemoveAccount(self,account)
	if self.allAccount[account] ~= nil then
		self.allAccount[account] = nil
		self:WriteCache()
	end
end

local function AccountBindHandle(self,message)

	if message["errorCode"] == nil then
		Setting:SetString(SettingKeys.GAME_ACCOUNT, self.param.userName)
		local one = AccountInfo.New()
		one.account = self.param.userName
		one.name = LuaEntry.Player.name
		one.server = LuaEntry.Player:GetSelfServerId()
		one.pic = LuaEntry.Player.pic
		--one.password = self.param.pwd
		one.uid = LuaEntry.Player:GetUid()
		one.picVer = LuaEntry.Player.picVer

		self:AddAccount(one)

		if self.param.pwd ~= nil and self.param.pwd ~= "" then
			Setting:SetString(SettingKeys.GAME_PWD, self.param.pwd)
		end

		--记录账号验证状态
		Setting:SetPrivateInt(SettingKeys.ACCOUNT_STATUS, AccountBandState.UnCheck)
		EventManager:GetInstance():Broadcast(EventId.AccountBindEvent)
		UIManager:GetInstance():OpenWindow(UIWindowNames.UIAccountVerify,{anim = true,isBlur = true}, self.param.userName,2)
	else
		UIUtil.ShowTips(Localization:GetString(message["errorCode"]))
		if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UICreateAccount,{ anim = true, isBlur = true }) then
			EventManager:GetInstance():Broadcast(EventId.CreateAccountMailFail)
		end
	end
end

local function SetParam(self,param)
	self.param = param
end

local function AccountChangePasswordHandle(self,message)

	if message["errorCode"] == nil then
		Setting:SetString(SettingKeys.GAME_ACCOUNT, self.param.userName)
		local one = AccountInfo.New()
		one.account = self.param.userName
		one.name = LuaEntry.Player.name
		one.server = LuaEntry.Player:GetSelfServerId()
		one.pic = LuaEntry.Player.pic
		one.password = self.param.pwd
		one.uid = LuaEntry.Player:GetUid()
		one.picVer = LuaEntry.Player.picVer

		self:AddAccount(one)

		if self.param.pwd ~= nil and self.param.pwd ~= "" then
			Setting:SetString(SettingKeys.GAME_PWD, self.param.pwd)
		end

		--记录账号验证状态
		Setting:SetPrivateInt(SettingKeys.ACCOUNT_STATUS, AccountBandState.UnBand)
		--EventManager:GetInstance():Broadcast(EventId.AccountChangePwdEvent)
		--UIManager:GetInstance():OpenWindow(UIWindowNames.UIModifySuccess)
	else
		UIUtil.ShowTips(Localization:GetString(message["errorCode"]))
	end
end

--获取所有的账号列表
local function GetAllAccount(self)
	return self.allAccount
end

local function AccountLoginHandle(self,message)
	local errorCode = message['errorCode']

	if errorCode ~= nil then
		if errorCode == "E100200" then
			local userName = ""
			local userServerId = ""
			local reason = ""
			local bantime = 0
			if message["gameUserName"] ~= nil then
				userName = message["gameUserName"]
			end
			if message["serverId"] ~= nil then
				userServerId = message["serverId"]
			end
			if message["banMsgId"] ~= nil then
				reason = message["banMsgId"]
			end
			if message["banTime"] ~= nil then
				bantime = message["banTime"]
			end
			--todo 打开账号禁止页面
		elseif errorCode == "280048" then
			if self.param.mail ~= nil then
				UIUtil.ShowTips(Localization:GetString("280048",self.param.mail))
			else
				UIUtil.ShowTips(Localization:GetString("280048",""))
			end
		else
			UIUtil.ShowTipsId(errorCode)
		end

		return
	end


	local gameUid = message["gameUid"]
	if gameUid == nil or gameUid == '' then
		local status = message["status"]
		if status == nil then
			UIUtil.ShowMessage(Localization:GetString("280061"))
		else
			if status == 1 then
				UIUtil.ShowTipsId(280112)
				EventManager:GetInstance():Broadcast(EventId.AccountBindOKEvent)
			elseif status == 2 then
				UIUtil.ShowTipsId(280081)
				EventManager:GetInstance():Broadcast(EventId.AccountBindOKEvent)
			end
		end

		return
	end

	--UIManager:GetInstance():OpenWindow(UIWindowNames.UILoginConfirm, { anim = true }, message)
	if  message["accountArr"] then
		local accountArr = message["accountArr"]
		self.rolesList = {}
		for i = 1 ,#accountArr do
			local rolesInfo = RolesInfo.New()
			rolesInfo:Parse(accountArr[i])
			table.insert(self.rolesList,rolesInfo)
		end
		if message["type"]~=nil then
			local type = message["type"]
			if type ==0 then
				UIManager:GetInstance():OpenWindow(UIWindowNames.UIRoles,{ anim = true},1)
			else
				EventManager:GetInstance():Broadcast(EventId.RolesRefresh)
			end

		end
	else
		UIManager:GetInstance():OpenWindow(UIWindowNames.UILoginConfirm, { anim = true }, message)
	end
end

local function GetRolesList(self)
	return self.rolesList
end

local function ChangeAccountSecondOKCallback(self,message)
	local uid = message["gameUid"]
	Setting:SetString(SettingKeys.GAME_UID, uid)
	Setting:SetString(SettingKeys.GAME_ACCOUNT, self.param.userName)
	--Setting:SetString(SettingKeys.GAME_PWD, self.param.pwd)
	Setting:SetPrivateInt(SettingKeys.ACCOUNT_STATUS, AccountBandState.Band)
	Setting:SetString(SettingKeys.SERVER_IP, message["ip"])
	Setting:SetInt(SettingKeys.SERVER_PORT, message["port"])
	Setting:SetString(SettingKeys.SERVER_ZONE, message["zone"])
	--发送UserCleanPostMessage消息
	SFSNetwork.SendMessage(MsgDefines.UserCleanPost)
end

local function AccountChangeMailHandle(self,message)
	if message["errorCode"] == nil then
		Setting:SetString(SettingKeys.GAME_ACCOUNT, self.param.newEmail)
		local one = AccountInfo.New()
		one.account = self.param.newEmail
		one.name = LuaEntry.Player.name
		one.server = LuaEntry.Player:GetSelfServerId()
		one.pic = LuaEntry.Player.pic
		one.password = self.param.pwd
		one.uid = LuaEntry.Player:GetUid()
		one.picVer = LuaEntry.Player.picVer

		self:AddAccount(one)

		if self.param.pwd ~= nil and self.param.pwd ~= "" then
			Setting:SetString(SettingKeys.GAME_PWD, self.param.pwd)
		end

		--记录账号验证状态
		Setting:SetPrivateInt(SettingKeys.ACCOUNT_STATUS, AccountBandState.UnBand)
		EventManager:GetInstance():Broadcast(EventId.AccountChangeMailEvent)
		--UIManager:GetInstance():OpenWindow(UIWindowNames.UIBindSendMail,self.param.newEmail)
	else
		UIUtil.ShowTips(Localization:GetString(message["errorCode"]))
	end
end

local function PushAccountChangePwdHandle(self,message)
	Setting:SetPrivateInt(SettingKeys.ACCOUNT_STATUS, AccountBandState.UnCheck)
	EventManager:GetInstance():Broadcast(EventId.AccountBindOKEvent)

	--UIManager:GetInstance():OpenWindow(UIWindowNames.UIBindSuccess, BindSuccessType.ChangePassword, false)
end

local function PushAccountFirmedHandle(self,message)
	Setting:SetPrivateInt(SettingKeys.ACCOUNT_STATUS, AccountBandState.Band)
	EventManager:GetInstance():Broadcast(EventId.AccountBindOKEvent)
	UIManager:GetInstance():DestroyWindow(UIWindowNames.UIAccountVerify)
	UIManager:GetInstance():OpenWindow(UIWindowNames.UIBindSuccess, BindSuccessType.BindAccount, message["reward"] ~= nil)
end

local function AddSelfAccount(self)
	--当前账号-加入缓存
	local Player = LuaEntry.Player
	if Player ~= nil then
		local account = Setting:GetString(SettingKeys.GAME_ACCOUNT, "")
		local pwd = Setting:GetString(SettingKeys.GAME_PWD, "")
		if account ~= "" and pwd ~= "" then
			local one = AccountInfo.New()
			one.account = account
			one.name = Player.name
			one.server = Player:GetSelfServerId()
			one.pic = Player.pic
			one.password = pwd
			one.uid = LuaEntry.Player:GetUid()
			one.picVer = LuaEntry.Player.picVer

			self:AddAccount(one)
		end
	end
end

local function GetAccountBindState(self)
	local account = Setting:GetString(SettingKeys.GAME_ACCOUNT, "")
	if account ~= nil and account ~= "" then
		--账号验证状态
		local status = Setting:GetPrivateInt(SettingKeys.ACCOUNT_STATUS, 0)
		return status

		--if status == AccountCheckState.Check then
		--	--已验证、即已绑定
		--	return AccountBandState.Band
		--else
		--	--未验证
		--	return AccountBandState.UnCheck
		--end
	else
		return AccountBandState.UnBand
	end
end

local function OnHandleNewGame(self)
	local state = self:GetAccountBindState()

	if state == AccountBandState.Band then
		UIUtil.ShowMessage(Localization:GetString("280095"), 1, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
			SFSNetwork.SendMessage(MsgDefines.NewAccount, {confirm = 2})
		end)

		return
	end

	local k1 = LuaEntry.DataConfig:TryGetNum("newgame_base", "k1")
	local currentMainLv = DataCenter.BuildManager.MainLv

	if currentMainLv >= k1 then
		UIUtil.ShowMessage(Localization:GetString('280097'), 1, GameDialogDefine.GOTO,"",function()
			local isArrow = true
			UIManager:GetInstance():DestroyWindow(UIWindowNames.UISetting)
			UIManager:GetInstance():OpenWindow(UIWindowNames.UISettingAccount,{ anim = true,isBlur = true },isArrow)
		end,false,false,"")
		return
	end

	UIUtil.ShowMessage(Localization:GetString("280096"), 1, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
		SFSNetwork.SendMessage(MsgDefines.NewAccount,{ confirm = 2})
	end)
end

--忘记密码 向邮箱发送验证码
local function AccountForgetPasswordHandle(self,message)
	if message["errorCode"] ~= nil then
		--邮箱不存在
		UIUtil.ShowTipsId(208207)
		return
	end
	EventManager:GetInstance():Broadcast(EventId.AccountCheckSuccess)
end

local function SaveBindAccountReward(self,message)
	if next(message["reward"]) then
		self.bindReward = message["reward"]
	end
end

local function GetBindAccountReward(self)
	return self.bindReward
end

local function AccountGetAllServerHandle(self,message)
	if message["type"]~=nil then
		local type = message["type"]
		if message["servers"] then
			local tempList = message["servers"]
			local list = {}

			for k, v in pairs(tempList) do
				if v.id ~= 11 then
					table.insert(list,v)
				end
			end
			table.sort(list,function(a,b)
				if a.id < b.id then
					return true
				end
				return false
			end)
			if type == 0 then
				if self.maxServerId<=0 then
					self.serverList ={}
					self.maxServerId = message["maxServerId"]
					local num = LuaEntry.DataConfig:TryGetNum("server_population", "k3")
					local count = math.ceil((self.maxServerId)/num)
					for i=1 ,count do
						local param = {}
						param.minNum = 1+(i-1)*num
						param.maxNum = math.min(i*num,self.maxServerId)
						param.serverList = {}
						param.serverIndex = i-1
						self.serverList[i-1] = param
					end
				end
				if self.serverList[-1] == nil then
					local param = {}
					param.minNum = 0
					param.maxNum = 0
					param.serverList = list
					param.serverIndex = -1
					self.serverList[-1] = param
				else
					self.serverList[-1].serverList = list
				end
			else
				local page = message["page"]
				if page~=nil then
					if self.serverList[page]~=nil then
						self.serverList[page].serverList = list
					end
				end
			end
			EventManager:GetInstance():Broadcast(EventId.ServerListRefresh)
		end
		if type ==2 then
			self.checkServerList = {}
			if message["serverInfoArr"] then
				local arr = message["serverInfoArr"]
				for k,v in pairs(arr) do
					local serverId = v["id"]
					local season = v["season"]
					local settleTime = v["settleTime"]
					local serverType = v["serverType"]
					local data = {}
					data.serverId = serverId
					data.season = season
					data.settleTime = settleTime
					data.serverType = serverType
					if serverId~=nil and serverId>0 then
						self.checkServerList[serverId] = data
					end
				end
			end
		end
		
	end
end

local function GetCheckServerList(self)
	local tempList = {}
	for k,v in pairs(self.checkServerList) do
		if v.serverType == ServerType.NORMAL then
			table.insert(tempList,v.serverId)
		end
	end
	table.sort(tempList,function(a,b)
		return a>b
	end)
	return tempList
end

local function CheckIsInServerList(self,serverId)
	if self.checkServerList[serverId]~=nil then
		local serverData = self.checkServerList[serverId]
		if serverData.serverType == ServerType.NORMAL or serverData.serverType == ServerType.EDEN_SERVER then
			return true
		end
		return false
	else
		return false
	end
end

local function GetSeasonNumByServerId(self,serverId)
	local season = 0
	if self.checkServerList[serverId]~=nil then
		season = self.checkServerList[serverId].season
	end
	return season
end
local function GetSeasonSettleTimeByServerId(self,serverId)
	local settleTime = 0
	if self.checkServerList[serverId]~=nil then
		settleTime = self.checkServerList[serverId].settleTime
	end
	return settleTime
end
local function GetServerTypeByServerId(self,serverId)
	local type = ServerType.NORMAL
	if self.checkServerList[serverId]~=nil then
		type = self.checkServerList[serverId].serverType
	end
	return type
end
local function GetServerListByIndex(self,index)
	if self.serverList[index]~=nil then
		return self.serverList[index].serverList
	end
	return ""
end

local function GetServerTabData(self)
	local list = {}
	for k,v in pairs(self.serverList) do
		if k>=0 then
			local param = {}
			param.index = k
			param.minNum = v.minNum
			param.maxNum = v.maxNum
			table.insert(list,param)
		end
	end
	table.sort(list,function(a, b)
		return a.index > b.index
	end)
	local firstParam = {}
	firstParam.index = -1
	table.insert(list,1,firstParam)
	return list
end


local function GetMaxServerId(self)
	return self.maxServerId
end

AccountManager.__init = __init
AccountManager.__delete = __delete
AccountManager.InitData = InitData
AccountManager.InitAccountBind = InitAccountBind
AccountManager.InitAccountList = InitAccountList
AccountManager.AddAccount = AddAccount
AccountManager.RemoveAccount = RemoveAccount
AccountManager.GetAccount = GetAccount
AccountManager.WriteCache = WriteCache
AccountManager.SetParam = SetParam
AccountManager.AccountBindHandle = AccountBindHandle
AccountManager.AccountChangePasswordHandle = AccountChangePasswordHandle
AccountManager.GetAllAccount = GetAllAccount
AccountManager.AccountLoginHandle = AccountLoginHandle
AccountManager.ChangeAccountSecondOKCallback = ChangeAccountSecondOKCallback
AccountManager.AccountChangeMailHandle = AccountChangeMailHandle
AccountManager.PushAccountChangePwdHandle = PushAccountChangePwdHandle
AccountManager.PushAccountFirmedHandle = PushAccountFirmedHandle
AccountManager.AddSelfAccount = AddSelfAccount

AccountManager.GetAccountBindState = GetAccountBindState
AccountManager.OnHandleNewGame = OnHandleNewGame

AccountManager.AccountForgetPasswordHandle = AccountForgetPasswordHandle
AccountManager.SaveBindAccountReward = SaveBindAccountReward
AccountManager.GetBindAccountReward = GetBindAccountReward

AccountManager.GetRolesList = GetRolesList
AccountManager.AccountGetAllServerHandle = AccountGetAllServerHandle
AccountManager.GetServerListByIndex = GetServerListByIndex
AccountManager.GetServerTabData = GetServerTabData
AccountManager.GetMaxServerId = GetMaxServerId
AccountManager.GetCheckServerList = GetCheckServerList
AccountManager.CheckIsInServerList = CheckIsInServerList
AccountManager.GetSeasonNumByServerId =GetSeasonNumByServerId
AccountManager.GetSeasonSettleTimeByServerId = GetSeasonSettleTimeByServerId
AccountManager.GetServerTypeByServerId =GetServerTypeByServerId
return AccountManager