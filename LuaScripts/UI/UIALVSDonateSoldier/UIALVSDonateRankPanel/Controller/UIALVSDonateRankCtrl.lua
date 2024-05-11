local UIALVSDonateRankCtrl = BaseClass("UIALVSDonateRankCtrl", UIBaseCtrl)

local function CloseSelf(self)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIALVSDonateRank)
end

UIALVSDonateRankCtrl.CloseSelf = CloseSelf

return UIALVSDonateRankCtrl