---------------------------------------------------------------------
-- aps_client1 (C) CompanyName, All Rights Reserved
-- Created by: AuthorName
-- Date: 2021-10-28 11:23:47
---------------------------------------------------------------------

-- To edit this template in: Data/Config/Template.lua
-- To disable this template, check off menuitem: Options-Enable Template File

---@class BuildingDate
local BuildingDate = BaseClass("BuildingDate")

local function __init(self)
   self:reset()
end

local function __delete(self)
    self:reset()
end

local function reset(self)
    self.uuid = 0        --建筑唯一id
    self.itemId = 0        --建筑类型
    self.hp = 0           --建筑耐久
    self.level = 0        --建筑的等级
    self.pointId = 0      --坐标
    self.connect = 1      --是否连电
    self.state = BuildingStateType.Normal --状态
    self.startTime = 0
    self.updateTime = 0
    self.buildActiveTime = 0
    self.isHelped = 0
    self.lastCollectTime = 0
    self.unavailableTime = 0
    self.produceEndTime = 0
    self.growValStartTime = 0
    self.destroyEndTime = 0
    self.lastCashCdTime = 0
    self.lastStaminaTime = 0
    self.srcServer = 0--原服
    self.server = 0--当前服
    self.srcWorldId = 0--建筑原服worldId 不传默认0
    self.worldId = 0--建筑当前所在服worldId  不传默认0
    self.isWorldBuild = false
    self.repairStartTime = 0
    self.lastHurtTime = 0
    self.hurtTimer = nil
    
    self.deltaStamina = 0
end

local function UpdateInfo(self, message, _,isWorldBuild)
    if message == nil then
        return
    end
    if isWorldBuild~=nil then
        self.isWorldBuild =isWorldBuild
    end
    self.uuid = message["uuid"]
    --新逻辑
    if message["bId"] ~= nil then
        self.itemId = message["bId"]
    end

    if message["hp"] ~= nil then
        self.hp = message["hp"]
    end

    if message["lv"]~=nil then
        self.level = message["lv"]
    end

    if message["pId"]~=nil then
        self.pointId = message["pId"]
    end

    if message["state"] ~= nil then
        self.state = message["state"]
    else
        self.state = 0
    end

    if message["sT"] ~= nil then
        self.startTime = message["sT"]
    else
        self.startTime = 0
    end

    if message["uT"] ~= nil then
        self.updateTime = message["uT"]
    else
        self.updateTime = 0
    end
    
    if message["help"] then
        self.isHelped = message["help"]
    else
        self.isHelped = 0
    end

    if message["lCT"] then
        self.lastCollectTime = message["lCT"]
    else
        self.lastCollectTime = 0
    end

    if message["unaT"] then
        self.unavailableTime = message["unaT"]
    else
        self.unavailableTime = 0
    end

    if message["pEndT"] then
        self.produceEndTime = message["pEndT"]
    else
        self.produceEndTime = 0
    end

    if message["gValT"] then
        self.growValStartTime = message["gValT"]
    else
        self.growValStartTime = 0
    end

    if message["dEndT"] then
        self.destroyEndTime = message["dEndT"]
    else
        self.destroyEndTime= 0
    end
    if message["dStT"] then
        self.destroyStartTime = message["dStT"]
    else
        self.destroyStartTime= 0
    end

    if message["lCashT"] then
        self.lastCashCdTime = message["lCashT"]
    else
        self.lastCashCdTime = 0
    end

    if message["lStaT"] then
        self.lastStaminaTime = message["lStaT"]
    else
        self.lastStaminaTime = 0
    end
    
    if message["srcServer"] then
        self.srcServer = message["srcServer"]
    else
        self.srcServer = LuaEntry.Player:GetSelfServerId()
    end
    
    if message["srcWorld"] then
        self.srcWorldId = message["srcWorld"]
    else
        self.srcWorldId = 0
    end

    if message["world"] then
        self.worldId = message["world"]
    else
        self.worldId = 0
    end
    
    if message["server"] then
        self.server = message["server"]
    else
        self.server = LuaEntry.Player:GetSelfServerId()
    end

    if message["zDT"] then
        self.deltaStamina = -tonumber(message["zDT"])
    end
    
    local refreshBuild = false
    if self.destroyEndTime>0 then
        DataCenter.BuildQueueManager:AddFixQueue(self.uuid)
    else
        DataCenter.BuildQueueManager:RemoveFixQueue(self.uuid)
    end
    
    if self.itemId == BuildingTypes.FUN_BUILD_MAIN then
		Logger.Log("mainBuild Uuid"..self.uuid)
        if self.state == BuildingStateType.FoldUp then
            DataCenter.BuildManager.MainLv = 0
        else
            DataCenter.BuildManager.MainLv = self.level
        end

        --缓存主城等级，登陆加载时使用
        CS.GameEntry.Setting:SetInt(SettingKeys.FUN_BUILD_MAIN_LEVEL, self.level)
        DataCenter.AccountListManager:UpdatePlayerMainLv(LuaEntry.Player.serverId,LuaEntry.Player.uid,self.level)
        EventManager:GetInstance():Broadcast(EventId.HeroStationUpdate)
        EventManager:GetInstance():Broadcast(EventId.RefreshWelfareRedDot)
        EventManager:GetInstance():Broadcast(EventId.MainLvUp)
    end
    if self.itemId == BuildingTypes.WORM_HOLE_CROSS or self.itemId == BuildingTypes.APS_BUILD_WORMHOLE_SUB or BuildingUtils.IsInEdenSubwayGroup(self.itemId)==true then
        self.isWorldBuild = true
    end
    local template = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(self.itemId)
    if template ~= nil and template:IsSeasonBuild() then
        self.isWorldBuild = true
    end
    if template ~= nil and (not self.isWorldBuild) then
        self.pointId = template:GetPosIndex()
    end
    if self.updateTime>0 then
        DataCenter.BuildManager:PushNoticeBuilding(self.itemId,self.updateTime)
    else
        DataCenter.BuildManager:RemoveNoticeBuilding(self.itemId)
    end
    --end
    return refreshBuild
