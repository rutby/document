--[[
-- added by wsh @ 2017-11-30
-- UI视图层基类：该界面所有UI刷新操作，只和展示相关的数据放在这，只有操作相关数据放Model去
-- 注意：
-- 1、被动刷新：所有界面刷新通过消息驱动---除了打开界面时的刷新
-- 2、对Model层可读，不可写---调试模式下强制
-- 3、所有写数据、游戏控制操作、网络相关操作全部放Ctrl层
-- 4、Ctrl层不依赖View层，但是依赖Model层
-- 5、任何情况下不要在游戏逻辑代码操作界面刷新---除了打开、关闭界面
--]]

local UIBaseView = BaseClass("UIBaseView", UIBaseContainer)
local base = UIBaseContainer
local UnityCanvas = CS.UnityEngine.Canvas
local UnityGraphicRayCaster = CS.UnityEngine.UI.GraphicRaycaster
local UIFormBlurEffect = typeof(CS.UIFormBlurEffect)
-- 构造函数：必须把基类需要的所有参数列齐---即使在这里不用，提高代码可读性
-- 子类别再写构造函数，初始化工作放OnCreate
local function __init(self, holder, var_arg, ctrl)
	self.layer = holder
	self.ctrl = ctrl
	self.WindowName = var_arg
end

local function SetBlurObj(self,blurObj,order)
	if blurObj~=nil then
		self.blurScript = blurObj:GetComponent(typeof(UIFormBlurEffect))
		if self.blurScript~=nil then
			self.orderNum = order
			if self.orderNum>4 then
				self.orderNum = 4
			end
			if self.blurScript~=nil then
				self.blurScript:ShowBlurImage(self.orderNum)
			end
			
		end
	end

end
-- 创建：资源加载完毕
local function OnCreate(self)
	base.OnCreate(self)
	-- 初始化RectTransform
	--self.rectTransform.offsetMax = Vector2.zero
	--self.rectTransform.offsetMin = Vector2.zero
	--self.rectTransform.anchorMin = Vector2.zero
	--self.rectTransform.anchorMax = Vector2.one
	--self.rectTransform.localScale = Vector3.one
	--self.rectTransform.localPosition = Vector3.zero

	self.rectTransform:Set_offsetMax(0, 0)
	self.rectTransform:Set_offsetMin(0, 0)
	self.rectTransform:Set_anchorMin(0, 0)
	self.rectTransform:Set_anchorMax(1, 1)
	self.rectTransform:Set_localScale(1, 1, 1)
	self.rectTransform:Set_localPosition(0, 0, 0)
	self.rectTransform:SetAsLastSibling()

	----------------------特效排序 改之前先找zlh讨论下----------------------
	--要想ui和特效排序 overrideSorting必须设置为true overrideSorting不设的情况下 相邻的ui会在同个srp batch中绘制 特效无法通过更改z值 在相邻的ui中间渲染
	local canvas = self.rectTransform:GetOrAddComponent(typeof(UnityCanvas))
	canvas.renderMode = CS.UnityEngine.RenderMode.ScreenSpaceCamera
	canvas.worldCamera = UIManager:GetInstance():GetUICamera()
	canvas.overrideSorting = true
	canvas.sortingLayerName = 'Default'
	self.canvas = canvas
	--防止影响点击事件
	self.rectTransform:GetOrAddComponent(typeof(UnityGraphicRayCaster))
	self.lastSortingOrder = IntMinValue

	local allParticleSet = self.rectTransform:GetComponentsInChildren(typeof(CS.UISurvivalParticleSetUp), true)
	self.allParticleSet = allParticleSet
	if allParticleSet ~= nil and allParticleSet.Length > 0 then
		for i = 0, allParticleSet.Length -1 do
			allParticleSet[i]:Refresh()
		end
	end

	local allOrderSet = self.rectTransform:GetComponentsInChildren(typeof(CS.UIOrderInLayerSetUp), true)
	self.allOrderSet = allOrderSet
	if allOrderSet ~= nil and allOrderSet.Length > 0 then
		for i = 0, allOrderSet.Length -1 do
			allOrderSet[i]:Refresh()
		end
	end
	-------------------------------------------------------
end

local function HideBlur(self)
	if self.blurScript~=nil then
		self.blurScript:HideBlurImage()
		local obj = self.blurScript.gameObject
		CS.UnityEngine.GameObject.Destroy(obj)
		self.blurScript = nil
		return true
	end
	return false
end
-- 销毁：窗口销毁
local function OnDestroy(self)
	self.layer = nil
	self.ctrl = nil
	base.OnDestroy(self)
end

local function SetUserData(self, userData)
	self.userData = userData
end

local function GetUserData(self)
	return SafeUnpack(self.userData)
end

--UI与特效排序: zlh
--历史：aps开发过程中 美术对UIParticle插件比较抵触 基于此C项目开发了 UI与特效排序
--发现通过override+z值的方式来实现排序 实测 有些发散的粒子特效还是会有部分穿透的情况 猜想可能是粒子做了随机 z值并不固定
--因此改用canvas.sortingOrder + childrenRender.orderInLayer方式来实现，相邻两个Layer差值5000，相邻俩个UIWindow差值100，单个ui内特效局部order设置范围[0, 100)
--有部分ui关闭时有动画 因此单纯通过transform.childCount计算order并不准确 会因关闭动画带来的时序问题计算有误
--同样如果缓存layer节点数量易出问题 unity的sortingOrder也有范围限制(-32,768 to 32,767)无法简单递增, 因此改为每次ui打开都对当前所在layer重排一下
function UIBaseView:ResortOrder(baseLayerOrder)
	if self.canvas == nil or self.transform == nil then
		return
	end

	local siblingIndex = self.transform:GetSiblingIndex()
	local globalOrder = math.min(baseLayerOrder + siblingIndex * 100, baseLayerOrder + 5000 - 100)
	if globalOrder ~= self.lastSortingOrder then
		self.lastSortingOrder = globalOrder
		self.canvas.sortingOrder = globalOrder
		self:__checkAllChildrenOrderSetUp()
	end
end
function UIBaseView:__checkAllChildrenOrderSetUp()
	if self.allParticleSet ~= nil and self.allParticleSet.Length > 0 then
		for i = 0, self.allParticleSet.Length -1 do
			self.allParticleSet[i]:Refresh()
		end
	end

	if self.allOrderSet ~= nil and self.allOrderSet.Length > 0 then
		for i = 0, self.allOrderSet.Length -1 do
			self.allOrderSet[i]:Refresh()
		end
	end

	self:ResortUIEffect()
end

UIBaseView.__init = __init
UIBaseView.GetUserData = GetUserData
UIBaseView.SetUserData = SetUserData
UIBaseView.OnCreate = OnCreate
UIBaseView.OnEnable = OnEnable
UIBaseView.OnDisable = OnDisable
UIBaseView.OnDestroy = OnDestroy
UIBaseView.SetBlurObj =SetBlurObj
UIBaseView.HideBlur =HideBlur
return UIBaseView