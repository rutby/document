---
--- Created by shimin.
--- DateTime: 2020/10/22 18:57
---
local PinPwdCheckFrequencyMessage = BaseClass("PinPwdCheckFrequencyMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
    base.OnCreate(self)
    if param ~= nil then
        DataCenter.PinManager:SetParam(param)
        self.sfsObj:PutInt("type", param.state)
    end
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    DataCenter.PinManager:PinPwdCheckFrequencyHandle(t)
end

PinPwdCheckFrequencyMessage.OnCreate = OnCreate
PinPwdCheckFrequencyMessage.HandleMessage = HandleMessage

return PinPwdCheckFrequencyMessage