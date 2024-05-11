---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2024/4/2 14:04
---
local UserFinishZombieMessage = BaseClass("UserFinishZombieMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, zombieId, heroes, pass)
    base.OnCreate(self)
    self.sfsObj:PutInt("zombieId", zombieId)
    
    if heroes then
        local heroArray = SFSArray.New()
        for _, v in pairs(heroes) do
            local obj = SFSObject.New()
            obj:PutInt("index", v.index)
            obj:PutLong("uuid", v.uuid)
            heroArray:AddSFSObject(obj)
        end
        self.sfsObj:PutSFSArray("heroes", heroArray)
    end
    
    self.sfsObj:PutInt("pass", pass)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    if t["errorCode"] ~= nil then
        return
    end
    
    DataCenter.CitySiegeManager:HandleFinishZombie(t)
end

UserFinishZombieMessage.OnCreate = OnCreate
UserFinishZombieMessage.HandleMessage = HandleMessage

return UserFinishZombieMessage