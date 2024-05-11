--[[
-- 跳转工具类
--]]

local GoToUtil = {}
local Data = CS.GameEntry.Data
local Localization = CS.GameEntry.Localization
local ResType = {[1] = ResourceType.Oil,[2] = ResourceType.Metal,[3] = ResourceType.Water,[4] = ResourceType.Electricity}
local Const = require("Scene.PVEBattleLevel.Const")
-- 跳转到建筑（没有就建造，存在就跳转） 默认取出最大等级建筑
--  buildId:建筑类型
local function GotoCityByBuildId(buildId,worldTileBtnType,questTemplate)
    DataCenter.FurnitureManager:SetEnterPanelCameraPosParam(nil)
    local buildData = DataCenter.BuildManager:GetFunbuildByItemID(buildId)
    if buildData == nil or buildData.level == 0 then
        GoToUtil.GotoBuildListByBuildId(buildId,questTemplate)
    else
        GoToUtil.GotoCityByBuildUuid(buildData.uuid, worldTileBtnType,nil, questTemplate)
    end
end

--去建造列表
local function GotoBuildListByBuildId(bId, questTemplate)
    local buildId = bId
    SceneUtils.ChangeToCity(function()
        GoToUtil.CloseAllWindows()
        --判断前置建筑
        local data = DataCenter.BuildCityBuildManager:GetCityBuildDataByBuildId(buildId)
        if data ~= nil then
            local levelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildId, 0)
            if levelTemplate ~= nil then
                --这里面还要判断 能不能建造
                if data.state == BuildCityBuildState.Pre then
                    if data.preState == BuildCityBuildPreState.Build then
                        local preBuild = levelTemplate:GetPreBuild()
                        if preBuild ~= nil then
                            for k1, v1 in ipairs(preBuild) do
                                if not DataCenter.BuildManager:IsExistBuildByTypeLv(v1[1], v1[2]) then
                                    GoToUtil.GotoBuildListByBuildId(v1[1], questTemplate)
                                    return
                                end
                            end
                        end
                    elseif data.preState == BuildCityBuildPreState.Pve then
                        local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
                        if buildTemplate ~= nil then
                            --如果可以解锁直接解锁
                            local landId = levelTemplate.need_pve
                            local state =  DataCenter.LandManager:GetState(LandObjectType.Zone, landId)
                            if state == LandState.Unlocked or state == LandState.Cleared then
                                pos = DataCenter.LandManager:GetObjectPos(LandObjectType.Zone, landId)
                                local obj = DataCenter.LandManager:GetObject(LandObjectType.Zone, landId)
                                if obj ~= nil then
                                    obj:OnClick()
                                end
                            else
                                local pos = buildTemplate:GetPosition()
                                GoToUtil.GotoCityPos(pos, nil, nil, function()
                                    DataCenter.BuildFogEffectManager:ShowOneEffect(buildId)
                                end)
                            end
                        end
                        return
                    elseif data.preState == BuildCityBuildPreState.Science then
                        return
                    elseif data.preState == BuildCityBuildPreState.Vip then
                        UIManager:GetInstance():OpenWindow(UIWindowNames.UIVip,{ anim = true, hideTop = true}, levelTemplate.need_vip)
                        return
                    elseif data.preState == BuildCityBuildPreState.LandReward then
                        local need_landreward = levelTemplate.need_landreward or 0
                        if need_landreward ~= 0 then
                            DataCenter.LandManager:JumpToRewardBubble(need_landreward)
                            return
                        end
                    elseif data.preState == BuildCityBuildPreState.Land then
                        SceneUtils.ChangeToCity(function()
                            GoToUtil.CloseAllWindows()
                            local obj = DataCenter.LandManager:GetCurrentObject(LandObjectType.Block)
                            if obj ~= nil then
                                local pos = obj.transform.position
                                GoToUtil.GotoCityPos(pos, nil, nil, function()
                                    local param = {}
                                    param.position = pos
                                    param.positionType = PositionType.World
                                    param.isPanel = true
                                    param.isAutoClose = 3
                                    DataCenter.ArrowManager:ShowArrow(param)
                                end)
                            end
                            return
                        end)
                    end
                else
                    local param = {}
                    param.buildId = buildId
                    if questTemplate then
                        param.questId = questTemplate.id
                    end
                    GoToUtil.GotoOpenBuildCreateWindow(UIWindowNames.UIBuildCreate, NormalPanelAnim, param)
                end
            end
        end
    end)
end

local function GotoOpenView(ui_name,...)
    GoToUtil.CloseAllWindows()
    if ui_name == UIWindowNames.UISearch then
        UIManager:GetInstance():OpenWindow(ui_name,{ anim = true, UIMainAnim = UIMainAnimType.AllHide }, ...) 
    else
        UIManager:GetInstance():OpenWindow(ui_name, ...)
    end
    
end

local function GoToMonthCard(monthCardId)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIGiftPackage,{anim = true},
            {
                welfareTagType = WelfareTagType.MonthCard,
            })
end

--礼包跳转，根据type决定时跳到哪里
local function GotoGiftPackView(packageInfo,welfareTagType)
    local packId = nil
    if packageInfo then
        packId = packageInfo:getID()
        local targetPack = GiftPackManager.get(packId)
        if targetPack then
            local rechargeLine = targetPack:getRechargeLineData()
            if rechargeLine then
                if rechargeLine.type == WelfareTagType.ScrollPack then
                    UIManager:GetInstance():OpenWindow(UIWindowNames.UIScrollPack, {anim = true},packageInfo)
                    return
                end
            end
        end
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIGiftPackage, {anim = true},
            {
                targetPackageId = packId,welfareTagType = welfareTagType
            })

end


local function GotoScience(scienceId,tab,bUuid, keepOpenedUI)
    local buildUuid = 0
    local buildId = BuildingTypes.FUN_BUILD_SCIENE
    local list = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(buildId)
    local hasBuild = true
    local isUpgrading = false
    if bUuid~=nil and bUuid~=0 then
        buildUuid = bUuid
        local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(bUuid)
        if buildData ==nil then
            hasBuild =false
        end
    elseif list ~= nil and table.count(list) > 0 then
        
        for k,v in ipairs(list) do
            buildUuid = v.uuid
            if v:IsUpgrading() then
                isUpgrading = true
            end
        end
    else
        hasBuild = false
    end

    if hasBuild ==false then
        UIUtil.ShowTips(Localization:GetString(GameDialogDefine.NEED_FIRST_BUILD, 
                Localization:GetString(GetTableData(DataCenter.BuildTemplateManager:GetTableName(), buildId + 1,"name"))))
        GoToUtil.GotoBuildListByBuildId(buildId)
    else
        if isUpgrading then
            GoToUtil.GotoCityByBuildUuid(buildUuid)
        else
            if scienceId == nil then
                if tab == nil then
                    GoToUtil.OpenScienceTabPanel(tab,buildUuid, keepOpenedUI)
                else
                    local state = DataCenter.ScienceTemplateManager:GetTabState(tab, buildUuid)
                    if state == ScienceTabState.UnLock or state == ScienceTabState.CanUnlock then
                        GoToUtil.OpenScienceTabPanel(tab,buildUuid, keepOpenedUI)
                    elseif state == ScienceTabState.Lock then
                        GoToUtil.OpenScienceTabPanel(tab,buildUuid, keepOpenedUI)
                    end
                end
            else
                local tempTemplate = DataCenter.ScienceTemplateManager:GetScienceTemplate(scienceId,1)
                if tempTemplate ~= nil then
                    local state = DataCenter.ScienceTemplateManager:GetTabState(tempTemplate.tab, buildUuid)
                    if state == ScienceTabState.UnLock or state == ScienceTabState.CanUnlock then
                        GoToUtil.OpenSciencePanel(tempTemplate.tab,scienceId,buildUuid, keepOpenedUI)
                    elseif state == ScienceTabState.Lock or state == ScienceTabState.LockShow then
                        UIUtil.ShowTipsId(GameDialogDefine.NEED_UNLOCK_SCIENCE)
                        GoToUtil.OpenScienceTabPanel(tempTemplate.tab,buildUuid, keepOpenedUI)
                    end
                end
            end
        end
    end
end

local function OpenSciencePanel(tab,scienceId,bUuid, keepOpenedUI)
    if not keepOpenedUI then
        GoToUtil.CloseAllWindows()
    end
    local panel = UIManager:GetInstance():GetWindow(UIWindowNames.UIScience)
    if panel == nil then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIScience,tab,scienceId,false,bUuid)
    else
        local param = {}
        param.tab = tab
        param.scienceId = scienceId
        EventManager:GetInstance():Broadcast(EventId.GOTO_SCIENCE, param)
    end
end

local function OpenScienceTabPanel(tab,bUuid, keepOpenedUI)
    if not keepOpenedUI then
        GoToUtil.CloseAllWindows()
    end
    local panel = UIManager:GetInstance():GetWindow(UIWindowNames.UIScienceTab)
    if panel == nil then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIScienceTab,tab,bUuid)
    end
end

local function CloseAllWindows()
    UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
    UIManager:GetInstance():DestroyWindowByLayer(UILayer.Background)
end

local function MoveToWorldPoint(pointId,sceneId)
    if sceneId and sceneId == SceneManagerSceneID.City then
        GoToUtil.GotoCityPos(SceneUtils.TileIndexToWorld(pointId,ForceChangeScene.City))
    else
        GoToUtil.CloseAllWindows()
        GoToUtil.GotoWorldPos(SceneUtils.TileIndexToWorld(pointId,ForceChangeScene.World))
    end
end

--移动到世界点然后点击打开页面（注意沙虫用MoveToWorldTroopAndOpen）
local function MoveToWorldPointAndOpen(pointId, type)
    DataCenter.WorldGotoManager:MoveToWorldPointAndOpen(pointId, type)
end

--移动到世界行军然后点击打开页面（沙虫，世界boss, 行军）
local function MoveToWorldTroopAndOpen(pointId, uuid)
    DataCenter.WorldGotoManager:MoveToWorldTroopAndOpen(pointId, uuid)
end

local function GotoPayTips()
    UIUtil.ShowMessage(Localization:GetString(GameDialogDefine.NO_DIAMOND_GOTO_BUY), 1, GameDialogDefine.GOTO, GameDialogDefine.CANCEL, function()
        GoToUtil.GotoPay()
    end, function() end)
end
 
local function GotoPay()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIGiftPackage)
end

