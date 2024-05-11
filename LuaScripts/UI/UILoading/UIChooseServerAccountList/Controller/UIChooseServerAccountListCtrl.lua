---------------------------------------------------------------------
-- aps (C) CompanyName, All Rights Reserved
-- Created by: AuthorName
-- Date: 2021-07-30 11:36:26
---------------------------------------------------------------------

-- To edit this template in: Data/Config/Template.lua
-- To disable this template, check off menuitem: Options-Enable Template File

---@class UIChooseServerAccountListCtrl
local UIChooseServerAccountListCtrl = BaseClass("UIChooseServerAccountListCtrl", UIBaseCtrl)

local function CloseSelf(self)
	UIManager:GetInstance():DestroyWindow(UIWindowNames.UIChooseServerAccountList)
end

local function Close(self)
	UIManager:GetInstance():DestroyWindowByLayer(UILayer.Info)
end
UIChooseServerAccountListCtrl.CloseSelf=CloseSelf
UIChooseServerAccountListCtrl.Close=Close

return UIChooseServerAccountListCtrl