---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by w.
--- DateTime: 2022/11/30 13:00
---

local UIParkourBattleMainCtrl = BaseClass("UIZombieBattleMainCtrl", UIBaseCtrl)

function UIParkourBattleMainCtrl:CloseSelf()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIParkourBattleMain, { anim = false})
end

function UIParkourBattleMainCtrl:InitData(self)
end

return UIParkourBattleMainCtrl