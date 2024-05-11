---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2022/4/27 20:34
---

local UIPVELoadingCtrl = BaseClass("UIPVELoadingCtrl", UIBaseCtrl)

local function CloseSelf(self)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPVELoading)
end

local function Close(self)
    UIManager:GetInstance():DestroyWindowByLayer(UILayer.Dialog)
end

UIPVELoadingCtrl.CloseSelf = CloseSelf
UIPVELoadingCtrl.Close = Close

return UIPVELoadingCtrl