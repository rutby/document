
local UIGloryEdenGroupCtrl = BaseClass("UIGloryEdenGroupCtrl", UIBaseCtrl)
function UIGloryEdenGroupCtrl:CloseSelf()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGloryEdenGroup)
end

return UIGloryEdenGroupCtrl