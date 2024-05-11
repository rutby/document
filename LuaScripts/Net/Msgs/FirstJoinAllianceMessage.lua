---
--- Created by shimin.
--- DateTime: 2022/6/17 11:02
--- 答完题后发送结果是否成为盟主
---
local FirstJoinAllianceMessage = BaseClass("FirstJoinAllianceMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
    base.OnCreate(self)
    if param ~= nil then
        self.sfsObj:PutInt("chooseLeader", param.chooseLeader)
        self.sfsObj:PutInt("status", param.status)
    end
    DataCenter.GuideManager:SetWaitingMessage(WaitMessageFinishType.FirstJoinAlliance,true)
end

local function HandleMessage(self, message)
    base.HandleMessage(self, message)
    DataCenter.GuideManager:SetWaitingMessage(WaitMessageFinishType.FirstJoinAlliance,nil)
    EventManager:GetInstance():Broadcast(EventId.GuideWaitMessage)
end

FirstJoinAllianceMessage.OnCreate = OnCreate
FirstJoinAllianceMessage.HandleMessage = HandleMessage

return FirstJoinAllianceMessage