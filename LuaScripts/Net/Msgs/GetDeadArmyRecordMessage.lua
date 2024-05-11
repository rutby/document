--- Created by shimin.
--- DateTime: 2023/1/30 18:25
--- 获取报废士兵信息

local GetDeadArmyRecordMessage = BaseClass("GetDeadArmyRecordMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GetDeadArmyRecordMessage:OnCreate(param)
    base.OnCreate(self)
end

function GetDeadArmyRecordMessage:HandleMessage(message)
    base.HandleMessage(self, message)
    DataCenter.DeadArmyRecordManager:GetDeadArmyRecordHandle(message)
end

return GetDeadArmyRecordMessage