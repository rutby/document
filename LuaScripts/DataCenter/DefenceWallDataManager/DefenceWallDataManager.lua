---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2021/7/20 17:03
---
local DefenceWallDataManager = BaseClass("ArmyFormationDataManager");
local Localization = CS.GameEntry.Localization
local function __init(self)
    self.defenceWallData = {}
    self.defenceFormationMaxSize = 0
    self.defFormationFirstMaxCount = 0
    self.defFormationSecondMaxCount = 0
    self.defFormationThirdMaxCount = 0
    self.defDomeMaxNum = 0
    self.defDomeAddSpeed = 0
    self.fixPercentOnce= 0
    self.guardArmyInfo = nil
    self.eden_last_protect_time = 0
    EventManager:GetInstance():AddListener(EventId.EffectNumChange, self.UpdateValueSignal)
end

local function __delete(self)
    self.defenceWallData =nil
    self.guardArmyInfo = nil
    self.eden_last_protect_time = 0
    EventManager:GetInstance():RemoveListener(EventId.EffectNumChange, self.UpdateValueSignal)
end
local function InitData(self,message)
    self:UpdateValue()
    self:UpdateDefenceWallData(message)
    self:UpdateEdenProtectTime(message)
    if message["defend_wall"]~=nil then
        local dic = message["defend_wall"]
        if dic["cityBroken"]~=nil then
            local state = dic["cityBroken"]
            if state == true then
                Logger.Log("show broken")
                UIUtil.ShowMessage(Localization:GetString("300543"), 1, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL,function()
                    GoToUtil.GotoMainBuildPos()
                end, function()
                    GoToUtil.GotoMainBuildPos()
                end)
            end
        end
    end
    
end
local function UpdateDefenceWallData(self,message)
    self.defenceWallData = DefenceWallData.New()
    if message["defend_wall"]~=nil then
        self.defenceWallData:ParseData(message["defend_wall"])
    end

end
local function UpdateCurDurability(self,message)
    if message["uid"]~=nil then
        local uid = message["uid"]
        if uid == LuaEntry.Player.uid then
            if message["nowDurability"]~=nil and self.defenceWallData~=nil then
                self.defenceWallData:SetCurDurability(message["nowDurability"])
            end
        end
    end
    
end
local function UpdateColdDownTime(self,message)
    if message["lastGoldRecoverDurabilityTime"]~=nil and self.defenceWallData~=nil then
        self.defenceWallData:SetColdDownTime(message["lastGoldRecoverDurabilityTime"])
    end
    if message["durability"]~=nil and self.defenceWallData~=nil then
        self.defenceWallData:SetCurDurability(message["durability"])
    end
end

local function UpdateEdenProtectTime(self,message)
    if message["eden_last_protect_time"]~=nil then
        self.eden_last_protect_time = message["eden_last_protect_time"]
    end
end
local function GetEdenProtectTime(self)
    return self.eden_last_protect_time
end
local function UpdateValueSignal(data)
    DataCenter.DefenceWallDataManager:UpdateValue()
end
local function UpdateValue(self)
    self.defenceFormationMaxSize = LuaEntry.Effect:GetGameEffect(EffectDefine.APS_DEFENCE_FORMATION_SIZE)
    self.defFormationFirstMaxCount = LuaEntry.Effect:GetGameEffect(EffectDefine.APS_DEFENCE_FORMATION_FIRST_HERO_COUNT)
    self.defFormationSecondMaxCount = LuaEntry.Effect:GetGameEffect(EffectDefine.APS_DEFENCE_FORMATION_SECOND_HERO_COUNT)
    self.defFormationThirdMaxCount = LuaEntry.Effect:GetGameEffect(EffectDefine.APS_DEFENCE_FORMATION_THIRD_HERO_COUNT)
    self.defDomeMaxNum = 0--LuaEntry.Effect:GetGameEffect(EffectDefine.APS_DEFENCE_DOME_NUM)
    self.defDomeAddSpeed= 0--LuaEntry.Effect:GetGameEffect(EffectDefine.APS_DEFENCE_DOME_SPEED)
    self.fixPercentOnce = LuaEntry.DataConfig:TryGetNum("city_wall", "k1")
    self.fixDiamond = LuaEntry.DataConfig:TryGetNum("city_wall", "k2")
    self.fixColdDownTime = LuaEntry.DataConfig:TryGetNum("city_wall", "k3")
    local buildingData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_DEFENCE_CENTER_NEW)
    if buildingData then
        local buildLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(BuildingTypes.FUN_BUILD_DEFENCE_CENTER_NEW, buildingData.level)
        if buildLevelTemplate ~= nil then
            local carIndex = DataCenter.EquipmentDataManager:GetCarIndexByBuildingId(BuildingTypes.FUN_BUILD_DEFENCE_CENTER_NEW)
            self.defDomeMaxNum = buildLevelTemplate:GetDefenceWallMax() + Mathf.Round(DataCenter.EquipmentDataManager:GetEffectValue(carIndex, EffectDefine.BUILDING_HP_EFFECT))
            self.defDomeAddSpeed = buildLevelTemplate:GetDefenceWallCoverSpeed() * (1 + DataCenter.EquipmentDataManager:GetEffectValue(carIndex, EffectDefine.BUILDING_HP_REC_SPEED_EFFECT) / 100)
        end
    else
        local k9 = LuaEntry.DataConfig:TryGetNum("city_wall", "k9")
        local k10 = LuaEntry.DataConfig:TryGetNum("city_wall", "k10")
        self.defDomeMaxNum = k9
        self.defDomeAddSpeed = k10
    end
