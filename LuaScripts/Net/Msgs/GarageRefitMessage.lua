---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2022/2/28 12:03
---

local GarageRefitMessage = BaseClass("GarageRefitMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
    base.OnCreate(self)
    self.sfsObj:PutLong("uuid", param.uuid)
    self.sfsObj:PutInt("count", param.count)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    
    if t["errorCode"] ~= nil then
        return
    end
    
    if t["resources"] ~= nil then
        LuaEntry.Resource:UpdateResource(t["resources"])
    end
    
    local userTank = t["userTank"]
    if userTank then
        DataCenter.GarageRefitManager:UpdateGarageRefit(userTank)
        local id = userTank["garage"]
        local level = userTank["level"]
        local power = 0
        if level > 1 then
            local temp = DataCenter.GarageRefitManager:GetModifyTemplate(id, level - 1)
            if temp ~= nil then
                power = temp:getValue("power")
            end
        end
        local temp = DataCenter.GarageRefitManager:GetModifyTemplate(id, level)
        if temp ~= nil then
            power = temp:getValue("power") - power
        end
        if power > 0 then
            GoToUtil.ShowPower({power = temp:getValue("power")})
        end
    end
    
    if t["freeTankTransform"] then
        DataCenter.GarageRefitManager:UpdateGarageRefitFree(t["freeTankTransform"])
    end
    
    EventManager:GetInstance():Broadcast(EventId.GarageRefitUpdate, t)
end

GarageRefitMessage.OnCreate = OnCreate
GarageRefitMessage.HandleMessage = HandleMessage

return GarageRefitMessage