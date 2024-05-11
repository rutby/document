---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 16/1/2024 下午9:28
---
local UIQueueListCtrl = BaseClass("UIQueueListCtrl", UIBaseCtrl)

local function CloseSelf(self)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIQueueList)
end

function UIQueueListCtrl:GetBuildQueueListId()
    local showList = {}
    local list = DataCenter.BuildQueueManager:GetQueueValueList()
    if list~=nil then
        table.sort(list, function(a,b)
            return a.index<b.index
        end)
        local hasUnlock = false
        local robotId = LuaEntry.DataConfig:TryGetNum("robot_free", "k2")
        for i = 1,#list do
            local uuid = list[i].uuid
            if list[i].robotId == robotId then
                hasUnlock = true
            end 
            table.insert(showList,uuid)
        end
        if hasUnlock ==false then
            local giftId = toInt(GetTableData(TableName.Robot,robotId,"gift"))
            if giftId~=nil and giftId~=0 then
                table.insert(showList,robotId)
            end
        end
    end
    return showList
end

function UIQueueListCtrl:GetArmyQueueListId()
    local showList = {}
    local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_INFANTRY_BARRACK)
    if buildData ~= nil and buildData.level > 0 then
        local list = DataCenter.QueueDataManager:GetAllQueueByType(NewQueueType.FootSoldier)
        if list~=nil and #list>0 then
            for i=1,#list do
                table.insert(showList,list[i].uuid)
            end
        end
    end
    buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_CAR_BARRACK)
    if buildData ~= nil and buildData.level > 0 then
        local list = DataCenter.QueueDataManager:GetAllQueueByType(NewQueueType.CarSoldier)
        if list~=nil and #list>0 then
            for i=1,#list do
                table.insert(showList,list[i].uuid)
            end
        end
    end
    buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_AIRCRAFT_BARRACK)
    if buildData ~= nil and buildData.level > 0 then
        local list = DataCenter.QueueDataManager:GetAllQueueByType(NewQueueType.BowSoldier)
        if list~=nil and #list>0 then
            for i=1,#list do
                table.insert(showList,list[i].uuid)
            end
        end
    end
    
    return showList
end

function UIQueueListCtrl:GetScienceQueueListId()
    local showList = {}
    local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_SCIENE)
    if buildData ~= nil and buildData.level > 0 then
        local list = DataCenter.QueueDataManager:GetAllQueueByType(NewQueueType.Science)
        if list~=nil and #list>0 then
            for i=1,#list do
                table.insert(showList,list[i].uuid)
            end
        end
    end
    return showList
end

function UIQueueListCtrl:GetFormationListId()
    local list = {}
    for i = 1,FormationMaxNum do
        local formationInfo = DataCenter.ArmyFormationDataManager:GetOneArmyInfoByIndex(i)
        if formationInfo~=nil then
            table.insert(list,formationInfo.uuid)
        else
            table.insert(list,i)
        end
    end
    return list
end

function UIQueueListCtrl:GetStateDes(status)
    if status == MarchStatus.ATTACKING then
        return "120125"
    end
    if status == MarchStatus.MOVING or status == MarchStatus.CHASING then
        return "120166"
    end
    if status == MarchStatus.ASSISTANCE then
        return "120165"
    end
    if status == MarchStatus.COLLECTING then
        return "300039"
    end
    return "300542"
end

function UIQueueListCtrl:GetTargetDes(targetType)
    if targetType == MarchTargetType.STATE then
        return "100610"
    end
    if targetType == MarchTargetType.ATTACK_MONSTER then
        return "470083"
    end
    if targetType == MarchTargetType.COLLECT or targetType == MarchTargetType.BUILD_ALLIANCE_BUILDING or targetType == MarchTargetType.COLLECT_ALLIANCE_BUILD_RESOURCE or targetType == MarchTargetType.ASSISTANCE_COLLECT_ACT_ALLIANCE_MINE then
        return "121487"
    end
    if targetType == MarchTargetType.BACK_HOME then
        return "470084"
    end
    if targetType == MarchTargetType.ATTACK_BUILDING or targetType == MarchTargetType.ATTACK_ALLIANCE_BUILDING or targetType == MarchTargetType.ATTACK_ACT_ALLIANCE_MINE or targetType ==  MarchTargetType.ATTACK_DRAGON_BUILDING or targetType == MarchTargetType.TRIGGER_DRAGON_BUILDING then
        return "121486"
    end
    if targetType == MarchTargetType.ATTACK_ARMY then
        return "121491"
    end
    if targetType == MarchTargetType.JOIN_RALLY then
        return "121489"
    end
    if targetType == MarchTargetType.RALLY_FOR_BOSS then
        return "121490"
    end
    if targetType == MarchTargetType.RALLY_FOR_BUILDING  or targetType == MarchTargetType.RALLY_FOR_ACT_ALLIANCE_MINE then
        return "121490"
    end
    if targetType == MarchTargetType.ATTACK_ARMY_COLLECT then
        return "121491"
    end
    if targetType == MarchTargetType.ATTACK_CITY or targetType == MarchTargetType.DIRECT_ATTACK_CITY then
        return "121492"
    end
    if targetType == MarchTargetType.RALLY_FOR_CITY then
        return "121493"
    end
    if targetType == MarchTargetType.ASSISTANCE_BUILD then
        return "121494"
    end
    if targetType == MarchTargetType.ASSISTANCE_CITY then
        return "121495"
    end
    if targetType == MarchTargetType.GO_WORM_HOLE then
        return "121496"
    end
    if targetType == MarchTargetType.ATTACK_ALLIANCE_CITY then
        return "121500"
    end
    if targetType == MarchTargetType.ASSISTANCE_ALLIANCE_CITY or targetType == MarchTargetType.ASSISTANCE_ALLIANCE_BUILDING or targetType == MarchTargetType.RALLY_ASSISTANCE_THRONE or targetType == MarchTargetType.ASSISTANCE_DRAGON_BUILDING then
        return "121501"
    end
    if targetType == MarchTargetType.RALLY_FOR_ALLIANCE_CITY or targetType == MarchTargetType.RALLY_ALLIANCE_BUILDING or targetType == MarchTargetType.RALLY_THRONE or targetType == MarchTargetType.RALLY_DRAGON_BUILDING then
        return "121502"
    end
    if targetType == MarchTargetType.BUILD_WORM_HOLE then
        return "121503"
    end
    if targetType == MarchTargetType.TRANSPORT_ACT_BOSS then
        return "121504"
    end
    if targetType == MarchTargetType.DIRECT_ATTACK_ACT_BOSS then
        return "121486"
    end
    if targetType == MarchTargetType.CROSS_SERVER_WORM then
        return "121505"
    end
    return "121485"
end

UIQueueListCtrl.CloseSelf = CloseSelf

return UIQueueListCtrl