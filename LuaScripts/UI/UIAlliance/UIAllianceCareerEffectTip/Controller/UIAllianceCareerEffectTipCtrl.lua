---
--- Created by shimin.
--- DateTime: 2022/3/14 18:53
---
---
local UIAllianceCareerEffectTipCtrl = BaseClass("UIAllianceCareerEffectTipCtrl", UIBaseCtrl)

local function CloseSelf(self)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIAllianceCareerEffectTip)
end

UIAllianceCareerEffectTipCtrl.CloseSelf = CloseSelf

return UIAllianceCareerEffectTipCtrl