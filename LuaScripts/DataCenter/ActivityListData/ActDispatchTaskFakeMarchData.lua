---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 3/4/2024 下午5:16
---
--- 派遣任务假行军数据，仿照 FakeCollectGarbageMarchData
--- 目前只有单程行军了，去和回，去-到了目的地就消失，回=回到终点也消失
---@class ActDispatchTaskFakeMarchData
local ActDispatchTaskFakeMarchData = BaseClass("ActDispatchTaskFakeMarchData")

local retry_gap_time = 10000
local FakeMarchState = {
    FAKE_MARCH_STATE_NULL = 0,
    FAKE_MARCH_TO_GARBAGE = 1,
    FAKE_MARCH_COLLECT_GARBAGE = 2,
    FAKE_MARCH_GO_HOME = 3,
    FAKE_MARCH_ARRIVE_HOME = 4,
}

local function __init(self)
    self.startIndex = 0
    self.endIndex = 0
    self.startTime = 0
    self.GarbageStartTime = 0
    self.backHomeTime = 0
    self.arriveHomeTime = 0
    self.curState = FakeMarchState.FAKE_MARCH_STATE_NULL
end

local function __delete(self)
    self.startIndex = nil
    self.endIndex = nil
    self.startTime = nil
    self.GarbageStartTime = nil
    self.backHomeTime = nil
    self.arriveHomeTime = nil
end

local function SetStartAndEndIndex(self, pointIndex, startIndex, endIndex, backHome)
    self.pointIndex = pointIndex
    self.startIndex = startIndex
    self.endIndex = endIndex
    self.backHome = backHome
    --local data = CS.SceneManager.World:GetPointInfo(self.pointIndex)
    --self.pointUid = data.ownerUid
    --self.uuid = data.uuid

    --local detectEventData = DataCenter.RadarCenterDataManager:GetDetectEventInfoByPointId(self.pointIndex)
    --if detectEventData ~= nil then
    --    self.uuid = detectEventData.uuid
    --end
end

local function UpdateState(self, curTime)
    if self.curState == FakeMarchState.FAKE_MARCH_STATE_NULL then
        self:StartMarch()
    elseif self.curState == FakeMarchState.FAKE_MARCH_TO_GARBAGE and curTime >= self.GarbageStartTime then
        self:CheckAndStartCollectGarbage(curTime)
    elseif self.curState == FakeMarchState.FAKE_MARCH_COLLECT_GARBAGE and curTime >= self.backHomeTime then
        self:CheckAndGoBack(curTime)
    elseif self.curState == FakeMarchState.FAKE_MARCH_GO_HOME and curTime >= self.arriveHomeTime then
        self:CheckBackHome(curTime)
    end
    self:SendPickEndMessage()
end

---派遣任务 2个 单程假行军
local function StartMarch(self)
    if self.curState == FakeMarchState.FAKE_MARCH_STATE_NULL then
        local curTime = UITimeManager:GetInstance():GetServerTime()
        local marchTime = self:CalculateMarchTime()
        if self.backHome then
            self.curState = FakeMarchState.FAKE_MARCH_GO_HOME
            self.startTime = math.ceil(curTime)
            self.backHomeTime = self.startTime
            self.arriveHomeTime = math.ceil(curTime + marchTime)
            self.GarbageStartTime = self.arriveHomeTime
        else
            self.curState = FakeMarchState.FAKE_MARCH_TO_GARBAGE
            self.startTime = math.ceil(curTime)
            self.GarbageStartTime = math.ceil(curTime + marchTime)
            self.backHomeTime = math.ceil(self.GarbageStartTime + self:CalculateCollectGarbageTime())
            self.arriveHomeTime = math.ceil(self.backHomeTime + marchTime)
        end

        --SFSNetwork.SendMessage(MsgDefines.StartPickGarbage, self.pointUid)

        if CS.SceneManager:IsInWorld() then
            if self.backHome then
                DataCenter.WorldMarchDataManager:AddFakeSampleMarchData(self.startIndex, self.endIndex, self.startTime, self.GarbageStartTime, MarchTargetType.BACK_HOME)
                --CS.SceneManager.World:UpdateFakeSampleMarchDataWhenBack(self.endIndex, self.backHomeTime, self.arriveHomeTime + 500)
            else
                DataCenter.WorldMarchDataManager:AddFakeSampleMarchData(self.startIndex, self.endIndex, self.startTime, self.GarbageStartTime, MarchTargetType.DISPATCH_TASK)
            end
        end
    end
end

local function CheckAndStartCollectGarbage(self, curTime)
    if self.curState ~= FakeMarchState.FAKE_MARCH_COLLECT_GARBAGE and curTime >= self.GarbageStartTime then
        self.curState = FakeMarchState.FAKE_MARCH_COLLECT_GARBAGE
        if CS.SceneManager:IsInWorld() then
            DataCenter.WorldMarchDataManager:UpdateFakeSampleMarchDataWhenStartPick(self.endIndex, self.backHomeTime)
        end
    end
end

local function CheckAndGoBack(self, curTime)
    if self.curState ~= FakeMarchState.FAKE_MARCH_GO_HOME and curTime >= self.backHomeTime then
        self.curState = FakeMarchState.FAKE_MARCH_GO_HOME
        if CS.SceneManager:IsInWorld() then
            DataCenter.WorldMarchDataManager:UpdateFakeSampleMarchDataWhenBack(self.endIndex, self.backHomeTime, self.arriveHomeTime + 1000)
        end
    end
end

