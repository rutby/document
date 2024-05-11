---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2023/11/7 11:30
---

local UserSynResidentMessage = BaseClass("UserSynResidentMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, changedResidentDataList)
    base.OnCreate(self)
    if not table.IsNullOrEmpty(changedResidentDataList) then
        local array = SFSArray.New()
        for _, residentData in ipairs(changedResidentDataList) do
            local obj = SFSObject.New()
            obj:PutLong("uuid", residentData.uuid)
            if residentData.deltaStamina ~= 0 then
                obj:PutFloat("STA", residentData.deltaStamina)
            end
            if residentData.deltaMood ~= 0 then
                obj:PutFloat("mood", residentData.deltaMood)
            end
            array:AddSFSObject(obj)
        end
        self.sfsObj:PutSFSArray("delta", array)
    end
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    if t["errorCode"] == nil then
        DataCenter.VitaManager:HandleSync(t)
    end
end

UserSynResidentMessage.OnCreate = OnCreate
UserSynResidentMessage.HandleMessage = HandleMessage

return UserSynResidentMessage