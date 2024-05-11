---
--- Created by shimin.
--- DateTime: 2022/3/9 22:16
---
local SetAllianceCareerPosMessage = BaseClass("SetAllianceCareerPosMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
    base.OnCreate(self)
    if param ~= nil then
        if param.arr ~= nil then
            local oneArr = SFSArray.New()
            for k,v in pairs(param.arr) do
                local obj = SFSObject.New()
                obj:PutUtfString("uid",k)
                obj:PutInt("pos", v)
                oneArr:AddSFSObject(obj)
            end
            self.sfsObj:PutSFSArray("appointArr", oneArr)
        end
    end
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
end

SetAllianceCareerPosMessage.OnCreate = OnCreate
SetAllianceCareerPosMessage.HandleMessage = HandleMessage

return SetAllianceCareerPosMessage