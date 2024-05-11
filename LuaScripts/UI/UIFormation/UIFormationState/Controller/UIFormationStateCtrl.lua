---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2021/7/27 11:48
---
local UIFormationStateCtrl = BaseClass("UIFormationStateCtrl", UIBaseCtrl)

local function CloseSelf(self)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIFormationState)
end

local function Close(self)
    UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end



UIFormationStateCtrl.CloseSelf = CloseSelf
UIFormationStateCtrl.Close = Close
return UIFormationStateCtrl