---
--- Created by shimin.
--- DateTime: 2021/6/18 16:35
---

local UIBuildUpgradeAddDesCtrl = BaseClass("UIBuildUpgradeAddDesCtrl", UIBaseCtrl)

local function CloseSelf(self)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIBuildUpgradeAddDes,{anim = true})
end

local function Close(self)
    UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end


UIBuildUpgradeAddDesCtrl.CloseSelf = CloseSelf
UIBuildUpgradeAddDesCtrl.Close = Close

return UIBuildUpgradeAddDesCtrl