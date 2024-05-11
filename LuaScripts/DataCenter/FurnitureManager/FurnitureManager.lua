--- Created by shimin.
--- DateTime: 2023/11/7 11:28
--- 家具管理器

local FurnitureManager = BaseClass("FurnitureManager")
local FurnitureInfo = require "DataCenter.FurnitureManager.FurnitureInfo"
local Localization = CS.GameEntry.Localization

function FurnitureManager:__init()
    self.allData = {}--所有家具<uuid, info>
    self.parentData = {}--<主建筑bUuid, <info>>
    self.enterCameraParam = {}--进入建造/升级界面保存的相机参数
    self.firstUuid = {}--某种家具的第一个Uuid <furnitureId, fUuid>
end

function FurnitureManager:__delete()
    self.allData = {}--所有家具<uuid, info>
    self.parentData = {}--<主建筑bUuid, <info>>
    self.enterCameraParam = {}--进入建造/升级界面保存的相机参数
    self.firstUuid = {}--某种家具的第一个Uuid <furnitureId, fUuid>
end

function FurnitureManager:Startup()

end

--初始化信息
function FurnitureManager:InitData(message)
    self.allData = {}
    self.parentData = {}
    local furnitureArr = message["furnitureArr"]
    if furnitureArr ~= nil then
        for k, v in ipairs(furnitureArr) do
            self:UpdateOneInfo(v)
        end
    end
end

--更新一个信息
function FurnitureManager:UpdateOneInfo(message)
    if message ~= nil then
        local uuid = message["uuid"]
        local one = self:GetFurnitureByUuid(uuid)
        if one == nil then
            one = FurnitureInfo.New()
            one:UpdateInfo(message)
            self.allData[uuid] = one
            if self.parentData[one.bUuid] == nil then
                self.parentData[one.bUuid] = {}
            end
            table.insert(self.parentData[one.bUuid], one)
        else
            one:UpdateInfo(message)
        end
      
        EventManager:GetInstance():Broadcast(EventId.RefreshFurniture, uuid)
    end
end

--通过uuid获取家具信息
function FurnitureManager:GetFurnitureByUuid(uuid)
    return self.allData[uuid]
end

--通过bUuid获取家具
function FurnitureManager:GetFurnitureListByBUuid(bUuid)
    return self.parentData[bUuid] or {}
end

--通过建筑uuid和家具id获取家具信息  index:第几个同家具id（默认是1）
function FurnitureManager:GetFurnitureByBuildUuid(uuid, fId, index)
    if index == nil or index == 0 then
        index = FurnitureIndex
    end
    local list = self.parentData[uuid]
    if list ~= nil then
        for k,v in ipairs(list) do
            if v.fId == fId and v.index == index then
                return v
            end
        end
    end
    return nil
end

function FurnitureManager:GetFurnitureByBuildUuidAndFurnitureId(bUuid, fId)
    local list = {}
    if self.parentData[bUuid] ~= nil then
        for _, furnitureInfo in ipairs(self.parentData[bUuid]) do
            if furnitureInfo.fId == fId then
                table.insert(list, furnitureInfo)
            end
        end
    end
    return list
end

function FurnitureManager:GetFurnitureByFurnitureId(fId)
    local list = {}
    for _, furnitureInfo in pairs(self.allData) do
        if furnitureInfo.fId == fId then
            table.insert(list, furnitureInfo)
        end
    end
    return list
end

--获取建筑当前拥有的经验
function FurnitureManager:GetBuildCurExp(bUuid)
    local result = 0
    local list = self.parentData[bUuid]
    if list ~= nil then
        local template = nil
        for k,v in ipairs(list) do
            template = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(v.fId, v.lv)
            if template ~= nil then
                result = result + template.building_exp
            end
        end
    end
    return result
end
--发送建造家具
function FurnitureManager:SendUserBuildFurniture(buildUuid, furnitureId, index)
    SFSNetwork.SendMessage(MsgDefines.UserBuildFurniture, {buildUuid = buildUuid, furnitureId = furnitureId, index = index})