local function GoToByQuestId(questTemplate)
    if questTemplate ~= nil then
        local goType =  tonumber(questTemplate.gotype2)
        local goPara = questTemplate.gopara
        if goType == QuestGoType.BuildBtn then
            GoToUtil:CloseAllWindows()
            if goPara[2] == nil then
                GoToUtil.GotoCityByBuildId(tonumber(goPara[1]),nil,questTemplate)
            else
                GoToUtil.GotoCityByBuildId(tonumber(goPara[1]), tonumber(goPara[2]), questTemplate)
            end
        elseif goType == QuestGoType.GetResource then
            if goPara ~= nil and table.count(goPara) > 0 then
                local list = DataCenter.BuildManager:GetCanGetResourceBuildUuidByResourceType(tonumber(goPara[1]))
                if list == nil then
                    --一个建筑都没有应该去建造
                    GoToUtil.GotoBuildListByBuildId(nil,questTemplate)
                else
                    GoToUtil.GotoCityByBuildUuid(list.uuid,nil,nil,questTemplate)
                end
            end
        elseif goType == QuestGoType.GetResourceRandom then
            GoToUtil.GotoResourceBuild()
        elseif goType == QuestGoType.BuildList then
            local buildId = tonumber(goPara[1])
            GoToUtil.GotoCityByBuildId(buildId, nil, questTemplate)
        elseif goType == QuestGoType.Science then
            if goPara ~= nil and table.count(goPara) > 0 then
                GoToUtil.CloseAllWindows()
                local baseId = CommonUtil.GetScienceBaseType(tonumber(goPara[1]))
                GoToUtil.GotoScience(baseId)
            end
        elseif goType == QuestGoType.HeroUpgrade then
            GoToUtil.GotoOpenView(UIWindowNames.UIHeroList,{anim = false,UIMainAnim = UIMainAnimType.AllHide})

            local list = {}
            local secondParam = {}
            secondParam.arrowSecondType = ArrowSecondType.HeroList
            secondParam.uiName = UIWindowNames.UIHeroList
            secondParam.arrowTypeHero = HeroListArrowTypeHero.LvUpHero
            if goPara[1] ~= nil and goPara[1] ~= "" then
                secondParam.heroId = tonumber(goPara[1])
            else
                secondParam.para = tonumber(questTemplate.para1)
            end
            table.insert(list, secondParam)

            local secondParam2 = {}
            secondParam2.arrowSecondType = ArrowSecondType.HeroInfo
            secondParam2.uiName = UIWindowNames.UIHeroInfo
            secondParam2.arrowTypeHero = HeroListArrowTypeHero.LvUpHero
            table.insert(list, secondParam2)

            DataCenter.ArrowManager:SetSecondArrowParam(list)
        elseif goType == QuestGoType.Searching then
            GoToUtil.CloseAllWindows()
            local targetLv = nil
            if questTemplate.para1 then
                targetLv = DataCenter.MonsterTemplateManager:GetTableValue(questTemplate.para1,"level")
            end
            if tonumber(goPara[1]) then
                targetLv = tonumber(goPara[1])
            end
            SceneUtils.ChangeToWorld(function()
                GoToUtil.GotoOpenView(UIWindowNames.UISearch,UISearchType.Monster, targetLv)
            end)
        elseif goType == QuestGoType.CollectResource then
            if goPara ~= nil and table.count(goPara) > 0 then
                GoToUtil.GotoWorldResource(tonumber(goPara[1]))
            elseif goPara ~= "" then
                GoToUtil.GotoWorldResource(tonumber(goPara))
            end
        elseif goType == QuestGoType.DailyBuildUp then
            if goPara == nil or goPara[1] == nil then
                GoToUtil.CloseAllWindows()
                local buildId = DataCenter.BuildCityBuildManager:GetCanUpgradeBuildId()
                if buildId>0 then
                    GoToUtil.GotoCityByBuildId(buildId,WorldTileBtnType.City_Upgrade)
                end
            elseif tonumber(goPara[1]) == 1 then
                local uuid = DataCenter.BuildQueueManager:GetAllQueueUuid()
                if uuid then
                    GoToUtil.GotoCityByBuildUuid(uuid,WorldTileBtnType.City_SpeedUp, nil, questTemplate)
                else
                    GoToUtil.CloseAllWindows()
                end
            end
        elseif goType == QuestGoType.AttackMonster then
            GoToUtil.CloseAllWindows()
            SceneUtils.ChangeToWorld(function()
                GoToUtil.GotoOpenView(UIWindowNames.UISearch,UISearchType.Boss)
            end)
        elseif goType == QuestGoType.AllianceHelp then
            if LuaEntry.Player:IsInAlliance() then
                GoToUtil.CloseAllWindows()
                UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceHelp,{ anim = true, hideTop = true })
            else
                UIUtil.ShowTipsId(GameDialogDefine.NO_JOIN_ALLIANCE)
                GoToUtil.GotoOpenView(UIWindowNames.UIAllianceIntro,{ anim = true,isBlur = true})
            end
        elseif goType == QuestGoType.RadarProbe then
            if goPara ~= "" then
                GoToUtil.GoRadarProbe(tonumber(goPara))
            end
        elseif goType == QuestGoType.ChangePlayerName then
            GoToUtil.CloseAllWindows()
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIPlayerInfo,LuaEntry.Player.uid, PLayerInfoArrowType.ChangeName)
        elseif goType == QuestGoType.CollectGarbage then
            GoToUtil.GoGarbage(questTemplate)
        elseif goType == QuestGoType.GoRobot then
            GoToUtil.GotoBuildListRobotByRobotId(goPara[1])
        elseif goType == QuestGoType.GoBarracks then
            GoToUtil.GoBarracks()
        elseif goType == QuestGoType.GoBindAccount then
            GoToUtil.CloseAllWindows()
            --UIManager:GetInstance():OpenWindow(UIWindowNames.UIPlayerInfo,LuaEntry.Player.uid,2)
            EventManager:GetInstance():Broadcast(EventId.ShowArrowPlayerBtn,2)
        elseif goType == QuestGoType.GoConnectBuild then
            GoToUtil.GoConnectBuild(questTemplate.para1)
        elseif goType == QuestGoType.MonsterReward then
            GoToUtil.GotoMonsterReward()
        elseif goType == QuestGoType.GoHeroStation then
            GoToUtil.GoHeroStation(questTemplate)
        elseif goType == QuestGoType.GoGiftMall then
            GoToUtil.GoGiftMall()
        elseif goType == QuestGoType.GoBagPackUseItem then
            GoToUtil.GoBagPackUseItem()
        elseif goType == QuestGoType.GoSearchEnemy then
            GoToUtil.GoSearchEnemy(goPara)
        elseif goType == QuestGoType.GoGarageUpgrade then
            GoToUtil.GoGarageUpgrade(goPara)
        elseif goType == QuestGoType.GoHeroStationScores then
            GoToUtil.GoHeroStationScores(questTemplate)
        elseif goType == QuestGoType.GoHospital then
            GoToUtil.GoHospital(questTemplate)
        elseif goType == QuestGoType.GoHeroTrust then
            GoToUtil.GoHeroTrust(questTemplate)
        elseif goType == QuestGoType.GoTriggerPve or goType == QuestGoType.GoPveAutoTo then
            GoToUtil.GoTriggerPve(goPara)
        elseif goType == QuestGoType.GoFelledTree then

        elseif goType == QuestGoType.GoActUI then
            GoToUtil.GoActWindow(tonumber(goPara[1]))
        elseif goType == QuestGoType.GoCityCollect then
            GoToUtil.GoCityCollect(tonumber(goPara[1]))
        elseif goType == QuestGoType.GoFormation then
            GoToUtil.GoFormation(tonumber(goPara[1]))
        elseif goType == QuestGoType.GoTaskToBuild then
            if goPara[2] == nil then
                GoToUtil.GotoCityByBuildId(tonumber(goPara[1]),nil,questTemplate)
            else
                GoToUtil.GotoCityByBuildId(tonumber(goPara[1]), tonumber(goPara[2]), questTemplate)
            end
        elseif goType == QuestGoType.GoCheckBuild then
            GoToUtil.GoCheckBuild(tonumber(goPara[1]),tonumber(goPara[2]))
        elseif goType == QuestGoType.GoHeroBag then
            GoToUtil.GoHeroBag()
        elseif goType == QuestGoType.GoHeroSkill then
            GoToUtil.GoHeroSkill(questTemplate.para3,questTemplate.para1)
        elseif goType == QuestGoType.GoBuildOpenUpgrade then
            GoToUtil.GotoCityByBuildId(tonumber(goPara[1]),nil,questTemplate)
        elseif goType == QuestGoType.GoWorldToSearch then
            GoToUtil.GoWorldToSearch()
        elseif goType == QuestGoType.HeroStar then
            GoToUtil.HeroStar(tonumber(goPara[1]), tonumber(questTemplate.para1))
        elseif goType == QuestGoType.GoWorldCity then
            if goPara ~= nil and table.count(goPara) > 0 then
                GoToUtil.GoWorldCity(tonumber(goPara[1]))
            elseif goPara ~= "" then
                GoToUtil.GoWorldCity(tonumber(goPara))
            end
        elseif goType == QuestGoType.GoFlint then
            GoToUtil.GoFlint(questTemplate)
        elseif goType == QuestGoType.GoWorldBuildList then
            GoToUtil.GoWorldBuildList(goPara)
        elseif goType == QuestGoType.GoDailyUI then
            GoToUtil.GoDailyUI()
        elseif goType == QuestGoType.GoSeasonDesertMaxLv then
            GoToUtil.GoSeasonDesertMaxLv(goPara[1])
        elseif goType == QuestGoType.GoSelfDesert then
            GoToUtil.GoSelfDesert()
        elseif goType == QuestGoType.GoSeasonManager then
            GoToUtil.GoSeasonManager()
        elseif goType == QuestGoType.GoActWindowByType then
            GoToUtil.GoActWindowByType(tonumber(goPara[1]))
        elseif goType == QuestGoType.GOGiftPackageView then
            GoToUtil.GOGiftPackageView(goPara[1])
        elseif goType == QuestGoType.GoHeroBagRankUp then
            GoToUtil.GotoOpenView(UIWindowNames.UIHeroList,{anim = false,UIMainAnim = UIMainAnimType.AllHide})
            
            local list = {}
            local secondParam = {}
            secondParam.arrowSecondType = ArrowSecondType.HeroList
            secondParam.uiName = UIWindowNames.UIHeroList
            secondParam.arrowTypeHero = HeroListArrowTypeHero.RankUp
            if goPara[1] ~= nil and goPara[1] ~= "" then
                secondParam.heroId = tonumber(goPara[1])
            else
                secondParam.para = tonumber(questTemplate.para1)
            end
            table.insert(list, secondParam)

            local secondParam2 = {}
            secondParam2.arrowSecondType = ArrowSecondType.HeroInfo
            secondParam2.uiName = UIWindowNames.UIHeroInfo
            secondParam2.arrowTypeHero = HeroListArrowTypeHero.RankUp
            table.insert(list, secondParam2)

            DataCenter.ArrowManager:SetSecondArrowParam(list)
        elseif goType == QuestGoType.GoMastery then
            local dataList = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.RobotWars.Type)
            if dataList ~= nil and #dataList > 0 then
                local actData = dataList[1]
                if actData ~= nil then
                    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityCenterTable, { anim = true, hideTop = true, UIMainAnim = UIMainAnimType.AllHide }, tonumber(actData.id),false,1)
                end
            end
        elseif goType == QuestGoType.GoHeroPlugin then
            local list = DataCenter.HeroDataManager:GetAllHeroByPowerSortAndPlugin()
            if list then
                GoToUtil.CloseAllWindows()
                local isOpen = DataCenter.HeroPluginManager:IsOpen()
                local isArrow = isOpen
                GoToUtil.GoHeroSkill(list.heroId,1,isArrow and 3 or 0)
            end
        elseif goType == QuestGoType.GoAddWork then
            SceneUtils.ChangeToCity(function()
                local buildId = tonumber(goPara[1])
                local buildData = DataCenter.BuildManager:GetFunbuildByItemID(buildId)
                if buildData ~= nil and (not buildData:IsUpgrading()) then
                    SceneUtils.ChangeToCity(function()
                        local param = {}
                        param.buildUuid = buildData.uuid
                        param.tabType = UIFurnitureUpgradeTabType.Work
                        param.arrowType = UIFurnitureUpgradeArrowType.AddWork
                        param.questId = questTemplate.id
                        param.showArrow = true
                        UIManager:GetInstance():OpenWindow(UIWindowNames.UIFurnitureUpgrade, NormalPanelAnim, param)
                    end)
                else
                    GoToUtil.GotoCityByBuildId(buildId,nil,questTemplate)
                end
            end)
        elseif goType == QuestGoType.GoUpgradeFurniture then
            local buildId = tonumber(goPara[1])
            local buildData = DataCenter.BuildManager:GetFunbuildByItemID(buildId)
            if buildData ~= nil and (not buildData:IsUpgrading()) then
                SceneUtils.ChangeToCity(function()
                    local param = {}
                    param.buildUuid = buildData.uuid
                    param.tabType = UIFurnitureUpgradeTabType.Furniture
                    param.arrowType = UIFurnitureUpgradeArrowType.UpgradeFurniture
                    param.furnitureId = tonumber(goPara[2])
                    param.questId = questTemplate.id
                    UIManager:GetInstance():OpenWindow(UIWindowNames.UIFurnitureUpgrade, NormalPanelAnim, param)
                end)
            else
                GoToUtil.GotoCityByBuildId(buildId,nil,questTemplate)
            end
        elseif goType == QuestGoType.GoUpgradeFurnitureBuild then
            local buildId = tonumber(goPara[1])
            local buildData = DataCenter.BuildManager:GetFunbuildByItemID(buildId)
            if buildData ~= nil and (not buildData:IsUpgrading()) then
                SceneUtils.ChangeToCity(function()
                    local param = {}
                    param.buildUuid = buildData.uuid
                    param.tabType = UIFurnitureUpgradeTabType.Furniture
                    param.arrowType = UIFurnitureUpgradeArrowType.UpgradeBuild
                    param.questId = questTemplate.id
                    GoToUtil.CloseAllWindows()
                    UIManager:GetInstance():OpenWindow(UIWindowNames.UIFurnitureUpgrade, NormalPanelAnim, param)
                end)
            else
                GoToUtil.GotoCityByBuildId(buildId,nil,questTemplate)
            end
        elseif goType == QuestGoType.GoStory then
            GoToUtil.GotoOpenView(UIWindowNames.UIJeepAdventureMain, { anim = true })
        elseif goType == QuestGoType.GoLand then
            GoToUtil.CloseAllWindows()
            local pos = DataCenter.LandManager:GetNextObjectPos(LandObjectType.Block)
            GoToUtil.GotoCityPos(pos, nil, nil, function()
                if not UIManager:GetInstance():HasWindow() then
                    local param = {}
                    param.position = pos
                    param.positionType = PositionType.World
                    param.isPanel = true
                    param.isAutoClose = 3
                    DataCenter.ArrowManager:ShowArrow(param)
                end
            end)
        elseif goType == QuestGoType.AllianceScience then
            if LuaEntry.Player:IsInAlliance() then
                GoToUtil.CloseAllWindows()
                local param = {}
                param.position = UIUtil.GetUIMainSavePos(UIMainSavePosType.Alliance)
                param.positionType = PositionType.Screen
                param.isPanel = false
                param.isAutoClose = ArrowAutoCloseTime
                DataCenter.ArrowManager:ShowArrow(param)
                
                local secondParam = {}
                secondParam.arrowSecondType = ArrowSecondType.AllianceScience
                secondParam.uiName = UIWindowNames.UIAllianceMainTable
                DataCenter.ArrowManager:SetSecondArrowParam({param, secondParam})
            else
                UIUtil.ShowTipsId(GameDialogDefine.NO_JOIN_ALLIANCE)
                GoToUtil.GotoOpenView(UIWindowNames.UIAllianceIntro,{ anim = true,isBlur = true})
            end
        elseif goType == QuestGoType.GoArena then
            local buildId = BuildingTypes.FUN_BUILD_ARENA
            local data = DataCenter.BuildCityBuildManager:GetCityBuildDataByBuildId(buildId)
            if data ~= nil then
                if data.state == BuildCityBuildState.Own then
                    GoToUtil.CloseAllWindows()
                    local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
                    if buildTemplate ~= nil then
                        GoToUtil.GotoCityPos(buildTemplate:GetPosition(), CS.SceneManager.World.InitZoom, LookAtFocusTime, function()
                            local obj = DataCenter.BuildBubbleManager:GetBubbleObjByBubbleTypeAndBuildId(BuildBubbleType.ArenaFreeTime, buildId)
                            if obj ~= nil then
                                local param = {}
                                param.positionType = PositionType.Screen
                                param.position = obj:GetArrowPosition()
                                DataCenter.ArrowManager:ShowArrow(param)
                            else
                                UIManager:GetInstance():OpenWindow(UIWindowNames.UIArenaMain,{anim = false})
                            end
                        end)
                    end
                else
                    GoToUtil.GotoBuildListByBuildId(buildId)
                end
            end
        else
            GoToUtil.CloseAllWindows()
        end
    end
