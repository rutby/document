---------------------------------------------------------------------
-- aps_new (C) CompanyName, All Rights Reserved
-- Created by: AuthorName
-- Date: 2021-08-26 11:12:00
---------------------------------------------------------------------

-- To edit this template in: Data/Config/Template.lua
-- To disable this template, check off menuitem: Options-Enable Template File

---@class ChangeModStrMessage
local ChangeModStrMessage = BaseClass("ChangeModStrMessage", SFSBaseMessage)

local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self,content)
	base.OnCreate(self)
	self.sfsObj:PutUtfString("moodstr", content)

end

local function HandleMessage(self, t)
	base.HandleMessage(self, t)
	local errCode =  t["errorCode"]
	if errCode == nil then
		local uid = LuaEntry.Player.uid
		local info =  DataCenter.PlayerInfoDataManager:GetPlayerDataByUid(uid)
		if info~=nil then
			DataCenter.PlayerInfoDataManager:ChangeSelfMood(t["moodstr"])
		end
	end
end
ChangeModStrMessage.OnCreate = OnCreate
ChangeModStrMessage.HandleMessage = HandleMessage
return ChangeModStrMessage