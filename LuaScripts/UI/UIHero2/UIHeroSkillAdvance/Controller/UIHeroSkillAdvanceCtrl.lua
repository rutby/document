
local UIHeroSkillAdvanceCtrl = BaseClass("UIHeroSkillAdvanceCtrl", UIBaseCtrl)

local function CloseSelf(self)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeroSkillAdvance)
end

UIHeroSkillAdvanceCtrl.CloseSelf = CloseSelf

return UIHeroSkillAdvanceCtrl