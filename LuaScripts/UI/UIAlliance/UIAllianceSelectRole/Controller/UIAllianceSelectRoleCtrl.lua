---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by mac.
--- DateTime: 7/22/21 2:48 PM
---
local UIAllianceSelectRoleCtrl = BaseClass("UIAllianceSelectRoleCtrl", UIBaseCtrl)

local function CloseSelf(self)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIAllianceSelectRole)
end

local function Close(self)
    UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

UIAllianceSelectRoleCtrl.CloseSelf = CloseSelf
UIAllianceSelectRoleCtrl.Close = Close

return UIAllianceSelectRoleCtrl