end

--跳转建筑（世界的建筑跳转到世界）(uuid 建筑uuid worldTileBtnType WorldTileBtnType)
local function GotoCityByBuildUuid(uuid,btnType, needShow,quest)
    local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(uuid)
    if buildData ~= nil then
        local buildId = buildData.itemId
        local isFinish = true
        if buildData.destroyStartTime<=0 then
            if buildData.isWorldBuild then
                isFinish = DataCenter.BuildManager:CheckSendBuildFinish(buildData.uuid,true)
            else
                isFinish = DataCenter.BuildManager:CheckSendBuildFinish(buildData.uuid)
            end
        end
        local worldTileBtnType = btnType
        local needShowWorldTileUI = needShow
        local questTemplate = quest
        --这里判断是否世界建筑
        if buildData.isWorldBuild then
            SceneUtils.ChangeToWorld(function()
                GoToUtil.GotoWorldBuildAndOpenUI(buildData.pointId,worldTileBtnType, needShowWorldTileUI,isFinish,buildId,buildData.uuid,questTemplate, true)
            end)
        else
            SceneUtils.ChangeToCity(function()
                --这里区分打开按钮界面或者升级界面
                local gotoFun = nil
                if buildId == BuildingTypes.FUN_BUILD_MAIN then
                    if buildData:IsUpgrading() then
                        local param = {}
                        param.buildId = buildId
                        if quest ~= nil then
                            param.questId = quest.id
                        end
                        GoToUtil.GotoOpenBuildCreateWindow(UIWindowNames.UIBuildCreate, NormalPanelAnim, param)
                    else
                        if btnType == nil then
                            UIManager:GetInstance():OpenWindow(UIWindowNames.UIBuildOpenFire)
                        else
                            UIManager:GetInstance():OpenWindow(UIWindowNames.UIBuildOpenFire, NormalPanelAnim, {arrowUpgrade = true})
                        end
                    end
                elseif buildId == BuildingTypes.FUN_BUILD_ARENA then
                    gotoFun = function()
                        local pos = nil
                        if questTemplate ~= nil then
                            --任务进来，有气泡不打开界面手指指向气泡
                            local obj = DataCenter.BuildBubbleManager:GetBubbleObjByBubbleTypeAndBuildId(BuildBubbleType.ArenaFreeTime, buildId)
                            if obj ~= nil then
                                pos = obj:GetArrowPosition()
                            end
                        end
                        if pos == nil then
                            UIManager:GetInstance():OpenWindow(UIWindowNames.UIArenaMain,{anim = false})
                        else
                            local param = {}
                            param.positionType = PositionType.Screen
                            param.position = pos
                            DataCenter.ArrowManager:ShowArrow(param)
                        end
                    end
                elseif buildId == BuildingTypes.FUN_BUILD_MILESTONE then

                elseif buildId == BuildingTypes.FUN_BUILD_RADAR_CENTER then
                    gotoFun = function()
                        local pos = nil
                        if questTemplate ~= nil then
                            --任务进来，有气泡不打开界面手指指向气泡
                            local obj = DataCenter.BuildBubbleManager:GetBubbleObjByBubbleTypeAndBuildId(BuildBubbleType.DetectEvent, buildId)
                            if obj ~= nil then
                                pos = obj:GetArrowPosition()
                            end
                        end
                        if pos == nil then
                            GoToUtil.GotoWorldBuildAndOpenUI(buildData.pointId,worldTileBtnType, needShowWorldTileUI,isFinish,buildId,buildData.uuid,questTemplate, false)
                            --UIManager:GetInstance():OpenWindow(UIWindowNames.UIDetectEvent)
                        else
                            local param = {}
                            param.positionType = PositionType.Screen
                            param.position = pos
                            DataCenter.ArrowManager:ShowArrow(param)
                        end
                    end
                elseif buildId == BuildingTypes.APS_BUILD_PUB then
                    gotoFun = function()
                        local pos = nil
                        if questTemplate ~= nil then
                            --任务进来，有气泡不打开界面手指指向气泡
                            local obj = DataCenter.BuildBubbleManager:GetBubbleObjByBubbleTypeAndBuildId(BuildBubbleType.HeroRecruit, buildId)
                            if obj ~= nil then
                                pos = obj:GetArrowPosition()
                            end
                        end
                        if pos == nil then
                            GoToUtil.GotoWorldBuildAndOpenUI(buildData.pointId,worldTileBtnType, needShowWorldTileUI,isFinish,buildId,buildData.uuid,questTemplate, false)
                            --UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroRecruit)
                        else
                            local param = {}
                            param.positionType = PositionType.Screen
                            param.position = pos
                            DataCenter.ArrowManager:ShowArrow(param)
                        end
                    end
                elseif buildId == BuildingTypes.FUN_BUILD_OPINION_BOX then
                    gotoFun = function()
                        local pos = nil
                        if questTemplate ~= nil then
                            --任务进来，有气泡不打开界面手指指向气泡
                            local obj = DataCenter.BuildBubbleManager:GetBubbleObjByBubbleTypeAndBuildId(BuildBubbleType.OpinionBox, buildId)
                            if obj ~= nil then
                                pos = obj:GetArrowPosition()
                            end
                        end
                        if pos == nil then
                            UIManager:GetInstance():OpenWindow(UIWindowNames.UIOpinionBox)
                        else
                            local param = {}
                            param.positionType = PositionType.Screen
                            param.position = pos
                            DataCenter.ArrowManager:ShowArrow(param)
                        end
                    end
                elseif buildId == BuildingTypes.DS_EXPLORER_CAMP then
                    gotoFun = function()
                        local pos = nil
                        if questTemplate ~= nil then
                            --任务进来，有气泡不打开界面手指指向气泡
                            local obj = DataCenter.BuildBubbleManager:GetBubbleObjByBubbleTypeAndBuildId(BuildBubbleType.HangupReward, buildId)
                            if obj ~= nil then
                                pos = obj:GetArrowPosition()
                            end
                        end
                        if pos == nil then
                            if DataCenter.LandManager:IsFunctionEnd() then
                                --打开推图关
                                UIManager:GetInstance():OpenWindow(UIWindowNames.UIJeepAdventureMain,  { anim = true })
                            else
                                --打开挂机奖励
                                UIManager:GetInstance():OpenWindow(UIWindowNames.UIJeepAdventureReward, NormalPanelAnim)
                            end
                        else
                            local param = {}
                            param.positionType = PositionType.Screen
                            param.position = pos
                            DataCenter.ArrowManager:ShowArrow(param)
                        end
                    end
                else
                    local levelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildId, 0)
                    if levelTemplate ~= nil and levelTemplate:IsFurnitureBuild() then
                        local param = {}
                        param.buildId = buildId
                        param.buildUuid = uuid
                        if quest ~= nil then
                            param.questId = quest.id
                        end

                        if buildData:IsUpgrading() then
                            GoToUtil.GotoOpenBuildCreateWindow(UIWindowNames.UIBuildCreate, NormalPanelAnim, param)
                        else
                            UIManager:GetInstance():OpenWindow(UIWindowNames.UIFurnitureUpgrade, NormalPanelAnim, param)
                        end
                    else
                        GoToUtil.GotoWorldBuildAndOpenUI(buildData.pointId,worldTileBtnType, needShowWorldTileUI,isFinish,buildId,buildData.uuid,questTemplate, false)
                    end
                end
                if gotoFun then
                    local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
                    if buildTemplate ~= nil then
                        local pos = buildTemplate:GetPosition()
                        pos.y = 0
                        local index = SceneUtils.WorldToTileIndex(CS.SceneManager.World.CurTarget, ForceChangeScene.City)
                        local posIndex = SceneUtils.WorldToTileIndex(pos, ForceChangeScene.City)
                        if index == posIndex then
                            gotoFun()
                        else
                            GoToUtil.GotoCityPos(pos, CS.SceneManager.World.InitZoom, LookAtFocusTime, gotoFun)
                        end
                    end
                end
            end)
        end
    end
