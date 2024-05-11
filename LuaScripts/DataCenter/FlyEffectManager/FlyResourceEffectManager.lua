
local FlyResourceEffectManager = BaseClass("FlyResourceEffectManager")
local ResourceManager = CS.GameEntry.Resource
local FlyResourceEffect = require "UI.FlyResourceEffect.View.FlyResourceEffect"
local FlyFoldUpBuildEffect = require "UI.FlyResourceEffect.View.FlyFoldUpBuildEffect"

local function __init(self)
	self.allEffect = {} --所有特效 
	self.startPos = Vector3.New(0,0,0) --世界坐标
end

local function __delete(self)
	for k,v in pairs(self.allEffect) do
		for k1,v1 in pairs(v) do
			local request = v1.param.request
			v1:OnDestroy()
			request:Destroy()
		end
	end
	self.allEffect = nil
	self.startPos = nil 
end

local function ShowGetResourceEffect(self,startPos,resourceType,showNum)
	--local endPos = UIUtil.GetResourcePos(resourceType)
	--local icon = DataCenter.ResourceManager:GetResourceIconByType(resourceType)
	--if showNum>0 then
	--	for i = 1,showNum do
	--		self:ShowOneResourceEffect(startPos,endPos,icon,resourceType,i)
	--	end
	--else
	--	self:ShowOneResourceEffect(startPos,endPos,icon,resourceType,3)
	--end
end

--展示一个升级特效 结束自动销毁
local function ShowOneResourceEffect(self,startPos,endPos,icon,resourceType,staticMoveNum)
	local request = ResourceManager:InstantiateAsync(UIAssets.FlyResourceEffect)
	if self.allEffect[resourceType] == nil then
		self.allEffect[resourceType] = {}
	end
	local layer = UIManager:GetInstance():GetLayer(UILayer.Dialog.Name)
	if layer == nil then
		Logger.Log("can not get layer")
		return
	end
	request:completed('+', function()
		if request.isError then
			return
		end
		request.gameObject:SetActive(true)
		request.gameObject.transform:SetParent(layer.transform, false)
		request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
		
		local flyResourceEffect = FlyResourceEffect.New()
		flyResourceEffect:OnCreate(request)
		table.insert(self.allEffect[resourceType],flyResourceEffect)
		local param = {}
		param.startPos = startPos
		param.endPos = endPos
		param.stopTime =  0.4
		param.time = 1--AutoCloseTime - 1
		param.icon = icon
		param.id = resourceType
		param.request = request
		param.staticMoveNum = staticMoveNum
		flyResourceEffect:ReInit(param)
	end)
end


local function ShowFoldUpBuildEffect(self,startPos,bUuid)
	local layer = UIManager:GetInstance():GetLayer(UILayer.Normal.Name)
	if layer == nil then
		Logger.Log("can not get layer")
		return
	end
	local window = UIManager:GetInstance():GetWindow(UIWindowNames.UIMain)
	if window==nil then
		return
	end
	local request = ResourceManager:InstantiateAsync(UIAssets.FlyFoldUpBuildEffect)
	if self.allEffect[bUuid] == nil then
		self.allEffect[bUuid] = {}
	end
	--local showTwoBezier =false
	--local curTime = math.floor(UITimeManager:GetInstance():GetServerTime())
	--if math.fmod(curTime,2) ~= 0 then
	--	showTwoBezier =true
	--end
	request:completed('+', function()
		if request.isError then
			return
		end
		request.gameObject:SetActive(true)
		request.gameObject.transform:SetParent(layer.transform, false)
		request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
		local endPos = window.View:GetSavePos(UIMainSavePosType.Build)
		local flyResourceEffect = FlyFoldUpBuildEffect.New()
		flyResourceEffect:OnCreate(request)
		table.insert(self.allEffect[bUuid],flyResourceEffect)
		local distance= Vector3.Distance(endPos,startPos)
		local param = {}
		param.startPos = startPos
		param.endPos = endPos
		param.stopTime = 0.7
		param.time = 0.7 + distance*0.05/200
		--AutoCloseTime - 1
		param.id = bUuid
		param.request = request
		param.distance = distance
		flyResourceEffect:ReInit(param)
	end)
end

local function RemoveOneEffect(self,param)
	for i = #self.allEffect[param.id],1,-1 do
		if self.allEffect[param.id][i] == param then
			local temp = table.remove(self.allEffect[param.id],i)
			temp:OnDestroy()
		end
	end
	if param.request ~= nil then
		param.request:Destroy()
	end
end

FlyResourceEffectManager.__init = __init
FlyResourceEffectManager.__delete = __delete
FlyResourceEffectManager.ShowOneResourceEffect = ShowOneResourceEffect
FlyResourceEffectManager.ShowGetResourceEffect = ShowGetResourceEffect
FlyResourceEffectManager.RemoveOneEffect = RemoveOneEffect
FlyResourceEffectManager.ShowFoldUpBuildEffect = ShowFoldUpBuildEffect

return FlyResourceEffectManager