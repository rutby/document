---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by w.
--- DateTime: 2023/3/13 16:16
---
local Resource = CS.GameEntry.Resource

---@class Scene.LWBattle.BarrageBattle.TriggerItem.BarrageTriggerItem
local BarrageTriggerItem = BaseClass("BarrageTriggerItem")
function BarrageTriggerItem:__init(battleManager,triggerMetaId,pos)
    self.triggerMetaId = triggerMetaId
    self.meta = DataCenter.LWTriggerItemTemplateManager:GetTemplate(triggerMetaId)
    self.battleManager = battleManager
    self.pos = pos
end

function BarrageTriggerItem:Load()
    local req = Resource:InstantiateAsync(self.meta.effect)
    req:completed('+', function()
        local trans = req.gameObject.transform
        trans:Set_position(self.pos.x, self.pos.y, self.pos.z)
    end)
    self.loadReq = req
end
function BarrageTriggerItem:Trigger()
    local heros = self.battleManager.squad.members
    for _, hero in pairs(heros) do
        hero.buffManager:AddBuff(self.meta.para)
    end

    self.battleManager:ShowEffectObj(self.meta.dead_effect, self.pos,nil,1,nil)
    local sound = self.meta.contact_sound:GetRandom()
    if sound then
        CS.GameEntry.Sound:PlayEffect(sound)
    end
    self:Destroy()
end
function BarrageTriggerItem:Destroy()
    if self.loadReq then
        self.loadReq:Destroy()
        self.loadReq = nil
    end
end
return BarrageTriggerItem