---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2024/3/25 20:40
---

local UIHeroEtoileUpCtrl = BaseClass("UIHeroEtoileUpCtrl", UIBaseCtrl)

local function CloseSelf(self)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeroEtoileUp)
end

UIHeroEtoileUpCtrl.CloseSelf = CloseSelf

return UIHeroEtoileUpCtrl