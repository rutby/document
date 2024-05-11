local ReceiveBuildingGrowValRewardMessage = BaseClass("ReceiveBuildingGrowValRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
	base.OnCreate(self)
    if param ~= nil then
        self.sfsObj:PutLong("uuid", param.uuid)
    end
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    DataCenter.BuildManager:ReceiveBuildingGrowValRewardHandle(t)
end

ReceiveBuildingGrowValRewardMessage.OnCreate = OnCreate
ReceiveBuildingGrowValRewardMessage.HandleMessage = HandleMessage

return ReceiveBuildingGrowValRewardMessage