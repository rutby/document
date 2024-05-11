---------------------------------------------------------------------
-- dr_client (C) CompanyName, All Rights Reserved
-- Created by: AuthorName
-- Date: 2024-03-22 16:01:54
---------------------------------------------------------------------

-- To edit this template in: Data/Config/Template.lua
-- To disable this template, check off menuitem: Options-Enable Template File

---@class HeroEquipPromoteMessage
local HeroEquipPromoteMessage = BaseClass("HeroEquipPromoteMessage", SFSBaseMessage)
local base = SFSBaseMessage

function HeroEquipPromoteMessage:OnCreate(uuid)
	base.OnCreate(self)
	self.sfsObj:PutLong("uuid", uuid)
end

function HeroEquipPromoteMessage:HandleMessage(t)
	base.HandleMessage(self, t)
	DataCenter.HeroEquipManager:HeroEquipPromoteHandler(t)
end

return HeroEquipPromoteMessage