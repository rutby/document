---------------------------------------------------------------------
-- dr_client (C) CompanyName, All Rights Reserved
-- Created by: AuthorName
-- Date: 2024-03-22 16:02:48
---------------------------------------------------------------------

-- To edit this template in: Data/Config/Template.lua
-- To disable this template, check off menuitem: Options-Enable Template File

---@class HeroEquipAddPushMessage
local HeroEquipAddPushMessage = BaseClass("HeroEquipAddPushMessage", SFSBaseMessage)
local base = SFSBaseMessage

function HeroEquipAddPushMessage:OnCreate(uuid)
	base.OnCreate(self)
	self.sfsObj:PutLong("uuid", uuid)
end

function HeroEquipAddPushMessage:HandleMessage(t)
	base.HandleMessage(self, t)
	DataCenter.HeroEquipManager:HeroEquipAddPushHandler(t)
end

return HeroEquipAddPushMessage