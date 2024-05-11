local LWCountBattleMainCtrl = BaseClass("LWCountBattleMainCtrl", UIBaseCtrl)

function LWCountBattleMainCtrl:CloseSelf()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.LWCountBattleMain, { anim = false})
end

function LWCountBattleMainCtrl:InitData(self)
end

return LWCountBattleMainCtrl