---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 19/3/2024 上午11:26
---
local base = WorldDetectEventItemObject
local WorldHighSpeedCollectObject = BaseClass("WorldHighSpeedCollectObject",WorldDetectEventItemObject)

function WorldHighSpeedCollectObject:NeedShowDetectEventIcon()
    return true
end

function WorldHighSpeedCollectObject:GetPointUid()
    local info = DataCenter.WorldPointManager:GetPointInfo(self.pointIndex)
    if info~=nil and info.resourceInfo~=nil then
        return info.resourceInfo.uuid
    end
    return 0
end

function WorldHighSpeedCollectObject:GetEventId()
    local info = DataCenter.WorldPointManager:GetPointInfo(self.pointIndex)
    if info~=nil and info.resourceInfo~=nil then
        return info.resourceInfo.eventId
    end
    return 0
end

function WorldHighSpeedCollectObject:GetModelPath()
    local info = DataCenter.WorldPointManager:GetPointInfo(self.pointIndex)
    if info~=nil and info.resourceInfo~=nil then
        local id = info.resourceInfo.resourceId
        local resModel = GetTableData(TableName.GatherResource,id,"model")
        if resModel~=nil and resModel~="" then
            return "Assets/Main/Prefabs/HighSpeedCollectResource/HighSpeed"..resModel..".prefab"
        end
    end
	return "Assets/Main/Prefabs/HighSpeedCollectResource/HighSpeedCollectResourcesGold_world.prefab"
end

function WorldHighSpeedCollectObject:NeedShowTime()
    local info = DataCenter.WorldPointManager:GetPointInfo(self.pointIndex)
    if info~=nil and info.resourceInfo~=nil then
        local showProgress = false
        self.pickupStartTime = 0
        self.pickupEndTime = 0
        self.collectSpd = 0
        local march = DataCenter.WorldMarchDataManager:GetMarch(info.resourceInfo.gatherUuid)
        if march~=nil and march:GetMarchStatus() == MarchStatus.COLLECTING then
            showProgress = true
            self.pickupStartTime = march.startTime
            self.pickupEndTime = march.endTime
            self.collectSpd = march.collectSpd
        end
        return showProgress
    end
    return false
end

function WorldHighSpeedCollectObject:NeedShowCollectSpeed()
    local info = DataCenter.WorldPointManager:GetPointInfo(self.pointIndex)
    if info~=nil and info.resourceInfo~=nil then
        local showCollectSpd = false
        self.collectSpd = 0
        local march = DataCenter.WorldMarchDataManager:GetMarch(info.resourceInfo.gatherUuid)
        if march~=nil and march:GetMarchStatus() == MarchStatus.COLLECTING then
            showCollectSpd = true
            self.collectSpd = march.collectSpd
        end
        return showCollectSpd
    end
    return false
end

return WorldHighSpeedCollectObject