---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2021/8/5 20:47
---
local UIDetectEventPowerUpgradeCtrl = BaseClass("UIDetectEventCtrl", UIBaseCtrl)

local function CloseSelf(self)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIDetectEventPowerUpgrade)
end

local function Close(self)
    UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

local function Goto(self)
    local itemId, _ = self:GetUpgradeItem()
    local gotoPoint = nil
    if itemId ~= nil then
        local allEvents = DataCenter.RadarCenterDataManager:GetDetectEventInfoUuids()
        table.walk(allEvents, function (k, v) 
            local data = DataCenter.RadarCenterDataManager:GetDetectEventInfo(v)
            if data ~= nil then
                table.walk(data.rewardList, function (k1, v1)
                    if itemId == v1.itemId then
                        gotoPoint = data.pointId
                    end
                end)
            end
        end)
    end
    if gotoPoint ~= nil then
        GoToUtil.GotoWorldPos(SceneUtils.TileIndexToWorld(gotoPoint), CS.SceneManager.World.InitZoom)
    end
    self:CloseSelf()
end

local function IsCanUpdate(self)
    return DataCenter.RadarCenterDataManager:IsCanUpdate()
end

local function GetUpgradeItem(self)
    return DataCenter.RadarCenterDataManager:GetUpgradeItem()
end

--local function GetDetectEventLevelUpNum(self, level)
--    local result = DataConfig:GetStr("detect_config", "k4")
--    local vec = string.split(result,";")
--    if table.count(vec) < level then
--        return -1
--    end
--    return vec[level]
--end

UIDetectEventPowerUpgradeCtrl.CloseSelf = CloseSelf
UIDetectEventPowerUpgradeCtrl.Close = Close
UIDetectEventPowerUpgradeCtrl.Goto = Goto
UIDetectEventPowerUpgradeCtrl.IsCanUpdate = IsCanUpdate
UIDetectEventPowerUpgradeCtrl.GetUpgradeItem = GetUpgradeItem

return UIDetectEventPowerUpgradeCtrl