end

local function GetConfigData(self)
    local oneData = {}
    oneData.defenceFormationMaxSize = self.defenceFormationMaxSize
    oneData.defFormationFirstMaxCount = self.defFormationFirstMaxCount
    oneData.defFormationSecondMaxCount = self.defFormationSecondMaxCount
    oneData.defFormationThirdMaxCount = self.defFormationThirdMaxCount
    oneData.defDomeMaxNum = 0
    oneData.defDomeAddSpeed = 0
    local buildingData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_DEFENCE_CENTER_NEW)
    if buildingData then
        local buildLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(BuildingTypes.FUN_BUILD_DEFENCE_CENTER_NEW, buildingData.level)
        if buildLevelTemplate ~= nil then
            local carIndex = DataCenter.EquipmentDataManager:GetCarIndexByBuildingId(BuildingTypes.FUN_BUILD_DEFENCE_CENTER_NEW)
            oneData.defDomeMaxNum = buildLevelTemplate:GetDefenceWallMax() + Mathf.Round(DataCenter.EquipmentDataManager:GetEffectValue(carIndex, EffectDefine.BUILDING_HP_EFFECT))
            oneData.defDomeAddSpeed = buildLevelTemplate:GetDefenceWallCoverSpeed() * (1 + DataCenter.EquipmentDataManager:GetEffectValue(carIndex, EffectDefine.BUILDING_HP_REC_SPEED_EFFECT) / 100)
        end
    else
        local k9 = LuaEntry.DataConfig:TryGetNum("city_wall", "k9")
        local k10 = LuaEntry.DataConfig:TryGetNum("city_wall", "k10")
        oneData.defDomeMaxNum = k9
        oneData.defDomeAddSpeed = k10
    end
    oneData.fixPercentOnce = self.fixPercentOnce
    oneData.fixDiamond = self.fixDiamond
    oneData.fixColdDownTime =self.fixColdDownTime
    return oneData
end

local function GetDefenceWallData(self)
    return self.defenceWallData
end

local function GetMaxDefenceNum(self)
    return self.defenceFormationMaxSize;
end

local function UpdateGuardArmyInfo(self,message)
    if message["armyInfo"]~=nil then
        self.guardArmyInfo = PBController.ParsePb1(message["armyInfo"], "protobuf.ArmyUnitInfo")
    end
end

local function GetGuardArmyInfo(self)
    return self.guardArmyInfo
end
DefenceWallDataManager.__init = __init
DefenceWallDataManager.__delete = __delete
DefenceWallDataManager.UpdateCurDurability = UpdateCurDurability
DefenceWallDataManager.UpdateDefenceWallData = UpdateDefenceWallData
DefenceWallDataManager.UpdateValue = UpdateValue
DefenceWallDataManager.UpdateValueSignal = UpdateValueSignal
DefenceWallDataManager.GetConfigData= GetConfigData
DefenceWallDataManager.GetDefenceWallData = GetDefenceWallData
DefenceWallDataManager.InitData= InitData
DefenceWallDataManager.UpdateColdDownTime= UpdateColdDownTime
DefenceWallDataManager.GetMaxDefenceNum = GetMaxDefenceNum
DefenceWallDataManager.UpdateGuardArmyInfo = UpdateGuardArmyInfo
DefenceWallDataManager.GetGuardArmyInfo = GetGuardArmyInfo
DefenceWallDataManager.UpdateEdenProtectTime =UpdateEdenProtectTime
DefenceWallDataManager.GetEdenProtectTime = GetEdenProtectTime
return DefenceWallDataManager