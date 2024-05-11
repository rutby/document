---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zhangjiabin.
--- DateTime: 2024/3/24 12:07 PM
---

local HeroEquipTemplateManager = BaseClass("HeroEquipTemplateManager")
local HeroEquipTemplate = require "DataCenter.HeroEquipManager.HeroEquipTemplate"

function HeroEquipTemplateManager:__init()
    self.allTemplate = {}
    self.isInit = false
end

function HeroEquipTemplateManager:__delete()
    self.allTemplate = {}
    self.isInit = false
end

function HeroEquipTemplateManager:InitAllTemplate()
    if self.isInit then
        return
    end
    self.isInit = true
    self.allTemplate = {}
    LocalController:instance():visitTable(TableName.Equip, function(_, lineData)
        local equip = HeroEquipTemplate.New()
        equip:InitData(lineData)
        self.allTemplate[equip.id] = equip
    end)
end

function HeroEquipTemplateManager:GetTemplate(id)
    if not self.isInit then
        self:InitAllTemplate()
    end
    return self.allTemplate[tonumber(id)]
end

function HeroEquipTemplateManager:GetAllTemplate()
    if not self.isInit then
        self:InitAllTemplate()
    end
    return self.allTemplate or {}
end

function HeroEquipTemplateManager:GetTemplateListBySlot(slot)
    local result = {}
    if slot ~= nil then
        if not self.isInit then
            self:InitAllTemplate()
        end
        local tempList = {}
        for k, v in pairs(self:GetAllTemplate()) do
            if v.isCraft and v.slot == slot then
                table.insert(tempList, v)
            end
        end
        table.sort(tempList, function (a, b)
            return a.quality < b.quality
        end)
        for k, v in pairs(tempList) do
            table.insert(result, v.id)
        end
    end
    return result
end

function HeroEquipTemplateManager:GetEquipmentAllAttr(id, lv, promote)
    local result = {}
    local base = self:GetEquipmentBaseAttr(id, lv, promote)
    for k, v in pairs(base) do
        table.insert(result, v)
    end
    local addition = self:GetEquipmentAdditionAttr(id, lv, promote)
    for k, v in pairs(addition) do
        table.insert(result, v)
    end
    return result
end

