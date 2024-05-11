--[[
	* 这是debug的账号管理类
	* 目的:管理账号信息
	* 1、添加账号到缓存并且存储到本地，存储数量有上限
	* 2、删除账号，删除缓存和本地数据
	* 3、查询账号
	*
]]

local AccountListManager = BaseClass("AccountListManager")
local AccountInfo = require "DataCenter.AccountData.AccountInfo"

local MaxLimit = 50
local Sdk = CS.GameEntry.Sdk
local Setting = CS.GameEntry.Setting

function AccountListManager:__init()
	self.m_accountInfos = nil
	self:LoadAcountInfos()
end

--加载账号信息
function AccountListManager:LoadAcountInfos()
	
	local accountCache = Sdk:GetDataFromNative("PM_getDatFromFile", "account.txt")
	local historyAccount = ""
	if (not string.IsNullOrEmpty(accountCache)) then
		historyAccount = accountCache
	else
		historyAccount = Setting:GetString(SettingKeys.ACCOUNT_LIST_DEBUG, "")
	end

	self.m_accountInfos = {}
	local accList = string.string2array_s(historyAccount, "|", "#")
	for k,v in ipairs(accList) do
		if table.IsNullOrEmpty(v) then
			goto continue
		end
		
		if #v < 4 then
			goto continue
		end
		
		local accountInfo = AccountInfo.New()
		accountInfo.serverid = toInt(v[1])
		accountInfo.gameUid = v[2];
		accountInfo.nickname = v[3];
		accountInfo.level = toInt(v[4])

		if #v >= 5 then
			accountInfo.newLevel = toInt(v[5])
		end
		if #v == 8 then
			accountInfo.ip = v[6]
			accountInfo.port = toInt(v[7])
			accountInfo.zone = v[8]
		end
		if #v >= 9 then
			accountInfo.time = v[9]
		end

		table.insert(self.m_accountInfos, accountInfo)
		::continue::
	end

end

		
function AccountListManager:AddAcountInfo(accountInfo)
		
	local queryIndex = self:GetAcountInfoIndexByUid(accountInfo.serverid,accountInfo.gameUid)
	-- 有的话先删除
	if (queryIndex ~= -1) then
		table.remove(self.m_accountInfos, queryIndex)
	end
		
	table.insert(self.m_accountInfos, accountInfo)
	self:Save()
end

function AccountListManager:DeleteAcountInfo(serverId, uid)

	local index = self:GetAcountInfoIndexByUid(serverId,uid)
	if (index == -1) then
		return
	end
	
	table.remove(self.m_accountInfos, index)
	self:Save()
end
			

function AccountListManager:GetAcountInfoIndexByUid(serverId, uid)
	
	local index = -1
	if (string.IsNullOrEmpty(uid)) then
		return index
	end
	
	for k,v in pairs(self.m_accountInfos) do
		if (v.serverid == serverId and v.gameUid == uid) then
			index = k
			break
		end
	end

	return index
end

function AccountListManager:Save()
	local count = #self.m_accountInfos
	local beginIndex = (count > MaxLimit) and (count - MaxLimit) or 0
	beginIndex = beginIndex + 1
	
	local tbl = {}
	for i = beginIndex, count do
		local acountInfo = self.m_accountInfos[i]
		if not string.IsNullOrEmpty(acountInfo.gameUid) then
			local newStr = string.format("%s|%s|%s|%s|%s|%s|%s|%s|%s", 
				acountInfo.serverid, 
				acountInfo.gameUid, 
				acountInfo.nickname or "", 
				acountInfo.level or 0,
				acountInfo.newLevel or 0, 
				acountInfo.ip, 
				acountInfo.port, 
				acountInfo.zone,
				acountInfo.time)
			
			table.insert(tbl, newStr)
		end
	end
		
	local str = table.concat(tbl, "#")
	Setting:SetString(SettingKeys.ACCOUNT_LIST_DEBUG, str)

	Sdk:saveDataToSdcard(str, "account.txt")
end
			
-- 更新玩家主城等级
function AccountListManager:UpdatePlayerMainLv(serverId, uid, level)
			
	local index = self:GetAcountInfoIndexByUid(serverId, uid)
	if (index == -1) then
		return
	end
					
	self.m_accountInfos[index].newLevel = level
	self:Save()
end

--更新玩家名字
function AccountListManager:UpdatePlayerName(serverId, uid, name)
		
	local index = self:GetAcountInfoIndexByUid(serverId, uid)
	if (index == -1) then
		return
	end
		
	self.m_accountInfos[index].nickname = name
	self:Save()
end

function AccountListManager:GetAccountInfos()
	return self.m_accountInfos
end

				
return AccountListManager

