--- Created by shimin
--- DateTime: 2023/11/10 14:39
--- 暴风雪预览界面

local UIPreviewStormCtrl = BaseClass("UIPreviewStormCtrl", UIBaseCtrl)

function UIPreviewStormCtrl:CloseSelf()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPreviewStorm)
end

return UIPreviewStormCtrl