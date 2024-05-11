--- Created by shimin.
--- DateTime: 2024/2/27 11:47
--- 引导小人死亡

local NewbieResidentDeadMessage = BaseClass("NewbieResidentDeadMessage", SFSBaseMessage)
local base = SFSBaseMessage

function NewbieResidentDeadMessage:OnCreate(param)
    base.OnCreate(self)
    if param.uuidArr ~= nil and param.uuidArr[1] ~= nil then
        local array = SFSArray.New()
        for _, v in pairs(param.uuidArr) do
            array:AddLong(v)
        end
        self.sfsObj:PutSFSArray("uuidArr", array)
    end
end

function NewbieResidentDeadMessage:HandleMessage(t)
    base.HandleMessage(self, t)
    DataCenter.VitaManager:NewbieResidentDeadHandle(t)
end

return NewbieResidentDeadMessage