end

--获取可采集资源的百分比
local function GetResourcePercent(self)
    local result = 0
    local buildLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(self.itemId,self.level)
    if buildLevelTemplate ~= nil then
        local outSpeed = buildLevelTemplate:GetCollectSpeed() / 1000
        if outSpeed > 0 then
            local now = UITimeManager:GetInstance():GetServerTime()
            if self.unavailableTime > 0 and now > self.unavailableTime then
                now = self.unavailableTime
            end

            if self.produceEndTime > 0 and now > self.produceEndTime then
                now = self.produceEndTime
            end
            local count = (now - self.lastCollectTime) * outSpeed
            local max = buildLevelTemplate:GetCollectMax()
            if count > max then
                count = max
            end
            result = count / max
        end
    end
    
    return result
end

--获取达到percent百分比的剩余时间
local function GetNextChangeTimeByPercent(self, percent)
    local result = 0
    local buildLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(self.itemId,self.level)
    if buildLevelTemplate ~= nil then
        local outSpeed = buildLevelTemplate:GetCollectSpeed() / 1000
        if outSpeed > 0 then
            if self.unavailableTime == 0 then
                local now = UITimeManager:GetInstance():GetServerTime()
                local max = buildLevelTemplate:GetCollectMax()
                result = percent / 100 * max / outSpeed + self.lastCollectTime - now
            end
        end
    end

    return result
end

--获取中心位置pointId
local function GetCenterIndex(self)
    --local buildDesTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(self.itemId)
    --if buildDesTemplate ~= nil then
    --    return BuildingUtils.GetBuildModelCenter(self.pointId, buildDesTemplate.tiles)
    --end
    return self.pointId
end

--获取模型中心位置vec3
local function GetCenterVec(self)
    --local buildDesTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(self.itemId)
    --if buildDesTemplate ~= nil then
    --    return BuildingUtils.GetBuildModelCenterVec(self.pointId, buildDesTemplate.tiles)
    --end
    return SceneUtils.TileIndexToWorld(self.pointId) 
end

local function IsRangePoint(self,index)
    if self.isWorldBuild then
        local buildDesTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(self.itemId)
        if buildDesTemplate ~= nil then
            local max = buildDesTemplate.tiles - 1
            for x = 0,max ,1 do
                for y = 0,max ,1 do
                    if index == SceneUtils.GetIndexByOffset(self.pointId, -x, -y) then
                        return true
                    end
                end
            end
        end
    else
        return index == self.pointId
    end
    return false
end

--是否在盒子状态
local function IsUpgradeFinish(self)
    local now = UITimeManager:GetInstance():GetServerTime()
    return  self.updateTime > 0 and now >= self.updateTime 
end

function BuildingDate:IsNeedShowBox()
    local needBox = false
    local curLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(self.itemId, self.level)
    if curLevelTemplate then
        local needBoxConfig = toInt(curLevelTemplate.need_open)
        if needBoxConfig ==1 then
            needBox = true
        end
    end
    return needBox
end
local function IsActive(self)
    return self.state ~= BuildingStateType.FoldUp and self.level > 0
end

local function IsFixFinish(self)
    local now = UITimeManager:GetInstance():GetServerTime()
    return  self.destroyEndTime>0 and now >= self.destroyEndTime
end

--是否处于被攻击废墟状态
local function IsInFix(self)
    local now = UITimeManager:GetInstance():GetServerTime()
    return  self.destroyEndTime> 0 and now < self.destroyEndTime
end

--是否在升级中
local function IsUpgrading(self)
    local now = UITimeManager:GetInstance():GetServerTime()
    return  self.updateTime > 0 and now < self.updateTime
end

-- 是否在修理中
local function IsRepairing(self)
    local now = UITimeManager:GetInstance():GetServerTime()
    return self.repairStartTime > 0 and now < self.repairStartTime + BuildRepairTime * 1000
end

