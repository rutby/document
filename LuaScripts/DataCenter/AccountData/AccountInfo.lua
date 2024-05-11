local AccountInfo = BaseClass("AccountInfo")

local function __init(self)
	self.account 	= ""
	self.password 	= ""
	self.server 	= ""
	self.uid 		= ""
	self.name 		= ""
	self.pic 		= ""
	self.picVer 	= ""
end

local function __delete(self)
	self.account 	= nil
	self.password 	= nil
	self.server 	= nil
	self.uid 		= nil
	self.name 		= nil
	self.pic 		= nil
	self.picVer 	= nil
end

local function SetData(self, account, password, server, uid, name, pic, picVer)
	self.account 	= account
	self.password 	= password
	self.server 	= server
	self.uid 		= uid
	self.name 		= name
	self.pic 		= pic
	self.picVer 	= tostring(picVer)
end

local function IsEqual(self, other)
	if other == nil then
		return false
	end
	
	return self.account == other.account and self.password == other.password and self.server == other.server and 
			self.uid == other.uid and self.name == other.name and self.pic == other.pic and self.picVer == other.picVer
end

local function ToString(self)
	return self.account .. ';' .. self.password.. ';' .. self.server .. ';' .. self.uid .. ';' .. self.name .. ';' .. self.pic .. ';' .. self.picVer
end

local function ParseFromString(self, str)
	local spl = string.split(str,";")
	if spl == nil or #spl < 7 then
		return false
	end
	
	self.account  = spl[1]
	self.password = spl[2]
	self.server   = spl[3]
	self.uid 	  = spl[4]
	self.name     = spl[5]
	self.pic      = spl[6]
	self.picVer   = spl[7]
	
	return true
end


AccountInfo.__init = __init
AccountInfo.__delete = __delete
AccountInfo.SetData = SetData
AccountInfo.IsEqual = IsEqual
AccountInfo.ToString = ToString
AccountInfo.ParseFromString = ParseFromString

return AccountInfo