end

--跳转到世界建筑并且打开UI，指向worldTileBtnType按钮
local function GotoWorldBuildAndOpenUI(pointId,worldTileBtnType, needShowWorldTileUI,isFinish,itemId,uuid,questTemplate, isWorldBuild)
    GoToUtil.CloseAllWindows()
    local template = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(itemId)
    local worldPointPos = BuildingUtils.GetBuildModelCenterVec(pointId, template.tiles)
    if worldTileBtnType == WorldTileBtnType.City_Upgrade then
        if itemId == BuildingTypes.FUN_BUILD_MAIN then
            worldPointPos.z = worldPointPos.z + 5
        else
            local building = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(itemId)
            if building~=nil then
                if not string.IsNullOrEmpty(building.upgrade_notice) then
                    local obj = DataCenter.BuildBubbleManager:GetBubbleObjByBubbleTypeAndBuildId(BuildBubbleType.BuildCanUpgrade,itemId)
                    if obj then
                        worldPointPos = obj.transform.position
                    end
                end
            end
        end
    end
    GoToUtil.GotoPos(worldPointPos, CS.SceneManager.World.InitZoom,LookAtFocusTime)
    local timer = TimerManager:GetInstance():GetTimer(LookAtFocusTime, function()
        local level = 0
        local buildData = DataCenter.BuildManager:GetBuildingDataByPointId(pointId, isWorldBuild)
        if buildData ~= nil then
            level = buildData.level
        end
        if level >= 0 and needShowWorldTileUI ~= false then
            if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIWorldTileUI) and worldTileBtnType then
                local param = {}
                param.pointId = pointId
                param.worldTileBtnType = worldTileBtnType
                EventManager:GetInstance():Broadcast(EventId.RefreshUIWorldTileUI,param)
            else
                if isFinish then
                    local buildData = DataCenter.BuildManager:GetBuildingDataByPointId(pointId, isWorldBuild)
                    if worldTileBtnType then
                        --如果是升级并且是特定建筑，检查升级气泡
                        if worldTileBtnType == WorldTileBtnType.City_Upgrade then
                            local data
                            if CS.SceneManager:IsInWorld() then
                                data = DataCenter.WorldPointManager:GetPointInfo(pointId)
                            elseif CS.SceneManager:IsInCity() then
                                data = buildData
                            end
                            if data then
                                local building = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(data.itemId)
                                if building~=nil then
                                    if not string.IsNullOrEmpty(building.upgrade_notice) then
                                        local obj = DataCenter.BuildBubbleManager:GetBubbleObjByBubbleTypeAndBuildId(BuildBubbleType.BuildCanUpgrade,data.itemId)
                                        --升级气泡存在时指向气泡，不存在时打开面板
                                        if obj then
                                            WorldArrowManager:GetInstance():ShowArrowEffect(0,obj.transform.position,ArrowType.Building)
                                            return
                                        else
                                            if level == 0 then
                                                GoToUtil.GotoOpenBuildCreateWindow(UIWindowNames.UIBuildCreate, NormalPanelAnim, {buildId = data.itemId})
                                                return
                                            end
                                        end
                                    else
                                        if level == 0 then
                                            GoToUtil.GotoOpenBuildCreateWindow(UIWindowNames.UIBuildCreate, NormalPanelAnim, {buildId = data.itemId})
                                            return
                                        end
                                    end
                                end
                            end
                        elseif level == 0 then
                            local obj = DataCenter.BuildBubbleManager:GetBubbleObjByBubbleTypeAndBuildId(BuildBubbleType.BuildingLv0Ruins,buildData.itemId)
                            --升级气泡存在时指向气泡，不存在时打开面板
                            if obj then
                                WorldArrowManager:GetInstance():ShowArrowEffect(0,obj.transform.position)
                            else
                                GoToUtil.GotoOpenBuildCreateWindow(UIWindowNames.UIBuildCreate, NormalPanelAnim, {buildId = buildData.itemId})
                            end
                            return
                        end
                        local info
                        if CS.SceneManager:IsInWorld() then
                            info = DataCenter.WorldPointManager:GetPointInfo(pointId)
                        elseif CS.SceneManager:IsInCity() then
                            info = DataCenter.BuildManager:GetBuildingDataByPointId(pointId, isWorldBuild)
                        end
                        UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldTileUI,{anim = true,playEffect = false},pointId,false,worldTileBtnType,questTemplate)
                    elseif level == 0 then
                        GoToUtil.GotoOpenBuildCreateWindow(UIWindowNames.UIBuildCreate, NormalPanelAnim, {buildId = buildData.itemId})
                    end
                else
                    DataCenter.BuildManager:CheckSendBuildFinish(uuid)
                end
            end
        else
            EventManager:GetInstance():Broadcast(EventId.UIMAIN_VISIBLE, true)
        end
    end , nil, true,false,false)
    timer:Start()
end

--跳转到世界资源点
local function GotoWorldResource(resourceType)
    local list = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(BuildingTypes.FUN_BUILD_MAIN)
    if list ~= nil and table.count(list) > 0 then
        GoToUtil.CloseAllWindows()
        SFSNetwork.SendMessage(MsgDefines.FindResourcePoint,resourceType, 0)
    end
end

--跳转到资源建筑可收取，每日用
local function GotoResourceBuild()
    local lists = {}
    for i = 1, 4 do
        lists[i] = DataCenter.BuildManager:GetCanGetResourceBuildUuidByResourceType(ResType[i]) or 0
    end
    for i = 4, 1, -1 do
        if lists[i] == 0 then
            table.remove(lists,i)
        end
    end
    if next(lists) then
        table.sort(lists,function(a,b)
            if a.num > b.num then
                return true
            elseif a.num == b.num then
                return false
            end
            return false
        end)
        GoToUtil.GotoCityByBuildUuid(lists[1].uuid)
    else
        GoToUtil.GotoBuildListByBuildId()
    end
end

--跳转到集结怪，每日用
local function GoAttackMonster()
    local targetOwnerList = DataCenter.WorldMarchDataManager:GetMarchesBossInfo()
    local isGoto = false
    for i, v in pairs(targetOwnerList) do
        if v:GetMarchType() == NewMarchType.BOSS then
            GoToUtil.CloseAllWindows()
            isGoto = true
            GoToUtil.GotoWorldPos(SceneUtils.TileIndexToWorld(v.startPos), CS.SceneManager.World.InitZoom, LookAtFocusTime, function ()
                UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint,{anim = true,playEffect = false,UIMainAnim = UIMainAnimType.LeftRightBottomHide},v.uuid,v.startPos,"",WorldPointUIType.Monster,0)
                --UIManager:GetInstance():OpenWindow(UIWindowNames.WorldDesUI,v.uuid)
            end)
            break
        end
    end
    if not isGoto then
       -- UIUtil.ShowMessage(Localization:GetString("170441"),1,nil,nil,function ()end,nil,nil)
        UIUtil.ShowTipsId(170441) 
    end
end

--跳转等级区间的集结怪
local function GotoBossMonsterBetweenLv(self, minLevel, maxLevel)
    local targetOwnerList = DataCenter.WorldMarchDataManager:GetMarchesBossInfo()
    local findMonster = nil
    local currentMonsterLv = 0
    for i, v in pairs(targetOwnerList) do
        if v:GetMarchType() == NewMarchType.BOSS then
            local monsterId = v.monsterId
            local level =  DataCenter.MonsterTemplateManager:GetTableValue(monsterId,"level")
            if level >= minLevel and level <= maxLevel and currentMonsterLv < level then
                findMonster = v
                currentMonsterLv = level
            end
        end
    end
    if findMonster ~= nil then
        GoToUtil.CloseAllWindows()
        GoToUtil.GotoWorldPos(SceneUtils.TileIndexToWorld(findMonster.startPos), CS.SceneManager.World.InitZoom, LookAtFocusTime, function ()
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint,{anim = true,playEffect = false,UIMainAnim = UIMainAnimType.LeftRightBottomHide}, findMonster.uuid, findMonster.startPos, "", WorldPointUIType.Monster, 0)
        end)
    end
end

--跳转到雷达探测具体任务，每日用
local function GoRadarProbe(eventId, eventType,uuid) -- 匹配 eventId 或 eventType
    --有雷达站时看向雷达站，没有就建造
    local buildId = BuildingTypes.FUN_BUILD_RADAR_CENTER
    local data = DataCenter.BuildCityBuildManager:GetCityBuildDataByBuildId(buildId)
    if data ~= nil then
        if data.state == BuildCityBuildState.Own then
            if uuid then
                GoToUtil.CloseAllWindows()
                UIManager:GetInstance():OpenWindow(UIWindowNames.UIDetectEvent, uuid)
            else
                --如果在主城跳到建筑并打开界面,在世界就手指指向雷达按钮
                if SceneUtils.GetIsInWorld() then
                    GoToUtil.CloseAllWindows()
                    local param = {}
                    param.positionType = PositionType.Screen
                    param.position = UIUtil.GetUIMainSavePos(UIMainSavePosType.LaDar)
                    DataCenter.ArrowManager:ShowArrow(param)
                else
                    GoToUtil.CloseAllWindows()
                    local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
                    if buildTemplate ~= nil then
                        GoToUtil.GotoCityPos(buildTemplate:GetPosition(), CS.SceneManager.World.InitZoom, LookAtFocusTime, function()
                            local obj = DataCenter.BuildBubbleManager:GetBubbleObjByBubbleTypeAndBuildId(BuildBubbleType.DetectEvent, buildId)
                            if obj ~= nil then
                                local param = {}
                                param.positionType = PositionType.Screen
                                param.position = obj:GetArrowPosition()
                                DataCenter.ArrowManager:ShowArrow(param)
                            else
                                local list = DataCenter.RadarCenterDataManager:GetDetectEventInfoUuids()
                                local result = {}
                                local function GetOneEventData(uuid)
                                    local data = DataCenter.RadarCenterDataManager:GetDetectEventInfo(uuid)
                                    if data == nil then
                                        return nil
                                    end

                                    local template = DataCenter.DetectEventTemplateManager:GetDetectEventTemplate(data.eventId)
                                    if template == nil then
                                        return nil
                                    end
                                    local param = {}
                                    param.uuid = uuid
                                    param.eventId = tonumber(data.eventId)
                                    param.template = template
                                    return param
                                end
                                table.walk(list, function (k, v)
                                    local param = GetOneEventData(v)
                                    if param ~= nil then
                                        table.insert(result, param)
                                    end
                                end)
                                local isFind = false
                                local isSpecial = 0
                                local quality = 0
                                local uuid = 0
                                for i = 1, #result do
                                    if result[i].template:getValue("type") == DetectEventType.DetectEventTypeSpecial then
                                        isSpecial = i
                                    end
                                    if eventId == result[i].eventId or eventType == result[i].template:getValue("type") then
                                        if quality < result[i].template:getValue("quality") then
                                            quality = result[i].template:getValue("quality")
                                            uuid = result[i].uuid
                                        end
                                        isFind = true
                                    end
                                end
                                if isFind then
                                    UIManager:GetInstance():OpenWindow(UIWindowNames.UIDetectEvent,uuid)
                                elseif eventType then
                                    UIManager:GetInstance():OpenWindow(UIWindowNames.UIDetectEvent)
                                elseif isSpecial ~= 0 then
                                    UIUtil.ShowTips(Localization:GetString("129098",result[isSpecial].template:getValue("nameValue")))
                                    UIManager:GetInstance():OpenWindow(UIWindowNames.UIDetectEvent,result[isSpecial].uuid)
                                else
                                    UIManager:GetInstance():OpenWindow(UIWindowNames.UIDetectEvent)
                                end
                            end
                        end)
                    end
                end
            end
        else
            GoToUtil.GotoBuildListByBuildId(buildId)
        end
    end
