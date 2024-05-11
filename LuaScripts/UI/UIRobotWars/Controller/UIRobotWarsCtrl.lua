---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2021/9/15 16:38
---UIRobotWarsCtrl.lua
local UIRobotWarsCtrl = BaseClass("UIRobotWarsCtrl", UIBaseCtrl)

local function CloseSelf(self)
    UIManager.Instance:DestroyWindow(UIWindowNames.UIRobotWars,{ anim = true})
end

local function Close(self)
    UIManager.Instance:DestroyWindowByLayer(UILayer.Normal, false)
end

UIRobotWarsCtrl.CloseSelf = CloseSelf
UIRobotWarsCtrl.Close = Close
return UIRobotWarsCtrl