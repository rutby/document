

local UIOfflineRewardPanelCtrl = BaseClass("UIOfflineRewardPanelCtrl", UIBaseCtrl)

local function CloseSelf(self)
    UIManager.Instance:DestroyWindow(UIWindowNames.UIOfflineRewardPanel)
end

local function Close(self)
    UIManager.Instance:DestroyWindowByLayer(UILayer.Normal, false)
end


UIOfflineRewardPanelCtrl.CloseSelf = CloseSelf
UIOfflineRewardPanelCtrl.Close = Close

return UIOfflineRewardPanelCtrl