end

local function OpenInCity(openCallback, targetBuild)
    targetBuild = targetBuild or BuildingTypes.FUN_BUILD_MAIN
    local buildList = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(targetBuild)
    if buildList~=nil and table.count(buildList)>0 and buildList[1] ~=nil then
        local posEnd = buildList[1].pointId
        GoToUtil.GotoCityPos(SceneUtils.TileIndexToWorld(posEnd,ForceChangeScene.City), CS.SceneManager.World.InitZoom, LookAtFocusTime, openCallback)
    else
        GoToUtil.CloseAllWindows()
        return
    end
end

--跳转到垃圾
local function GoGarbage(questTemplate)
    GoToUtil.CloseAllWindows()
    SFSNetwork.SendMessage(MsgDefines.GetGarbageInfo)
end

--购买机器人
local function GotoBuildListRobotByRobotId(robotId)
    GoToUtil.CloseAllWindows()
end

--训练士兵
local function GoBarracks()
    local queueStateFree = {}
    local queueStateWork = {}
    local queueStateFinish = {}
    for i, v in pairs(BarracksBuild) do
        local queueType = DataCenter.ArmyManager:GetArmyQueueTypeByBuildId(v)
        local ArmyQueue = DataCenter.ArmyManager:GetArmyQueue(queueType)
        if ArmyQueue then
            --记录训练营状态
            if (ArmyQueue:GetQueueState() == NewQueueState.Free) then
                table.insert(queueStateFree,v)
            elseif  (ArmyQueue:GetQueueState() == NewQueueState.Work) then
                table.insert(queueStateWork,v)
            elseif  (ArmyQueue:GetQueueState() == NewQueueState.Finish) then
                table.insert(queueStateFinish,v)
            end
        end
    end
    if next(queueStateFree) then
        GoToUtil.CloseAllWindows()
        --只有一个训练营空着
        if #queueStateFree == 1 then
            GoToUtil.GotoCityByBuildId(queueStateFree[1],BarracksBuildToBtnType[queueStateFree[1]])
            return
        end
        local buildlv = {}
        --获取建筑等级
        for i = 1, #queueStateFree do
            local param = {}
            param.lv = DataCenter.BuildManager:GetMaxBuildingLevel(queueStateFree[i])
            param.buildId = queueStateFree[i]
            table.insert(buildlv,param)
        end
        table.sort(buildlv, function(a,b) return a.lv>b.lv end)
        GoToUtil.GotoCityByBuildId(buildlv[1].buildId,BarracksBuildToBtnType[buildlv[1].buildId])
    elseif next(queueStateFinish) then
        GoToUtil.GotoCityByBuildId(queueStateFinish[1],BarracksBuildToBtnType[queueStateFinish[1]])
    elseif next(queueStateWork) then
        --没有空闲训练营时，跳转到第一个训练营并加速
        GoToUtil.GotoCityByBuildId(queueStateWork[1],WorldTileBtnType.City_SpeedUpTrain)
    end
end

local function GotoTrainSolider(jumpType)--type0:建造兵，--type1；升级兵
    local buildData = DataCenter.BuildManager:GetArmyBuildMaxLevelData()
    if buildData~=nil then
        GoToUtil.CloseAllWindows()
        UIManager:GetInstance():OpenWindow(UIWindowNames.UITrain,buildData.itemId,jumpType)
    else 
        GoToUtil.GotoCityByBuildId(BuildingTypes.FUN_BUILD_CAR_BARRACK)
    end
end

--连接建筑道路
local function GoConnectBuild(buildId)
end

--寻找野怪掉落宝箱
local function GotoMonsterReward()
    local minDis = IntMaxValue
    local minDisPoint = nil
    local list = DataCenter.CollectRewardDataManager:GetRewardListBySort()
    if #list>0 then
        for i = 1, #list do
            --循环计算最小距离
            local dis =  math.ceil(SceneUtils.TileDistance(SceneUtils.IndexToTilePos(list[i].pointId,ForceChangeScene.World), DataCenter.BuildManager.main_city_pos))
            if dis < minDis then
                minDis = dis
                minDisPoint = list[i].pointId
            end
        end
    end
    if minDisPoint then
        --有奖励箱子找箱子
        GoToUtil.CloseAllWindows()
        WorldArrowManager:GetInstance():RemoveEffect()
        GoToUtil.GotoWorldPos(SceneUtils.TileIndexToWorld(minDisPoint,ForceChangeScene.World), CS.SceneManager.World.InitZoom,LookAtFocusTime,function()
            WorldArrowManager:GetInstance():ShowArrowEffect(0,SceneUtils.TileIndexToWorld(minDisPoint),ArrowType.Guide_Garbage)
        end)
    else
        SceneUtils.ChangeToWorld(function()
            GoToUtil.GotoOpenView(UIWindowNames.UISearch,UISearchType.Monster, DataCenter.MonsterManager:GetCurCanAttackMaxLevel())
        end)
    end
end

--跳转到英雄驻扎
local function GoHeroStation(questTemplate)
    local buildId = questTemplate.para1
    local buildList = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(buildId)
    GoToUtil.CloseAllWindows()
    if buildList~=nil and table.count(buildList)>0 and buildList[1] ~=nil then
        if buildList[1].state == BuildingStateType.Upgrading then
            DataCenter.BuildManager:CheckSendBuildFinish(buildList[1].uuid)
        end
        local posEnd = buildList[1].pointId
        local stationId = DataCenter.HeroStationManager:GetStationIdByBuildId(tonumber(buildId))
        local isArrow = nil
        local index = 1 --默认第一个
        --判断英雄是否可驻扎并且是否有驻扎空位
        if stationId ~= nil then
            local stationData = DataCenter.HeroStationManager:GetStationData(stationId)
            local heroUuids = stationData:GetHeroUuids()
            local emptySlot = DataCenter.HeroStationManager:GetEmptySlotList(stationId)
            local lockedSlot = DataCenter.HeroStationManager:GetLockedSlotList(stationId)
            --如果英雄不够那就判断判断是否还能驻扎
            if #heroUuids < questTemplate.para2 then
                if next(emptySlot) then
                    isArrow = 1
                elseif next(lockedSlot) then
                    isArrow = 3
                end
            else
                --如果英雄够则是等级不够
                for i = 1, #heroUuids do
                    --查找要升级的英雄
                    local heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroUuids[i])
                    if heroData.level < tonumber(questTemplate.para3) then
                        index = i
                        break
                    end
                end
                isArrow = 2
            end
        end
        DataCenter.BuildManager:CheckSendBuildFinish(buildList[1].uuid)
        GoToUtil.GotoPos(SceneUtils.TileIndexToWorld(posEnd), CS.SceneManager.World.InitZoom,LookAtFocusTime, function ()
            GoToUtil.GotoOpenView(UIWindowNames.UIHeroStation, stationId,isArrow,false,index)
        end)
    else
        GoToUtil.GotoCityByBuildId(buildId)
        return
    end
end

--跳转驻守任务目标增益
local function GoHeroStationScores(questTemplate)
    local buildId = questTemplate.para1
    local buildList = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(buildId)
    GoToUtil.CloseAllWindows()
    if buildList~=nil and table.count(buildList)>0 and buildList[1] ~=nil then
        local posEnd = buildList[1].pointId
        local stationId = DataCenter.HeroStationManager:GetStationIdByBuildId(tonumber(buildId))
        GoToUtil.GotoPos(SceneUtils.TileIndexToWorld(posEnd), CS.SceneManager.World.InitZoom,LookAtFocusTime, function ()
            GoToUtil.GotoOpenView(UIWindowNames.UIHeroStation, stationId,nil,false,nil,questTemplate)
        end)
    else
        GoToUtil.GotoCityByBuildId(buildId)
    end
end

--跳转治疗伤兵
local function GoHospital(questTemplate)
    local buildId = questTemplate.para1
    local buildList = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(buildId)
    if buildList~=nil and table.count(buildList)>0 and buildList[1] ~=nil then
        local posEnd = buildList[1].pointId
        GoToUtil.GotoCityPos(SceneUtils.TileIndexToWorld(posEnd,ForceChangeScene.City), CS.SceneManager.World.InitZoom,LookAtFocusTime, function ()
            local isArrow = 1
            GoToUtil.GotoOpenView(UIWindowNames.UIHospital,isArrow)
        end)
    else
        GoToUtil.GotoCityByBuildId(buildId)
    end
end

--跳转到礼包商城
local function GoGiftMall()
    GoToUtil.GotoOpenView(UIWindowNames.UIGiftPackage,{anim = true})
end

--跳转到背包使用道具
local function GoBagPackUseItem(itemId)
    GoToUtil.GotoOpenView(UIWindowNames.UICapacityTableNew, UICapacityTableTab.Item,itemId)
end

--寻找敌人
local function GoSearchEnemy(goPara)
    SFSNetwork.SendMessage(MsgDefines.FindEnemyPoint,tonumber(goPara[1]))
end

--跳转到车库升级
local function GoGarageUpgrade(goPara)
    local buildList = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(tonumber(goPara[1]))
    if buildList~=nil and table.count(buildList)>0 and buildList[1] ~=nil then
        local posEnd = buildList[1].pointId
        GoToUtil.CloseAllWindows()
        GoToUtil.GotoCityPos(SceneUtils.TileIndexToWorld(posEnd,ForceChangeScene.City), CS.SceneManager.World.InitZoom,LookAtFocusTime, function()
            --GoToUtil.GotoOpenView(UIWindowNames.UIGarageRefit, tonumber(goPara[1]),tonumber(goPara[2]))
        end)
    else
        GoToUtil.CloseAllWindows()
        GoToUtil.GotoCityByBuildId(tonumber(goPara[1]))
    end
end

--跳转到自己的大本
local function GotoMainBuildPos(self)
    local buildList = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(BuildingTypes.FUN_BUILD_MAIN)
    if buildList~=nil and table.count(buildList)>0 and buildList[1] ~=nil then
        local posEnd = buildList[1].pointId
        GoToUtil.GotoCityPos(SceneUtils.TileIndexToWorld(posEnd), CS.SceneManager.World.InitZoom)
    end
end

local function FindMonster(level)
    SFSNetwork.SendMessage(MsgDefines.FindMonster, LuaEntry.Player:GetMainWorldPos(), level, false)
end

local function GotoGuluBox(self)
    local list = DataCenter.CollectRewardDataManager:GetRewardListBySort()
    if #list > 0 then
        GoToUtil.CloseAllWindows()
        local pointId = list[1].pointId
        local pos = SceneUtils.TileIndexToWorld(pointId, ForceChangeScene.World)
        GoToUtil.GotoWorldPos(pos, CS.SceneManager.World.InitZoom,LookAtFocusTime, function()
            WorldArrowManager:GetInstance():ShowArrowEffect(0, pos)
        end)
        return true
    end
    return false
