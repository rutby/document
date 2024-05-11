--- Created by shimin
--- DateTime: 2023/9/26 17:25
--- 推翻胡蒂尔页面

local UIOverthrowHudierCtrl = BaseClass("UIOverthrowHudierCtrl", UIBaseCtrl)

function UIOverthrowHudierCtrl:CloseSelf()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIOverthrowHudier)
end

return UIOverthrowHudierCtrl