---
--- Created by shimin.
--- DateTime: 2020/7/6 21:39
---
local MoveCityToWorldMessage = BaseClass("MoveCityToWorldMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
    base.OnCreate(self)
    if param ~= nil then
        if param.asAlLeader ~= nil then
            self.sfsObj:PutInt("chooseLeader", param.asAlLeader)
        end
        if param.status ~= nil then
            self.sfsObj:PutInt("status", param.status)
        end
    end
    DataCenter.GuideManager:SetWaitingMessage(WaitMessageFinishType.MoveCityToWorld,true)
end

local function HandleMessage(self, message)
    base.HandleMessage(self, message)
    DataCenter.GuideCityManager:MoveCityToWorldHandle(message)
end

MoveCityToWorldMessage.OnCreate = OnCreate
MoveCityToWorldMessage.HandleMessage = HandleMessage

return MoveCityToWorldMessage