---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2022/3/7 11:15
---


local AlLeaderElectManager = BaseClass("AlLeaderElectManager");

local function Startup()
end

local function __init(self)
    self.candidateList = {}
    self:AddListener()
end

local function AddListener(self)
    --EventManager:GetInstance():AddListener(EventId.TrainingArmy, self.OnBuildTrainingStartSignal)
end

local function RemoveListener(self)
    --EventManager:GetInstance():RemoveListener(EventId.GetAllDetectInfo, self.CheckDetectEventSignal)
end

local function __delete(self)
    self.candidateList = nil
end

local function AddOrUpdateOneCandidate(self, t)
    if t["userInfo"] then
        local updatedUid = nil
        for i = 1, #self.candidateList do
            if self.candidateList[i].uid == t["userInfo"].uid then
                self.candidateList[i]:ParseData(t["userInfo"])
                updatedUid = self.candidateList[i].uid
                break
            end
        end
        if not updatedUid then
            local newOne = AlLeaderCandidateData.New()
            newOne:ParseData(t["userInfo"])
            table.insert(self.candidateList, newOne)
        end
        self:ResortCandidateList()
        
        EventManager:GetInstance():Broadcast(EventId.OnUpdateAlLeaderCandidates, updatedUid)
    end
end

local function ResortCandidateList(self)
    local serverT = UITimeManager:GetInstance():GetServerTime()
    local onLineTime = 15 * 3600000
    table.sort(self.candidateList, function(a, b)
        if a.uid == LuaEntry.Player.uid then
            return true
        elseif b.uid == LuaEntry.Player.uid then
            return false
        else
            local memberA = DataCenter.AllianceMemberDataManager:GetAllianceMemberByUid(a.uid)
            local offlineTimeA = serverT - (memberA and memberA.offLineTime or 0)
            local orderA = (offlineTimeA < onLineTime and 32 or 0)
            local memberB = DataCenter.AllianceMemberDataManager:GetAllianceMemberByUid(b.uid)
            local offlineTimeB = serverT - (memberB and memberB.offLineTime or 0)
            local orderB = (offlineTimeB < onLineTime and 32 or 0)
            if not string.IsNullOrEmpty(a.voteSlogan) then
                if string.len(a.voteSlogan) > 200 then
                    orderA = orderA + 16
                else
                    orderA = orderA + 8
                end
            end
            --orderA = orderA + ((not string.IsNullOrEmpty(a.voteSlogan)) and 8 or 0)
            if not string.IsNullOrEmpty(b.voteSlogan) then
                if string.len(b.voteSlogan) > 200 then
                    orderB = orderB + 16
                else
                    orderB = orderB + 8
                end
            end
            --orderB = orderB + ((not string.IsNullOrEmpty(b.voteSlogan)) and 8 or 0)
            orderA = orderA + (string.IsNullOrEmpty(a.pic) and 4 or 0)
            orderB = orderB + (string.IsNullOrEmpty(b.pic) and 4 or 0)

            if orderA ~= orderB then
                return orderA > orderB
            elseif a.power ~= b.power then
                return a.power > b.power
            else
                return a.uid < b.uid
            end
        end
    end)
end

local function UpdateCandidatesList(self, t)
    if t["userList"] then
        self.candidateList = {}
        for i, v in ipairs(t["userList"]) do
            local newOne = AlLeaderCandidateData.New()
            newOne:ParseData(v)
            table.insert(self.candidateList, newOne)
        end
        self:ResortCandidateList()
        EventManager:GetInstance():Broadcast(EventId.OnUpdateAlLeaderCandidates)
    end
end

local function OnRecvVoteResult(self, t)
    if t["voteList"] then
        local baseInfo = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
        if baseInfo then
            baseInfo:UpdateVoteList(t["voteList"])
        end
    end
    if t["userInfo"] then
        self:AddOrUpdateOneCandidate(t)
    end

    EventManager:GetInstance():Broadcast(EventId.OnUpdateAlLeaderCandidates)
end

--return:stage,endTime
local function GetCurElectStage(self)
    local baseInfo = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
    if baseInfo then
        return baseInfo.sysAlState, baseInfo.stateEndTime
    end
