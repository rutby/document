---------------------------------------------------------------------
-- aps (C) CompanyName, All Rights Reserved
-- Created by: AuthorName
-- Date: 2021-08-13 14:26:20
---------------------------------------------------------------------

-- To edit this template in: Data/Config/Template.lua
-- To disable this template, check off menuitem: Options-Enable Template File

---@class UIHeadIconCtrl
local UIHeadIconShowCtrl = BaseClass("UIHeadIconShowCtrl", UIBaseCtrl)


local function CloseSelf(self)
	UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeadIconShow)
end
UIHeadIconShowCtrl.CloseSelf = CloseSelf
return UIHeadIconShowCtrl