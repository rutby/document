---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2023/11/7 16:15
---

local ResidentMailChooseMessage = BaseClass("ResidentMailChooseMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, uuid, index)
    base.OnCreate(self)

    self.sfsObj:PutLong("uuid", uuid)
    self.sfsObj:PutLong("choose", index)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    if t["errorCode"] == nil then
        DataCenter.OpinionManager:HandleChooseMail(t)
    end
end

ResidentMailChooseMessage.OnCreate = OnCreate
ResidentMailChooseMessage.HandleMessage = HandleMessage

return ResidentMailChooseMessage