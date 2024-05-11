--- Created by shimin.
--- DateTime: 2023/3/16 16:56
--- 世界跳转管理器（由于镜头移动到达位置后，网络卡，没有数据信息，导致此时不能打开界面，与需求不符，所有有了这个类）

local WorldGotoManager = BaseClass("WorldGotoManager")

function WorldGotoManager:__init()
	self.needWaitPoint = nil --需要等待世界点信息刷新(最多一个)
	self.needWaitMarch = nil --需要等待世界行军信息刷新(最多一个)
	self:AddListener()
end

function WorldGotoManager:__delete()
	self.needWaitPoint = nil --需要等待世界点信息刷新(最多一个)
	self.needWaitMarch = nil --需要等待世界行军信息刷新(最多一个)
	self:RemoveListener()
end

function WorldGotoManager:Startup()
end

function WorldGotoManager:AddListener()
	if self.pveLevelEnterSignal == nil then
		self.pveLevelEnterSignal = function()
			self:PveLevelEnterSignal()
		end
		EventManager:GetInstance():AddListener(EventId.PveLevelEnter, self.pveLevelEnterSignal)
	end
	if self.onEnterWorldSignal == nil then
		self.onEnterWorldSignal = function()
			self:OnEnterWorldSignal()
		end
		EventManager:GetInstance():AddListener(EventId.OnEnterWorld, self.onEnterWorldSignal)
	end
	if self.onEnterCitySignal == nil then
		self.onEnterCitySignal = function()
			self:OnEnterCitySignal()
		end
		EventManager:GetInstance():AddListener(EventId.OnEnterCity, self.onEnterCitySignal)
	end
	self:AddWorldListener()
end

function WorldGotoManager:AddWorldListener()
	if self.updateMarchItemSignal == nil then
		self.updateMarchItemSignal = function()
			self:UpdateMarchItemSignal()
		end
		EventManager:GetInstance():AddListener(EventId.UpdateMarchItem, self.updateMarchItemSignal)
	end
	if self.updatePointsDataSignal == nil then
		self.updatePointsDataSignal = function()
			self:UpdatePointsDataSignal()
		end
		EventManager:GetInstance():AddListener(EventId.UPDATE_POINTS_DATA, self.updatePointsDataSignal)
	end
end

function WorldGotoManager:RemoveWorldListener()
	if self.updateMarchItemSignal ~= nil then
		EventManager:GetInstance():RemoveListener(EventId.UpdateMarchItem, self.updateMarchItemSignal)
		self.updateMarchItemSignal = nil
	end
	if self.updatePointsDataSignal ~= nil then
		EventManager:GetInstance():RemoveListener(EventId.UPDATE_POINTS_DATA, self.updatePointsDataSignal)
		self.updatePointsDataSignal = nil
	end
end

function WorldGotoManager:RemoveListener()
	if self.onEnterCitySignal ~= nil then
		EventManager:GetInstance():RemoveListener(EventId.OnEnterCity, self.onEnterCitySignal)
		self.onEnterCitySignal = nil
	end
	if self.pveLevelEnterSignal ~= nil then
		EventManager:GetInstance():RemoveListener(EventId.PveLevelEnter, self.pveLevelEnterSignal)
		self.pveLevelEnterSignal = nil
	end
	if self.onEnterWorldSignal ~= nil then
		EventManager:GetInstance():RemoveListener(EventId.OnEnterWorld, self.onEnterWorldSignal)
		self.onEnterWorldSignal = nil
	end
	self:RemoveWorldListener()
end

--处理行军更新
function WorldGotoManager:UpdateMarchItemSignal()
	if self.needWaitMarch ~= nil then
		local marchInfo = DataCenter.WorldMarchDataManager:GetMarch(self.needWaitMarch.uuid)
		if marchInfo ~= nil then
			if not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIWorldPoint) then
				--当前视觉中心点是要打开的点才打开界面
				local curTarget = CS.SceneManager.World.CurTarget
				local pointId = SceneUtils.WorldToTileIndex(curTarget)
				if pointId == self.needWaitMarch.pointId then
					UIUtil.OnClickWorldTroop(self.needWaitMarch.uuid)
				end
			end
			self.needWaitMarch = nil
		end
	end
end

--处理世界点更新
function WorldGotoManager:UpdatePointsDataSignal()
	if self.needWaitPoint ~= nil then
		local info = DataCenter.WorldPointManager:GetPointInfo(self.needWaitPoint.pointId)
		local worldTileInfo = CS.SceneManager.World:GetWorldTileInfo(self.needWaitPoint.pointId)
		if info ~= nil or worldTileInfo then
			if not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIWorldPoint) then
				--当前视觉中心点是要打开的点才打开界面
				local curTarget = CS.SceneManager.World.CurTarget
				local pointId = SceneUtils.WorldToTileIndex(curTarget)
				if pointId == self.needWaitPoint.pointId then
					UIUtil.OnClickWorld(self.needWaitPoint.pointId, self.needWaitPoint.worldType)
				end
			end
			self.needWaitPoint = nil
		end
	end
end

function WorldGotoManager:OnEnterCitySignal()
	self.needWaitPoint = nil
	self.needWaitMarch = nil
	self:RemoveWorldListener()
end
function WorldGotoManager:OnEnterWorldSignal()
	self:AddWorldListener()
end
function WorldGotoManager:PveLevelEnterSignal()
	self.needWaitPoint = nil
	self.needWaitMarch = nil
	self:RemoveWorldListener()
end

--移动到世界点然后点击打开页面（注意沙虫用MoveToWorldTroopAndOpen）
function WorldGotoManager:MoveToWorldPointAndOpen(pointId, type)
	local pos = SceneUtils.TileIndexToWorld(pointId, ForceChangeScene.World)
	GoToUtil.GotoWorldPos(pos,nil,nil,function ()
		local info = DataCenter.WorldPointManager:GetPointInfo(pointId)
		local worldTileInfo = CS.SceneManager.World:GetWorldTileInfo(pointId)
		if info ~= nil or worldTileInfo then
			UIUtil.OnClickWorld(pointId, type)
		else
			--保存下来
			local param = {}
			param.pointId = pointId
			param.worldType = type
			self.needWaitPoint = param
		end
	end)
end

--移动到世界行军然后点击打开页面（沙虫，世界boss, 行军）
function WorldGotoManager:MoveToWorldTroopAndOpen(pointId, uuid)
	local pos = SceneUtils.TileIndexToWorld(pointId, ForceChangeScene.World)
	GoToUtil.GotoWorldPos(pos,nil,nil,function ()
		if uuid ~= nil and uuid ~= 0 then
			local marchInfo = DataCenter.WorldMarchDataManager:GetMarch(uuid)
			if marchInfo ~= nil then
				UIUtil.OnClickWorldTroop(uuid)
			else
				--保存下来
				local param = {}
				param.pointId = pointId
				param.uuid = uuid
				self.needWaitMarch = param
			end
		end
	end)
end

return WorldGotoManager