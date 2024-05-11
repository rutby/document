local CityManageData = BaseClass("CityManageData")

local function __init(self)
	self.id    = 0 		
	self.name1 = 0 		--大标题
	self.name2 = 0		--小标题
	self.des   = 0		--描述
	self.icon  = ""      --icon
	self.type  = 0       --goods表筛选条件1
	self.type2 = 0       --goods表筛选条件2
	self.group = 0       --是否在同组
	self.status = nil
	self.formStatus = nil
end

local function __delete(self)
	self.id    = nil
	self.name1 = nil
	self.name2 = nil		--小标题
	self.des   = nil		--描述
	self.icon  = nil       --icon
	self.type  = nil       --goods表筛选条件1
	self.type2 = nil      --goods表筛选条件2
	self.group = nil      --是否在同组
	self.status = nil
	self.formStatus = nil
end

local function InitData(self,row)
	if row == nil then
		return
	end
	self.id = row:getValue("id")
	self.name1 = row:getValue("name1")
	self.name2 = row:getValue("name2")
	self.des = row:getValue("desc")
	self.icon = row:getValue("icon")
	self.type = row:getValue("type")
	self.type2 = row:getValue("type2")
	self.group = row:getValue("group")
	self.status = row:getValue("status")
	self.formStatus = row:getValue("formation_status")
end



CityManageData.__init = __init
CityManageData.__delete = __delete
CityManageData.InitData = InitData

return CityManageData