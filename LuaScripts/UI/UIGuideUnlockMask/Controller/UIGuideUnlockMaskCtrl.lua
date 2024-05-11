--- 引导出现鸵鸟全屏暗角
--- Created by shimin.
--- DateTime: 2022/1/14 00:00

local UIGuideUnlockMaskCtrl = BaseClass("UIGuideUnlockMaskCtrl", UIBaseCtrl)

local function CloseSelf(self)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGuideUnlockMask,{ anim = true , playEffect = false})
end

UIGuideUnlockMaskCtrl.CloseSelf = CloseSelf
UIGuideUnlockMaskCtrl.Close = Close

return UIGuideUnlockMaskCtrl