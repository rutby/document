--[[
-- added by wsh @ 2017-12-08
-- UI组件基类：所有UI组件从这里继承
-- 说明：
-- 1、采用基于组件的设计方式，容器类负责管理和调度子组件，实现类似于Unity中挂载脚本的功能
-- 2、组件对应Unity原生的各种Component和Script，容器对应Unity原生的GameObject
-- 3、写逻辑时完全不需要关注脚本调度，在cs中脚本函数怎么调度的，这里就怎么调度，只是要注意接口变动，lua侧没有Get、Set访问器
-- 注意：
-- 1、Lua侧组件的名字并不总是和Unity侧组件名字同步，Lua侧组件名字会作为组件系统中组件的标识
-- 2、Lua侧组件名字会在组件创建时提取Unity侧组件名字，随后二者没有任何关联，Unity侧组件名字可以随便改
-- 3、虽然Unity侧组件名字随后可以随意改，但是不建议（有GC），此外Lua侧组件一旦创建，使用时全部以Lua侧名字为准
-- 4、需要定时刷新的界面，最好启用定时器、协程，界面需要刷新的频率一般较低，倒计时之类的只需要每秒钟更新一次即可
--]]

local UIBaseComponent = BaseClass("UIBaseComponent")

local ResourceManager = CS.GameEntry.Resource

-- 构造函数：除非特殊情况，所有子类不要再写这个函数，初始化工作放OnCreate
-- 多种重载方式：
-- 1、ComponentTypeClass.New(relative_path)
-- 2、ComponentTypeClass.New(unity_gameObject)
local function __init(self, holder, var_arg)
	-- 窗口view层脚本
	self.view = nil
	-- 持有者
	self.holder = holder
	-- 脚本绑定的transform
	self.transform = nil
	-- transform对应的gameObject
	self.gameObject = nil
	-- trasnform对应的RectTransform
	self.rectTransform = nil
	-- 名字：Unity中获取Transform的名字是有GC的，而Lua侧组件大量使用了名字，所以这里缓存下
	self.__name = nil
	-- 可变类型参数，用于重载
	self.__var_arg = var_arg
	-- 是否激活
	self.activeSelf = false
	self.activeCached = nil
	self.goInstances = {}
	self.initActiveSelf = nil
end

-- 析构函数：所有组件的子类不要再写这个函数，释放工作全部放到OnDestroy
local function __delete(self)
	self:OnDestroy()
end

-- 创建
local function OnCreate(self)
	local holderTrans = self.holder.transform

	-- 初始化view
	if self._class_type == UILayerComponent then
		self.view = nil
	else
		local now_holder = self.holder
		while now_holder ~= nil do
			if now_holder._class_type == UILayerComponent then
				self.view = self
				break
			elseif now_holder.view ~= nil then
				self.view = now_holder.view
				break
			end
			now_holder = now_holder.holder
		end
	end

	-- 初始化其它基本信息
	local argType = type(self.__var_arg)
 	if argType == "string" then
		-- 与持有者的相对路径
		local transform = holderTrans:Find(self.__var_arg)
		if transform ~= nil then
			self.gameObject = transform.gameObject
		else
			error("OnCreate : cannot find component!\nholder: " .. holderTrans.name .. "\npath: " .. self.__var_arg)
		end
	elseif argType == "userdata" then
		-- Unity侧GameObject
		self.gameObject = self.__var_arg
	else
		error("OnCreate : error params list! " .. argType .. " " .. tostring(self.__var_arg))
	end

	if self.initActiveSelf ~= nil then
		self.gameObject:SetActive(self.initActiveSelf)
		self.initActiveSelf = nil
	end
	self.activeSelf = self.gameObject.activeSelf
	self.transform = self.gameObject.transform
	self.rectTransform = self.gameObject:GetComponent(typeof(CS.UnityEngine.RectTransform))
	self.__name = self.gameObject.name;
end

-- 打开
local function OnEnable(self)
end

-- 获取名字
local function GetName(self)
	return self.__name
