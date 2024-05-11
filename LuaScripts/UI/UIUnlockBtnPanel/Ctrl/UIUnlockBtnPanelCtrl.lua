
local UIUnlockBtnPanelCtrl = BaseClass("UIUnlockBtnPanelCtrl", UIBaseCtrl)

local function CloseSelf(self)
    UIManager.Instance:DestroyWindow(UIWindowNames.UIUnlockBtnPanel)
end

local function Close(self)
    UIManager.Instance:DestroyWindowByLayer(UILayer.Normal, false)
end

UIUnlockBtnPanelCtrl.CloseSelf = CloseSelf
UIUnlockBtnPanelCtrl.Close = Close
return UIUnlockBtnPanelCtrl