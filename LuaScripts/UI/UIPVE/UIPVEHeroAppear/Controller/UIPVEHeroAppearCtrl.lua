---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 24224.
--- DateTime: 2022/5/24 21:15
---
local UIPVEHeroAppearCtrl = BaseClass("UIPVEHeroAppearCtrl", UIBaseCtrl)

local function CloseSelf(self)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPVEHeroAppear)
end



UIPVEHeroAppearCtrl.CloseSelf = CloseSelf
return UIPVEHeroAppearCtrl