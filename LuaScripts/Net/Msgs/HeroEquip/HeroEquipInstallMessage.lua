---------------------------------------------------------------------
-- dr_client (C) CompanyName, All Rights Reserved
-- Created by: AuthorName
-- Date: 2024-03-22 16:00:27
---------------------------------------------------------------------

-- To edit this template in: Data/Config/Template.lua
-- To disable this template, check off menuitem: Options-Enable Template File

---@class HeroEquipInstallMessage
local HeroEquipInstallMessage = BaseClass("HeroEquipInstallMessage", SFSBaseMessage)
local base = SFSBaseMessage

function HeroEquipInstallMessage:OnCreate(heroId, equipUuids)
	base.OnCreate(self)
	self.sfsObj:PutInt("heroId", heroId)
	
	local arr = SFSArray.New()
	table.walk(equipUuids,function (k,v)
		arr:AddLong(v)
	end)
	self.sfsObj:PutSFSArray("equipUuids", arr)
end

function HeroEquipInstallMessage:HandleMessage(t)
	base.HandleMessage(self, t)
	DataCenter.HeroEquipManager:HeroEquipInstallHandler(t)
end

return HeroEquipInstallMessage