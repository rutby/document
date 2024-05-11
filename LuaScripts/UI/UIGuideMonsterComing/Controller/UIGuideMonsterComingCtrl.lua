--- Created by shimin.
--- DateTime: 2024/2/28 18:25
--  引导丧尸来袭页面

local UIGuideMonsterComingCtrl = BaseClass("UIGuideMonsterComingCtrl", UIBaseCtrl)

function UIGuideMonsterComingCtrl:CloseSelf()
    UIManager.Instance:DestroyWindow(UIWindowNames.UIGuideMonsterComing)
end

return UIGuideMonsterComingCtrl