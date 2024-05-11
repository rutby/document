---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2023/3/1 15:15
---

local UIEquipmentInfoCtrl = BaseClass("UIEquipmentInfoCtrl", UIBaseCtrl)

local function CloseSelf(self)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIEquipmentUpgrade)
end

local function GetPanelData(self, equipmentUid)
    local result = {}
    result.equipmentUid = equipmentUid
    local data = DataCenter.EquipmentDataManager:GetEquipByUuid(equipmentUid)
    if data then
        local template = DataCenter.EquipmentTemplateManager:GetTemplate(data.equipId)
        result.equipmentId = data.equipId
        result.lv = data.lv
        result.attrList = EquipmentUtil.GetEquipmentAttr(data.equipId)
        result.curExp = data.exp
        result.maxExp = template.lvExp
        local upgradeItem = template.costMaterial
        result.upgradeItem = upgradeItem
        result.upgradeItemInfo = {}
        result.upgradeItemInfo.icon = DataCenter.ItemTemplateManager:GetIconPath(upgradeItem)
        local itemCount = DataCenter.ItemData:GetItemCount(upgradeItem)
        result.upgradeItemInfo.num = string.GetFormattedSeperatorNum(itemCount) .."/1"
        if itemCount < 1 then
            result.upgradeItemInfo.num = "<color=#dd2828>" .. string.GetFormattedSeperatorNum(itemCount) .. "</color>".."/1"
        end
        result.qualityUpgradeCost = {}
        local qualityCost = template.qualityUpgradeCost
        for k, v in pairs(qualityCost) do
            local param = {}
            param.icon = DataCenter.ResourceManager:GetResourceIconByType(k)
            local resCount = LuaEntry.Resource:GetCntByResType(k)
            param.num = string.GetFormattedSeperatorNum(resCount) .."/"..string.GetFormattedSeperatorNum(v)
            if resCount < v then
                param.num = "<color=#dd2828>" .. string.GetFormattedSeperatorNum(resCount) .. "</color>".."/"..string.GetFormattedSeperatorNum(v)
            end
            param.id = k
            param.need = v
            param.have = resCount
            table.insert(result.qualityUpgradeCost, param)
        end
        
        local toTemplate = DataCenter.EquipmentTemplateManager:GetTemplate(tonumber(data.equipId) + 1)
        if toTemplate then
            local attrList1 = EquipmentUtil.GetEquipmentAttr(toTemplate.id)
            local count = table.count(result.attrList)
            
            for i = 1, count do
                if result.attrList[i].isLocked ~= true then
                    local toValue = attrList1[i].value
                    result.attrList[i].toValue = toValue
                end
            end
        end
    end
    return result
end

UIEquipmentInfoCtrl.CloseSelf = CloseSelf
UIEquipmentInfoCtrl.GetPanelData = GetPanelData

return UIEquipmentInfoCtrl