

local UITaskMainCtrl = BaseClass("UITaskMainCtrl", UIBaseCtrl)

local function CloseSelf(self)
    UIManager.Instance:DestroyWindow(UIWindowNames.UITaskMain)
end

local function Close(self)
    UIManager.Instance:DestroyWindowByLayer(UILayer.Normal, false)
end


UITaskMainCtrl.CloseSelf = CloseSelf
UITaskMainCtrl.Close = Close

return UITaskMainCtrl