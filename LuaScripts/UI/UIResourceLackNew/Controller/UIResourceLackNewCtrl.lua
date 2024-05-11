--- 获得更多界面
--- Created by shimin.
--- DateTime: 2024/1/17 15:18
local UIResourceLackNewCtrl = BaseClass("UIResourceLackNewCtrl", UIBaseCtrl)

function UIResourceLackNewCtrl:CloseSelf()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIResourceLackNew)
end

return UIResourceLackNewCtrl