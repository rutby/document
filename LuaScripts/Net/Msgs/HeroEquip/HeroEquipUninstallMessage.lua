---------------------------------------------------------------------
-- dr_client (C) CompanyName, All Rights Reserved
-- Created by: AuthorName
-- Date: 2024-03-22 16:00:46
---------------------------------------------------------------------

-- To edit this template in: Data/Config/Template.lua
-- To disable this template, check off menuitem: Options-Enable Template File

---@class HeroEquipUninstallMessage
local HeroEquipUninstallMessage = BaseClass("HeroEquipUninstallMessage", SFSBaseMessage)
local base = SFSBaseMessage

function HeroEquipUninstallMessage:OnCreate(heroId, equipUuids)
	base.OnCreate(self)
	self.sfsObj:PutInt("heroId", heroId)

	local arr = SFSArray.New()
	table.walk(equipUuids,function (k,v)
		arr:AddLong(v)
	end)
	self.sfsObj:PutSFSArray("equipUuids", arr)
end

function HeroEquipUninstallMessage:HandleMessage(t)
	base.HandleMessage(self, t)
	DataCenter.HeroEquipManager:HeroEquipUninstallHandler(t)
end

return HeroEquipUninstallMessage