end

local function CheckIfSignedUp(self)
    local baseInfo = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
    if baseInfo then
        return baseInfo.register == 1
    end
end

local function CheckIfLeaderElecting(self)
    local baseInfo = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
    if baseInfo then
        return (baseInfo.sysAlState >= SysAlState.SignUp and baseInfo.sysAlState <= SysAlState.LeaderResult)
    end
end

local function GetCandidatesList(self)
    return self.candidateList
end

local function GetMyVoted(self)
    local baseInfo = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
    local retTb = {}
    if baseInfo then
        for i, v in ipairs(baseInfo.voteList) do
            if baseInfo.sysAlState == SysAlState.R4Elect then
                if v.type == 0 then
                    table.insert(retTb, v.voteUid)
                end
            elseif baseInfo.sysAlState == SysAlState.LeaderElect then
                if v.type == 1 then
                    table.insert(retTb, v.voteUid)
                end
            end
        end
    end
    return retTb
end

local function CheckModuleUnlocked(self)
    local unlockLv = LuaEntry.DataConfig:TryGetNum("union_Election", "k6")
    local mainLv = DataCenter.BuildManager.MainLv
    local unlocked = mainLv >= unlockLv
    return unlocked
end

local function GetAlElectRedCount(self)
    if not self:CheckModuleUnlocked() then
        return 0
    end
    
    local stage = self:GetCurElectStage()
    local redK = self:GetRedKey(stage)
    if stage == SysAlState.SignUp or stage == SysAlState.R4Reuslt or stage == SysAlState.LeaderResult then
        local isShow = CS.GameEntry.Setting:GetInt(redK, 1)
        return isShow
    elseif stage == SysAlState.R4Elect or stage == SysAlState.LeaderElect then
        local myVoted = self:GetMyVoted()
        local maxNum = 0
        if stage == SysAlState.R4Elect then
            LuaEntry.DataConfig:TryGetNum("union_Election", "k8")
        elseif stage == SysAlState.LeaderElect then
            LuaEntry.DataConfig:TryGetNum("union_Election", "k11")
        end
        local remainTimes = maxNum - (#myVoted)
        remainTimes = remainTimes < 0 and 0 or remainTimes
        return remainTimes
    end
end

local function SetCurStageChecked(self)
    local stage = self:GetCurElectStage()
    local redK = self:GetRedKey(stage)
    if stage == SysAlState.SignUp or stage == SysAlState.R4Reuslt or stage == SysAlState.LeaderResult then
        CS.GameEntry.Setting:SetInt(redK, 0)
        EventManager:GetInstance():Broadcast(EventId.UpdateAlElectRed)
    end
end

local function GetRedKey(self, stage)
    return "AlElectRed_" .. stage .. "_" .. LuaEntry.Player.uid .. "_" .. LuaEntry.Player.allianceId
end

AlLeaderElectManager.Startup = Startup
AlLeaderElectManager.__init = __init
AlLeaderElectManager.__delete = __delete
AlLeaderElectManager.AddListener = AddListener
AlLeaderElectManager.RemoveListener = RemoveListener

AlLeaderElectManager.GetCurElectStage = GetCurElectStage
AlLeaderElectManager.CheckIfLeaderElecting = CheckIfLeaderElecting
AlLeaderElectManager.GetCandidatesList = GetCandidatesList
AlLeaderElectManager.CheckIfSignedUp = CheckIfSignedUp
AlLeaderElectManager.GetMyVoted = GetMyVoted
AlLeaderElectManager.UpdateCandidatesList = UpdateCandidatesList
AlLeaderElectManager.AddOrUpdateOneCandidate = AddOrUpdateOneCandidate
AlLeaderElectManager.ResortCandidateList = ResortCandidateList
AlLeaderElectManager.OnRecvVoteResult = OnRecvVoteResult
AlLeaderElectManager.CheckModuleUnlocked = CheckModuleUnlocked
AlLeaderElectManager.GetAlElectRedCount = GetAlElectRedCount
AlLeaderElectManager.SetCurStageChecked = SetCurStageChecked
AlLeaderElectManager.GetRedKey = GetRedKey

return AlLeaderElectManager