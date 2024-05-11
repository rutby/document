---
--- Created by zzl.
--- DateTime: 
---

local UIRolesCtrl = BaseClass("UIRolesCtrl", UIBaseCtrl)

local function CloseSelf(self)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIRoles)
end

local function Close(self)
    UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end


UIRolesCtrl.CloseSelf = CloseSelf
UIRolesCtrl.Close = Close
return UIRolesCtrl