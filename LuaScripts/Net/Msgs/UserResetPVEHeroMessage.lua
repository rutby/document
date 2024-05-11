---
--- 英雄经验关卡，设置上阵英雄
---

local UserResetPVEHeroMessage = BaseClass("UserResetPVEHeroMessage", SFSBaseMessage)
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
        self.sfsObj:PutSFSArray("heroes", heroesArray)
    end
end

local function HandleMessage(self, message)
    base.HandleMessage(self, message)

    if message["finishTrigger"] then
        ---
        --- TODO
        ---
    end

    if message["rewardInfos"] then
        ---
        --- TODO
        ---
    end

    local resource = message["resource"]
    if resource then
        LuaEntry.Resource:UpdateResource(resource)
    end
    
    DataCenter.BattleLevel:Start()
end

UserResetPVEHeroMessage.OnCreate = OnCreate
UserResetPVEHeroMessage.HandleMessage = HandleMessage

return UserResetPVEHeroMessage