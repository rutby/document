--[[
-- added by wsh @ 2017-12-08
-- UI容器基类：当一个UI组件持有其它UI组件时，它就是一个容器类，它要负责调度其它UI组件的相关函数
-- 注意：
-- 1、window.view是窗口最上层的容器类
-- 2、AddComponent用来添加组件，一般在window.view的OnCreate中使用，RemoveComponent相反
-- 3、GetComponent用来获取组件，GetComponents用来获取一个类别的组件
-- 4、很重要：子组件必须保证名字互斥，即一个不同的名字要保证对应于Unity中一个不同的Transform
--]]

local UIBaseContainer = BaseClass("UIBaseContainer", UIBaseComponent)
-- 基类，用来调用基类方法
local base = UIBaseComponent
local tinsert = table.insert
local tcount = table.count
local pairs = pairs
local assert = assert
local error = error
local type = type

-- 创建
local function OnCreate(self)
	base.OnCreate(self)
	self.components = {}
	self.length = 0
	self.__event_handlers = {}
end

-- 打开
local function OnEnable(self)
	base.OnEnable(self)
	
	if self.__update_handle then
		UpdateManager:GetInstance():RemoveUpdate(self.__update_handle)
		self.__update_handle = nil
	end
	if self.Update then
		self.__update_handle = function() self:Update() end
		UpdateManager:GetInstance():AddUpdate(self.__update_handle)
	end

	self:OnAddListener()
end

-- 关闭
local function OnDisable(self)
	self:OnRemoveListener()

	if self.__update_handle then
		UpdateManager:GetInstance():RemoveUpdate(self.__update_handle)
		self.__update_handle = nil
	end
	
	base.OnDisable(self)
end

-- 注册消息
local function OnAddListener(self)
end

-- 注销消息
local function OnRemoveListener(self)
end

-- 注册UI数据监听事件，别重写
local function AddUIListener(self, msg_name, callback)
	local bindFunc = function(...) callback(self, ...) end
	self.__event_handlers[msg_name] = bindFunc
	EventManager:GetInstance():AddListener(msg_name, bindFunc)
end

-- 注销UI数据监听事件，别重写
local function RemoveUIListener(self, msg_name, callback)
	local bindFunc = self.__event_handlers[msg_name]
	if not bindFunc then
		Logger.LogError(msg_name, " not register")
		return
	end
	self.__event_handlers[msg_name] = nil
	--UIManager:GetInstance():RemoveListener(msg_name, bindFunc)
	EventManager:GetInstance():RemoveListener(msg_name, bindFunc)
end

local function UIBroadcast(self, msg_name, ...)
	--UIManager:GetInstance():Broadcast(msg_name, ...)
	EventManager:GetInstance():Broadcast(msg_name, bindFunc)
end

-- 遍历：注意，这里是无序的
local function Walk(self, callback, component_class)
	if self.components~=nil then
		for _,components in pairs(self.components) do
			for cmp_class,component in pairs(components) do
				if component_class == nil then
					callback(component)
				elseif cmp_class == component_class then
					callback(component)
				end
			end
		end
	end
	
end

-- 如果必要，创建新的记录，对应Unity下一个Transform下所有挂载脚本的记录表
local function AddNewRecordIfNeeded(self, name)
	if self.components[name] == nil then
		self.components[name] = {}
	end
end

-- 记录Component
local function RecordComponent(self, name, component_class, component)
	-- 同一个Transform不能挂两个同类型的组件
	assert(self.components[name][component_class] == nil, "Aready exist, name: " .. name .. ", component_class: " .. component_class.__cname)
	self.components[name][component_class] = component
end

-- 子组件改名回调
local function OnComponentSetName(self, component, new_name)
	AddNewRecordIfNeeded(self, new_name)
	-- 该名字对应Unity的Transform下挂载的所有脚本都要改名
	local old_name = component:GetName()
	local components = self.components[old_name]
	for k,v in pairs(components) do
		v:SetName(new_name)
		RecordComponent(self, new_name, k, v)
	end
	self.components[old_name] = nil
end

-- 子组件销毁
local function OnComponentDestroy(self, component)
	self.length = self.length - 1
end

