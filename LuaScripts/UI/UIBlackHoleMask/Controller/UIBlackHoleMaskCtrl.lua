--- 黑色遮罩页面
--- Created by shimin.
--- DateTime: 2022/11/9 16:10

local UIBlackHoleMaskCtrl = BaseClass("UIBlackHoleMaskCtrl", UIBaseCtrl)

function UIBlackHoleMaskCtrl:CloseSelf()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIBlackHoleMask,{ anim = false , playEffect = false})
end

return UIBlackHoleMaskCtrl