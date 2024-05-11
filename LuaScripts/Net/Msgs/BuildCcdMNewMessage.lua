---
--- Created by shimin.
--- DateTime: 2020/7/6 21:39
---
local BuildCcdMNewMessage = BaseClass("BuildCcdMNewMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param, golloesSpeedTime)
    base.OnCreate(self)
    if param ~= nil then
        self.sfsObj:PutLong("bUUID", param.bUUID)
        if param.isFixRuins~=nil then
            self.sfsObj:PutBool("isFixRuins", param.isFixRuins)
        else
            self.sfsObj:PutBool("isFixRuins", false)
        end
        self.sfsObj:PutUtfString("itemIDs", param.itemIDs)
        if golloesSpeedTime then
            local intTime = math.modf(golloesSpeedTime)
            self.sfsObj:PutInt("golloesSpeedTime", intTime)
        end
        if param.useGold then
            self.sfsObj:PutBool("useGold", param.useGold)
        end
    end
end

local function HandleMessage(self, message)
    base.HandleMessage(self, message)
    DataCenter.BuildManager:BuildCcdMNewHandle(message)
end

BuildCcdMNewMessage.OnCreate = OnCreate
BuildCcdMNewMessage.HandleMessage = HandleMessage

return BuildCcdMNewMessage