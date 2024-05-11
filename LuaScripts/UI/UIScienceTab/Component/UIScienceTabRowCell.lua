local UIScienceTabRowCell = BaseClass("UIScienceTabRowCell", UIBaseContainer)
local base = UIBaseContainer
local UIScienceTabCell = require "UI.UIScienceTab.Component.UIScienceTabCell"

-- 创建
function UIScienceTabRowCell:OnCreate()
	base.OnCreate(self)
	self:ComponentDefine()
	self:DataDefine()
end

-- 销毁
function UIScienceTabRowCell:OnDestroy()
	self:ComponentDestroy()
	self:DataDestroy()
	base.OnDestroy(self)
end

-- 显示
function UIScienceTabRowCell:OnEnable()
	base.OnEnable(self)
end

-- 隐藏
function UIScienceTabRowCell:OnDisable()
	base.OnDisable(self)
end


--控件的定义
function UIScienceTabRowCell:ComponentDefine()
end

--控件的销毁
function UIScienceTabRowCell:ComponentDestroy()
end

--变量的定义
function UIScienceTabRowCell:DataDefine()
	self.param = {}
	self.cells = {}
end

--变量的销毁
function UIScienceTabRowCell:DataDestroy()
	self.param = {}
	self.cells = {}
end

-- 全部刷新
function UIScienceTabRowCell:ReInit(param)
	self.param = param
	self:ShowCells()
end

function UIScienceTabRowCell:Refresh()
	for k,v in ipairs(self.cells) do
		if v.model ~= nil then
			v.model:Refresh()
		end
	end
end

function UIScienceTabRowCell:ShowCells()
	local count = #self.param.list
	for k, v in ipairs(self.param.list) do
		if self.cells[k] == nil then
			self.cells[k] = v
			v.visible = true
			v.req = self:GameObjectInstantiateAsync(UIAssets.UIScienceTabCell, function(request)
				if request.isError then
					return
				end
				local go = request.gameObject
				go:SetActive(true)
				go.transform:SetParent(self.transform)
				go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
				go.transform:SetAsLastSibling()
				local nameStr = tostring(k)
				go.name = nameStr
				local model = self:AddComponent(UIScienceTabCell, nameStr)
				model:ReInit(self.cells[k])
				self.cells[k].model = model
				--self.view:CheckUpgradingEffect(self.param.index, k)
			end)
		else
			v.req = self.cells[k].req
			v.model = self.cells[k].model
			self.cells[k] = v
			v.visible = true
			if v.model ~= nil then
				v.model:ReInit(v)
				--self.view:CheckUpgradingEffect(self.param.index, k)
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

function UIScienceTabRowCell:SetUpgradeEffect(index, go)
	local cell = self.cells[index]
	if cell ~= nil and cell.model ~= nil then
		cell.model:SetUpgradeEffect(go)
	end
end

return UIScienceTabRowCell