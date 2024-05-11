--- Created by shimin
--- DateTime: 2023/3/21 12:07
--- 王座嘉奖记录界面

local UIThroneSendListCtrl = BaseClass("UIThroneSendListCtrl", UIBaseCtrl)

function UIThroneSendListCtrl:CloseSelf()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIThroneSendList)
end

return UIThroneSendListCtrl