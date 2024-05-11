--- Created by shimin
--- DateTime: 2023/12/28 11:58
--- 去建筑（没有就建造， 如果家具建筑有空闲工作位，调去工作，没有就去升级）

local ResLackItemBase = require "DataCenter.ResLackTips.ResLackItemBase"
local ResLackItem_Build = BaseClass("ResLackItem_Build", ResLackItemBase)

function ResLackItem_Build:CheckIsOk( _resType, _needCnt)
    return true
end

function ResLackItem_Build:TodoAction()
    local buildId = tonumber(self._config.para1)
    DataCenter.FurnitureManager:SetEnterPanelCameraPosParam(nil)
    local levelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildId, 0)
    if levelTemplate ~= nil and levelTemplate:IsFurnitureBuild() then
        local buildData = DataCenter.BuildManager:GetFunbuildByItemID(buildId)
        if buildData == nil or buildData:IsUpgrading() then
            DataCenter.FurnitureManager:SetEnterPanelCameraNoQuitParam(true)
            GoToUtil.CloseAllWindows()
            GoToUtil.GotoCityByBuildId(buildId)
        else
            local gotoWork = false
            if levelTemplate.need_worker > 0 then
                if DataCenter.FurnitureManager:HasCanSetWorkFurnitureByBUuid(buildData.uuid) then
                    gotoWork = true
                    DataCenter.FurnitureManager:SetEnterPanelCameraNoQuitParam(true)
                    GoToUtil.CloseAllWindows()
                    SceneUtils.ChangeToCity(function()
                        local param = {}
                        param.buildUuid = buildData.uuid
                        param.tabType = UIFurnitureUpgradeTabType.Work
                        param.arrowType = UIFurnitureUpgradeArrowType.AddWork
                        UIManager:GetInstance():OpenWindow(UIWindowNames.UIFurnitureUpgrade, NormalPanelAnim, param)
                    end)
                end
            end
            if not gotoWork then
                DataCenter.FurnitureManager:SetEnterPanelCameraNoQuitParam(true)
                GoToUtil.CloseAllWindows()
                GoToUtil.GotoCityByBuildId(buildId)
            end
        end
    else
        if buildId == BuildingTypes.FUN_BUILD_MAIN then
            DataCenter.FurnitureManager:SetEnterPanelCameraNoQuitParam(true)
            GoToUtil.CloseAllWindows()
            GoToUtil.GotoCityByBuildId(buildId)
        else
            local buildData = DataCenter.BuildManager:GetFunbuildByItemID(buildId)
            if buildData == nil then
                DataCenter.FurnitureManager:SetEnterPanelCameraNoQuitParam(true)
            end
            GoToUtil.CloseAllWindows()
            GoToUtil.GotoCityByBuildId(buildId)
        end
    end
end

return ResLackItem_Build