end

local function GotoColdStorage(itemId)
    -- deleted
end


-- 事实上，garage 就是车库的 buildId
local function GoToGarageRefit(garage)
    GoToUtil.CloseAllWindows()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIGarageRefit, garage)
end

local function GoHeroTrust(questTemplate)
    local worldPos = DataCenter.HeroEntrustTemplateManager:GetHeroEntrustPosition(tonumber(questTemplate.gopara[1]))
    if worldPos then
        GoToUtil.GotoCityPos(worldPos, CS.SceneManager.World.InitZoom,LookAtFocusTime,function ()
        end)
    end
end

local function GotoPos(worldPos,zoom,time, onComplete,serverId,worldId,canDragonMove)
    local curWorldId = LuaEntry.Player:GetCurWorldId()
    local curServerId = LuaEntry.Player:GetCurServerId()
    local selfServerId = LuaEntry.Player:GetSelfServerId()
    local targetServerId = serverId
    local targetWorldId = worldId
    if targetServerId == nil then
        targetServerId = LuaEntry.Player:GetSelfServerId()
    end
    if targetWorldId == nil then
        targetWorldId = LuaEntry.Player.srcWorldId
    end
    local targetServerType = DataCenter.AccountManager:GetServerTypeByServerId(targetServerId)
    if canDragonMove == nil or canDragonMove ==false then
        if targetServerType == ServerType.DRAGON_BATTLE_FIGHT_SERVER then
            if LuaEntry.Player.serverType ~= ServerType.DRAGON_BATTLE_FIGHT_SERVER or targetWorldId ~= curWorldId then
                UIUtil.ShowTipsId(376132)
                return
            end
        else
            if LuaEntry.Player.serverType == ServerType.DRAGON_BATTLE_FIGHT_SERVER then
                UIUtil.ShowTipsId(376135)
                return
            end
        end
    end
    if CS.SceneManager.World ~= nil then
        local zoomSize = zoom
        if zoomSize ==nil then
            zoomSize = CS.SceneManager.World.InitZoom
        end
        local changeTime = time
        if changeTime ==nil then
            changeTime = LookAtFocusTime
        end
        if curServerId~=targetServerId or targetWorldId~=curWorldId then
            if targetServerId == selfServerId and targetWorldId == LuaEntry.Player.srcWorldId then --回原服
                CrossServerUtil.OnBackSelfServer()
            else
                CrossServerUtil.OnCrossServer(targetServerId,targetWorldId) --去新的服
            end
            CS.SceneManager.World:AutoLookat(worldPos,zoomSize,changeTime,onComplete)
        else --和当前完全一致
            CS.SceneManager.World:AutoLookat(worldPos,zoomSize,changeTime,onComplete) --正常查看本服
        end
    end
end


local function GotoDragonPos(worldPos,zoom,time, onComplete,serverId,worldId)
    local pos = worldPos
    local lookZoom = zoom
    local lookTime = time
    local action = onComplete
    local targetSId = serverId
    local wId = worldId
    --这里防止原服点坐标在他服显示，只发一遍获取
    local noSendReq = serverId ~= LuaEntry.Player:GetCurServerId()
    SceneUtils.ChangeToWorld(function()
        GoToUtil.GotoPos(pos,lookZoom,lookTime,action,targetSId,wId,true)
    end, noSendReq)
end

local function GotoCityPos(cityPos,zoom,time,onComplete)
    if LuaEntry.Player.serverType == ServerType.DRAGON_BATTLE_FIGHT_SERVER then
        UIUtil.ShowTipsId(376135)
        return
    end
    local pos = cityPos
    local lookZoom = zoom
    local lookTime = time
    local action = onComplete
    SceneUtils.ChangeToCity(function()
        GoToUtil.GotoPos(pos,lookZoom,lookTime,action,LuaEntry.Player:GetSelfServerId())
    end)
end

local function GotoWorldPos(cityPos,zoom,time,onComplete,serverId,worldId)
    local targetServerType = DataCenter.AccountManager:GetServerTypeByServerId(serverId)
    if serverId~=nil and serverId>0 and targetServerType ~= LuaEntry.Player.serverType then
        if targetServerType == ServerType.DRAGON_BATTLE_FIGHT_SERVER then
            UIUtil.ShowTipsId(376132)
            
        end
        if LuaEntry.Player.serverType == ServerType.DRAGON_BATTLE_FIGHT_SERVER then
            UIUtil.ShowTipsId(376135)
            return
        end
    end
    local canUnlock,lock_tips = SceneUtils.CheckIsWorldUnlock()
    if canUnlock ==false then
        if lock_tips ~= 0 then
            UIUtil.ShowTipsId(lock_tips)
        end
        return
    end
    local pos = cityPos
    local lookZoom = zoom
    local lookTime = time
    local action = onComplete
    local targetSId = serverId
    local targetWorldId = worldId
    --这里防止原服点坐标在他服显示，只发一遍获取
    local noSendReq = false --serverId ~= LuaEntry.Player:GetCurServerId()
    SceneUtils.ChangeToWorld(function()
        GoToUtil.GotoPos(pos,lookZoom,lookTime,action,targetSId,targetWorldId)
    end, noSendReq)
end


local function GoTriggerPve(goPara)
    local trigger = nil
    for i = 1 ,#goPara do
        local str = string.split(goPara[i],",")
        local isGoto = true
        for k = 1 ,#str do
            local temp = DataCenter.BattleLevel:GetTriggerByTriggerId(tonumber(str[k]))
            if temp then
                local isFinish = DataCenter.BattleLevel:IsFinishTrigger(tonumber(str[k]))
                if isFinish then
                    isGoto = false
                end
            end
        end
        if isGoto then
            trigger = DataCenter.BattleLevel:GetTriggerByTriggerId(tonumber(str[1]))
            if trigger then
                local isFinish = DataCenter.BattleLevel:IsFinishTrigger(tonumber(goPara[i]))
                if not isFinish then
                    local pos = trigger:GetPosition()
                    local cameraParam = DataCenter.BattleLevel:GetCameraParam()
                    local height = (cameraParam and cameraParam.height) and cameraParam.height or Const.CameraParam.HeroExp[1].height
                    local battleLevel = DataCenter.BattleLevel
                    battleLevel:GetPlayer():PauseCameraFollow()
                    battleLevel:AutoLookat(pos, height, 0.4)
                    TimerManager:GetInstance():DelayInvoke(function()
                        battleLevel:AddOneArrow(pos)
                    end, 0.4)
                    TimerManager:GetInstance():DelayInvoke(function()
                        battleLevel:GetPlayer():ResumeCameraFollow()
                        battleLevel:RemoveOneArrowByPos(pos)
                    end, 2)
                    break
                end
            end
        end
    end
end

local function GoActWindow(actId,actParam)
    GoToUtil.CloseAllWindows()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityCenterTable, { anim = true, UIMainAnim = UIMainAnimType.AllHide },actId,nil,actParam)
end

local function GoActWindowByType(type)
    GoToUtil.CloseAllWindows()
    local activityList = DataCenter.ActivityListDataManager:GetActivityDataByType(type)
    if activityList and #activityList > 0 then
        local curTime = UITimeManager:GetInstance():GetServerTime()
        for _, actData in pairs(activityList) do
            if curTime > actData.startTime and curTime < actData.endTime then
                if actData.type == ActivityEnum.ActivityType.Arms then
                    if actData.personalEventType and actData.personalEventType ~= PersonalEventType.Permanent then
                        UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityCenterTable, { anim = true, UIMainAnim = UIMainAnimType.AllHide },tonumber(actData.id))
                        break
                    end
                else
                    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityCenterTable, { anim = true, UIMainAnim = UIMainAnimType.AllHide },tonumber(actData.id))
                    break
                end
            end
        end
        --if activityList and next(activityList) then
        --    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityCenterTable, { anim = true, UIMainAnim = UIMainAnimType.AllHide },tonumber(activityList[1].id))
        --end
    end
end

--根据礼包id跳转到礼包
local function GOGiftPackageView(id)
    GoToUtil.CloseAllWindows()
    local giftPack = GiftPackManager.get(id)
    --检查下是不是首充
    if id == LuaEntry.DataConfig:TryGetStr("first_pay", "k2") then
		--首充是否还在
        if DataCenter.PayManager:CheckIfFirstPayOpen() then
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIFirstPay, { anim = false, UIMainAnim = UIMainAnimType.AllHide })
        end
    else
        GoToUtil.GotoGiftPackView(giftPack)
    end
end

local function GoCityCollect(gopara)
    -- deleted
end

local function GoFormation(goPara)
    EventManager:GetInstance():Broadcast(EventId.GoTroopListShow,goPara)
end

local function GetBuildState(buildId)
    local buildNum = DataCenter.BuildManager:GetHaveBuildNumWithOutFoldUpByBuildId(buildId)
    local maxNum = DataCenter.BuildManager:GetMaxBuildNum(buildId)
    local curMaxNum = DataCenter.BuildManager:GetCurMaxBuildNum(buildId)
    if buildNum >=  maxNum then
        return false
    end
    if buildNum >= curMaxNum then
        return false
    end
    local list = DataCenter.BuildManager:GetFoldUpAndNotFixBuildByBuildId(buildId)
    if list ~= nil and table.count(list) > 0 then
        return true
    end
    local levelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildId, 0)
    if levelTemplate ~= nil then
        --判前置建筑
        local preBuild = levelTemplate:GetPreBuild()
        if preBuild ~= nil then
            for k1,v1 in ipairs(preBuild) do
                if DataCenter.BuildManager:IsExistBuildByTypeLv(v1[1],v1[2]) then
                    return true
                end
            end
        end
    end
    return false
end

local function GoCheckBuild(buildId,worldTileBtnType)
    local state = GoToUtil.GetBuildState(buildId)
    if state then
        GoToUtil.GotoBuildListByBuildId(buildId)
    else
        GoToUtil.GotoCityByBuildId(buildId,worldTileBtnType)
    end
end

local function GoHeroBag()
    GoToUtil.CloseAllWindows()
    local buildList = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(BuildingTypes.APS_BUILD_PUB)
    if buildList~=nil and table.count(buildList)>0 and buildList[1] ~=nil then
        local posEnd = buildList[1].pointId
        GoToUtil.GotoCityPos(SceneUtils.TileIndexToWorld(posEnd,ForceChangeScene.City),nil,nil,function()
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroBag)
        end)
    else
        GoToUtil.CloseAllWindows()
        GoToUtil.GotoCityByBuildId(BuildingTypes.FUN_BUILD_RADAR_CENTER)
        return
    end
end

local function GoHeroSkill(heroId,skillId, arrowType)
    if heroId ~= "" then
        local uuid = DataCenter.HeroDataManager:GetHeroUuidByHeroId(toInt(heroId))
        if uuid ~= 0 then
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroInfo,{ anim = true,UIMainAnim = UIMainAnimType.AllHide }, 1, uuid, {uuid},nil,nil,arrowType,nil,toInt(skillId))
        end
    else
        GoToUtil.GotoOpenView(UIWindowNames.UIHeroList,{anim = false,UIMainAnim = UIMainAnimType.AllHide})
    end
end

