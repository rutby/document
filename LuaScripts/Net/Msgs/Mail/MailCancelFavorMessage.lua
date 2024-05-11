--[[
	邮件取消收藏夹
]]

local MailCancelFavorMessage = BaseClass("MailCancelFavorMessage", SFSBaseMessage)

local function OnCreate(self, uid, type)
	self.sfsObj:PutUtfString("uid", uid)
	self.sfsObj:PutInt("type", type)
end

local function HandleMessage(self, t)

end

MailCancelFavorMessage.OnCreate = OnCreate
MailCancelFavorMessage.HandleMessage = HandleMessage

return MailCancelFavorMessage