-- 获取当前生命值
local function GetCurHp(self)
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local deltaTime = curTime - self.lastStaminaTime
    local recoverSpeed = LuaEntry.DataConfig:TryGetNum("building_attack", "k2")
    if self.itemId == BuildingTypes.WORM_HOLE_CROSS then
        local carIndex = DataCenter.EquipmentDataManager:GetCarIndexByBuildingId(BuildingTypes.WORM_HOLE_CROSS)
        recoverSpeed = recoverSpeed * (1 + DataCenter.EquipmentDataManager:GetEffectValue(carIndex, EffectDefine.BUILDING_HP_REC_SPEED_EFFECT) / 100)
    end
    local curHp = math.floor(deltaTime / 1000 * recoverSpeed + self.hp)
    curHp = Mathf.Clamp(curHp, 0, self:GetMaxHp())
    return curHp
end

-- 获取最大生命值
local function GetMaxHp(self)
    local buildLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(self.itemId, self.level)
    return buildLevelTemplate:GetMaxHp(true)
end

-- 当前生命值是否已满
local function IsHpFull(self)
    local curHp = self:GetCurHp()
    local maxHp = self:GetMaxHp()
    return curHp >= maxHp
end

local function GetWorkSlotCount(self)
    local count = 0
    local furnitureInfoList = DataCenter.FurnitureManager:GetFurnitureListByBUuid(self.uuid)
    for _, furnitureInfo in ipairs(furnitureInfoList) do
        local furnitureLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(furnitureInfo.fId, furnitureInfo.lv)
        count = count + furnitureLevelTemplate.need_worker
    end
    return count
end

local function GetWorkSlotFUuids(self)
    local fUuids = {}
    local furnitureInfoList = DataCenter.FurnitureManager:GetFurnitureListByBUuid(self.uuid)
    for _, furnitureInfo in ipairs(furnitureInfoList) do
        local furnitureLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(furnitureInfo.fId, furnitureInfo.lv)
        if furnitureLevelTemplate.need_worker > 0 then
            for i = 1, furnitureLevelTemplate.need_worker do
                table.insert(fUuids, furnitureInfo.uuid)
            end
        end
    end
    return fUuids
end

local function GetCurStamina(self)
    local maxStamina = self:GetMaxStamina()
    local stamina = maxStamina + self.deltaStamina
    return Mathf.Clamp(stamina, 0, maxStamina)
end

local function GetMaxStamina(self)
    local buildLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(self.itemId, self.level)
    local maxStamina = tonumber(buildLevelTemplate.durability) or 1
    return maxStamina
end

local function ChangeStamina(self, delta)
    self.deltaStamina = self.deltaStamina + delta
end

local function GetDestroyType(self)
    local curStamina = self:GetCurStamina()
    if curStamina <= 0 then
        return BuildingDestroyType.Ruin
    end
    
    local str = LuaEntry.DataConfig:TryGetStr("safety_area", "k9")
    local spls = string.split(str, "|")
    for i, spl in ipairs(spls) do
        local val = tonumber(spl) or 0
        if curStamina >= val then
            return i - 1
        end
    end
    return BuildingDestroyType.None
end

local function Hurt(self, damage)
    local curTime = UITimeManager:GetInstance():GetServerTime()
    self:ChangeStamina(-damage)
    self.lastHurtTime = curTime
    if self.hurtTimer then
        self.hurtTimer:Stop()
    end
    self.hurtTimer = TimerManager:GetInstance():DelayInvoke(function()
        DataCenter.CityHudManager:Destroy(self.uuid, CityHudType.BuildStamina)
    end, CityResidentDefines.BuildingStaminaDuration + 1)
end

BuildingDate.__init = __init
BuildingDate.__delete = __delete
BuildingDate.reset = reset
BuildingDate.UpdateInfo = UpdateInfo
BuildingDate.GetResourcePercent = GetResourcePercent
BuildingDate.GetCenterIndex = GetCenterIndex
BuildingDate.GetCenterVec = GetCenterVec
BuildingDate.IsRangePoint = IsRangePoint
BuildingDate.IsUpgradeFinish = IsUpgradeFinish
BuildingDate.IsActive = IsActive
BuildingDate.IsFixFinish = IsFixFinish
BuildingDate.IsInFix = IsInFix
BuildingDate.IsUpgrading = IsUpgrading
BuildingDate.IsRepairing = IsRepairing
BuildingDate.GetNextChangeTimeByPercent = GetNextChangeTimeByPercent
BuildingDate.GetCurHp = GetCurHp
BuildingDate.GetMaxHp = GetMaxHp
BuildingDate.IsHpFull = IsHpFull
BuildingDate.GetWorkSlotCount = GetWorkSlotCount
BuildingDate.GetWorkSlotFUuids = GetWorkSlotFUuids

BuildingDate.GetCurStamina = GetCurStamina
BuildingDate.GetMaxStamina = GetMaxStamina
BuildingDate.ChangeStamina = ChangeStamina
BuildingDate.GetDestroyType = GetDestroyType
BuildingDate.Hurt = Hurt

return BuildingDate