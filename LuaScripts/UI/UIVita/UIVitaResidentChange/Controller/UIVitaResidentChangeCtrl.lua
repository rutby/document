---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2023/11/2 17:33
---

local UIVitaResidentChangeCtrl = BaseClass("UIVitaResidentChangeCtrl", UIBaseCtrl)

local function CloseSelf(self)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIVitaResidentChange, { anim = true })
end

UIVitaResidentChangeCtrl.CloseSelf = CloseSelf

return UIVitaResidentChangeCtrl