---------------------------------------------------------------------
-- dr_client (C) CompanyName, All Rights Reserved
-- Created by: AuthorName
-- Date: 2024-03-22 14:28:56
---------------------------------------------------------------------

-- To edit this template in: Data/Config/Template.lua
-- To disable this template, check off menuitem: Options-Enable Template File

---@class UIHeroEquipBag
local UIHeroEquipBag = BaseClass("UIHeroEquipBag", UIBaseView)
local base = UIBaseView

function UIHeroEquipBag:OnCreate(self)
	base.OnCreate(self)
	self:ComponentDefine()
	self:DataDefine()
	self:ReInit()
end

-- 销毁
function UIHeroEquipBag:OnDestroy(self)
	self:ComponentDestroy()
	self:DataDestroy()
	base.OnDestroy(self)
end

function UIHeroEquipBag:ComponentDefine(self)

end

function UIHeroEquipBag:ComponentDestroy(self)

end

function UIHeroEquipBag:DataDefine(self)

end

function UIHeroEquipBag:DataDestroy(self)

end

function UIHeroEquipBag:OnEnable(self)
	base.OnEnable(self)
end

function UIHeroEquipBag:OnDisable(self)
	base.OnDisable(self)
end

function UIHeroEquipBag:OnAddListener(self)
	base.OnAddListener(self)
end

function UIHeroEquipBag:OnRemoveListener(self)

	base.OnRemoveListener(self)
end

function UIHeroEquipBag:ReInit(self)

end

return UIHeroEquipBag