---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2024/1/9 16:23
---

local FinishLandPveMessage = BaseClass("FinishLandPveMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, order, index, heroes, formations, pass)
    base.OnCreate(self)
    self.sfsObj:PutInt("block", order)
    self.sfsObj:PutInt("index", index)

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

    if formations then
        local formationArray = SFSArray.New()
        for armyId, count in pairs(formations) do
            local obj = SFSObject.New()
            obj:PutUtfString("armyId", armyId)
            obj:PutInt("count", count)
            formationArray:AddSFSObject(obj)
        end
        self.sfsObj:PutSFSArray("formations", formationArray)
    end

    if pass then
        self.sfsObj:PutInt("pass", pass)
    end
end

local function HandleMessage(self, message)
    base.HandleMessage(self, message)
    if message["errorCode"] then
        return
    end
    
    DataCenter.LandManager:HandleFinishPve(message)
end

FinishLandPveMessage.OnCreate = OnCreate
FinishLandPveMessage.HandleMessage = HandleMessage

return FinishLandPveMessage