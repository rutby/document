
local GetRankPreviewMessage = BaseClass("GetRankPreviewMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization
local function OnCreate(self)
	base.OnCreate(self)
end



local function HandleMessage(self, t)
	base.HandleMessage(self, t)
	local errCode =  t["errorCode"]
	if errCode ~= nil then
	else
		EventManager:GetInstance():Broadcast(EventId.UpdateRankPreview,t)
		--dump(t,"Data",6)
	end
end

GetRankPreviewMessage.OnCreate = OnCreate
GetRankPreviewMessage.HandleMessage = HandleMessage

return GetRankPreviewMessage