end
--建造家具回调处理
function FurnitureManager:UserBuildFurnitureHandle(message)
    local errorCode = message["errorCode"]
    if errorCode ~= nil then
        UIUtil.ShowTipsId(errorCode)
    else
        local resource = message["resource"]
        if resource then
            LuaEntry.Resource:UpdateResource(resource)
        end
        self:UpdateOneInfo(message["furniture"])

        EventManager:GetInstance():Broadcast(EventId.FurnitureUpgrade, message["furniture"]["uuid"])
    end
end

--发送升级家具
function FurnitureManager:SendUserLevelUpFurniture(uuid, isGold)
    if isGold == nil then
        isGold = false
    end
    SFSNetwork.SendMessage(MsgDefines.UserLevelUpFurniture, {uuid = uuid, isGold = isGold})
end
--升级家具回调处理
function FurnitureManager:UserLevelUpFurnitureHandle(message)
    local errorCode = message["errorCode"]
    if errorCode ~= nil then
        UIUtil.ShowTipsId(errorCode)
    else
        local resource = message["resource"]
        if resource then
            LuaEntry.Resource:UpdateResource(resource)
        end
        local remainGold = message["remainGold"]
        if remainGold ~= nil then
            LuaEntry.Player.gold = remainGold
            EventManager:GetInstance():Broadcast(EventId.UpdateGold)
        end

        local reward = message["reward"]
        if reward ~= nil then
            for k,v in pairs(message["reward"]) do
                DataCenter.RewardManager:AddOneReward(v)
            end
            DataCenter.RewardManager:ShowCommonReward(message)
        end
        local furniture = message["furniture"]
        self:UpdateOneInfo(furniture)
        if furniture ~= nil then
            local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(furniture["bUuid"])
            if buildData ~= nil then
                DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.FurnitureUpgradeLevel, buildData.itemId .. ";" .. furniture["fId"] .. ";" .. furniture["lv"])
            end
        end

        EventManager:GetInstance():Broadcast(EventId.FurnitureUpgrade, message["furniture"]["uuid"])
    end
end

