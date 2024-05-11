--- Created by shimin
--- DateTime: 2024/1/11 10:25
--- Vip界面

local UIVipCtrl = BaseClass("UIVipCtrl", UIBaseCtrl)

function UIVipCtrl:CloseSelf()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIVip)
end

return UIVipCtrl