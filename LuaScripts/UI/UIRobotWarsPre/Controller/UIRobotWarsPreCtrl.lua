---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2022/12/27 17:08
---
local UIRobotWarsPreCtrl = BaseClass("UIRobotWarsPreCtrl", UIBaseCtrl)

local function CloseSelf(self)
    UIManager.Instance:DestroyWindow(UIWindowNames.UIRobotWarsPre,{ anim = true})
end

local function Close(self)
    UIManager.Instance:DestroyWindowByLayer(UILayer.Normal, false)
end

UIRobotWarsPreCtrl.CloseSelf = CloseSelf
UIRobotWarsPreCtrl.Close = Close
return UIRobotWarsPreCtrl