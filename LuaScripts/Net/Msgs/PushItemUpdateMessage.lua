--- 道具变化推送
--- Created by shimin.
--- DateTime: 2024/1/18 16:44
local PushItemUpdateMessage = BaseClass("PushItemUpdateMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushItemUpdateMessage:OnCreate()
    base.OnCreate(self)
end

function PushItemUpdateMessage:HandleMessage(t)
    base.HandleMessage(self, t)
    DataCenter.ItemManager:PushItemUpdateHandle(t)
end

return PushItemUpdateMessage