---
--- 开始PVE关卡，进入PVE关卡时发送
---

local UserStartPVELevelMessage = BaseClass("UserStartPVELevelMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, level, heroes)
    base.OnCreate(self)
    
    self.sfsObj:PutInt("level", level)

    if heroes then
        local heroesArray = SFSArray.New()
        for index, uuid in pairs(heroes) do
            local obj = SFSObject.New()
            obj:PutInt("index", index)
            obj:PutLong("uuid", uuid)
            heroesArray:AddSFSObject(obj)
        end
        self.sfsObj:Put("heroes", heroesArray)
    end
end

local function HandleMessage(self, message)
    base.HandleMessage(self, message)
    DataCenter.BattleLevel:OnStartLevelMessage(message)
end

UserStartPVELevelMessage.OnCreate = OnCreate
UserStartPVELevelMessage.HandleMessage = HandleMessage

return UserStartPVELevelMessage