---
--- Created by shimin.
--- DateTime: 2021/12/13 11:33
---

local UISceneNoInputCtrl = BaseClass("UISceneNoInputCtrl", UIBaseCtrl)

local function CloseSelf(self)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UISceneNoInput,{ anim = false , playEffect = false})
end

UISceneNoInputCtrl.CloseSelf = CloseSelf

return UISceneNoInputCtrl