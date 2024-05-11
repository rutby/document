--[[
	游戏的全局配置
	因为这个配置其实不是和账号绑定的
]]
local rapidjson = require "rapidjson"
local util = require "Common.Tools.cjson.util"
local DataConfig = BaseClass("DataConfig")

function DataConfig:__init()
	self.dataConfig = {}
	self.functionOnConfig = {}
	self.itemMd5 = ""
end

function DataConfig:InitFromTable()
	local path = util.GetPersistentDataPath()
	local name = path.."/".."data_config.txt"
	local jsonStr = util.file_load(name)
	if jsonStr~=nil then
		local message = rapidjson.decode(jsonStr)
		if message~=nil then
			self.dataConfig = message["dataConfig"]
			self.functionOnConfig = message["function_on_config"]
			if self.dataConfig~=nil then
				if self.dataConfig["monster_interval"]~=nil then
					local str = self.dataConfig["monster_interval"]
					local strArr = string.split(str,";")
					if #strArr == 2 then
						CS.GameEntry.GlobalData:SetGlobalValue("staminaIntervalTime", strArr[2])
						CS.GameEntry.GlobalData:SetGlobalValue("staminaIntervalNum", strArr[1])
					end
				end
				if self.dataConfig["itemMd5"]~=nil then
					self.itemMd5 = self.dataConfig["itemMd5"]
				end
			end
		end
	end
end

function DataConfig:GetMd5()
	return self.itemMd5
end
function DataConfig:ClearMd5()
	self.itemMd5 = ""
	local path = util.GetPersistentDataPath()
	local name = path.."/".."data_config.txt"
	local jsonStr = ""
	util.file_save(name,jsonStr)
end
function DataConfig:InitFromNet(msg)
	if msg["dataConfig"]~=nil then
		self.dataConfig = msg["dataConfig"]
		if self.dataConfig["monster_interval"]~=nil then
			local str = self.dataConfig["monster_interval"]
			local strArr = string.split(str,";")
			if #strArr == 2 then
				CS.GameEntry.GlobalData:SetGlobalValue("staminaIntervalTime", strArr[2])
				CS.GameEntry.GlobalData:SetGlobalValue("staminaIntervalNum", strArr[1])
			end
		end
		if self.dataConfig["itemMd5"]~=nil then
			self.itemMd5 = self.dataConfig["itemMd5"]
		end
		if msg["function_on_config"]~=nil then
			self.functionOnConfig = msg["function_on_config"]
		end
		local path = util.GetPersistentDataPath()
		local name = path.."/".."data_config.txt"
		local data = {}
		data["dataConfig"] = self.dataConfig
		data["function_on_config"] = self.functionOnConfig
		local jsonStr = rapidjson.encode(data)
		util.file_save(name,jsonStr)
	end
end

function DataConfig:CheckSwitch(key)
	local isSwitch =false
	if self.functionOnConfig~=nil and self.functionOnConfig[key]~=nil then
		local num = tonumber(self.functionOnConfig[key])
		if num == 1 then
			isSwitch = true
		end
	end
	return isSwitch
end
function DataConfig:GetObj(key1)
	if self.dataConfig~=nil and self.dataConfig[key1]~=nil then
		return self.dataConfig[key1]
	end
end
function DataConfig:GetValue(key1,key2)
	local obj = self:GetObj(key1)
	if obj~=nil and obj[key2]~=nil then
		return obj[key2]
	end
end
function DataConfig:TryGetStr(key1,key2)
	local value = self:GetValue(key1,key2)
	if value~=nil then
		return tostring(value)
	else
		return ""
	end
end
function DataConfig:TryGetNum(key1,key2)
	local value = self:GetValue(key1,key2)
	if value~=nil then
		return tonumber(value)
	else
		return 0
	end
end

return DataConfig
