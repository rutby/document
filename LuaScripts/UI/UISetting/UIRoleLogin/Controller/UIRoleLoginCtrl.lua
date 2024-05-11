---
--- Created by zzl.
--- DateTime: 
---

local UIRoleLoginCtrl = BaseClass("UIRoleLoginCtrl", UIBaseCtrl)

local function CloseSelf(self)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIRoleLogin)
end

local function Close(self)
    UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end


UIRoleLoginCtrl.CloseSelf = CloseSelf
UIRoleLoginCtrl.Close = Close
return UIRoleLoginCtrl