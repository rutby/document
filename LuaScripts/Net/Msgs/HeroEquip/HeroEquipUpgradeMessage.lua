---------------------------------------------------------------------
-- dr_client (C) CompanyName, All Rights Reserved
-- Created by: AuthorName
-- Date: 2024-03-22 16:01:17
---------------------------------------------------------------------

-- To edit this template in: Data/Config/Template.lua
-- To disable this template, check off menuitem: Options-Enable Template File

---@class HeroEquipUpgradeMessage
local HeroEquipUpgradeMessage = BaseClass("HeroEquipUpgradeMessage", SFSBaseMessage)
local base = SFSBaseMessage

function HeroEquipUpgradeMessage:OnCreate(uuid)
	base.OnCreate(self)
	self.sfsObj:PutLong("uuid", uuid)
end

function HeroEquipUpgradeMessage:HandleMessage(t)
	base.HandleMessage(self, t)
	DataCenter.HeroEquipManager:HeroEquipUpgradeHandler(t)
end

return HeroEquipUpgradeMessage