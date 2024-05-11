---
--- UIPVE结果控制器
---

local UIPVEResultCtrl = BaseClass("UIPVEResultCtrl", UIBaseCtrl)
local function CloseSelf(self)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPVEResult)
end

local function Close(self)
    UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end


UIPVEResultCtrl.CloseSelf =CloseSelf
UIPVEResultCtrl.Close =Close

return UIPVEResultCtrl