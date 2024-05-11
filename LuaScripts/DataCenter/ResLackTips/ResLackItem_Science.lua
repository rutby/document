---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by f.
--- DateTime: 2021/11/23 14:14
---
--[[
收集资源
跳转到科技
]]

local ResLackItemBase = require "DataCenter.ResLackTips.ResLackItemBase"
local ResLackItem_Science = BaseClass("ResLackItem_Science", ResLackItemBase)

function ResLackItem_Science:CheckIsOk( _resType, _needCnt )
    if  CS.SceneManager.IsInPVE() then
        return false
    end
    local list = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(BuildingTypes.FUN_BUILD_SCIENE)
    if list ~= nil and table.count(list) > 0 then
        for k,v in pairs(list) do
            if v.level < 1 then
                return false
            end
        end
    end
    local scienceId = self._config:getValue("para1")
    if (string.IsNullOrEmpty(scienceId)) then
        return false
    end
    self.scienceId = tonumber(scienceId)
    local curLevel = DataCenter.ScienceManager:GetScienceLevel(self.scienceId)
    if curLevel ~= 0 then
        return false
    end
    return true
end

function ResLackItem_Science:TodoAction()
    if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIScienceInfo) then
        UIManager:GetInstance():DestroyWindow(UIWindowNames.UIScienceInfo)
    end
    GoToUtil.GotoScience(self.scienceId)
end

return ResLackItem_Science