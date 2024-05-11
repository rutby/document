---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2023/3/20 16:34
---

local UIPositionAppointCtrl = BaseClass("UIPositionAppointCtrl", UIBaseCtrl)
local GovernmentConst = require("DataCenter.GovernmentManager.GovernmentConst")
local function CloseSelf(self, data, select)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPositionAppoint)
end

local function GetPanelData(self, playerUuid, playerName)
    local all = DataCenter.GovernmentTemplateManager:GetAllTemplate()
    local result = {}

    for k, v in pairs(all) do
        if k ~= GovernmentConst.King_Position_id then
            local param = {}
            param.id = k
            param.name = v.name
            param.icon = v.icon
            param.playerUuid = playerUuid
            param.playerName = playerName
            local positionInfo = DataCenter.GovernmentManager:GetPositionInfoByPositionId(k)
            param.positionInfo = positionInfo
            table.insert(result, param)
        end
    end
    return result
end

UIPositionAppointCtrl.CloseSelf = CloseSelf
UIPositionAppointCtrl.GetPanelData = GetPanelData

return UIPositionAppointCtrl