---
--- Created by shimin.
--- DateTime: 2021/8/18 22:18
---

local UIGuideTalkCtrl = BaseClass("UIGuideTalkCtrl", UIBaseCtrl)

function UIGuideTalkCtrl:CloseSelf()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGuideTalk,{ anim = true, UIMainAnim = UIMainAnimType.ChangeAllShow, playEffect = false})
end

return UIGuideTalkCtrl