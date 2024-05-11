
local UserChangePicMessage = BaseClass("UserChangePicMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization
local localPic
local function OnCreate(self,pic)
	base.OnCreate(self)
	localPic = pic
	self.sfsObj:PutUtfString("pic",pic)
end

local function HandleMessage(self, t)
	base.HandleMessage(self, t)
	local errCode =  t["errorCode"]
	if errCode == nil then
		-- 设置头像需要更新，否则设置成系统头像之后，不下线再聊天更换不了头像了
		if t["lastUpdateTime"] then
			LuaEntry.Player:SetLastUpdateTime(t["lastUpdateTime"])
		end
		UIUtil.ShowTipsId(129003) 
		LuaEntry.Player:SetPic(localPic)
		EventManager:GetInstance():Broadcast(EventId.UpdatePlayerHeadIcon,localPic)
	else
		print(errCode);
	end
end

UserChangePicMessage.OnCreate = OnCreate
UserChangePicMessage.HandleMessage = HandleMessage

return UserChangePicMessage