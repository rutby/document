--- Created by shimin
--- DateTime: 2023/10/31 15:50
--- 德雷克boss使用道具界面

local UIDrakeBossUseItemCtrl = BaseClass("UIDrakeBossUseItemCtrl", UIBaseCtrl)

function UIDrakeBossUseItemCtrl:CloseSelf()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIDrakeBossUseItem)
end

return UIDrakeBossUseItemCtrl