---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2023/5/11 15:49
---

local UIMailDefenceDetailCtrl = BaseClass("UIMailDefenceDetailCtrl", UIBaseCtrl)

local function CloseSelf(self)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIMailDefenceDetail)
end

UIMailDefenceDetailCtrl.CloseSelf = CloseSelf

return UIMailDefenceDetailCtrl