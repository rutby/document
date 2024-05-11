--- Timeline一键跳过
--- Created by shimin.
--- DateTime: 2022/8/31 15:33
---
local UITimelineJumpCtrl = BaseClass("UITimelineJumpCtrl", UIBaseCtrl)

function UITimelineJumpCtrl:CloseSelf()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UITimelineJump,{ anim = false , playEffect = false})
end

return UITimelineJumpCtrl