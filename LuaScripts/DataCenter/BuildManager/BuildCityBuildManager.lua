--- Created by shimin.
--- DateTime: 2023/11/24 00:05
--- 0级假建筑管理器

local BuildCityBuildManager = BaseClass("BuildCityBuildManager")
local BuildCityBuildInfo = require "DataCenter.BuildManager.BuildCityBuildInfo"

function BuildCityBuildManager:__init()
    self.cityBuildDic = {}--所有城内建筑<pointId, cityBuildInfo>
    self.cityBuildIdDic = {}--所有城内建筑<buildId, cityBuildInfo>
    self:AddListener()
end

function BuildCityBuildManager:__delete()
    self:RemoveListener()
    self.cityBuildDic = {}--所有城内建筑<pointId, cityBuildInfo>
    self.cityBuildIdDic = {}--所有城内建筑<buildId, cityBuildInfo>
end

function BuildCityBuildManager:Startup()
end

function BuildCityBuildManager:AddListener()
    if self.buildUpgradeFinishSignal == nil then
        self.buildUpgradeFinishSignal = function(param)
            self:BuildUpgradeFinishSignal(param)
        end
        EventManager:GetInstance():AddListener(EventId.BuildUpgradeFinish , self.buildUpgradeFinishSignal)--建筑升级完成
    end
    if self.updateScienceDataSignal == nil then
        self.updateScienceDataSignal = function()
            self:UpdateScienceDataSignal()
        end
        EventManager:GetInstance():AddListener(EventId.UPDATE_SCIENCE_DATA , self.updateScienceDataSignal)--刷新科技
    end

    if self.vipDataRefreshSignal == nil then
        self.vipDataRefreshSignal = function()
            self:VipDataRefreshSignal()
        end
        EventManager:GetInstance():AddListener(EventId.VipDataRefresh , self.vipDataRefreshSignal)--刷新vip
    end
    if self.landDataRefreshSignal == nil then
        self.landDataRefreshSignal = function()
            self:LandDataRefreshSignal()
        end
        EventManager:GetInstance():AddListener(EventId.LandReceiveReward , self.landDataRefreshSignal)--刷新地块领取奖励
        EventManager:GetInstance():AddListener(EventId.LandDataRefresh , self.landDataRefreshSignal)--刷新地块数据
    end
    
end

function BuildCityBuildManager:RemoveListener()
    if self.buildUpgradeFinishSignal ~= nil then
        EventManager:GetInstance():RemoveListener(EventId.BuildUpgradeFinish, self.buildUpgradeFinishSignal)--建筑升级完成
        self.buildUpgradeFinishSignal = nil
    end
    if self.updateScienceDataSignal ~= nil then
        EventManager:GetInstance():RemoveListener(EventId.UPDATE_SCIENCE_DATA, self.updateScienceDataSignal)--刷新科技
        self.updateScienceDataSignal = nil
    end
    if self.vipDataRefreshSignal ~= nil then
        EventManager:GetInstance():RemoveListener(EventId.VipDataRefresh, self.vipDataRefreshSignal)--刷新vip
        self.vipDataRefreshSignal = nil
    end
    if self.landDataRefreshSignal ~= nil then
        EventManager:GetInstance():RemoveListener(EventId.LandReceiveReward , self.landDataRefreshSignal)--刷新地块领取奖励
        EventManager:GetInstance():RemoveListener(EventId.LandDataRefresh, self.landDataRefreshSignal)--刷新地块数据
        self.landDataRefreshSignal = nil
    end
end

function BuildCityBuildManager:InitData()
    self.cityBuildDic = {}
    self.cityBuildIdDic = {}
    local pointIndex = 0 
    local all = DataCenter.BuildTemplateManager:GetAllBuildingDesTemplate()
    for k, v in pairs(all) do
        pointIndex = v:GetPosIndex()
        if pointIndex ~= 0 then
            local info = BuildCityBuildInfo.New()
            info:InitData(pointIndex, v.id)
            self.cityBuildDic[pointIndex] = info
            self.cityBuildIdDic[v.id] = info
        end
    end
end

function BuildCityBuildManager:Refresh()
    local refresh = false
    for k,v in pairs(self.cityBuildDic) do
        refresh = v:Refresh()
        if refresh then
            EventManager:GetInstance():Broadcast(EventId.RefreshCityBuildModel, k)
        end
    end
end

function BuildCityBuildManager:GetAllData()
    return self.cityBuildDic
end

function BuildCityBuildManager:GetCityBuildDataByPoint(pointId)
    return self.cityBuildDic[pointId]
end

function BuildCityBuildManager:BuildUpgradeFinishSignal()
    self:Refresh()
end

function BuildCityBuildManager:UpdateScienceDataSignal()
    self:Refresh()
end

function BuildCityBuildManager:GetCanUpgradeBuildId()
    local level = -1
    local buildId = 0
    for k, v in pairs(self.cityBuildDic) do
        if v:CanBuildUpgradeJump() then
            local buildData = DataCenter.BuildManager:GetFunbuildByItemID(v.buildId)
            if buildData ~= nil and buildData.level > 0 then
                if level<0 or (level>0 and level > buildData.level) then
                    level = buildData.level
                    buildId = v.buildId
                end
            end
        end
    end
    return buildId
end

function BuildCityBuildManager:LandUnlockZoneSignal()
    self:Refresh()
end

function BuildCityBuildManager:VipDataRefreshSignal()
    self:Refresh()
end

function BuildCityBuildManager:GetCityBuildDataByBuildId(buildId)
    return self.cityBuildIdDic[buildId]
end

function BuildCityBuildManager:LandDataRefreshSignal()
    self:Refresh()
end

--已解锁还没建造的建筑
function BuildCityBuildManager:GetCanCreateBuildIdList()
    local result = {}
    for k, v in pairs(self.cityBuildDic) do
        if v.state == BuildCityBuildState.Fake then
            table.insert(result, v.buildId)
        end
    end
    return result
end

--延迟显示建筑处理
function BuildCityBuildManager:SetBuildNoShow(canShow)
    if DataCenter.GuideManager:IsStartCanShowBuild() ~= canShow then
        DataCenter.GuideManager:SetCanShowBuild(canShow)
        if canShow then
            EventManager:GetInstance():Broadcast(EventId.ShowAllGuideObject)
        end
    end
end

function BuildCityBuildManager:CheckAddBuildModelVisible(buildId)
    if not DataCenter.GuideManager:IsStartCanShowBuild() then
        local cityData = self:GetCityBuildDataByBuildId(buildId)
        if cityData ~= nil then
            local build = CS.SceneManager.World:GetObjectByPointId(cityData.pointId)
            if build ~= nil then
                build:SetIsVisible(false)
            end
        end
    end
end

return BuildCityBuildManager
