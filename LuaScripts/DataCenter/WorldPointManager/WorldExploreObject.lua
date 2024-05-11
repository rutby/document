---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 19/3/2024 上午11:27
---
local base = WorldDetectEventItemObject
local WorldExploreObject = BaseClass("WorldExploreObject",WorldDetectEventItemObject)

function WorldExploreObject:NeedShowDetectEventIcon()
    return true
end
function WorldExploreObject:GetPointUid()
    local info = DataCenter.WorldPointManager:GetPointInfo(self.pointIndex)
    if info~=nil and info.explorePointInfo~=nil then
        return info.explorePointInfo.uuid
    end
    return 0
end
function WorldExploreObject:GetEventId()
    local info = DataCenter.WorldPointManager:GetPointInfo(self.pointIndex)
    if info~=nil and info.explorePointInfo~=nil then
        return info.explorePointInfo.eventId
    end
    return 0
end
function WorldExploreObject:GetModelPath()
    local str =GetTableData(TableName.DetectEvent,toInt(self.eventId),"image")
    return "Assets/Main/Prefabs/Monsters/"..str..".prefab"
end
function WorldExploreObject:NeedShowTime()
    return false
end

function WorldExploreObject:DoWhenCreateComplete(model)
    --if self.gameObject~=nil then
    --    self.gameObject:GetComponentsInChildren(typeof(CS.UIWorldLabel),true)
    --    
    --end
    
end
return WorldExploreObject