
local UIScratchSelectHeroCtrl = BaseClass("UIScratchSelectHeroCtrl", UIBaseCtrl)

function UIScratchSelectHeroCtrl : CloseSelf()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIScratchSelectHero)
end

return UIScratchSelectHeroCtrl