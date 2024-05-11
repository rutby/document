local ItemInfo = BaseClass("ItemInfo")

local function __init(self)
	self.itemId = ""
	self.use = ""
	self.count = 0
	self.para1 = ""
	self.para2 = ""
	self.para3 = ""
	self.para4 = ""
	self.uuid = ""
	self.cbitem = ""
	self.cbpart = ""
	self.cbnum = ""
	self.rightseffect = ""
	--
	self.redState = true--红点状态（false为显示红点）客户端状态
end

local function __delete(self)
	self.itemId = nil
	self.use = nil
	self.count = nil
	self.para1 = nil
	self.para2 = nil
	self.para3 = nil
	self.para4 = nil
	self.uuid = nil
	self.cbitem = nil
	self.cbpart = nil
	self.cbnum = nil
	self.rightseffect = nil
	self.redState = true--红点状态（false为显示红点）客户端状态
end

local function UpdateInfo(self, message)
	if message == nil then
		return
	end

	if message["itemId"] ~= nil then
		self.itemId =  message["itemId"]
	end
	if message["goodsId"] ~= nil then
		self.itemId =  message["goodsId"]
	end
	if message["use"] ~= nil then
		self.use =  message["use"]
	end
	if message["count"] ~= nil then
		self.count =  message["count"]
	end
	if message["addNum"] ~= nil then
		self.count = self.count + message["addNum"]
	end
	if message["num"] ~= nil then
		self.count = message["num"]
	end
	if message["itemLeftCnt"] ~= nil then
		self.count = message["itemLeftCnt"]
	end
	if message["para1"] ~= nil then
		self.para1 = message["para1"]
	end
	if message["para2"] ~= nil then
		self.para2 = message["para2"]
	end
	if message["para3"]~= nil then
		self.para3 = message["para3"]
	end
	if message["para4"] ~= nil then
		self.para4 = message["para4"]
	end
	if message["uuid"]~=nil then
		self.uuid = message["uuid"]
	end
	if message["cbitem"] ~= nil then
		self.cbitem = message["cbitem"]
	end
	if message["cbnum"] ~= nil then
		self.cbnum = message["cbnum"]
	end
	if message["cbpart"] ~= nil then
		self.cbpart = message["cbpart"]
	end
	if message["rightseffect"] ~= nil then
		self.rightseffect = message["rightseffect"]
	end
end

local function GetComposeInfo(self,vec1,vec2,vec3)

	local para1 = nil
	local para2 = nil
	local para3 = nil

	if haveEff and LuaEntry.DataConfig:CheckSwitch("combination") and self.cbitem ~= nil and self.cbitem ~= ""
			and self.cbnum ~= nil and self.cbnum ~= "" and self.cbpart ~= nil and self.cbpart ~= "" then
		para1 = string.split(self.cbitem,"\\")
		para2 = string.split(self.cbpart,"\\")
		para3 = string.split(self.cbnum,"\\")
	else
		local template = DataCenter.ItemTemplateManager:GetItemTemplate(self.itemId)
		if template ~= nil then
			if template.type == GOODS_TYPE.GOODS_TYPE_23 then
				para1 = string.split(self.para3,"\\")--目标item
				para2 = string.split(self.itemId,"\\")--材料item
				para3 = string.split(self.para4,"\\")--个数
			else
				para1 = string.split(self.para1,"\\")
				para2 = string.split(self.para2,"\\")
				para3 = string.split(self.para2,"\\")
			end
		end
	end
	if 0 >= #para1 or #para1 ~= #para2 or #para2 ~= #para3 then
		return false
	end

	for i = 1,#para1 do
		local temp2 = string.split(para2[i],";")
		local temp3 = string.split(para3[i],";")
		if #temp2 > 0 and #temp2 == #para3 then
			for j=1,#temp2 do
				table.insert(vec1,para1[i])
				table.insert(vec2,temp2[j])
				table.insert(vec3,temp3[j])
			end
		end
	end
	
	return true
end

ItemInfo.__init = __init
ItemInfo.__delete = __delete
ItemInfo.UpdateInfo = UpdateInfo
ItemInfo.GetComposeInfo = GetComposeInfo



return ItemInfo