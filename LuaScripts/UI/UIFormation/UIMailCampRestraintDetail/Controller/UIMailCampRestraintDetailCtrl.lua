---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2022/9/29 16:49
---
local UIMailCampRestraintDetailCtrl = BaseClass("UIFormationStateCtrl", UIBaseCtrl)

local function CloseSelf(self)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIMailCampRestraintDetail)
end

local function Close(self)
    UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end



UIMailCampRestraintDetailCtrl.CloseSelf = CloseSelf
UIMailCampRestraintDetailCtrl.Close = Close
return UIMailCampRestraintDetailCtrl