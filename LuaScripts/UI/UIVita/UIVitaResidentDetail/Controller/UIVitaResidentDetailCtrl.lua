---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2024/3/19 11:05
---

local UIVitaResidentDetailCtrl = BaseClass("UIVitaResidentDetailCtrl", UIBaseCtrl)

local function CloseSelf(self)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIVitaResidentDetail)
end

UIVitaResidentDetailCtrl.CloseSelf = CloseSelf

return UIVitaResidentDetailCtrl