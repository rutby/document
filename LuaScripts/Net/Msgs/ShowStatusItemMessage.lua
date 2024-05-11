
local ShowStatusItemMessage = BaseClass("ShowStatusItemMessage", SFSBaseMessage)
-- 基类，用来调用基类方法
local base = SFSBaseMessage

local function HandleMessage(self, t)
	base.HandleMessage(self, t)
	--DataCenter.ItemData:ParseStatusItems(t.statusItems)
end
ShowStatusItemMessage.HandleMessage = HandleMessage

return ShowStatusItemMessage