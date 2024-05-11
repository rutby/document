---
--- Created by shimin.
--- DateTime: 2022/6/14 15:11
--- 英雄委托
---

local UIHeroEntrustCtrl = BaseClass("UIHeroEntrustCtrl", UIBaseCtrl)

function UIHeroEntrustCtrl:CloseSelf()
    UIManager.Instance:DestroyWindow(UIWindowNames.UIHeroEntrust)
end

return UIHeroEntrustCtrl