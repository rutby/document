---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2023/2/28 15:42
---

local EquipmentBagCtrl = BaseClass("EquipmentBagCtrl", UIBaseCtrl)

local function CloseSelf(self)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.EquipmentBag)
end

local function GetPanelData(self, suitType)
    local allHasEquipmentId = {}
    local tmp = {}
    local allSuitTemplate = DataCenter.EquipmentSuitTemplateManager:GetAllTemplate()
    local allEquipments = DataCenter.EquipmentDataManager:GetAllEquip()

    local GetData = function(uuid, id, lv, carIndex, pos)
        local data = {}
        data.uuid = uuid
        if uuid ~= nil and carIndex ~= nil then
            data.showUpgrade = DataCenter.EquipmentDataManager:IsEquipmentCanUpgrade(uuid)
        end
        data.equipmentId = id
        data.lv = lv
        data.pos = pos
        data.carIndex = carIndex
        return data
    end

    for _, v in pairs(allEquipments) do
        local template = DataCenter.EquipmentTemplateManager:GetTemplate(v.equipId)
        if template ~= nil and template:GetSuitType() == suitType then
            local carIndex = DataCenter.EquipmentDataManager:GetEquipmentCarIndex(v.uuid)
            local para = GetData(v.uuid, v.equipId, v.lv, carIndex, template.position)
            local suitId = template:GetSuitId()
            local equipLv1Id = EquipmentUtil.GetEquipmentLv1Id(v.equipId)
            allHasEquipmentId[equipLv1Id] = 1
            if tmp[suitId] == nil then
                tmp[suitId] = {}
                tmp[suitId].suitId = suitId
                tmp[suitId].list = {}
            end
            table.insert(tmp[suitId].list, para)
        end
    end

    for _, v in pairs(allSuitTemplate) do
        if v.type == suitType then
            for _, equipmentId in ipairs(v.includeEquip) do
                if allHasEquipmentId[equipmentId] == nil then
                    local template = DataCenter.EquipmentTemplateManager:GetTemplate(equipmentId)
                    if template ~= nil then
                        local para = GetData(nil, equipmentId + EquipmentConst.EquipmentMaxLevel - 1, EquipmentConst.EquipmentMaxLevel, nil, template.position)
                        local suitId = template:GetSuitId()
                        if tmp[suitId] == nil then
                            tmp[suitId] = {}
                            tmp[suitId].suitId = suitId
                            tmp[suitId].list = {}
                        end
                        table.insert(tmp[suitId].list, para)
                    end
                end
            end
        end
    end
    
    local tmp1 = table.values(tmp)
    table.sort(tmp1, function (k, v)
        local templateA = DataCenter.EquipmentSuitTemplateManager:GetTemplate(k.suitId)
        local templateB = DataCenter.EquipmentSuitTemplateManager:GetTemplate(v.suitId)
        return templateA.order < templateB.order
    end)
    local result = {}
    local list = {}
    result.list = list
    for _, suit in ipairs(tmp1) do
        table.sort(suit.list, function (k, v)
            local isEquipA = k.carIndex ~= nil
            local isEquipB = v.carIndex ~= nil
            if isEquipA ~= isEquipB then
                return isEquipA
            end
            local hasA = k.uuid ~= nil
            local hasB = v.uuid ~= nil
            if hasA ~= hasB then
                return hasA
            end
            if v.lv ~= k.lv then
                return k.lv > v.lv
            end
            if v.pos ~= k.pos then
                return k.pos < v.pos
            end
            return false
        end)
        local suitTemplate = DataCenter.EquipmentSuitTemplateManager:GetTemplate(suit.suitId)
        if suitTemplate then
            local param = {}
            param.type = EquipmentConst.EquipmentBagViewCellType.EquipmentBagViewCellType_Title
            param.name = suitTemplate.name
            param.suitId = suit.suitId
            table.insert(list, param)
            
            local equipPara
            local count = 1
            for index, v in ipairs(suit.list) do
                if math.fmod(index, EquipmentConst.EquipmentBagViewCellNumPerLine) == 1 then
                    equipPara = {}
                    equipPara.type = EquipmentConst.EquipmentBagViewCellType.EquipmentBagViewCellType_Equipment
                    equipPara.list = {}
                    table.insert(list, equipPara)
                    count = 1
                end    
                v.index = count
                table.insert(equipPara.list, v)
                count = count + 1
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

local function GetTabButtonData(self)
    local result = {}
    local lang = {270013, 270012, 372281}
    for i = EquipmentConst.EquipmentSuitType.Equipment_Suit_Type_Fight, EquipmentConst.EquipmentSuitType.Equipment_Suit_Type_Defence do
        local para = {}
        para.unselectName = lang[i]
        para.selectName = lang[i]
        para.index = i
        table.insert(result, para)
    end
    return result
end

EquipmentBagCtrl.CloseSelf = CloseSelf
EquipmentBagCtrl.GetPanelData = GetPanelData
EquipmentBagCtrl.GetGiftData = GetGiftData
EquipmentBagCtrl.ShowGiftPanel = ShowGiftPanel
EquipmentBagCtrl.GetTabButtonData = GetTabButtonData

return EquipmentBagCtrl