local function GotoOpenBuildCreateWindow(windowName,anim,userParam)
    SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
    local showCreate = true
    if userParam ~= nil and userParam.buildId ~= nil then
        if userParam.buildId == BuildingTypes.FUN_BUILD_MAIN then
            showCreate = true
        else
            local buildData = DataCenter.BuildManager:GetFunbuildByItemID(userParam.buildId)
            if buildData == nil or buildData.level < 1 then
                showCreate = true
            else
                local levelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(userParam.buildId, 0)
                if levelTemplate ~= nil and levelTemplate:IsFurnitureBuild() then
                    showCreate = true
                else
                    showCreate = false
                end
            end
        end
    end
    if showCreate then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIBuildCreate, anim,userParam)
    else
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIBuildUpgrade, NormalBlurPanelAnim, userParam)
    end
end
local function GoWorldToSearch()
    SceneUtils.ChangeToWorld(function()
        EventManager:GetInstance():Broadcast(EventId.ShowArrowSearchBtn)
    end)
end

local function HeroStar(heroId, needStarLevel)
    GoToUtil.GotoOpenView(UIWindowNames.UIHeroList,{anim = false,UIMainAnim = UIMainAnimType.AllHide})

    local list = {}
    local secondParam = {}
    secondParam.arrowSecondType = ArrowSecondType.HeroList
    secondParam.uiName = UIWindowNames.UIHeroList
    secondParam.arrowTypeHero = HeroListArrowTypeHero.Star
    if heroId ~= nil and heroId ~= 0 then
        secondParam.heroId = heroId
    else
        secondParam.para = needStarLevel
    end
    table.insert(list, secondParam)

    local secondParam2 = {}
    secondParam2.arrowSecondType = ArrowSecondType.HeroInfo
    secondParam2.uiName = UIWindowNames.UIHeroInfo
    secondParam2.arrowTypeHero = HeroListArrowTypeHero.Star
    table.insert(list, secondParam2)

    DataCenter.ArrowManager:SetSecondArrowParam(list)
end

--跳转遗迹城点
local function GoWorldCity(targetLv)
    --获取所有遗迹点
    local template = DataCenter.AllianceCityTemplateManager:GetAllTemplate()
    local buildList = {}
    for i, v in pairs(template) do
        local cityData = DataCenter.WorldAllianceCityDataManager:GetAllianceCityDataByCityId(tonumber(i))
        if cityData == nil then
            local distance = math.ceil(SceneUtils.TileDistance(v.pos, SceneUtils.IndexToTilePos(LuaEntry.Player:GetMainWorldPos(),ForceChangeScene.World)))
            if v.level == targetLv then
                local param = {}
                param.distance = distance
                param.pos = v.pos
                param.id = i
                table.insert(buildList,param)
            end
        end
    end
    if next(buildList) then
        table.sort(buildList, function(a,b)
            if a.distance < b.distance then
                return true
            end
            return false
        end)
        GoToUtil.CloseAllWindows()
        local pointIndex = SceneUtils.TilePosToIndex(buildList[1].pos, ForceChangeScene.World)
        local worldPos = SceneUtils.TileIndexToWorld(pointIndex, ForceChangeScene.World)
        worldPos.x = worldPos.x - 6
        worldPos.z = worldPos.z - 6
        pointIndex = SceneUtils.WorldToTileIndex(worldPos, ForceChangeScene.World)
        GoToUtil.GotoWorldPos(worldPos, CS.SceneManager.World.InitZoom,LookAtFocusTime)
    else
        UIUtil.ShowTips(Localization:GetString("372182",targetLv))
    end
end

--跳转到赛季地块
local function GoFlint(questTemplate)
    GoToUtil.CloseAllWindows()
    --如果在城内
    if SceneUtils.GetIsInCity() then
        EventManager:GetInstance():Broadcast(EventId.MainToWorldBtn)
    else
        local lv = questTemplate.para1
        local type = tonumber(questTemplate.para3)
        if CS.SceneManager.World.GetDesertPointList ~= nil then
            local desertMap = CS.SceneManager.World:GetDesertPointList()
            if desertMap ~= nil and desertMap.Count > 0 then
                local disList= {}
                local pointList = {}
                for k,v in pairs(desertMap) do
                    local pi = v:GetWorldDesertInfo()
                    local desertType = GetTableData(TableName.Desert, pi.desertId, "desert_type")
                    local desertLv = GetTableData(TableName.Desert, pi.desertId, "desert_level")
                    local typeNew = pi:GetPlayerType()
                    if lv == desertLv and type == desertType and typeNew == CS.PlayerType.PlayerNone then
                        table.insert(pointList,pi)
                    end
                end
                if next(pointList) then
                    for i = 1,table.count(pointList) do
                        local tilePos = SceneUtils.IndexToTilePos(pointList[i].pointIndex)
                        local distance = math.ceil(SceneUtils.TileDistance(tilePos, SceneUtils.IndexToTilePos(LuaEntry.Player:GetMainWorldPos(),ForceChangeScene.World)))
                        local param = {}
                        param.data = pointList[i]
                        param.distance = distance
                        table.insert(disList,param)
                    end
                end
                if next(disList) then
                    table.sort(disList,function(a,b)
                        if a.distance < b.distance then
                            return true
                        end
                        return false
                    end)
                    local data = disList[1].data
                    local worldPos = SceneUtils.TileIndexToWorld(data.pointIndex, ForceChangeScene.World)
                    GoToUtil.GotoWorldPos(worldPos, CS.SceneManager.World.InitZoom,LookAtFocusTime,function()
                        --WorldArrowManager:GetInstance():ShowArrowEffect(0, worldPos)
                        local ownerUid = ""
                        local isAlliance = 0
                        local desertId = 0
                        local uuid = 0
                        local desertData = DataCenter.DesertDataManager:GetDesertDataByPoint(data.pointIndex)
                        if desertData~=nil then
                            desertId = desertData.desertId
                            ownerUid = LuaEntry.Player.uid
                            isAlliance =1
                            uuid = desertData.uuid
                        else
                            local worldTileInfo = CS.SceneManager.World:GetWorldTileInfo(data.pointIndex)
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
                        UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint,{anim = true,playEffect = false,UIMainAnim = UIMainAnimType.LeftRightBottomHide},uuid, data.pointIndex,ownerUid, WorldPointUIType.Desert, isAlliance,0,nil,desertId)
                    end)
                    return
                end
            end
        end
        UIUtil.ShowTipsId(110361)
    end
end


local function GoWorldBuildList(param)
    --有就找建筑，没有就建造
    GoToUtil.CloseAllWindows()
    local list = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(tonumber(param[1])) or {}
    if list and list[1] then
        local worldPos = SceneUtils.TileIndexToWorld(list[1].pointId,ForceChangeScene.World)
        GoToUtil.GotoWorldPos(worldPos, nil,nil,function()
           -- WorldArrowManager:GetInstance():ShowArrowEffect(0, worldPos)
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldTileUI,{anim = true,playEffect = false},tostring(list[1].pointId),false,param[2])
        end)
    else
        SceneUtils.ChangeToWorld(function()
        end)
    end
end

local function GoDailyUI()
    GoToUtil.CloseAllWindows()
    EventManager:GetInstance():Broadcast(EventId.MainToDailyAct,ActivityOverviewType.EverydayTask)
end

--最高等级地块
local function GoSeasonDesertMaxLv(param)
    GoToUtil.CloseAllWindows()
    --如果在城内
    if SceneUtils.GetIsInCity() then
        EventManager:GetInstance():Broadcast(EventId.MainToWorldBtn)
    else
        if param and param == "" then
            local lv = 0
            if CS.SceneManager.World.GetDesertPointList ~= nil then
                local desertMap = CS.SceneManager.World:GetDesertPointList()
                if desertMap ~= nil and desertMap.Count > 0 then
                    local pointInfo = nil
                    for k,v in pairs(desertMap) do
                        local pi = v:GetWorldDesertInfo()
                        local desertLv = GetTableData(TableName.Desert, pi.desertId, "desert_level")
                        local typeNew = pi:GetPlayerType()
                        if typeNew == CS.PlayerType.PlayerNone then
                            if lv < desertLv then
                                lv = desertLv
                                pointInfo = pi
                            end
                        end
                    end
                    if pointInfo then
                        local worldPos = SceneUtils.TileIndexToWorld(pointInfo.pointIndex, ForceChangeScene.World)
                        GoToUtil.GotoWorldPos(worldPos, CS.SceneManager.World.InitZoom,LookAtFocusTime,function()
                            --WorldArrowManager:GetInstance():ShowArrowEffect(0, worldPos)
                            local ownerUid = ""
                            local isAlliance = 0
                            local desertId = 0
                            local uuid = 0
                            local desertData = DataCenter.DesertDataManager:GetDesertDataByPoint(pointInfo.pointIndex)
                            if desertData~=nil then
                                desertId = desertData.desertId
                                ownerUid = LuaEntry.Player.uid
                                isAlliance =1
                                uuid = desertData.uuid
                            else
                                local worldTileInfo = CS.SceneManager.World:GetWorldTileInfo(pointInfo.pointIndex)
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
                            UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint,{anim = true,playEffect = false,UIMainAnim = UIMainAnimType.LeftRightBottomHide},uuid, pointInfo.pointIndex,ownerUid, WorldPointUIType.Desert, isAlliance,0,nil,desertId)
                        end)
                        return
                    end
                end
            end
            UIUtil.ShowTipsId(110381)
        else    
            --找自己的
            local dic = DataCenter.DesertDataManager:GetAllMyDesert()
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
                table.sort(list,function(a,b)
                    if a.level > b.level then
                        return true
                    elseif a.level == b.level then
                        return a.dis < b.dis
                    end
                    return false
                end)
                local worldPos = SceneUtils.TileIndexToWorld(list[1].pointId, ForceChangeScene.World)
                GoToUtil.GotoWorldPos(worldPos, CS.SceneManager.World.InitZoom,LookAtFocusTime,function()
                    --WorldArrowManager:GetInstance():ShowArrowEffect(0, worldPos)
                    local ownerUid = ""
                    local isAlliance = 0
                    local desertId = 0
                    local uuid = 0
                    local desertData = DataCenter.DesertDataManager:GetDesertDataByPoint(list[1].pointId)
                    if desertData~=nil then
                        desertId = desertData.desertId
                        ownerUid = LuaEntry.Player.uid
                        isAlliance =1
                        uuid = desertData.uuid
                    else
                        local worldTileInfo = CS.SceneManager.World:GetWorldTileInfo(list[1].pointId)
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
                    UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint,{anim = true,playEffect = false,UIMainAnim = UIMainAnimType.LeftRightBottomHide},uuid, list[1].pointId,ownerUid, WorldPointUIType.Desert, isAlliance,0,nil,desertId)
                end)
                return
            end
            UIUtil.ShowTipsId(110381)
        end
    end
end

--自己最低等级地块
local function GoSelfDesert(self)
    GoToUtil.CloseAllWindows()
    --如果在城内
    if SceneUtils.GetIsInCity() then
        EventManager:GetInstance():Broadcast(EventId.MainToWorldBtn)
    else
        local dic = DataCenter.DesertDataManager:GetAllMyDesert()
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
            table.sort(list,function(a,b)
                if a.level < b.level then
                    return true
                elseif a.level == b.level then
                    return a.dis < b.dis
                end
                return false
            end)
            local worldPos = SceneUtils.TileIndexToWorld(list[1].pointId, ForceChangeScene.World)
            GoToUtil.GotoWorldPos(worldPos, CS.SceneManager.World.InitZoom,LookAtFocusTime,function()
                local ownerUid = ""
                local isAlliance = 0
                local desertId = 0
                local uuid = 0
                local desertData = DataCenter.DesertDataManager:GetDesertDataByPoint(list[1].pointId)
                if desertData~=nil then
                    desertId = desertData.desertId
                    ownerUid = LuaEntry.Player.uid
                    isAlliance =1
                    uuid = desertData.uuid
                else
                    local worldTileInfo = CS.SceneManager.World:GetWorldTileInfo(list[1].pointId)
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
                UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint,{anim = true,playEffect = false,UIMainAnim = UIMainAnimType.LeftRightBottomHide},uuid, list[1].pointId,ownerUid, WorldPointUIType.Desert, isAlliance,0,nil,desertId)
            end)
            return
        end
        UIUtil.ShowTipsId(110472)
    end
