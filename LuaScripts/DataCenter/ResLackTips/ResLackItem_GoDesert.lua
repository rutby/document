---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zzl.
--- DateTime: 
---
--[[
跳转赛季地块
]]

local ResLackItemBase = require "DataCenter.ResLackTips.ResLackItemBase"
local ResLackItem_GoDesert = BaseClass("ResLackItem_GoDesert", ResLackItemBase)

function ResLackItem_GoDesert:CheckIsOk( _resType, _needCnt )
    --local lv = 99
    local type = nil
    if _resType == 0 then
        type = 1
    elseif _resType == 13 then
        type = 2
    end
    if type then
        if CS.SceneManager.World.GetDesertPoint ~= nil then
            local param = self._config.para1
            local dic = DataCenter.DesertDataManager:GetAllMyDesert()
            if param == "" then
                --找最高级
                local lv = 0
                for i ,v in pairs(dic) do
                    if v.level > lv  then
                        lv = v.level
                    end
                end
                if lv > 0 then
                    local desertMap = CS.SceneManager.World:GetDesertPointList()
                    for k,v in pairs(desertMap) do
                        local pi = v:GetWorldDesertInfo()
                        local desertLv = GetTableData(TableName.Desert, pi.desertId, "desert_level")
                        local typeNew = pi:GetPlayerType()
                        if typeNew == CS.PlayerType.PlayerNone then
                            if lv <= desertLv then
                                local pointInfo = DataCenter.WorldPointManager:GetPointInfo(pi.pointIndex)
                                if pointInfo == nil then
                                    self.pointIndex = pi.pointIndex
                                    return true
                                end
                            end
                        end
                    end
                else
                    local pointIndex = CS.SceneManager.World:GetDesertPoint(1,type)
                    if pointIndex ~= 0 then
                        self.pointIndex = pointIndex
                        return true
                    end
                end
            elseif tonumber(param) == 1 or tonumber(param) == 2 then
                --找自己的最高等级地
                if dic and next(dic) then
                    local list = {}
                    for i ,v in pairs(dic) do
                        local data = {}
                        local tilePos = SceneUtils.IndexToTilePos(v.pointId)
                        local distance = math.ceil(SceneUtils.TileDistance(tilePos, SceneUtils.IndexToTilePos(LuaEntry.Player:GetMainWorldPos(),ForceChangeScene.World)))
                        data.dis = distance
                        data.level = v.level
                        data.pointId = v.pointId
                        table.insert(list,data)
                    end
                    if tonumber(param) == 1 then
                        table.sort(list,function(a,b)
                            if a.level > b.level then
                                return true
                            elseif a.level == b.level then
                                return a.dis < b.dis
                            end
                            return false
                        end)
                    elseif tonumber(param) == 2 then
                        table.sort(list,function(a,b)
                            if a.level < b.level then
                                return true
                            elseif a.level == b.level then
                                return a.dis < b.dis
                            end
                            return false
                        end)
                    end
                    self.pointIndex = list[1].pointId
                    return true
                end
            end
        end
    end
    return false
end

function ResLackItem_GoDesert:TodoAction()
    GoToUtil.CloseAllWindows()
    local worldPos = SceneUtils.TileIndexToWorld(self.pointIndex, ForceChangeScene.World)
    GoToUtil.GotoWorldPos(worldPos, CS.SceneManager.World.InitZoom,LookAtFocusTime,function()
        local ownerUid = ""
        local isAlliance = 0
        local desertId = 0
        local uuid = 0
        local desertData = DataCenter.DesertDataManager:GetDesertDataByPoint(self.pointIndex)
        if desertData~=nil then
            desertId = desertData.desertId
            ownerUid = LuaEntry.Player.uid
            isAlliance =1
            uuid = desertData.uuid
        else
            local worldTileInfo = CS.SceneManager.World:GetWorldTileInfo(self.pointIndex)
            if worldTileInfo~=nil then
                local desertInfo = worldTileInfo:GetWorldDesertInfo()
                if desertInfo~=nil then
                    ownerUid = desertInfo.ownerUid
                    local allianceId = desertInfo.allianceId
                    if allianceId ~= "" and allianceId == LuaEntry.Player.allianceId then
                        isAlliance = 1
                    end
                    desertId = desertInfo.desertId
                    uuid =desertInfo.uuid
                end
            end
        end
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint,{anim = true,playEffect = false,UIMainAnim = UIMainAnimType.LeftRightBottomHide},uuid, self.pointIndex,ownerUid, WorldPointUIType.Desert, isAlliance,0,nil,desertId)
    end)
end

return ResLackItem_GoDesert