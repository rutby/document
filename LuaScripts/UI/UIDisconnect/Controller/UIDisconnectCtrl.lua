
local UIDisconnectCtrl = BaseClass("UIDisconnectCtrl", UIBaseCtrl)


local function CloseSelf(self)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIDisconnect)
end

local function SendLoginInit(self)
    SFSNetwork.SendMessage(MsgDefines.LoginInitCommand)
end

UIDisconnectCtrl.SendLoginInit = SendLoginInit
UIDisconnectCtrl.CloseSelf = CloseSelf

return UIDisconnectCtrl