-- 添加组件
-- 多种重载方式
-- 指定Lua侧组件类型和必要参数，新建组件并添加，多种重载方式：
--    A）inst:AddComponent(ComponentTypeClass, relative_path)
--    B）inst:AddComponent(ComponentTypeClass, unity_gameObject)
local function AddComponent(self, component_target, var_arg, ...)
	assert(component_target.__ctype == ClassType.class)
	local component_inst = nil
	local component_class = nil
	component_inst = component_target.New(self, var_arg)
	component_class = component_target
	component_inst:OnCreate(...)
	
	local name = component_inst:GetName()
	AddNewRecordIfNeeded(self, name)
	RecordComponent(self, name, component_class, component_inst)
	self.length = self.length + 1

	if component_inst:GetActiveInHierarchy() then
		component_inst:OnEnable()
	end
	
	return component_inst
end

-- 获取组件
local function GetComponent(self, name, component_class)
	local components = self.components[name]
	if components == nil then
		return nil
	end
	
	if component_class == nil then
		-- 必须只有一个组件才能不指定类型，这一点由外部代码保证
		assert(tcount(components) == 1, "Must specify component_class while there are more then one component!")
		for _,component in pairs(components) do
			return component
		end
	else
		return components[component_class]
	end
end

-- 获取一系列组件：2种重载方式
-- 1、获取一个类别的组件
-- 2、获取某个name（Transform）下的所有组件
local function GetComponents(self, component_target)
	local components = {}
	if type(component_target) == "table" then
		self:Walk(function(component)
			tinsert(components, component)
		end, component_target)
	elseif type(component_target) == "string" then
		components = self.components[component_target]
	else
		error("GetComponents params err!")
	end
	return components
end

-- 获取组件个数
local function GetComponentsCount(self)
	return self.length
end

-- 移除组件
local function RemoveComponent(self, name, component_class)
	local component = self:GetComponent(name, component_class)
	if not component then
		return
	end

	component:SetActive(false)
	
	local cmp_class = component._class_type
	component:Delete()
	self.components[name][cmp_class] = nil
end

-- 移除一系列组件：2种重载方式
-- 1、移除一个类别的组件
-- 2、移除某个name（Transform）下的所有组件
local function RemoveComponents(self, component_target)
	local components = self:GetComponents(component_target)
	if not components then
		return
	end
	for _,component in pairs(components) do
		component:SetActive(false)
		local cmp_name = component:GetName()
		local cmp_class = component._class_type
		component:Delete()
		self.components[cmp_name][cmp_class] = nil
	end
end

-- 销毁
local function OnDestroy(self)
	if self.__event_handlers then
		for k,v in pairs(self.__event_handlers) do
			self:RemoveUIListener(k, v)
		end
		self.__event_handlers = nil
	end
	if self.components then
		self:Walk(function(component)
			component:Delete()
		end)
		self.components = nil
	end
	base.OnDestroy(self)
end

local function SetActiveRecursive(com)
	local state, changed
	if com.activeCached ~= nil then
		local oldActive = com.activeCached
		com.activeCached = nil
		state = com:GetActiveInHierarchy()
		changed = oldActive ~= state
	else
		state = com:GetActiveInHierarchy()
		changed = true
	end

	if com.components ~= nil then
		for _,components in pairs(com.components) do
			for _,childCom in pairs(components) do
				SetActiveRecursive(childCom)
			end
		end
	end

	if changed then
		if state then
			com:OnEnable()
		else
			com:OnDisable()
		end
	end
end

local function SetActive(self, active)
	if active then
		if self:GetActiveInHierarchy() then
			return
		end
	else
		if not self:GetActiveInHierarchy() then
			self.activeSelf = false
			if self.gameObject then
				self.gameObject:SetActive(false)
			else
				self:SetInitActiveSelf(false)
			end
			return
		end
	end
	
	self.activeSelf = active;
	if self.gameObject then
		self.gameObject:SetActive(active)
	else
		self:SetInitActiveSelf(active)
	end
	SetActiveRecursive(self)
end

--刷新动态添加的UIEffect order
function UIBaseContainer:ResortUIEffect()
	base.ResortUIEffect(self)

	if self.components ~= nil then
		self:Walk(function(component)
			component:ResortUIEffect()
		end)
	end
end

