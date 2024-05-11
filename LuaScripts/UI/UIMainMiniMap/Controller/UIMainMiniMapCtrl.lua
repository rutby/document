---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2022/11/16 21:09
---
local UIMainMiniMapCtrl = BaseClass("UIMainMiniMapCtrl", UIBaseCtrl)

local function CloseSelf(self)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIMainMiniMap)
end

local function GetCityPointData(self,length)
    local oneData = {}
    oneData.list = {}
    oneData.isNew = false
    if LuaEntry.Player:IsInAlliance() then
        local list = DataCenter.WorldPointManager:GetSelfAllianceList()
        if list~=nil then
            for k,v in pairs(list) do
                local state = WorldBuildUtil.GetPlayerType(v)
                if state == PlayerType.PlayerSelf or state == PlayerType.PlayerAlliance or state == PlayerType.PlayerAllianceLeader then
                    local temp ={}
                    temp.pType = state
                    temp.pos = SceneUtils.IndexToTilePos(v.id,ForceChangeScene.World)
                    table.insert(oneData.list,temp)
                end
            end
        end
    else
        local temp ={}
        temp.pType = PlayerType.PlayerSelf
        temp.pos = SceneUtils.IndexToTilePos(LuaEntry.Player:GetMainWorldPos(),ForceChangeScene.World)
        table.insert(oneData.list,temp)
    end
    if #oneData.list~=length then
        oneData.isNew = true
    end
    return oneData
end

local function GetDragonPointData(self)
    local oneData = {}
    oneData.list = {}
    local list = DataCenter.WorldPointManager:GetDragonPointDic()
    if list~=nil then
        for k,v in pairs(list) do
            local temp ={}
            local icon,scale = WorldBuildUtil.GetDragonBuildLodIcon(v)
            temp.icon = icon
            temp.scale = scale
            temp.pos = SceneUtils.IndexToTilePos(v.id,ForceChangeScene.World)
            table.insert(oneData.list,temp)
        end
    end
    return oneData
end

local function GetAttackerPointData(self)
    local oneData = {}
    oneData.list = {}
    local msg = DataCenter.WorldNewsDataManager:GetAttackerInfoPointMsg()
    if msg~=nil then
        if msg.server == LuaEntry.Player:GetCurServerId() then
            local arr = msg.arr
            for k,v in pairs(arr) do
                local temp ={}
                temp.uid = v.uid
                temp.pos = SceneUtils.IndexToTilePos(v.p,ForceChangeScene.World)
                table.insert(oneData.list,temp)
            end
        end
    end
    return oneData
end
UIMainMiniMapCtrl.CloseSelf = CloseSelf
UIMainMiniMapCtrl.GetCityPointData= GetCityPointData
UIMainMiniMapCtrl.GetAttackerPointData = GetAttackerPointData
UIMainMiniMapCtrl.GetDragonPointData = GetDragonPointData
return UIMainMiniMapCtrl