--[[
-- 跳转工具类
--]]

local GoToResLack = {}

--资源+道具
local function GoToItemResLackList(list, isReturn)
    if list ~= nil then
        --local dis = {}
        --for i = 1, #list, 1 do
        --    if list[i].type == ResLackType.Res then
        --        --资源
        --        local own = LuaEntry.Resource:GetCntByResType(list[i].resType)
        --        --pve体力特殊获取
        --        if list[i].resType == ResourceType.FORMATION_STAMINA then
        --            own = math.ceil(LuaEntry.Player:GetCurPveStamina())
        --        elseif list[i].resType == ResourceType.MasteryPoint then
        --            own = DataCenter.MasteryManager:GetRestPoint()
        --        end
        --        local param = {}
        --        param.disNum = list[i].targetNum - own  --还缺多少
        --        param.resType = list[i].resType
        --        param.needCount = list[i].targetNum     --一共需要
        --        table.insert(dis,param)
        --    elseif list[i].type == ResLackType.Item then
        --        --道具
        --        local own = DataCenter.ItemData:GetItemCount(list[i].itemId)
        --        local param = {}
        --        param.disNum = list[i].targetNum - own
        --        param.resType = list[i].itemId
        --        param.needCount = list[i].targetNum
        --        param.isItem = true
        --        table.insert(dis,param)
        --    elseif list[i].type == ResLackType.HeroExp then
        --        local hero = DataCenter.HeroDataManager:GetHeroByUuid(list[i].heroUuid)
        --        list[i].targetNum = HeroUtils.GetLevelUpNeedExp(hero.level)
        --        local param = {}
        --        param.disNum = list[i].targetNum - hero.exp
        --        param.resType = list[i].itemId
        --        param.needCount = list[i].targetNum
        --        param.isHero = true
        --        param.heroUuid = list[i].heroUuid
        --        table.insert(dis,param)
        --    end
        --end
        
        -- 餐饮特殊跳转
        if #list == 1 then
            local v = list[1]
            if v.type == ResLackType.Res and v.id == ResourceType.Meal then
                local furnitureInfoList = DataCenter.FurnitureManager:GetFurnitureByFurnitureId(FurnitureType.CookingBench)
                if #furnitureInfoList > 0 then
                    GoToUtil.GotoFurniture(furnitureInfoList[1].uuid)
                end
                UIUtil.ShowTipsId(450245)
                return
            end
        end

        local resList = {}
        local newDis = {}
        for k, v in ipairs(list) do
            local way = DataCenter.ResLackManager:CheckResAddWay(v.id, v.targetNum)
            if way ~= nil then
                table.insert(resList, way)
                table.insert(newDis, v)
            end
        end
        if isReturn then
            return resList, newDis
        end
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIResourceLackNew, NormalBlurPanelAnim, resList, newDis)
    end
end

local function GotoSpeedLackList(speedType)
    local dis = {}
    local param = {}
    param.id = SpeedLackType
    param.type = ResLackType.Speed
    table.insert(dis,param)
    local resList = {}
    resList[1] = DataCenter.ResLackManager:CheckResAddWay(SpeedLackType)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIResourceLackNew, HideBlurPanelAnim, resList, dis, speedType)
end

--英雄经验
local function GoToHeroLvUp(targetNum)
    local lackTab = {}
    local param = {}
    param.type = ResLackType.Res
    param.id = ResourceType.Food
    param.targetNum = targetNum
    table.insert(lackTab,param)
    GoToResLack.GoToItemResLackList(lackTab)
end

local function GotoAddStamina(needStamina)
    local lackTab = {}
    local param = {}
    param.type = ResLackType.Res
    param.id = ResourceType.FORMATION_STAMINA
    param.targetNum = needStamina
    table.insert(lackTab,param)
    GoToResLack.GoToItemResLackList(lackTab)
end

local function GotoMasteryPoint(extra,type_para)
    local dis = {}
    local param = {}
    param.targetNum = extra
    param.isSeasonMastery = true
    param.id = type_para
    table.insert(dis,param)
    local resList = {}
    for i = 1, #dis do
        resList[i] = DataCenter.ResLackManager:CheckResAddWay(dis[i].resType, dis[i].needCount,ResLackTypeNew.MasteryPoint)
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIResourceLackNew, NormalBlurPanelAnim, resList, dis)
end

local function GotoEquip(equipId)
    local dis = {}
    local param = {}
    param.targetNum = 1
    param.isEquip = true
    param.id = equipId
    table.insert(dis,param)
    local resList = {}
    for i = 1, #dis do
        resList[i] = DataCenter.ResLackManager:CheckResAddWay(dis[i].resType, dis[i].needCount,ResLackTypeNew.Equip)
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIResourceLackNew, NormalBlurPanelAnim, resList, dis)
end

local function GotoTitleSkin(skinId)
    local dis = {}
    local param = {}
    param.targetNum = 1
    param.isSkin = true
    param.id = skinId
    table.insert(dis,param)
    local resList = {}
    for i = 1, #dis do
        resList[i] = DataCenter.ResLackManager:CheckResAddWay(dis[i].resType, dis[i].needCount,ResLackTypeNew.TitleSkin)
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIResourceLackNew, NormalBlurPanelAnim, resList, dis)
end

function GoToResLack:GotoHeroEquip()
    local dis = {}
    local param = {}
    param.typeNew = ResLackTypeNew.HeroEquip
    param.targetNum = 1
    table.insert(dis,param)
    local resList = {}
    for i = 1, #dis do
        resList[i] = DataCenter.ResLackManager:CheckResAddWay(dis[i].resType, dis[i].needCount, ResLackTypeNew.HeroEquip)
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIResourceLackNew, NormalBlurPanelAnim, resList, dis)
end

GoToResLack.GoToItemResLackList = GoToItemResLackList
GoToResLack.GoToHeroLvUp = GoToHeroLvUp
GoToResLack.GotoAddStamina = GotoAddStamina
GoToResLack.GotoMasteryPoint = GotoMasteryPoint
GoToResLack.GotoEquip = GotoEquip
GoToResLack.GotoTitleSkin = GotoTitleSkin
GoToResLack.GotoSpeedLackList = GotoSpeedLackList

return ConstClass("GoToResLack", GoToResLack)