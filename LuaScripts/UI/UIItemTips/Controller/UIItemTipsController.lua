---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by mac.
--- DateTime: 7/22/21 2:48 PM
---
local UIItemTipsController = BaseClass("UIItemTipsController", UIBaseCtrl)

local function CloseSelf(self)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIItemTips)
end

UIItemTipsController.CloseSelf = CloseSelf

return UIItemTipsController