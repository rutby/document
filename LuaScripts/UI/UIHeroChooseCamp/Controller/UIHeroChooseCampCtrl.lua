--- Created by shimin
--- DateTime: 2023/9/19 10:09
--- 英雄选择阵容页面

local UIHeroChooseCampCtrl = BaseClass("UIHeroChooseCampCtrl", UIBaseCtrl)

function UIHeroChooseCampCtrl:CloseSelf()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeroChooseCamp)
end

return UIHeroChooseCampCtrl