function FurnitureManager:GetAttrParam(dialog, para1, effect, para4)
    local result = {}
    if dialog == FurnitureAttrDialogType.Time then
        result.icon = string.format("Assets/Main/Sprites/UI/UIMain/icon_time_5") 
        result.name = Localization:GetString(dialog)
        result.des = Localization:GetString(GameDialogDefine.TIME_DES)
    elseif dialog == FurnitureAttrDialogType.Attr or dialog == FurnitureAttrDialogType.Product then
        if para1 == nil or para1 == "" then
            if effect == EffectDefine.MEAL_HUNGER_ADD then
                result.icon = string.format(LoadPath.UIVita, "survivor_icon_healthy06")
                result.name = Localization:GetString(GameDialogDefine.HEALTH_VALUE)
                result.des = Localization:GetString(GameDialogDefine.HEALTH_VALUE_DES)
            elseif effect == EffectDefine.MEAL_CAPACITY then
                local config = DataCenter.VitaManager:GetCurSelectFoodParam()
                result.icon = string.format(LoadPath.UIMain, config.icon)
                result.name = Localization:GetString(GameDialogDefine.MEAL_CAPACITY_VALUE)
                result.des = Localization:GetString(GameDialogDefine.MEAL_CAPACITY_DES)
            elseif effect == EffectDefine.FURNITURE_HEALTH_ADD then
                result.icon = string.format(LoadPath.UIVita, "UItemperature_icon_healthy")
                result.name = Localization:GetString(GameDialogDefine.HEALTH_VALUE)
                result.des = Localization:GetString(GameDialogDefine.HEALTH_VALUE_DES)
            elseif effect == EffectDefine.FURNITURE_SLEEP_ADD then
                result.icon = string.format(LoadPath.UIMain, "icon_rest")
                result.name = Localization:GetString(GameDialogDefine.SLEEP_VALUE)
                result.des = Localization:GetString(GameDialogDefine.SLEEP_VALUE_DES)
            elseif effect == EffectDefine.FURNITURE_COMFORT_ADD then
                result.icon = string.format(LoadPath.UIMain, "icon_comfortable")
                result.name = Localization:GetString(GameDialogDefine.COMFORT_VALUE)
                result.des = Localization:GetString(GameDialogDefine.COMFORT_VALUE_DES)
            elseif effect == EffectDefine.FURNITURE_MOOD_ADD then
                result.icon = string.format(LoadPath.UIVita, "survivor_icon_healthy05")
                result.name = Localization:GetString(GameDialogDefine.MOOD_VALUE)
                result.des = Localization:GetString(GameDialogDefine.MOOD_VALUE_DES)
            elseif effect == EffectDefine.RESIDENT_CURE_ADD then
                result.icon = string.format(LoadPath.UIMain, "icon_sceneView_hospital")
                result.name = Localization:GetString(GameDialogDefine.CURE_VALUE)
                result.des = Localization:GetString(GameDialogDefine.CURE_VALUE_DES)
            elseif effect == EffectDefine.VITA_TEMPERATURE_ADD then
                result.icon = string.format(LoadPath.UIVita, "UItemperature_icon_temperature")
                result.name = Localization:GetString(GameDialogDefine.TEMPERATURE_VALUE)
                result.des = Localization:GetString(GameDialogDefine.TEMPERATURE_VALUE_DES)
            elseif effect == EffectDefine.FURNITURE_FOOD_ADD or effect == EffectDefine.FURNITURE_FOOD_ADD_PERCENT then
                local template = LocalController:instance():getLine(TableName.Resource, ResourceType.Food)
                if template then
                    result.icon = string.format(LoadPath.CommonPath, template.icon)
                    result.name = Localization:GetString(template.name)
                    result.des = Localization:GetString(template.description)
                end
            elseif effect == EffectDefine.FURNITURE_PLANK_ADD or effect == EffectDefine.FURNITURE_STEEL_ADD_PERCENT then
                local template = LocalController:instance():getLine(TableName.Resource, ResourceType.Plank)
                if template then
                    result.icon = string.format(LoadPath.CommonPath, template.icon)
                    result.name = Localization:GetString(template.name)
                    result.des = Localization:GetString(template.description)
                end
            elseif effect == EffectDefine.FURNITURE_STEEL_ADD or effect == EffectDefine.FURNITURE_STEEL_ADD_PERCENT then
                local template = LocalController:instance():getLine(TableName.Resource, ResourceType.Steel)
                if template then
                    result.icon = string.format(LoadPath.CommonPath, template.icon)
                    result.name = Localization:GetString(template.name)
                    result.des = Localization:GetString(template.description)
                end
            elseif effect == EffectDefine.FURNITURE_ELECTRICITY_ADD or effect == EffectDefine.FURNITURE_ELECTRICITY_ADD_PERCENT then
                local template = LocalController:instance():getLine(TableName.Resource, ResourceType.Electricity)
                if template then
                    result.icon = string.format(LoadPath.CommonPath, template.icon)
                    result.name = Localization:GetString(template.name)
                    result.des = Localization:GetString(template.description)
                end
            end
        else
            local para4Type = tonumber(para4)
            local para1Num = tonumber(para1)
            if para4Type == FurniturePara4Type.Resource then
                --饭是resourceType 特殊处理
                if para1Num == ResourceType.Meal then
                    --餐厅特殊处理
                    local config = DataCenter.VitaManager:GetCurSelectFoodParam()
                    if config ~= nil then
                        result.icon = string.format(LoadPath.UIMain, config.icon)
                    end
                    result.name = Localization:GetString(GameDialogDefine.HUNGRY_VALUE)
                    result.des = Localization:GetString(GameDialogDefine.HUNGRY_VALUE_DES)
                    result.special = FurnitureSpecialType.Dining
                else
                    local template = LocalController:instance():getLine(TableName.Resource, tostring(para1))
                    if template then
                        result.icon = string.format(LoadPath.CommonPath, template.icon)
                        result.name = Localization:GetString(template.name)
                        result.des = Localization:GetString(template.description)
                    end
                end
            else
                if para1Num == FurniturePara1Type.Health then
                    if dialog == FurnitureAttrDialogType.Attr then
                        result.icon = string.format(LoadPath.UIMain, "icon_sceneView_hospital")
                        result.name = Localization:GetString(GameDialogDefine.CURE_VALUE)
                        result.des = Localization:GetString(GameDialogDefine.CURE_VALUE_DES)
                    elseif dialog == FurnitureAttrDialogType.Product then
                        result.icon = string.format(LoadPath.UIVita, "UItemperature_icon_healthy")
                        result.name = Localization:GetString(GameDialogDefine.HEALTH_VALUE)
                        result.des = Localization:GetString(GameDialogDefine.HEALTH_VALUE_DES)
                    end
                elseif para1Num == FurniturePara1Type.Stamina then
                    result.icon = string.format(LoadPath.UIVita, "survivor_icon_healthy06")
                    result.name = Localization:GetString(GameDialogDefine.SLEEP_VALUE)
                    result.des = Localization:GetString(GameDialogDefine.SLEEP_VALUE_DES)
                elseif para1Num == FurniturePara1Type.Mood then
                    result.icon = string.format(LoadPath.UIVita, "survivor_icon_healthy05")
                    result.name = Localization:GetString(GameDialogDefine.MOOD_VALUE)
                    result.des = Localization:GetString(GameDialogDefine.MOOD_VALUE_DES)
                elseif para1Num == FurniturePara1Type.Comfort then
                    result.icon = string.format(LoadPath.UIMain, "icon_comfortable")
                    result.name = Localization:GetString(GameDialogDefine.COMFORT_VALUE)
                    result.des = Localization:GetString(GameDialogDefine.COMFORT_VALUE_DES)
                elseif para1Num == FurniturePara1Type.Doctor then
                    result.icon = string.format(LoadPath.UIMain, "icon_sceneView_hospital")
                    result.name = Localization:GetString(GameDialogDefine.CURE_VALUE)
                    result.des = Localization:GetString(GameDialogDefine.CURE_VALUE_DES)
                end
            end
        end
    end
    return result