local function SendPickEndMessage(self)
    --if self.curState == FakeMarchState.FAKE_MARCH_GO_HOME or self.curState == FakeMarchState.FAKE_MARCH_ARRIVE_HOME then
    --    local now = UITimeManager:GetInstance():GetServerTime()
    --
    --    if self.uuid ~= nil and (self.callTime == nil or now - self.callTime > retry_gap_time) then
    --        self.callTime = now
    --        --SFSNetwork.SendMessage(MsgDefines.FinishSampling, self.uuid)
    --        --Logger.LogError("Fake_Sample_3")
    --    end
    --end
end

local function CheckBackHome(self, curTime)
    if self.curState == FakeMarchState.FAKE_MARCH_GO_HOME and curTime >= self.arriveHomeTime then
        self.curState = FakeMarchState.FAKE_MARCH_ARRIVE_HOME
        self:Remove()
    end
end

local function CalculateMarchTime(self)
    local startPt = SceneUtils.IndexToTilePos(self.startIndex, ForceChangeScene.World)
    local endPt = SceneUtils.IndexToTilePos(self.endIndex, ForceChangeScene.World)
    local dis = Vector2.Distance(startPt, endPt)
    local speed = LuaEntry.DataConfig:TryGetNum("armyspeed", "k2") -- speed
    local time = math.ceil(dis * 1000 / speed)
    return time
end

local function CalculateCollectGarbageTime(self)
    local info = CS.SceneManager.World:GetPointInfo(self.pointIndex)
    if info == nil or string.IsNullOrEmpty(info.pointIndex) then
        return 1
    end
    local cfg = LocalController:instance():getLine(TableName.LwDispatchTask, info.cfgId)
    if cfg == nil then
        return 1
    end
    if string.IsNullOrEmpty(cfg.times) then
        return 1
    end
    return toInt(cfg.times) * 1000
end

local function Remove(self)
    --Logger.LogError("Fake_Sample_4")
    if CS.SceneManager:IsInWorld() then
        DataCenter.WorldMarchDataManager:RemoveFakeSampleMarchData(self.endIndex)
        EventManager:GetInstance():Broadcast(EventId.MarchItemUpdateSelf)
    end
end

local function NeedRemove(self)
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if self.curState == FakeMarchState.FAKE_MARCH_TO_GARBAGE and curTime >= self.GarbageStartTime then
        return true
    end
    if self.curState == FakeMarchState.FAKE_MARCH_ARRIVE_HOME and curTime >= self.arriveHomeTime then
        return true
    end
    return false
end

local function IsEventDoing(self)
    return self.curState == FakeMarchState.FAKE_MARCH_TO_GARBAGE or self.curState == FakeMarchState.FAKE_MARCH_COLLECT_GARBAGE
end

local function DoWhenBackToWorld(self)
    if CS.SceneManager.World:ExistMarch(self.endIndex) then
        return
    end
    local pointInfo = CS.SceneManager.World:GetPointInfo(self.endIndex)
    if pointInfo == nil then
        return
    end
    if self.curState == FakeMarchState.FAKE_MARCH_TO_GARBAGE or self.curState == FakeMarchState.FAKE_MARCH_GO_HOME then
        --local marchTime = self:CalculateMarchTime()
        --local curTime = UITimeManager:GetInstance():GetServerTime()
        --self.curState = FakeMarchState.FAKE_MARCH_TO_GARBAGE
        --self.startTime = math.ceil(curTime)
        --self.GarbageStartTime =  math.ceil(curTime + marchTime)
        --self.backHomeTime =  math.ceil(self.GarbageStartTime + self:CalculateCollectGarbageTime())
        --self.arriveHomeTime =  math.ceil(self.backHomeTime + marchTime)
        if CS.SceneManager:IsInWorld() then
            DataCenter.WorldMarchDataManager:RemoveFakeSampleMarchData(self.endIndex)
            DataCenter.WorldMarchDataManager:AddFakeSampleMarchData(self.startIndex, self.endIndex, self.startTime, self.GarbageStartTime, MarchTargetType.DISPATCH_TASK)
        end
        
    else
        self.curState = FakeMarchState.FAKE_MARCH_ARRIVE_HOME
        self:UpdateState(UITimeManager:GetInstance():GetServerTime())
    end
end

ActDispatchTaskFakeMarchData.__init = __init
ActDispatchTaskFakeMarchData.__delete = __delete
ActDispatchTaskFakeMarchData.SetStartAndEndIndex = SetStartAndEndIndex
ActDispatchTaskFakeMarchData.StartMarch = StartMarch
ActDispatchTaskFakeMarchData.CheckAndStartCollectGarbage = CheckAndStartCollectGarbage
ActDispatchTaskFakeMarchData.CheckAndGoBack = CheckAndGoBack
ActDispatchTaskFakeMarchData.CalculateMarchTime = CalculateMarchTime
ActDispatchTaskFakeMarchData.CalculateCollectGarbageTime = CalculateCollectGarbageTime
ActDispatchTaskFakeMarchData.UpdateState = UpdateState
ActDispatchTaskFakeMarchData.Remove = Remove
ActDispatchTaskFakeMarchData.CheckBackHome = CheckBackHome
ActDispatchTaskFakeMarchData.SendPickEndMessage = SendPickEndMessage
ActDispatchTaskFakeMarchData.NeedRemove = NeedRemove
ActDispatchTaskFakeMarchData.IsEventDoing = IsEventDoing
ActDispatchTaskFakeMarchData.DoWhenBackToWorld = DoWhenBackToWorld

return ActDispatchTaskFakeMarchData