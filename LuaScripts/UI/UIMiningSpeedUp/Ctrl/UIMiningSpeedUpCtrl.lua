
local UIMiningSpeedUpCtrl = BaseClass("UIMiningSpeedUpCtrl", UIBaseCtrl)

function UIMiningSpeedUpCtrl : CloseSelf()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIMiningSpeedUp)
end

function UIMiningSpeedUpCtrl : OnClickUseBtn(speedUpItemId, activityId, queueId, useNum)
    --SFSNetwork.SendMessage(MsgDefines.ItemUse, { uuid = speedUpItemId, num = 1 })
    SFSNetwork.SendMessage(MsgDefines.GetMiningSpeedUpResInfo, activityId, queueId, useNum)
end

function UIMiningSpeedUpCtrl : OnClickGetBtn(speedUpItemId)
    local lackTab = {}
    local param = {}
    param.type = ResLackType.Item
    param.id = speedUpItemId
    param.targetNum = 1
    table.insert(lackTab, param)
    GoToResLack.GoToItemResLackList(lackTab)
end

return UIMiningSpeedUpCtrl