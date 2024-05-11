local GuideAllianceMemberEffectManager = BaseClass("GuideAllianceMemberEffectManager")
local ResourceManager = CS.GameEntry.Resource
local GuideAllianceMemberEffect = require "Scene.GuideAllianceMemberEffect.GuideAllianceMemberEffect"

local function __init(self)
	self.effect = {}
	self.TimeCallBack = function()
		DataCenter.GuideManager:DoNext()
		self:RemoveAll()
	end
end

local function __delete(self)
	self:RemoveAll()
	self.effect = nil
	self.TimeCallBack = nil
end

local function Startup()
end

local function ShowAllianceMemberEffect(self,list,showTime,enemy)
	if self.effect == nil then
		self.effect = {}
	end
	local leaderUid = nil
	local baseData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
	if baseData ~= nil and baseData.leaderUid then
		leaderUid = baseData.leaderUid
	end
	for k,v in ipairs(list) do
		local request = ResourceManager:InstantiateAsync(UIAssets.GuideAllianceMemberEffect)
		self.effect[v.pointId] = request
		request:completed('+', function()
			if request.isError then
				return
			end
			request.gameObject:SetActive(true)
			request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
			local t = SceneUtils.TileIndexToWorld(v.pointId)
			request.gameObject.transform:Set_position(t.x, t.y, t.z)
			local param = {}
			if enemy then
				param.enemy = enemy
			else
				param.isLeader = leaderUid == v.uid
			end
			
			local effect = GuideAllianceMemberEffect.New()
			effect:OnCreate(request)
			effect:ReInit(param)
		end)
	end
	if showTime then
		self:AddTimer(showTime/1000)
	end
end

local function AddTimer(self,time)
	if self.timer == nil then
		self.timer = TimerManager:GetInstance():GetTimer(time, self.TimeCallBack,nil, true,false,false)
	end
	self.timer:Start()
end

local function RemoveTimer(self)
	if self.timer ~= nil then
		self.timer:Stop()
		self.timer = nil
	end
end

local function RemoveAll(self)
	self:RemoveTimer()
	if self.effect ~= nil then
		for k,v in pairs(self.effect) do
			v:Destroy()
		end
		self.effect = nil
	end
end

GuideAllianceMemberEffectManager.__init = __init
GuideAllianceMemberEffectManager.__delete = __delete
GuideAllianceMemberEffectManager.Startup = Startup
GuideAllianceMemberEffectManager.ShowAllianceMemberEffect = ShowAllianceMemberEffect
GuideAllianceMemberEffectManager.AddTimer = AddTimer
GuideAllianceMemberEffectManager.RemoveTimer = RemoveTimer
GuideAllianceMemberEffectManager.RemoveAll = RemoveAll

return GuideAllianceMemberEffectManager