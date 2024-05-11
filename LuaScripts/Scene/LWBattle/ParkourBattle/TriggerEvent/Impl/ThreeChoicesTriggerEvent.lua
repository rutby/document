---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by wsf.
---

---@class ThreeChoicesTriggerEvent
local ThreeChoicesTriggerEvent = BaseClass("ThreeChoicesTriggerEvent")

function ThreeChoicesTriggerEvent:__init()
    
end

function ThreeChoicesTriggerEvent:__delete()
    
end

function ThreeChoicesTriggerEvent:Execute(param, extra)
    if not extra then
        return
    end
    
    local array = param.paraArray
    if not array or #array == 0 then
        return
    end

    if type(extra) ~= "table" then
        return
    end

    if #extra ~= #array then
        return
    end

    local uiParam = {}
    uiParam.triggerItemList = array
    uiParam.heroUuidList = extra

    DataCenter.LWBattleManager:SetGamePause(true)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIParkourThreeChoices, {anim = true }, uiParam)
end

return ThreeChoicesTriggerEvent