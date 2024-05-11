---
--- Created by shimin.
--- DateTime: 2020/8/18 20:45
---
local HospitalCureMessage = BaseClass("HospitalCureMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
    base.OnCreate(self)
    
    if param ~= nil then
        if param.arr ~= nil then
            local oneArr = SFSArray.New()
            for k,v in pairs(param.arr) do
                local one = SFSObject.New()
                one:PutUtfString("armyId", k)
                one:PutInt("healNum", v)
                oneArr:AddSFSObject(one)
            end
            self.sfsObj:PutSFSArray("armyArray", oneArr)
        end
        self.sfsObj:PutInt("gold", param.gold)
        if param.hospitalType~=nil then
            self.sfsObj:PutInt("hospitalType", param.hospitalType)
        end
    end
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    DataCenter.HospitalManager:HospitalCureHandle(t)
end

HospitalCureMessage.OnCreate = OnCreate
HospitalCureMessage.HandleMessage = HandleMessage

return HospitalCureMessage