---
--- Created by Beef.
--- DateTime: 2024/4/2 19:07
---

local UICitySiegeStartCtrl = BaseClass("UICitySiegeStartCtrl", UIBaseCtrl)

function UICitySiegeStartCtrl:CloseSelf()
    UIManager.Instance:DestroyWindow(UIWindowNames.UICitySiegeStart)
end

return UICitySiegeStartCtrl