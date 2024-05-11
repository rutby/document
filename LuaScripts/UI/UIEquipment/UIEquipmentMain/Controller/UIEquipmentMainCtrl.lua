---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2023/2/27 15:55
---

local UIEquipmentMainCtrl = BaseClass("UIEquipmentMainCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization
local function CloseSelf(self)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIEquipmentMain)
end

local function GetPanelData(self, carIndex, suitType)
    local result = {}
    local equipments = {}
    result.equipments = equipments
    result.showTab1Red = DataCenter.EquipmentDataManager:SuitTypeHasRedDot(carIndex, EquipmentConst.EquipmentSuitType.Equipment_Suit_Type_Fight)
    result.showTab2Red = DataCenter.EquipmentDataManager:SuitTypeHasRedDot(carIndex, EquipmentConst.EquipmentSuitType.Equipment_Suit_Type_Gather)

    for i = EquipmentConst.Position.Equipment_Position_Cannon, EquipmentConst.Position.Equipment_Position_Energy_Core do
        local param = {}
        param.carIndex = carIndex
        param.type = suitType
        param.pos = i
        param.emptyIcon = EquipmentUtil.GetEquipmentEmptyIcon(suitType, i)
        param.showRedDot = DataCenter.EquipmentDataManager:PosHasRedDot(carIndex, suitType, i)
        param.showAdd = DataCenter.EquipmentDataManager:PosHasCanEquipEquipment(carIndex, suitType, i)
        table.insert(equipments, param)
    end
    local suitData = DataCenter.EquipmentDataManager:GetEquipSuit(carIndex, suitType)
    if suitData then
        for k, v in ipairs(suitData.equips) do
            local data = DataCenter.EquipmentDataManager:GetEquipByUuid(v)
            if data then
                local template = DataCenter.EquipmentTemplateManager:GetTemplate(data.equipId)
                if equipments[template.position] ~= nil then
                    equipments[template.position].uuid = v
                    equipments[template.position].lv = data.lv
                    equipments[template.position].equipmentId = data.equipId
                    equipments[template.position].showUpgrade = DataCenter.EquipmentDataManager:IsEquipmentCanUpgrade(v)
                end
            end
        end
        
        local suitTypeNum = {}
        for _, v in pairs(equipments) do
            if v.uuid ~= nil then
                local template = DataCenter.EquipmentTemplateManager:GetTemplate(v.equipmentId)
                if suitTypeNum[template:GetSuitId()] == nil then
                    local tmp = {}
                    tmp.num = 1
                    tmp.maxLv = v.lv
                    tmp.suitId = template:GetSuitId()
                    suitTypeNum[template:GetSuitId()] = tmp
                else
                    local tmp = suitTypeNum[template:GetSuitId()]
                    tmp.num = tmp.num + 1
                    if v.lv > tmp.maxLv then
                        tmp.maxLv = v.lv
                    end
                end
            end
        end
        
        local suitId = -1
        if table.count(suitTypeNum) > 0 then
            local values = table.values(suitTypeNum)
            table.sort(values, function (k, v)
                if k.num ~= v.num then
                    return k.num > v.num
                end
                if k.maxLv ~= v.maxLv then
                    return k.maxLv > v.maxLv
                end
                return false
            end)
            suitId = values[1].suitId
        end

        if suitId > 0 then
            local suitTemplate = DataCenter.EquipmentSuitTemplateManager:GetTemplate(suitId)
            if suitTemplate ~= nil then
                local suitIntro = {}
                result.suitIntro = suitIntro
                suitIntro.suitId = suitId
                suitIntro.name = suitTemplate.name
                local attrList = {}
                result.suitIntro.attrList = attrList
                for i = 1, EquipmentConst.MaxSuitAttr do
                    local isUnlock, lvNeed, numNeed, hasNum = DataCenter.EquipmentDataManager:IsSuitEffectUnlock(carIndex, suitType, suitId, i)

                    local para = {}
                    para.index = i
                    para.suitId = suitId
                    para.carIndex = carIndex
                    para.isLocked = not isUnlock
                    para.lvNeed = lvNeed
                    para.numNeed = numNeed
                    para.hasNum = hasNum
                    para.iconName = suitTemplate:GetSkillIconNameByIndex(i)

                    table.insert(attrList, para)
                end
            end

        end
    end
    result.giftData = self:GetGiftData(suitType)
    return result
end