function HeroEquipTemplateManager:GetEquipmentBaseAttr(id, lv, promote)
    local result = {}
    local template = DataCenter.HeroEquipTemplateManager:GetTemplate(id)

    if template ~= nil then
        lv = lv + 1
        lv = math.min(#template.basicAttributes, lv)
        if promote <= 0 then
            local attribute = template.basicAttributes[lv]
            if attribute ~= nil then
                for k, v in pairs(attribute.effects) do
                    local param = {}
                    param.isBase = true
                    param.desc = v.descKey
                    param.value = self:GetFormatAffectValue(v)
                    table.insert(result, param)
                end
            end
        else
            promote = promote + 1
            promote = math.min(#template.basicAttributesPromote, promote)
            local attribute = template.basicAttributes[lv]
            local attributePromote = template.basicAttributesPromote[promote]
            local attributePromoteNext = template.basicAttributesPromote[promote + 1]
            if attribute ~= nil and attributePromote ~= nil then
                for k, v in pairs(attribute.effects) do
                    local effect = {}
                    effect.id = v.id
                    effect.numType = v.numType
                    effect.descKey = v.descKey

                    local effectPromote = attributePromote.effects[k]
                    if effectPromote ~= nil then
                        effect.value = v.value + effectPromote.value
                    end

                    local param = {}
                    param.isBase = true
                    param.desc = effect.descKey
                    param.value = self:GetFormatAffectValue(effect)
                    if attributePromoteNext ~= nil then
                        local nextEffect = {}
                        nextEffect.id = v.id
                        nextEffect.numType = v.numType
                        nextEffect.descKey = v.descKey
                        local effectPromoteNext = attributePromote.effects[k]
                        if effectPromote ~= nil and effectPromoteNext ~= nil then
                            nextEffect.value = v.value + effectPromoteNext.value
                        end
                        param.toValue = self:GetFormatAffectValue(nextEffect)
                    end
                    
                    table.insert(result, param)
                end
            end
        end
    end
    return result
end

function HeroEquipTemplateManager:GetEquipmentAdditionAttr(id, lv, promote)
    local result = {}
    local template = DataCenter.HeroEquipTemplateManager:GetTemplate(id)
    if template ~= nil then
        local lvEffect = {}
        for unlockLevel, attribute in pairs(template.additionAttributes) do
            for k, v in pairs(attribute.effects) do
                local param = {}
                param.isUpgradeLocked = unlockLevel > lv
                param.unlockLevel = unlockLevel
                param.desc = v.descKey
                param.value = self:GetFormatAffectValue(v)
                table.insert(lvEffect, param)
            end
        end
        table.sort(lvEffect,function(a,b)
            return a.unlockLevel < b.unlockLevel
        end)
        
        if template:IsMaxLevel(lv) and table.count(template.additionAttributesPromote) > 0 then
            local promoteEffect = {}
            for unlockLevel, attribute in pairs(template.additionAttributesPromote) do
                for k, v in pairs(attribute.effects) do
                    local param = {}
                    param.key = k
                    param.unlockLevel = unlockLevel
                    param.desc = v.descKey
                    param.value = self:GetFormatAffectValue(v)
                    table.insert(promoteEffect, param)
                end
            end
            table.sort(promoteEffect,function(a,b)
                return a.unlockLevel < b.unlockLevel
            end)
            
            for i, v in ipairs(promoteEffect) do
                if i > #lvEffect then
                    v.isPromoteNew = true
                    if promote >= v.unlockLevel then
                        v.isPromote = true
                    else
                        v.isPromoteLocked = true
                    end
                else
                    if promote >= v.unlockLevel then
                        v.isPromote = true
                    else
                        v.isPromoteLocked = true
                        v.desc = lvEffect[i].desc
                        v.value = lvEffect[i].value
                    end
                end
                table.insert(result, v)
            end
        else
            result = lvEffect;
        end
    end
    return result
end

function HeroEquipTemplateManager:GetEquipmentPower(id, lv, promote)
    local power = 0
    local base = self:GetEquipmentBasePower(id, lv, promote)
    for k, v in pairs(base) do
        power = power + v
    end
    local addition = self:GetEquipmentAdditionPower(id, lv, promote)
    for k, v in pairs(addition) do
        power = power + v
    end
    return power
end

function HeroEquipTemplateManager:GetEquipmentBasePower(id, lv, promote)
    local result = {}
    local template = DataCenter.HeroEquipTemplateManager:GetTemplate(id)
    if template ~= nil then
        if promote <= 0 then
            local attribute = template.basicAttributes[lv + 1]
            if attribute ~= nil then
                table.insert(result, attribute.power)
            end
        else
            local attribute = template.basicAttributes[lv + 1]
            local attributePromote = template.basicAttributesPromote[promote + 1]
            if attribute ~= nil and attributePromote ~= nil then
                local power = attribute.power + attributePromote.power
                table.insert(result, power)
            end
        end
    end
    return result
end

function HeroEquipTemplateManager:GetEquipmentAdditionPower(id, lv, promote)
    local result = {}
    local template = DataCenter.HeroEquipTemplateManager:GetTemplate(id)
    if template ~= nil then
        if promote <= 0 then
            for unlockLevel, attribute in pairs(template.additionAttributes) do
                if lv >= unlockLevel then
                    table.insert(result, attribute.power)
                end
            end
        else
            for unlockLevel, attribute in pairs(template.additionAttributesPromote) do
                if promote >= unlockLevel then
                    table.insert(result, attribute.power)
                end
            end
        end
    end
    return result
end

function HeroEquipTemplateManager:GetCraftMaterialsByEquipId(id)
    local result = {}
    local template = self:GetTemplate(id)
    if template ~= nil then
        for itemId, num in pairs(template.craftMaterials) do
            local itemTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(itemId)
            if itemTemplate ~= nil then
                local param = {}
                param.rewardType = RewardType.GOODS
                param.itemId = itemId
                param.count = num
                table.insert(result, param)
            end
        end
    end
    return result
end

function HeroEquipTemplateManager:IsEnoughRes(id)
    local enough = true
	local lack = {}
    local template = self:GetTemplate(id)
    if template ~= nil then
        for resType, resCost in pairs(template.resource) do
            local resNum = LuaEntry.Resource:GetCntByResType(resType)
            if resNum < resCost then
                lack.type = ResLackType.Res
                lack.id = resType
                lack.targetNum = resCost
				enough = false
            end
            break
        end
        for itemId, cost in pairs(template.craftMaterials) do
            local itemNum = DataCenter.ItemData:GetItemCount(itemId)
            if itemNum < cost then
                lack.type = ResLackType.Item
                lack.id = itemId
                lack.targetNum = cost
                enough = false
                break
            end
            break
        end
    end
    return enough, lack
end

function HeroEquipTemplateManager:GetBreakMaterialsByEquipIds(ids)
    local result = {}
    local itemDict = {}
    for _, id in pairs(ids) do
        local equip = self:GetTemplate(id)
        if equip ~= nil then
            for k, v in pairs(equip.breakMaterial) do
                local itemTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(k)
                if itemTemplate ~= nil then
                    local itemId = tonumber(itemTemplate.id)
                    if table.containsKey(itemDict, itemId) then
                        itemDict[itemId] = itemDict[itemId] + v
                    else
                        itemDict[itemId] = v
                    end
                end
            end
        end
    end
    for k, v in pairs(itemDict) do
        local param = {}
        param.rewardType = RewardType.GOODS
        param.itemId = k
        param.count = v
        table.insert(result, param)
    end

    return result
end

function HeroEquipTemplateManager:IsEquipUnlock(id)
    local equip = self:GetTemplate(id)
    if equip ~= nil then
        if equip.unlockLevel ~= nil and equip.unlockLevel > 0 then
            return DataCenter.BuildManager:IsExistBuildByTypeLv(BuildingTypes.DS_EQUIP_FACTORY, equip.unlockLevel), equip.unlockLevel
        else 
            return true, equip.unlockLevel
        end
    end
end

function HeroEquipTemplateManager:GetFormatAffectValue(data)
    if data == nil 
    or data.numType == nil 
    or data.numType == ""
    or data.value == nil then
        return ""
    end
    if tonumber(data.numType)  == 1 then
        return  "+"..data.value.."%"
    elseif tonumber(data.numType)  == 2 then
        if data.value == 0 then
            return "+".. 0 .."%"
        else
            return  "+"..data.value/10 .."%"
        end
    elseif tonumber(data.numType)  == 0 then
        return "+"..data.value
    elseif tonumber(data.numType)  == 3 then
        return ""
    end
end

return HeroEquipTemplateManager