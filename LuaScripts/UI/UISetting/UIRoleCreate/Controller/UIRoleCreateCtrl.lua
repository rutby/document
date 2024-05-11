---
--- Created by zzl.
--- DateTime: 
---

local UIRoleCreateCtrl = BaseClass("UIRoleCreateCtrl", UIBaseCtrl)

local function CloseSelf(self)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIRoleCreate)
end

local function Close(self)
    UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end


UIRoleCreateCtrl.CloseSelf = CloseSelf
UIRoleCreateCtrl.Close = Close
return UIRoleCreateCtrl