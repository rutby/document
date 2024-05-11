local UIAllianceScienceDetailCell = BaseClass("UIAllianceScienceDetailCell", UIBaseContainer)
local base = UIBaseContainer

local UIAllianceScienceDetailDesCell = require "UI.UIAlliance.UIAllianceScienceDetail.Component.UIAllianceScienceDetailDesCell"
local line_go_path = "line"

-- 创建
function UIAllianceScienceDetailCell:OnCreate()
	base.OnCreate(self)
	self:ComponentDefine()
	self:DataDefine()
end

-- 销毁
function UIAllianceScienceDetailCell:OnDestroy()
	self:ComponentDestroy()
	self:DataDestroy()
	base.OnDestroy(self)
end

-- 显示
function UIAllianceScienceDetailCell:OnEnable()
	base.OnEnable(self)
end

-- 隐藏
function UIAllianceScienceDetailCell:OnDisable()
	base.OnDisable(self)
end


--控件的定义
function UIAllianceScienceDetailCell:ComponentDefine()
	self.line_go = self:AddComponent(UIBaseContainer, line_go_path)
end

--控件的销毁
function UIAllianceScienceDetailCell:ComponentDestroy()
end

--变量的定义
function UIAllianceScienceDetailCell:DataDefine()
	self.param = {}
	self.cells = {}
end

--变量的销毁
function UIAllianceScienceDetailCell:DataDestroy()
	self.param = {}
	self.cells = {}
end

-- 全部刷新
function UIAllianceScienceDetailCell:ReInit(param)
	self.param = param
	if self.param.showLine then
		self.line_go:SetActive(true)
	else
		self.line_go:SetActive(false)
	end
	self:ShowCells()
end

function UIAllianceScienceDetailCell:ShowCells()
	local count = #self.param.list
	for k, v in ipairs(self.param.list) do
		if self.cells[k] == nil then
			self.cells[k] = v
			v.visible = true
			v.req = self:GameObjectInstantiateAsync(UIAssets.UIScienceDetailDesCell, function(request)
				if request.isError then
					return
				end
				local go = request.gameObject
				go:SetActive(true)
				go.transform:SetParent(self.transform)
				go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
				go.transform:SetAsLastSibling()
				local nameStr = tostring(NameCount)
				go.name = nameStr
				NameCount = NameCount + 1
				local model = self:AddComponent(UIAllianceScienceDetailDesCell, nameStr)
				model:ReInit(self.cells[k])
				self.cells[k].model = model
			end)
		else
			v.req = self.cells[k].req
			v.model = self.cells[k].model
			self.cells[k] = v
			v.visible = true
			if v.model ~= nil then
				v.model:ReInit(v)
			end
		end
	end
	local cellCount = #self.cells
	if cellCount > count then
		for i = count + 1, cellCount, 1 do
			local cell = self.cells[i]
			if cell ~= nil then
				cell.visible = false
				if cell.model ~= nil then
					cell.model:Refresh()
				end
			end
		end
	end
end

function UIAllianceScienceDetailCell:SetSelect(go)
	go:SetActive(true)
	go.transform:SetParent(self.transform)
	go:SetLocalPosition(ResetPosition)
	go:SetLocalScale(ResetScale)
	go.transform:SetAsFirstSibling()
end

return UIAllianceScienceDetailCell