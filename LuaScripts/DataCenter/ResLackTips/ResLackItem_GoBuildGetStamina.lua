--- Created by shimin
--- DateTime: 2024/2/2 12:08
--- 领取体力
local ResLackItemBase = require "DataCenter.ResLackTips.ResLackItemBase"
local ResLackItem_GoBuildGetStamina = BaseClass("ResLackItem_GoBuildGetStamina", ResLackItemBase)

function ResLackItem_GoBuildGetStamina:CheckIsOk(_resType, _needCnt)
    self.buildId = tonumber(self._config:getValue("para1"))
    local buildData = DataCenter.BuildManager:GetFunbuildByItemID(self.buildId)
    if buildData ~= nil and buildData.level > 0 then
        local showTime = DataCenter.BuildManager:GetShowBubbleTime(buildData.uuid)
        local now = UITimeManager:GetInstance():GetServerTime()
        if showTime > 0 then
            if showTime <= now then
                return true
            end
        end
    end
    return false
end

function ResLackItem_GoBuildGetStamina:TodoAction()
    local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(self.buildId)
    if buildTemplate ~= nil then
        GoToUtil.CloseAllWindows()
        GoToUtil.GotoCityPos(buildTemplate:GetPosition(), CS.SceneManager.World.InitZoom, LookAtFocusTime, function()
            local obj = DataCenter.BuildBubbleManager:GetBubbleObjByBubbleTypeAndBuildId(BuildBubbleType.PubFreeEnergy, self.buildId)
            if obj ~= nil then
                local param = {}
                param.positionType = PositionType.Screen
                param.position = obj:GetArrowPosition()
                DataCenter.ArrowManager:ShowArrow(param)
            end
        end)
    end
end

return ResLackItem_GoBuildGetStamina