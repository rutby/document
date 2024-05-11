
local UIUnLockSuccessCtrl = BaseClass("UIUnLockSuccessCtrl", UIBaseCtrl)

local function CloseSelf(self)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIUnLockSuccess)
end

local function Close(self)
    UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

local function RemoveFirstData(self)
    DataCenter.UnlockDataManager:RemoveFirstData()
end

local function GetShowData(self)
    return DataCenter.UnlockDataManager:GetFirstData()
end

UIUnLockSuccessCtrl.CloseSelf =CloseSelf
UIUnLockSuccessCtrl.Close = Close
UIUnLockSuccessCtrl.ShowNextUnlock = ShowNextUnlock
UIUnLockSuccessCtrl.RemoveFirstData = RemoveFirstData
UIUnLockSuccessCtrl.GetShowData = GetShowData

return UIUnLockSuccessCtrl