end

-- 设置名字：toUnity指定是否同时设置Unity侧的名字---不建议，实在想不到什么情况下会用，但是调试模式强行设置，好调试
local function SetName(self, name, toUnity)
	if self.holder.OnComponentSetName ~= nil then
		self.holder:OnComponentSetName(self, name)
	end
	self.__name = name
	if toUnity or Config.Debug then
		if IsNull(self.gameObject) then
			Logger.LogError("gameObject null, you maybe have to wait for loading prefab finished!")
			return
		end
		self.gameObject.__name = name
	end
end

-- 激活、反激活
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
	
	self.activeSelf = active
	self.activeCached = active
	if self.gameObject ~= nil then
		self.gameObject:SetActive(active)
	else
		self:SetInitActiveSelf(active)
		Logger.Log("self.gameObject nil, " .. tostring(__var_arg))
	end

	if active then
		self:OnEnable()
	else
		self:OnDisable()
	end
end

-- 获取激活状态
local function GetActive(self)
	return self.activeSelf
end

local function GetActiveInHierarchy(self)
	local activeCached = self.activeCached
	if activeCached ~= nil then
		return activeCached
	end
    activeCached = self.activeSelf and (self.holder == nil or self.holder:GetActiveInHierarchy())
    self.activeCached = activeCached
	return activeCached
end

local function SetInitActiveSelf(self,active)
	self.initActiveSelf = active	
end

-- 关闭
local function OnDisable(self)
end

-- 销毁
local function OnDestroy(self)
	self:RemoveAllUIEffect()
	if self.holder ~= nil and self.holder.OnComponentDestroy ~= nil then
		self.holder:OnComponentDestroy(self)
	end
	self.holder = nil
	self.transform = nil
	self.gameObject = nil
	self.rectTransform = nil
	self.__name = nil
	
	for req, t in pairs(self.goInstances) do
		req:Destroy()
	end
end

local function GameObjectInstantiateAsync(self, prefabPath, onComplete)
	local req = ResourceManager:InstantiateAsync(prefabPath)
	req:completed('+', function()
		if onComplete then
			onComplete(req)
		end
	end)
	self.goInstances[req] = "InstanceRequest"
	return req
end

local function GameObjectDestroy(self, req)
	local t = self.goInstances[req]
	if t == "InstanceRequest" then
		self.goInstances[req] = nil
		req:Destroy()
	end
end

----------------------------------------------------------------------------------------------------------------
-- 添加一个ui特效 函数内部会处理特效和ui排序 otherParam支持parentNode、anchoredPosition、orderIncFromParent 
-- note:修改前先找zlh沟通下
function UIBaseComponent:AddUIEffect(effectPath, otherParam, callback)
	if self.uiEffectList == nil then
		self.uiEffectList = {}
	end

	--考虑到添加和移除的便利性 同一个界面不允许存在多个相同路径的粒子 后续如果这种需求再改
	local oldEffect = self.uiEffectList[effectPath]
	if oldEffect ~= nil then
		self:RemoveUIEffect(effectPath)
	end

	local parentNode = otherParam and otherParam.parentNode.rectTransform or self.rectTransform
	local anchoredPosition = otherParam and otherParam.anchoredPosition or Vector2.zero
	local localScale = otherParam and otherParam.localScale or ResetScale
	local orderIncFromParent = otherParam and otherParam.orderIncFromParent or 1

	if parentNode == nil or string.IsNullOrEmpty(effectPath) then
		Logger.LogError('AddUIEffect Error! parentNode or effectPath is nil!')
		return
	end

	local req = CommonUtil.LoadResAsync(effectPath,
			function(req)
				--处理加载过程中被cancel的情况
				if self.uiEffectList[effectPath] == nil then
					req:Destroy()
					return
				end

				local go = req.gameObject
				if go == nil then
					return
				end

				go.transform:SetParent(parentNode, false)
				go.transform:Set_anchoredPosition3D(anchoredPosition.x, anchoredPosition.y, 0)
				go.transform:Set_localScale(localScale.x, localScale.y, localScale.z)

				--改为CS里统一处理
				local particleSetUp = go.transform:GetComponent(typeof(CS.UISurvivalParticleSetUp))
				if particleSetUp == nil then
					particleSetUp = go.transform.gameObject:AddComponent(typeof(CS.UISurvivalParticleSetUp))
					particleSetUp:SetLocalOrder(orderIncFromParent)
				else
					particleSetUp:Refresh()
				end

				if callback ~= nil then
					callback(go)
				end
			end)

	self.uiEffectList[effectPath] = req
