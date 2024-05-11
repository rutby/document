--- UI配路径黄色箭头
--- Created by shimin.
--- DateTime: 2022/11/9 18:22

local UIPathArrowCtrl = BaseClass("UIPathArrowCtrl", UIBaseCtrl)

function UIPathArrowCtrl:CloseSelf()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPathArrow,{ anim = false , playEffect = false})
end

return UIPathArrowCtrl