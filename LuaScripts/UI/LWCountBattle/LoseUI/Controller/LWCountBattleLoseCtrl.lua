local LWCountBattleLoseCtrl = BaseClass("LWCountBattleLoseCtrl", UIBaseCtrl)

function LWCountBattleLoseCtrl:CloseSelf()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.LWCountBattleLose, { anim = false})
end

function LWCountBattleLoseCtrl:InitData(self)
end

return LWCountBattleLoseCtrl