end

-- 通过路径移除粒子特效
function UIBaseComponent:RemoveUIEffect(effectPath)
	if self.uiEffectList == nil then
		return
	end

	local req = self.uiEffectList[effectPath]
	self.uiEffectList[effectPath] = nil

	if req ~= nil then
		req:Destroy()
	end
end

function UIBaseComponent:RemoveAllUIEffect()
	if self.uiEffectList == nil then
		return
	end

	for _, req in pairs(self.uiEffectList) do
		if req ~= nil then
			req:Destroy()
		end
	end

	table.clear(self.uiEffectList)
end

function UIBaseComponent:ResortUIEffect()
	if self.uiEffectList == nil then
		return
	end

	for _, req in pairs(self.uiEffectList) do
		if req == nil or req.gameObject == nil then
			goto continue
		end

		local particleSetUp = req.gameObject.transform:GetComponent(typeof(CS.UISurvivalParticleSetUp))
		if particleSetUp ~= nil then
			particleSetUp:Refresh()
		end

		::continue::
	end
end

----------------------------------------------------------------------------------------------------------------


--[[
	删除childNode下的所有子节点,这个地方需要是transform
]]
local function DestroyChildNode(childTransform)
	if (childTransform == nil) then
		return
	end
	local childCnt = childTransform.transform.childCount
	for i = 0, childCnt-1, 1 do
		local child = childTransform.transform:GetChild(i)
		CS.UnityEngine.GameObject.Destroy(child.gameObject);
	end
end

-- 设置enable,这个不走生命周期
local function SetEnabled(self, value)
	local selfEnabled = self.unity_uitoggle.enabled
	if (selfEnabled ~= value) then
		self.unity_uitoggle.enabled = value
	end
end

------------
-- Position
------------
local function SetPositionXYZ(self, x, y, z)
	self.rectTransform:Set_position(x, y, z)
end

-- 直接返回3个float
local function GetPositionXYZ(self)
	return self.rectTransform:Get_position()
end

local function SetPosition(self, v)
	self.rectTransform:Set_position(v.x, v.y, v.z)
end

local function GetPosition(self)
	local x, y, z = self.rectTransform:Get_position()
	return Vector3.New(x, y, z)
end

------------
-- localPosition
------------
-----  慎用 一般都是SetAnchoredPosition  这个值不是unity中看到的  by shimin
local function SetLocalPositionXYZ(self, x, y, z)
	self.rectTransform:Set_localPosition(x, y, z)
end

-- 直接返回3个float
local function GetLocalPositionXYZ(self)
	return self.rectTransform:Get_localPosition()
end

local function SetLocalPosition(self, v)
	self.rectTransform:Set_localPosition(v.x, v.y, v.z)
end

local function GetLocalPosition(self)
	local x, y, z = self.rectTransform:Get_localPosition()
	return Vector3.New(x, y, z)
end


------------
-- localScale
------------
local function SetLocalScaleXYZ(self, x, y, z)
	self.rectTransform:Set_localScale(x, y, z)
end

-- 直接返回3个float
local function GetLocalScaleXYZ(self)
	return self.rectTransform:Get_localScale()
end

local function SetLocalScale(self, v)
	self.rectTransform:Set_localScale(v.x, v.y, v.z)
end

local function GetLocalScale(self)
	local x, y, z = self.rectTransform:Get_localScale()
	return Vector3.New(x, y, z)
end