local function GetGiftData(self, suitType)
    local result = {}
    result.showGift = false
    local allSuitTemplate = DataCenter.EquipmentSuitTemplateManager:GetAllTemplate()
    local hasGiftBag = false
    for _, v in pairs(allSuitTemplate) do
        if v.type == suitType then
            local packageTb = GiftPackageData.getPacksByShowType("12", tostring(v.id))
            if packageTb and #packageTb > 0 then
                hasGiftBag = true
            end
        end
    end
    local lv = 0
    if suitType == EquipmentConst.EquipmentSuitType.Equipment_Suit_Type_Gather then
        local k4 = LuaEntry.DataConfig:TryGetNum("car_equip", "k4")
        result.showGift = lv >= k4 and hasGiftBag
        result.giftIcon = string.format(LoadPath.UIMainNew, "UI_Equipment_Gift_gather_icon")

    elseif suitType == EquipmentConst.EquipmentSuitType.Equipment_Suit_Type_Fight then
        local k5 = LuaEntry.DataConfig:TryGetNum("car_equip", "k5")
        result.showGift = lv >= k5 and hasGiftBag
        result.giftIcon = string.format(LoadPath.UIMainNew, "UI_Equipment_Gift_fight_icon")
    elseif suitType == EquipmentConst.EquipmentSuitType.Equipment_Suit_Type_Defence then
        local k6 = LuaEntry.DataConfig:TryGetNum("car_equip", "k4")
        result.showGift = lv >= k6 and hasGiftBag
        result.giftIcon = string.format(LoadPath.UIMainNew, "UI_Equipment_Gift_fight_icon")
    end
    return result
end

local function ShowGiftPanel(self, suitType)
    local allSuitTemplate = DataCenter.EquipmentSuitTemplateManager:GetAllTemplate()
    local result = {}
    for _, v in pairs(allSuitTemplate) do
        if v.type == suitType then
            local packageTb = GiftPackageData.getPacksByShowType("12", tostring(v.id))
            if packageTb and #packageTb > 0 then
                for _, v in ipairs(packageTb) do
                    table.insert(result, v)
                end
            end
        end
    end
    if #result == 0 then
        return
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIScrollPackNew, {anim = true}, result)
end

local function GetTabButtonData(self, buildingId)
    local result = {}
    local lang = {270013, 270012, 372281}
    local showEquipmentType = EquipmentUtil.GetEquipmentTypeByBuildingId(buildingId)
    for i = EquipmentConst.EquipmentSuitType.Equipment_Suit_Type_Fight, EquipmentConst.EquipmentSuitType.Equipment_Suit_Type_Defence do
        local para = {}
        para.unselectName = lang[i]
        para.selectName = lang[i]
        para.index = i
        para.show = showEquipmentType[i] ~= nil
        table.insert(result, para)
    end
    return result
end

local function GetTipStr(self, buildingId)
    local result = ""
    if buildingId == BuildingTypes.FUN_BUILD_DEFENCE_CENTER_NEW then
        result = Localization:GetString("270037").."\n"..Localization:GetString("270038")
    elseif buildingId == BuildingTypes.WORM_HOLE_CROSS then
        result = Localization:GetString("270037").."\n"..Localization:GetString("270038")
    else
        result = Localization:GetString("270029").."\n"..Localization:GetString("270030").."\n"..Localization:GetString("270031")
    end
    return result
end

local function GetTitleStr(self, buildingId)
    local result = ""
    if buildingId == BuildingTypes.FUN_BUILD_DEFENCE_CENTER_NEW then
        result = Localization:GetString("300059")
    elseif buildingId == BuildingTypes.WORM_HOLE_CROSS then
        result = Localization:GetString("300059")
    else
        local carIndex = DataCenter.EquipmentDataManager:GetCarIndexByBuildingId(buildingId)
        result = Localization:GetString("140328", carIndex)
    end
    return result
end

local function GetTabRedPoint(self, carIndex, buildingId)
    local showEquipmentType = EquipmentUtil.GetEquipmentTypeByBuildingId(buildingId)
    local result = {}
    for k, _ in pairs(showEquipmentType) do
        result[k] = DataCenter.EquipmentDataManager:SuitTypeHasRedDot(carIndex, k)
    end
    return result
end

UIEquipmentMainCtrl.CloseSelf = CloseSelf
UIEquipmentMainCtrl.GetPanelData = GetPanelData
UIEquipmentMainCtrl.GetGiftData = GetGiftData
UIEquipmentMainCtrl.ShowGiftPanel = ShowGiftPanel
UIEquipmentMainCtrl.GetTabButtonData = GetTabButtonData
UIEquipmentMainCtrl.GetTipStr = GetTipStr
UIEquipmentMainCtrl.GetTitleStr = GetTitleStr
UIEquipmentMainCtrl.GetTabRedPoint = GetTabRedPoint

return UIEquipmentMainCtrl