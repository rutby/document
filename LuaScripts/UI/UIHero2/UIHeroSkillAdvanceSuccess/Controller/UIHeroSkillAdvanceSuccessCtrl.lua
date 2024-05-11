
local UIHeroSkillAdvanceSuccessCtrl = BaseClass("UIHeroSkillAdvanceSuccessCtrl", UIBaseCtrl)

local function CloseSelf(self)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeroSkillAdvanceSuccess)
end

UIHeroSkillAdvanceSuccessCtrl.CloseSelf = CloseSelf

return UIHeroSkillAdvanceSuccessCtrl