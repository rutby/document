---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2023/11/13 15:25
---

local UIVitaResidentIntroCtrl = BaseClass("UIVitaResidentIntroCtrl", UIBaseCtrl)

local function CloseSelf(self)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIVitaResidentIntro)
end

UIVitaResidentIntroCtrl.CloseSelf = CloseSelf

return UIVitaResidentIntroCtrl