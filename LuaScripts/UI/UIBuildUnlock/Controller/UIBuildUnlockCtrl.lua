---
--- Created by shimin.
--- DateTime: 2021/6/17 21:28
---

local UIBuildUnlockCtrl = BaseClass("UIBuildUnlockCtrl", UIBaseCtrl)

local function CloseSelf(self)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIBuildUnlock)
end

local function Close(self)
    UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end


UIBuildUnlockCtrl.CloseSelf = CloseSelf
UIBuildUnlockCtrl.Close = Close

return UIBuildUnlockCtrl