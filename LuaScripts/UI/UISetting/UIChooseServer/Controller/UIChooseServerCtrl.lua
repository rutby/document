---
--- Created by zzl.
--- DateTime: 
---

local UIChooseServerCtrl = BaseClass("UIChooseServerCtrl", UIBaseCtrl)

local function CloseSelf(self)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIChooseServer)
end

local function Close(self)
    UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end


UIChooseServerCtrl.CloseSelf = CloseSelf
UIChooseServerCtrl.Close = Close
return UIChooseServerCtrl