--- 召唤暴风雪
--- Created by shimin.
--- DateTime: 2023/11/10 11:22
local StartNewbieStormMessage = BaseClass("StartNewbieStormMessage", SFSBaseMessage)
local base = SFSBaseMessage

function StartNewbieStormMessage:OnCreate()
    DataCenter.GuideManager:SetWaitingMessage(WaitMessageFinishType.StartNewbieStorm, true)
    base.OnCreate(self)
end

function StartNewbieStormMessage:HandleMessage(t)
    base.HandleMessage(self, t)
    DataCenter.StormManager:StartNewbieStormHandle(t)
end

return StartNewbieStormMessage