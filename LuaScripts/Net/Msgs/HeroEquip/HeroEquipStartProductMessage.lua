---------------------------------------------------------------------
-- dr_client (C) CompanyName, All Rights Reserved
-- Created by: AuthorName
-- Date: 2024-03-22 16:03:26
---------------------------------------------------------------------

-- To edit this template in: Data/Config/Template.lua
-- To disable this template, check off menuitem: Options-Enable Template File

---@class HeroEquipStartProductMessage
local HeroEquipStartProductMessage = BaseClass("HeroEquipStartProductMessage", SFSBaseMessage)
local base = SFSBaseMessage

function HeroEquipStartProductMessage:OnCreate(queueUuid, equipId)
	base.OnCreate(self)
	self.sfsObj:PutLong("queueUuid", queueUuid)
	self.sfsObj:PutInt("equipId", equipId)
end

function HeroEquipStartProductMessage:HandleMessage(t)
	base.HandleMessage(self, t)
	DataCenter.HeroEquipManager:HeroEquipStartProductHandler(t)
end

return HeroEquipStartProductMessage