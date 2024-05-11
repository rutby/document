--- Created by shimin
--- DateTime: 2024/3/19 12:13
--- 暴风雪领奖界面

local UIPreviewStorm2Ctrl = BaseClass("UIPreviewStorm2Ctrl", UIBaseCtrl)

function UIPreviewStorm2Ctrl:CloseSelf()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPreviewStorm2)
end

return UIPreviewStorm2Ctrl