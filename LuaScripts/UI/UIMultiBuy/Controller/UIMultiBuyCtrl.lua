---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2021/9/15 16:38
---UIMultiBuyCtrl
---
local UIMultiBuyCtrl = BaseClass("UIMultiBuyCtrl", UIBaseCtrl)

function UIMultiBuyCtrl:CloseSelf()
    UIManager.Instance:DestroyWindow(UIWindowNames.UIMultiBuy)
end

return UIMultiBuyCtrl