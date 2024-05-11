---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2022/1/6 14:33
---
local UIFormationLackPowerCtrl = BaseClass("UIFormationLackPowerCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization
local function CloseSelf(self)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIFormationLackPower)
end

local function Close(self)
    UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

local function InitFormationUuid(self,uuid)
    self.uuid = uuid
end
local function GetAddList(self,monsterLevel)
    local list = {}
    local templateList = {}
    local mainLv = DataCenter.BuildManager.MainLv
    LocalController:instance():visitTable(TableName.Res_Lack_Tips,function(id,lineData)
        local tips = lineData:getValue("tips")
        local type = 0
        if tips~=nil then
            type = tonumber(tips)
        end
        local goods = lineData:getValue("goods")
        local res = lineData:getValue("res")
        if goods~=nil and goods~="" and res~=nil and res~="" then

        else
            if type== FormationAddSoldierType.TrainSoldier
                    or type== FormationAddSoldierType.TrainHighSoldier
                    or type== FormationAddSoldierType.HeroPowerAdd
                    or type == FormationAddSoldierType.GarageUpgrade then
                local oneData = {}
                oneData.selectType = type
                local baseLevel = lineData:getValue("base")
                oneData.order = lineData:getValue("order")
                oneData.name = lineData:getValue("name")
                oneData.pic = lineData:getValue("pic")
                oneData.para1 = lineData:getValue("para1")
                oneData.btnName = Localization:GetString(lineData:getValue("btn_name"))
                oneData.hasHero = false
                local limitLv = lineData:getValue("monster_level_limit")
                local baseLevelOk = true
                local levelLimit = true

                -- 过滤baseLevel
                local baseLevelArray = string.split(baseLevel, '-')
                if (table.count(baseLevelArray) == 2) then
                    local minLevel = tonumber(baseLevelArray[1])
                    local maxLevel = tonumber(baseLevelArray[2])
                    if (mainLv < minLevel or mainLv > maxLevel) then
                        baseLevelOk = false
                    end
                end
                if limitLv~=nil then
                    local monsterLevelArray = string.split(limitLv, '-')
                    if (table.count(monsterLevelArray) == 2) then
                        local minLevel = tonumber(monsterLevelArray[1])
                        local maxLevel = tonumber(monsterLevelArray[2])
                        if (monsterLevel < minLevel or monsterLevel > maxLevel) then
                            levelLimit = false
                        end
                    end
                end
                if baseLevelOk==true and levelLimit == true then
                    if type == FormationAddSoldierType.TrainSoldier then
                        local max = DataCenter.ArmyManager:GetArmyNumMax()
                        local current = DataCenter.ArmyManager:GetTotalArmyNum()
                        if current<max then
                            oneData.buildId = BuildingTypes.FUN_BUILD_INFANTRY_BARRACK
                            table.insert(templateList,oneData)
                        end
                    elseif type == FormationAddSoldierType.TrainHighSoldier then
                        local max = DataCenter.ArmyManager:GetArmyNumMax()
                        local current = DataCenter.ArmyManager:GetTotalArmyNum()
                        if current>=max then
                            local buildId = DataCenter.ArmyManager:GetCanUpgradeArmyBuildId()
                            if buildId>0 then
                                oneData.buildId = buildId
                                table.insert(templateList,oneData)
                            end
                        end
                    elseif type == FormationAddSoldierType.HeroPowerAdd then
                        oneData.hasHero = true
                        local heroUuid = DataCenter.ArmyFormationDataManager:GetArmyFormationHeroCanUpgradeUuid(self.uuid)
                        if heroUuid~=nil and heroUuid~=0 then
                            oneData.heroUuid = heroUuid
                            table.insert(templateList,oneData)
                        end
                    elseif type == FormationAddSoldierType.GarageUpgrade then
                        local formation = DataCenter.ArmyFormationDataManager:GetOneArmyInfoByUuid(self.uuid)
                        if formation~=nil then
                            local buildId = MarchUtil.GetFormationBuildNameByIndex(formation.index)
                            if buildId == BuildingTypes.FUN_BUILD_TRAINFIELD_4 then
                                buildId = BuildingTypes.FUN_BUILD_TRAINFIELD_1
                            end
                            local refitData = DataCenter.GarageRefitManager:GetGarageRefitDataCopy(buildId)
                            if refitData ~= nil then
                                local maxLevel = DataCenter.GarageRefitManager:GetMaxLevel()
                                if refitData.level < maxLevel then
                                    local modifyTemplate = DataCenter.GarageRefitManager:GetModifyTemplate(buildId, refitData.level)
                                    if modifyTemplate ~= nil then
                                        local restFreeCount = DataCenter.GarageRefitManager:GetGarageFreeCount(buildId)
                                        if restFreeCount>0 then
                                            oneData.buildId = buildId
                                            table.insert(templateList,oneData)
                                        else
                                            local isEnough = false
                                            if modifyTemplate:getValue("money") ~=nil and modifyTemplate:getValue("money") > 0 then
                                                isEnough = LuaEntry.Resource:GetCntByResType(ResourceType.Money) >= modifyTemplate:getValue("money")
                                            else
                                                local itemId, count = DataCenter.GarageRefitManager:GetCostItem(buildId, refitData.level)
                                                if itemId ~= nil and count > 0 then
                                                    local itemData = DataCenter.ItemData:GetItemById(itemId)
                                                    local itemCount = itemData and itemData.count or 0
                                                    isEnough = itemCount >= count
                                                end
                                            end
                                            if isEnough then
                                                oneData.buildId = buildId
                                                table.insert(templateList,oneData)
                                            end
                                        end
                                        
                                    end
                                    
                                end
                            end
                        end
                        
                    end
                end

            end
        end
        
    end)
    if #templateList> 0 then
        table.sort(templateList, function(a,b)
            return a.order<b.order
            
        end)
    end
    for i=1,#templateList do
        if i<=6 then
            table.insert(list,templateList[i])
        end
    end
    return list
end

UIFormationLackPowerCtrl.CloseSelf = CloseSelf
UIFormationLackPowerCtrl.Close = Close
UIFormationLackPowerCtrl.GetAddList = GetAddList
UIFormationLackPowerCtrl.InitFormationUuid = InitFormationUuid
return UIFormationLackPowerCtrl