
local GetHeroMonthCardAllRewardMessage = BaseClass("GetHeroMonthCardAllRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
    base.OnCreate(self)
end

local function HandleMessage(self, message)
    base.HandleMessage(self, message)
    DataCenter.HeroMonthCardManager:DoWhenGetAllRewardBack(message)
end

GetHeroMonthCardAllRewardMessage.OnCreate = OnCreate
GetHeroMonthCardAllRewardMessage.HandleMessage = HandleMessage

return GetHeroMonthCardAllRewardMessage