end

local function GoSeasonManager(self)
    --找自己的
    local dic = DataCenter.DesertDataManager:GetAllMyDesert()
    if dic and next(dic) then

    else
        UIUtil.ShowTipsId(110381)
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.UISeasonGroundManage)
end

local function GotoCrossWorm()
    local crossBuildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.WORM_HOLE_CROSS)
    if crossBuildData == nil then
        UIUtil.ShowTips(Localization:GetString("104273"))
        return
    end
    local targetServerId = crossBuildData.server
    local pointId = crossBuildData.pointId
    if pointId > 0 then
        local position = SceneUtils.TileIndexToWorld(pointId, ForceChangeScene.World)
        position.x = position.x - 1
        position.z = position.z - 1
        UIUtil.ShowMessage(Localization:GetString("142502", targetServerId), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
            GoToUtil.CloseAllWindows()
            GoToUtil.GotoWorldPos(position, nil, nil, function()
                WorldArrowManager:GetInstance():ShowArrowEffect(0, position, ArrowType.Building)
            end, targetServerId)
        end)
    end
end

local function GotoOpenBuildQueueWindow(userParam)
    local count = DataCenter.BuildQueueManager:GetOwnBuildQueueCount()
    if count > 1 then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIBuildQueue, NormalBlurPanelAnim, userParam)
    else
        --打开礼包界面
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIBuildQueueLease, NormalBlurPanelAnim, userParam)
    end
end

local function ShowPower(userParam)
    if DataCenter.BuildManager:CanShowPower() then
        if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIShowPower) then
            EventManager:GetInstance():Broadcast(EventId.ShowPower, userParam)
        else
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIShowPower, {}, userParam)
        end
    end
end

--在进入时移动镜头的页面中前往建筑专用
local function InMoveCameraGotoBuild(buildId)
    DataCenter.FurnitureManager:SetEnterPanelCameraPosParam(nil)
    local levelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildId, 0)
    if levelTemplate ~= nil and levelTemplate:IsFurnitureBuild() then
        DataCenter.FurnitureManager:SetEnterPanelCameraNoQuitParam(true)
    else
        if buildId == BuildingTypes.FUN_BUILD_MAIN then
            DataCenter.FurnitureManager:SetEnterPanelCameraNoQuitParam(true)
        else
            local data = DataCenter.BuildCityBuildManager:GetCityBuildDataByBuildId(buildId)
            if data ~= nil then
                --这里面还要判断 能不能建造
                if data.state == BuildCityBuildState.Fake then
                    DataCenter.FurnitureManager:SetEnterPanelCameraNoQuitParam(true)
                elseif data.state == BuildCityBuildState.Pre then
                    if data.preState == BuildCityBuildPreState.Build then
                        local preBuild = levelTemplate:GetPreBuild()
                        if preBuild ~= nil then
                            for k1, v1 in ipairs(preBuild) do
                                if not DataCenter.BuildManager:IsExistBuildByTypeLv(v1[1], v1[2]) then
                                    GoToUtil.InMoveCameraGotoBuild(v1[1])
                                    return
                                end
                            end
                        end
                    elseif data.preState == BuildCityBuildPreState.Pve then
                        SceneUtils.ChangeToCity(function()
                            GoToUtil.CloseAllWindows()
                            local obj = DataCenter.LandManager:GetNextObject(LandObjectType.Block)
                            if obj ~= nil then
                                local pos = obj.transform.position
                                GoToUtil.GotoCityPos(pos, nil, nil, function()
                                    local param = {}
                                    param.position = pos
                                    param.positionType = PositionType.World
                                    param.isPanel = true
                                    param.isAutoClose = 3
                                    DataCenter.ArrowManager:ShowArrow(param)
                                end)
                            end
                            return
                        end)
                    elseif data.preState == BuildCityBuildPreState.Science then
                        return
                    elseif data.preState == BuildCityBuildPreState.Vip then
                        GoToUtil.CloseAllWindows()
                        UIManager:GetInstance():OpenWindow(UIWindowNames.UIVip,{ anim = true, hideTop = true}, levelTemplate.need_vip)
                        return
                    elseif data.preState == BuildCityBuildPreState.Land then
                        SceneUtils.ChangeToCity(function()
                            GoToUtil.CloseAllWindows()
                            local obj = DataCenter.LandManager:GetCurrentObject(LandObjectType.Block)
                            if obj ~= nil then
                                local pos = obj.transform.position
                                GoToUtil.GotoCityPos(pos, nil, nil, function()
                                    local param = {}
                                    param.position = pos
                                    param.positionType = PositionType.World
                                    param.isPanel = true
                                    param.isAutoClose = 3
                                    DataCenter.ArrowManager:ShowArrow(param)
                                end)
                            end
                            return
                        end)
                    end
                end
            end
        end
    end

    GoToUtil.CloseAllWindows()
    local buildData = DataCenter.BuildManager:GetFunbuildByItemID(buildId)
    if buildData ~= nil and buildData:IsUpgrading() then
        GoToUtil.GotoCityByBuildId(buildId, WorldTileBtnType.City_SpeedUp)
    else
        GoToUtil.GotoCityByBuildId(buildId, WorldTileBtnType.City_Upgrade)
    end
end

local function GotoFurniture(fUuid) 
    local furnitureInfo = DataCenter.FurnitureManager:GetFurnitureByUuid(fUuid)
    if furnitureInfo == nil then
        return
    end
    
    local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(furnitureInfo.bUuid)
    if buildData == nil then
        return
    end
    
    SceneUtils.ChangeToCity(function()
        GoToUtil.CloseAllWindows()

        local param = {}
        param.buildId = buildData.itemId
        param.buildUuid = furnitureInfo.bUuid
        param.fUuid = fUuid

        if buildData:IsUpgrading() then
            GoToUtil.GotoOpenBuildCreateWindow(UIWindowNames.UIBuildCreate, NormalPanelAnim, param)
        else
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIFurnitureUpgrade, NormalPanelAnim, param)
        end
    end)
end

local function GotoCity()
    SceneUtils.ChangeToCity(function()
        local pos = DataCenter.CityCameraManager:GetCacheZoomPos()
        local zoom = DataCenter.CityCameraManager:GetCurZoom()
        if pos~=nil and zoom~=nil then
            GoToUtil.GotoCityPos(pos, zoom,0.02)
            DataCenter.CityCameraManager:SetCacheZoomValue(-1,nil)
        end
    end)
end
GoToUtil.GotoCity = GotoCity
GoToUtil.GotoCityByBuildId = GotoCityByBuildId
GoToUtil.GotoOpenView = GotoOpenView
GoToUtil.GotoBuildListByBuildId = GotoBuildListByBuildId
GoToUtil.GotoScience = GotoScience
GoToUtil.OpenSciencePanel = OpenSciencePanel
GoToUtil.OpenScienceTabPanel = OpenScienceTabPanel
GoToUtil.CloseAllWindows = CloseAllWindows
GoToUtil.MoveToWorldPoint = MoveToWorldPoint
GoToUtil.MoveToWorldPointAndOpen = MoveToWorldPointAndOpen
GoToUtil.GotoPayTips = GotoPayTips
GoToUtil.GotoPay = GotoPay
GoToUtil.GoToByQuestId = GoToByQuestId
GoToUtil.GotoWorldBuildAndOpenUI = GotoWorldBuildAndOpenUI
GoToUtil.GotoCityByBuildUuid = GotoCityByBuildUuid
GoToUtil.GotoMainBuildPos = GotoMainBuildPos
GoToUtil.GotoColdStorage = GotoColdStorage
GoToUtil.GoAttackMonster = GoAttackMonster
GoToUtil.GotoResourceBuild = GotoResourceBuild
GoToUtil.GotoWorldResource = GotoWorldResource
GoToUtil.GoRadarProbe = GoRadarProbe
GoToUtil.GoGarbage = GoGarbage
GoToUtil.GotoBossMonsterBetweenLv = GotoBossMonsterBetweenLv
GoToUtil.GoBarracks = GoBarracks
GoToUtil.GoToMonthCard = GoToMonthCard
GoToUtil.GotoBuildListRobotByRobotId = GotoBuildListRobotByRobotId
GoToUtil.OpenInCity = OpenInCity
GoToUtil.FindMonster = FindMonster
GoToUtil.GotoTrainSolider = GotoTrainSolider
GoToUtil.GoConnectBuild = GoConnectBuild
GoToUtil.GotoGuluBox = GotoGuluBox
GoToUtil.GotoMonsterReward = GotoMonsterReward
GoToUtil.GoHeroStation = GoHeroStation
GoToUtil.GoHeroStationScores = GoHeroStationScores
GoToUtil.GoGiftMall = GoGiftMall
GoToUtil.GoBagPackUseItem = GoBagPackUseItem
GoToUtil.GoSearchEnemy = GoSearchEnemy
GoToUtil.GoGarageUpgrade = GoGarageUpgrade
GoToUtil.GoToGarageRefit = GoToGarageRefit
GoToUtil.GotoGiftPackView = GotoGiftPackView
GoToUtil.GoHospital = GoHospital
GoToUtil.GoHeroTrust = GoHeroTrust
GoToUtil.GotoPos = GotoPos
GoToUtil.GoTriggerPve = GoTriggerPve
GoToUtil.GoActWindow = GoActWindow
GoToUtil.GoActWindowByType = GoActWindowByType
GoToUtil.GOGiftPackageView = GOGiftPackageView
GoToUtil.GotoWorldPos = GotoWorldPos
GoToUtil.GotoCityPos = GotoCityPos
GoToUtil.GoCityCollect = GoCityCollect
GoToUtil.GoFormation = GoFormation
GoToUtil.GetBuildState = GetBuildState
GoToUtil.GoCheckBuild = GoCheckBuild
GoToUtil.GoHeroBag = GoHeroBag
GoToUtil.GoHeroSkill = GoHeroSkill
GoToUtil.GoWorldToSearch = GoWorldToSearch
GoToUtil.HeroStar = HeroStar
GoToUtil.GoWorldCity = GoWorldCity
GoToUtil.GoFlint = GoFlint
GoToUtil.GoWorldBuildList = GoWorldBuildList
GoToUtil.GoDailyUI = GoDailyUI
GoToUtil.GoSeasonDesertMaxLv = GoSeasonDesertMaxLv
GoToUtil.GoSelfDesert = GoSelfDesert
GoToUtil.GoSeasonManager = GoSeasonManager
GoToUtil.MoveToWorldTroopAndOpen = MoveToWorldTroopAndOpen
GoToUtil.GotoCrossWorm = GotoCrossWorm
GoToUtil.GotoDragonPos = GotoDragonPos
GoToUtil.GotoOpenBuildCreateWindow = GotoOpenBuildCreateWindow
GoToUtil.GotoOpenBuildQueueWindow = GotoOpenBuildQueueWindow
GoToUtil.ShowPower = ShowPower
GoToUtil.InMoveCameraGotoBuild = InMoveCameraGotoBuild
GoToUtil.GotoFurniture = GotoFurniture

return ConstClass("GoToUtil", GoToUtil)