---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by mac.
--- DateTime: 10/11/21 2:52 PM
---
local Ctrl = BaseClass("Ctrl", UIBaseCtrl)

function Ctrl:CloseSelf()
    UIManager.Instance:DestroyWindow(UIWindowNames.UIMainMailTipsPanel)
end


return Ctrl