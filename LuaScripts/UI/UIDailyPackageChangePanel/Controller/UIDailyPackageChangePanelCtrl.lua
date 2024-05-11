
local UIDailyPackageChangePanelCtrl = BaseClass("UIDailyPackageChangePanelCtrl", UIBaseCtrl)

function UIDailyPackageChangePanelCtrl:CloseSelf()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIDailyPackageChangePanel)
end

return UIDailyPackageChangePanelCtrl