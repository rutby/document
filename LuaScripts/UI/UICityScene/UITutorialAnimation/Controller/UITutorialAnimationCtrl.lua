---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zhangliheng.
--- DateTime: 2022/2/24 21:51
---



local UITutorialAnimationCtrl = BaseClass("UITutorialAnimationCtrl", UIBaseCtrl)

local function CloseSelf(self)
    UIManager.Instance:DestroyWindow(UIWindowNames.UITutorialAnimation)
end

UITutorialAnimationCtrl.CloseSelf = CloseSelf

return UITutorialAnimationCtrl