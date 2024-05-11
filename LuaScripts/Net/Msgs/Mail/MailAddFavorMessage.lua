--[[
	邮件加入到收藏夹
]]

local MailAddFavorMessage = BaseClass("MailAddFavorMessage", SFSBaseMessage)
local Localization = CS.GameEntry.Localization
local function OnCreate(self, uid, type)
	self.sfsObj:PutUtfString("uid", uid)
	self.sfsObj:PutInt("type", type)
end

local function HandleMessage(self, t)
	Logger.Log(t)
	local errCode =  t["errorCode"]
	if errCode ~= nil then
		UIUtil.ShowTipsId(errCode) 
	else
		UIUtil.ShowTipsId(310111) 
	end
end

MailAddFavorMessage.OnCreate = OnCreate
MailAddFavorMessage.HandleMessage = HandleMessage

return MailAddFavorMessage