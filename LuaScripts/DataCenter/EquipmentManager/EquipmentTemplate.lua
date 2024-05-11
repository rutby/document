---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2023/2/24 17:33
---

local EquipmentTemplate = BaseClass("EquipmentTemplate")
local EquipmentAttrInfo = require "DataCenter.EquipmentManager.EquipmentAttrInfo"

local function __init(self)
    self.id = 0
    self.position = 0
    self.name = ""
    self.icon = ""
    self.description = ""
    self.level = 0
    self.color = 1
    self.lvExp = 0
    self.suitId = -1
    self.suitType = EquipmentConst.EquipmentSuitType.Equipment_Suit_Type_UnDefine
    self.qualityUpgradeCost = {}
    self.costMaterial = 0
    self.attrInfos = {}
end

local function __delete(self)
    self.id = 0
    self.position = 0
    self.name = ""
    self.icon = ""
    self.description = ""
    self.level = 0
    self.color = 1
    self.lvExp = 0
    self.suitId = -1
    self.suitType = EquipmentConst.EquipmentSuitType.Equipment_Suit_Type_UnDefine
    self.qualityUpgradeCost = {}
    self.costMaterial = 0
    self.attrInfos = {}
end

local function InitData(self, row)
    self.id = toInt(row:getValue("id"))
    self.position = toInt(row:getValue("position"))
    self.name = row:getValue("name")
    self.description = row:getValue("description")
    self.level = toInt(row:getValue("lv"))
    self.color = toInt(row:getValue("color"))
    self.lvExp = toInt(row:getValue("lv_exp"))
    self.icon = row:getValue("icon")
    self.qualityUpgradeCost = {}
    local costStr = row:getValue("cost")
    if not string.IsNullOrEmpty(costStr) then
        local vec = string.split(costStr, "|")
        for _, v in ipairs(vec) do
            local costVec = string.split(v, ";")
            if table.count(costVec) == 2 then
                self.qualityUpgradeCost[toInt(costVec[1])] = tonumber(costVec[2])
            end
        end
    end
    
    self.costMaterial = row:getValue("cost_material")

    self.attrInfos = {}

    local max = 100--多几个，便于策划往后配
    for i = 1, max do
        local effectDes = row:getValue("effect_description1"..i)
        if effectDes == nil or effectDes == 0 then
            break
        end
        local value = row:getValue("effect_value"..i)

        local showType = row:getValue("show_type"..i)

        local unlockTip = row:getValue("unlock_tips"..i)
        local info = EquipmentAttrInfo.New()
        info:InitData(effectDes, value, showType, unlockTip)
        table.insert(self.attrInfos, info)
    end
end

local function GetAllAttrInfo(self)
    return self.attrInfos
end

local function GetSuitId(self)
    if self.suitId == -1 then
        self.suitId = DataCenter.EquipmentSuitTemplateManager:GetSuitIdByEquipmentId(self.id)
    end
    
    return self.suitId
end

local function GetSuitType(self)
    if self.suitType == EquipmentConst.EquipmentSuitType.Equipment_Suit_Type_UnDefine then
        local suitId = self:GetSuitId()
        local suitTemplate = DataCenter.EquipmentSuitTemplateManager:GetTemplate(suitId)
        if suitTemplate then
            self.suitType = suitTemplate.type
        else
            self.suitType = EquipmentConst.EquipmentSuitType.Equipment_Suit_Type_Null
        end
    end

    return self.suitType
end

EquipmentTemplate.__init = __init
EquipmentTemplate.__delete = __delete
EquipmentTemplate.InitData = InitData
EquipmentTemplate.GetAllAttrInfo = GetAllAttrInfo
EquipmentTemplate.GetSuitId = GetSuitId
EquipmentTemplate.GetSuitType = GetSuitType

return EquipmentTemplate