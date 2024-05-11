---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2023/11/3 11:24
---

local ResidentSetFurnaceMessage = BaseClass("ResidentSetFurnaceMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, furnaceState)
    base.OnCreate(self)
    
    self.sfsObj:PutInt("status", furnaceState)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    
    if t["errorCode"] == nil then
        DataCenter.VitaManager:HandleSetFurnaceState(t)
    end
end

ResidentSetFurnaceMessage.OnCreate = OnCreate
ResidentSetFurnaceMessage.HandleMessage = HandleMessage

return ResidentSetFurnaceMessage