------------
-- eulerAngles
------------
local function SetEulerAnglesXYZ(self, x, y, z)
	self.rectTransform:Set_eulerAngles(x, y, z)
end

-- 直接返回3个float
local function GetEulerAnglesXYZ(self)
	return self.rectTransform:Get_eulerAngles()
end

local function SetEulerAngles(self, v)
	self.rectTransform:Set_eulerAngles(v.x, v.y, v.z)
end

local function GetEulerAngles(self)
	local x, y, z = self.rectTransform:Get_eulerAngles()
	return Vector3.New(x, y, z)
end

------------
-- anchorMin
------------
local function SetAnchorMinXY(self, x, y)
	self.rectTransform:Set_anchorMin(x, y)
end

-- 直接返回2个float
local function GetAnchorMinXY(self)
	return self.rectTransform:Get_anchorMin()
end

local function SetAnchorMin(self, v)
	self.rectTransform:Set_anchorMin(v.x, v.y)
end

local function GetAnchorMin(self)
	local x, y = self.rectTransform:Get_anchorMin()
	return Vector2.New(x, y)
end

------------
-- anchorMax
------------
local function SetAnchorMaxXY(self, x, y)
	self.rectTransform:Set_anchorMax(x, y)
end

-- 直接返回2个float
local function GetAnchorMaxXY(self)
	return self.rectTransform:Get_anchorMax()
end

local function SetAnchorMax(self, v)
	self.rectTransform:Set_anchorMax(v.x, v.y)
end

local function GetAnchorMax(self)
	local x, y = self.rectTransform:Get_anchorMax()
	return Vector2.New(x, y)
end


------------
-- offsetMax
------------
local function SetOffsetMaxXY(self, x, y)
	self.rectTransform:Set_offsetMax(x, y)
end

-- 直接返回2个float
local function GetOffsetMaxXY(self)
	return self.rectTransform:Get_offsetMax()
end

local function SetOffsetMax(self, v)
	self.rectTransform:Set_offsetMax(v.x, v.y)
end

local function GetOffsetMax(self)
	local x, y = self.rectTransform:Get_offsetMax()
	return Vector2.New(x, y)
end

------------
-- offsetMin
------------
local function SetOffsetMinXY(self, x, y)
	self.rectTransform:Set_offsetMin(x, y)
end

-- 直接返回2个float
local function GetOffsetMinXY(self)
	return self.rectTransform:Get_offsetMin()
end

local function SetOffsetMin(self, v)
	self.rectTransform:Set_offsetMin(v.x, v.y)
end

local function GetOffsetMin(self)
	local x, y = self.rectTransform:Get_offsetMin()
	return Vector2.New(x, y)
end


--param value:Vector2
local function SetAnchoredPosition(self, value)
	--self.rectTransform.anchoredPosition = value
	self.rectTransform:Set_anchoredPosition(value.x, value.y)
end

local function SetAnchoredPositionXY(self, x, y)
	--self.rectTransform.anchoredPosition = value
	self.rectTransform:Set_anchoredPosition(x, y)
end

local function GetAnchoredPosition(self)
	--return  self.rectTransform.anchoredPosition
	local x, y = self.rectTransform:Get_anchoredPosition()
	return Vector2.New(x, y)
end

local function GetAnchoredPositionX(self)
	--return  self.rectTransform.anchoredPosition
	local x, y = self.rectTransform:Get_anchoredPosition()
	return x
end

local function GetAnchoredPositionY(self)
	--return  self.rectTransform.anchoredPosition
	local x, y = self.rectTransform:Get_anchoredPosition()
	return y
end

local function GetSizeDelta(self)
	--return self.rectTransform.sizeDelta
	local x, y = self.rectTransform:Get_sizeDelta()
	return Vector2.New(x, y)
end

local function SetSizeDelta(self,value)
	--self.rectTransform.sizeDelta = value
	self.rectTransform:Set_sizeDelta(value.x, value.y)
end

local function SetPivotXY(self, x, y)
	self.rectTransform:Set_pivot(x, y)
