---------------------------------------------------------------------
-- dr_client (C) CompanyName, All Rights Reserved
-- Created by: AuthorName
-- Date: 2024-03-22 14:49:41
---------------------------------------------------------------------

-- To edit this template in: Data/Config/Template.lua
-- To disable this template, check off menuitem: Options-Enable Template File

---@class UIHeroEquipPromotionCtrl
local UIHeroEquipPromotionCtrl = BaseClass("UIHeroEquipPromotionCtrl", UIBaseCtrl)

local function CloseSelf()
	UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeroEquipPromotion)
end

UIHeroEquipPromotionCtrl.CloseSelf = CloseSelf

return UIHeroEquipPromotionCtrl