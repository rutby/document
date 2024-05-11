---------------------------------------------------------------------
-- dr_client (C) CompanyName, All Rights Reserved
-- Created by: AuthorName
-- Date: 2024-03-22 16:02:12
---------------------------------------------------------------------

-- To edit this template in: Data/Config/Template.lua
-- To disable this template, check off menuitem: Options-Enable Template File

---@class HeroEquipDecomposeMessage
local HeroEquipDecomposeMessage = BaseClass("HeroEquipDecomposeMessage", SFSBaseMessage)
local base = SFSBaseMessage

function HeroEquipDecomposeMessage:OnCreate(equipUuids)
	base.OnCreate(self)
	local arr = SFSArray.New()
	table.walk(equipUuids,function (k,v)
		arr:AddLong(v)
	end)
	self.sfsObj:PutSFSArray("equipUuids", arr)
end

function HeroEquipDecomposeMessage:HandleMessage(t)
	base.HandleMessage(self, t)
	DataCenter.HeroEquipManager:HeroEquipDecomposeHandler(t)
end

return HeroEquipDecomposeMessage