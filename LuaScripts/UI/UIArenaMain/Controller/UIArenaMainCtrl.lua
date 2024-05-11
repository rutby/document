--- Created by shimin
--- DateTime: 2023/12/6 12:01
--- 竞技场界面

local UIArenaMainCtrl = BaseClass("UIArenaMainCtrl", UIBaseCtrl)

function UIArenaMainCtrl:CloseSelf()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIArenaMain)
end

return UIArenaMainCtrl