end

--建造家具回调处理
function FurnitureManager:PushUsrAddFurnitureHandle(message)
    local furnitureArr = message["furnitureArr"]
    if furnitureArr ~= nil then
        for k, v in ipairs(furnitureArr) do
            self:UpdateOneInfo(v)
        end
    end
    local reward = message["reward"]
    if reward ~= nil then
        for k,v in pairs(message["reward"]) do
            DataCenter.RewardManager:AddOneReward(v)
        end
        DataCenter.RewardManager:ShowCommonReward(message)
    end
end

--家具升级界面镜头高度
function FurnitureManager:GetCameraParamByTiles(pos, deltaY, zoom)
    local result = {}
    result.zoom = zoom or BuildEnterMoveZoom --镜头高度
    result.constDeltaPosY = -2 --位置x轴偏移
    result.delta = 0.5 --位置系数
    --计算移动时间和当前高度有关
    result.time = self.enterCameraParam.time --镜头移动时间
    result.quitTime = self.enterCameraParam.quitTime --镜头退出移动时间
    local curPos = CS.SceneManager.World.CurTarget
    local delX = math.abs(curPos.x - pos.x) 
    if delX > 7 then
        local delY = math.abs(curPos.z - (pos.z + (deltaY or result.constDeltaPosY)))
        if delY > 7 then
            result.time = BuildEnterMaxTime --镜头移动时间
        end
    end
  
    return result
end

function FurnitureManager:GetFurnitureLocalNum(fUuid, i)
    local furnitureInfo = self:GetFurnitureByUuid(fUuid)
    if furnitureInfo then
        local buildLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(furnitureInfo.fId, furnitureInfo.lv)
        if buildLevelTemplate then
            return tonumber(buildLevelTemplate.local_num[i]) or 0
        end
    end
    return 0