end




UIBaseComponent.__init = __init
UIBaseComponent.__delete = __delete
UIBaseComponent.OnCreate = OnCreate
UIBaseComponent.OnEnable = OnEnable
UIBaseComponent.GetName = GetName
UIBaseComponent.SetName = SetName
UIBaseComponent.SetActive = SetActive
UIBaseComponent.SetInitActiveSelf = SetInitActiveSelf
UIBaseComponent.GetActive = GetActive
UIBaseComponent.GetActiveInHierarchy = GetActiveInHierarchy
UIBaseComponent.OnDisable = OnDisable
UIBaseComponent.OnDestroy = OnDestroy
UIBaseComponent.GameObjectInstantiateAsync = GameObjectInstantiateAsync
UIBaseComponent.GameObjectDestroy = GameObjectDestroy
UIBaseComponent.DestroyChildNode = DestroyChildNode
UIBaseComponent.SetEnabled = SetEnabled
UIBaseComponent.SetAnchoredPosition = SetAnchoredPosition
UIBaseComponent.SetAnchoredPositionXY = SetAnchoredPositionXY
UIBaseComponent.GetAnchoredPosition = GetAnchoredPosition
UIBaseComponent.GetAnchoredPositionX = GetAnchoredPositionX
UIBaseComponent.GetAnchoredPositionY = GetAnchoredPositionY

UIBaseComponent.GetSizeDelta = GetSizeDelta
UIBaseComponent.SetSizeDelta = SetSizeDelta

UIBaseComponent.SetPosition = SetPosition
UIBaseComponent.GetPosition = GetPosition
UIBaseComponent.SetPositionXYZ = SetPositionXYZ
UIBaseComponent.GetPositionXYZ = GetPositionXYZ

UIBaseComponent.SetLocalPosition = SetLocalPosition
UIBaseComponent.GetLocalPosition = GetLocalPosition
UIBaseComponent.SetLocalPositionXYZ = SetLocalPositionXYZ
UIBaseComponent.GetLocalPositionXYZ = GetLocalPositionXYZ

UIBaseComponent.SetLocalScale = SetLocalScale
UIBaseComponent.GetLocalScale = GetLocalScale
UIBaseComponent.SetLocalScaleXYZ = SetLocalScaleXYZ
UIBaseComponent.GetLocalScaleXYZ = GetLocalScaleXYZ

UIBaseComponent.SetEulerAngles = SetEulerAngles
UIBaseComponent.GetEulerAngles = GetEulerAngles
UIBaseComponent.SetEulerAnglesXYZ = SetEulerAnglesXYZ
UIBaseComponent.GetEulerAnglesXYZ = GetEulerAnglesXYZ

UIBaseComponent.SetAnchorMin = SetAnchorMin
UIBaseComponent.GetAnchorMin = GetAnchorMin
UIBaseComponent.SetAnchorMinXY = SetAnchorMinXY
UIBaseComponent.GetAnchorMinXY = GetAnchorMinXY

UIBaseComponent.SetAnchorMax = SetAnchorMax
UIBaseComponent.GetAnchorMax = GetAnchorMax
UIBaseComponent.SetAnchorMaxXY = SetAnchorMaxXY
UIBaseComponent.GetAnchorMaxXY = GetAnchorMaxXY

UIBaseComponent.SetOffsetMaxXY = SetOffsetMaxXY
UIBaseComponent.GetOffsetMaxXY = GetOffsetMaxXY
UIBaseComponent.SetOffsetMax = SetOffsetMax
UIBaseComponent.GetOffsetMax = GetOffsetMax
	
UIBaseComponent.SetOffsetMinXY = SetOffsetMinXY
UIBaseComponent.GetOffsetMinXY = GetOffsetMinXY
UIBaseComponent.SetOffsetMin = SetOffsetMin
UIBaseComponent.GetOffsetMin = GetOffsetMin

UIBaseComponent.SetPivotXY = SetPivotXY	

return UIBaseComponent