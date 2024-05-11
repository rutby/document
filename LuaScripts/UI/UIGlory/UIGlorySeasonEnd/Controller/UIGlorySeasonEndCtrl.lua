
local UIGlorySeasonEndCtrl = BaseClass("UIGlorySeasonEndCtrl", UIBaseCtrl)
function UIGlorySeasonEndCtrl:CloseSelf()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGlorySeasonEnd)
end

return UIGlorySeasonEndCtrl