end

function FurnitureManager:GetFurnitureEffectIcon(fUuid)
    local furnitureInfo = self:GetFurnitureByUuid(fUuid)
    if furnitureInfo then
        local buildLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(furnitureInfo.fId, furnitureInfo.lv)
        if buildLevelTemplate then
            local result = self:GetAttrParam(FurnitureAttrDialogType.Product, buildLevelTemplate.para1, nil, buildLevelTemplate.para4)
            return result.icon
        end
    end
    return nil
end

function FurnitureManager:SetEnterPanelCameraParam()
    if self.enterCameraParam.zoom == nil then
        if CS.SceneManager.World ~= nil then
            self.enterCameraParam.zoom = CS.SceneManager.World.Zoom
        else
            self.enterCameraParam.zoom = DataCenter.CityCameraManager:GetCurZoom()
        end
        self.enterCameraParam.time = BuildEnterMovePerZoomTime * (self.enterCameraParam.zoom - BuildEnterMoveZoom) + BuildEnterMinTime
        if self.enterCameraParam.time > BuildEnterMaxTime then
            self.enterCameraParam.time = BuildEnterMaxTime
        elseif self.enterCameraParam.time < BuildEnterMinTime then
            self.enterCameraParam.time = BuildEnterMinTime
        end
        self.enterCameraParam.quitTime = BuildQuitTime
    end
end

function FurnitureManager:GetEnterPanelCameraParam()
    return self.enterCameraParam
end

function FurnitureManager:ClearEnterPanelCameraParam()
    self.enterCameraParam.zoom = nil
    self.enterCameraParam.pos = nil
    self.enterCameraParam.noQuit = nil
end

--pos = nil时清空位置
function FurnitureManager:SetEnterPanelCameraPosParam(pos)
    self.enterCameraParam.pos = pos
end

function FurnitureManager:SetEnterPanelCameraNoQuitParam(value)
    self.enterCameraParam.noQuit = value
end

function FurnitureManager:HasCanSetWorkFurnitureByBUuid(bUuid)
    local residentDataList = DataCenter.VitaManager:GetRestingResidentDataList()
    if #residentDataList > 0 then
        local furnitureInfoList = self:GetFurnitureListByBUuid(bUuid)
        for _, furnitureInfo in ipairs(furnitureInfoList) do
            local furnitureLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(furnitureInfo.fId, furnitureInfo.lv)
            local furnitureResidentDataList = DataCenter.VitaManager:GetResidentDataListByFurnitureUuid(furnitureInfo.uuid)
            if #furnitureResidentDataList < furnitureLevelTemplate.need_worker then
                return true, furnitureInfo.uuid
            end
        end
    end
    return false, 0
end

function FurnitureManager:GetFirstFurnitureUuidById(furnitureId)
    if self.firstUuid[furnitureId] == nil then
        local furnitureInfoList = self:GetFurnitureByFurnitureId(furnitureId)
        if #furnitureInfoList > 0 then
            table.sort(furnitureInfoList, function(infoA, infoB)
                return infoA.uuid < infoB.uuid
            end)
            self.firstUuid[furnitureId] = furnitureInfoList[1].uuid
        end
    end
    return self.firstUuid[furnitureId]
end

--获取建筑当前最大可以解锁多少个工位(level为nil时表示建筑当前等级)
function FurnitureManager:GetCurMaxWork(buildId, level)
    local result = 0
    if level == nil then
        local buildData = DataCenter.BuildManager:GetFunbuildByItemID(buildId)
        if buildData ~= nil then
            level = buildData.level
        else
            level = 0
        end
    end

    local template = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildId, level)
    if template ~= nil then
        local list = template:GetFurnitureList()
        for k, v in ipairs(list) do
            local furnitureLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(v, 0)
            if furnitureLevelTemplate ~= nil and furnitureLevelTemplate.need_worker > 0 then
                result = result + furnitureLevelTemplate.need_worker
            end
        end
    end
  
    return result
end

return FurnitureManager
