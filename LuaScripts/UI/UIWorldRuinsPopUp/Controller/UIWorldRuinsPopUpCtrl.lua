---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2021/12/10 16:59
---
local UIWorldRuinsPopUpCtrl = BaseClass("UIWorldRuinsPopUpCtrl", UIBaseCtrl)

local function CloseSelf(self)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIWorldRuinsPopUp)
end
local function Close(self)
    UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

UIWorldRuinsPopUpCtrl.CloseSelf = CloseSelf
UIWorldRuinsPopUpCtrl.Close = Close
return UIWorldRuinsPopUpCtrl