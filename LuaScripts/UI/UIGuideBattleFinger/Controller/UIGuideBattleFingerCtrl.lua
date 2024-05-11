--- Created by shimin
--- DateTime: 2024/03/28 20:07
--- 战斗开始引导手左右滑动提示

local UIGuideBattleFingerCtrl = BaseClass("UIGuideBattleFingerCtrl", UIBaseCtrl)

function UIGuideBattleFingerCtrl:CloseSelf()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGuideBattleFinger)
end

return UIGuideBattleFingerCtrl