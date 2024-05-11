
local UIUnLockNewFuncCtrl = BaseClass("UIUnLockNewFuncCtrl", UIBaseCtrl)

local function CloseSelf(self)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIUnLockNewFunc)
end

local function Close(self)
    UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end


UIUnLockNewFuncCtrl.CloseSelf =CloseSelf
UIUnLockNewFuncCtrl.Close = Close

return UIUnLockNewFuncCtrl