-- example:
-- local compBook = {
--	 {name="imgHead", 		type=UIImage, 			path="Panel/img_head"},
--	 {name="top.btnOK", 	type=UIButton, 			path="Panel/top/group/btn_ok", 			onClick=function(self) self:OnClickOK() end},
--	 {name="top.txtTitle", 	type=UIText, 			path="Panel/top/info/txt_title", 		textKey="1120023"},
--	 {name="top.txtOK", 	type=UIText, 			path="Panel/top/info/txt_OK", 			text="OK"},
--	 {name="bottom", 		type=UIContainer, 		path="Panel/bottom"},
--	 {name="vfxObj", 		type=nil, 				path="Panel/bottom/vfxObj",				active=false},
-- }
local function DefineCompsByBook(self, compBook)
	self.__compBook = compBook
	for _, compEntry in ipairs(compBook) do
		local nameArr = string.split(compEntry.name, ".")
		local parent = self
		for i, nameEntry in ipairs(nameArr) do
			local isLast = i == #nameArr
			if isLast then
				local comp = nil
				if compEntry.type == nil then
					local trans = self.gameObject.transform:Find(compEntry.path)
					if trans == nil or IsNull(trans) then printError("ComponentDefine can't find " .. compEntry.path.." from "..self.gameObject.transform.name) end
					if compEntry.rawType then
						comp = trans.gameObject:GetComponent(typeof(compEntry.rawType))
						if compEntry.active ~= nil then
							comp.gameObject:SetActive(compEntry.active)
						end
					else
						comp = trans.gameObject
						if compEntry.active ~= nil then
							comp:SetActive(compEntry.active)
						end
					end
				else
					comp = self:AddComponent(compEntry.type, compEntry.path)
					if compEntry.active ~= nil then
						comp:SetActive(compEntry.active)
					end
					if compEntry.type == UIButton then
						if compEntry.onClick ~= nil then
							comp:SetOnClick(function()
								compEntry.onClick(self)
							end)
						end
					end
					if compEntry.type == UIToggle then
						if compEntry.onValueChanged ~= nil then
							comp:SetOnValueChanged(function(isOn)
								compEntry.onValueChanged(self, isOn)
							end)
						end
					end
					if compEntry.type == UIText then
						if compEntry.textKey ~= nil then
							comp:SetText(CS.GameEntry.Localization:GetString(compEntry.textKey))
						elseif compEntry.text ~= nil then
							comp:SetText(compEntry.text)
						end
					end
				end
				if comp then
					if compEntry.idx ~= nil then
						if parent[nameEntry] == nil then parent[nameEntry] = {} end
						table.insert(parent[nameEntry], compEntry.idx, comp)
					else
						parent[nameEntry] = comp
					end
				end
			else
				if parent[nameEntry] == nil then parent[nameEntry] = {} end
				parent = parent[nameEntry]
			end
		end
	end
end

local function ClearCompsByBook(self, compBook)
	compBook = compBook or self.__compBook
	for j = #compBook, 1, -1 do
		local compEntry = compBook[j]
		local nameArr = string.split(compEntry.name, ".")
		local parent = self
		for i, nameEntry in ipairs(nameArr) do
			if not parent then break end
			local isLast = i == #nameArr
			if isLast then
				parent[nameEntry] = nil
			else
				-- 这里如果book里面有层级定义，需要确保顺序，不然会空指针
				parent = parent[nameEntry]
			end
		end
	end
end

UIBaseContainer.SetActive = SetActive
UIBaseContainer.OnCreate = OnCreate
UIBaseContainer.OnEnable = OnEnable
UIBaseContainer.AddUIListener = AddUIListener
UIBaseContainer.RemoveUIListener = RemoveUIListener
UIBaseContainer.UIBroadcast = UIBroadcast
UIBaseContainer.OnAddListener = OnAddListener
UIBaseContainer.OnRemoveListener = OnRemoveListener
UIBaseContainer.Walk = Walk
UIBaseContainer.OnComponentSetName = OnComponentSetName
UIBaseContainer.OnComponentDestroy = OnComponentDestroy
UIBaseContainer.AddComponent = AddComponent
UIBaseContainer.GetComponent = GetComponent
UIBaseContainer.GetComponents = GetComponents
UIBaseContainer.GetComponentsCount = GetComponentsCount
UIBaseContainer.RemoveComponent = RemoveComponent
UIBaseContainer.RemoveComponents = RemoveComponents
UIBaseContainer.OnDisable = OnDisable
UIBaseContainer.OnDestroy = OnDestroy
UIBaseContainer.DefineCompsByBook = DefineCompsByBook
UIBaseContainer.ClearCompsByBook = ClearCompsByBook

return UIBaseContainer