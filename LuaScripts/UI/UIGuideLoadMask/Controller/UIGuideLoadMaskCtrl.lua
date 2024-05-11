--- 出世界/联盟迁城遮罩
--- Created by shimin.
--- DateTime: 2022/7/18 16:12

local UIGuideLoadMaskCtrl = BaseClass("UIGuideLoadMaskCtrl", UIBaseCtrl)

local function CloseSelf(self)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGuideLoadMask,{anim = true, playEffect = false})
end

UIGuideLoadMaskCtrl.CloseSelf = CloseSelf

return UIGuideLoadMaskCtrl