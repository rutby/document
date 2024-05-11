---------------------------------------------------------------------
-- dr_client (C) CompanyName, All Rights Reserved
-- Created by: AuthorName
-- Date: 2024-03-22 14:49:55
---------------------------------------------------------------------

-- To edit this template in: Data/Config/Template.lua
-- To disable this template, check off menuitem: Options-Enable Template File

---@class UIHeroEquipInfoCtrl
local UIHeroEquipInfoCtrl = BaseClass("UIHeroEquipInfoCtrl", UIBaseCtrl)

local function CloseSelf()
	UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeroEquipInfo)
end

UIHeroEquipInfoCtrl.CloseSelf = CloseSelf

return UIHeroEquipInfoCtrl