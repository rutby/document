---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2023/3/21 17:20
---

local UICrossWormCtrl = BaseClass("UICrossWormCtrl", UIBaseCtrl)

local function CloseSelf(self)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UICrossWorm)
end

UICrossWormCtrl.CloseSelf = CloseSelf

return UICrossWormCtrl