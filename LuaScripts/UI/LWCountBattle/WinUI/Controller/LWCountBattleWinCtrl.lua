local LWCountBattleLoseView = BaseClass("LWCountBattleLoseView", UIBaseCtrl)

function LWCountBattleLoseView:CloseSelf()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.LWCountBattleWin, { anim = false})
end

function LWCountBattleLoseView:InitData(self)
end

return LWCountBattleLoseView