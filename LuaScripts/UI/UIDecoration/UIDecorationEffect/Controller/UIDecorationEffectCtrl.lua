---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2022/12/13 17:48
---

local UIDecorationEffectCtrl = BaseClass("UIDecorationEffectCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
    UIManager.Instance:DestroyWindow(UIWindowNames.UIDecorationEffect)
end

local function GetPanelData(self)
    local result = {}
    local allDecoration = DataCenter.DecorationDataManager:GetAllActiveDecoration()
    local tmp = {}
    for _, decorationId in ipairs(allDecoration) do
        local data = DataCenter.DecorationDataManager:GetSkinDataById(decorationId)
        if data then
            local template = DataCenter.DecorationTemplateManager:GetTemplate(decorationId)
            if template ~= nil then
                if data:IsWear() then
                    for _, v in pairs(template.wearEffect) do
                        if tmp[v.key] == nil then
                            tmp[v.key] = v.value
                        else
                            tmp[v.key] = tmp[v.key] + v.value
                        end
                    end
                end
                for _, v in pairs(template.ownEffect) do
                    if tmp[v.key] == nil then
                        tmp[v.key] = v.value
                    else
                        tmp[v.key] = tmp[v.key] + v.value
                    end
                end
            end
        end

    end
    for k, v in pairs(tmp) do
        local effectId = k
        local value = v
        local nameStr = GetTableData(TableName.EffectNumDesc, effectId, 'des')
        local name = Localization:GetString(nameStr)
        local type = toInt(GetTableData(TableName.EffectNumDesc, effectId, 'type'))
        local addValue = self:GetEffectNumWithType(value, type)
        local para = {}
        para.name = name
        para.value = addValue
        table.insert(result, para)
    end
    return result
end

local function GetEffectNumWithType(self, value, type)
    local addValue = tonumber(value)
    local addSign = (addValue and tonumber(addValue) > 0) and "+" or ""
    local result = ""
    if type == EffectLocalTypeInEffectDesc.Num then
        result = addSign .. string.GetFormattedSeperatorNum(value)
    elseif type == EffectLocalTypeInEffectDesc.Percent then
        result = addSign .. string.GetFormattedPercentStr(value/100)
    elseif type == EffectLocalTypeInEffectDesc.Thousandth then
        result = addSign .. string.GetFormattedThousandthStr(value/1000)
    end

    if addSign ~= "+" then
        result = "<color=#f26a67>"..result.."</color>"
    else
        result = "<color=#94e138>"..result.."</color>"
    end
    return result
end

UIDecorationEffectCtrl.CloseSelf = CloseSelf
UIDecorationEffectCtrl.GetPanelData = GetPanelData
UIDecorationEffectCtrl.GetEffectNumWithType = GetEffectNumWithType

return UIDecorationEffectCtrl