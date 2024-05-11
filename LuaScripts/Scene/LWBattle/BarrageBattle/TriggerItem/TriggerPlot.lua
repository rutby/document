local Resource = CS.GameEntry.Resource

---@class Scene.LWBattle.BarrageBattle.TriggerItem.TriggerPlot
local TriggerPlot = BaseClass("TriggerPlot")
function TriggerPlot:__init(battleManager, triggerPlotCfg, pos)
    self.triggerPlotCfg = triggerPlotCfg
    self.battleManager = battleManager
    self.pos = pos
    self.timers = {}
end

function TriggerPlot:Trigger()
    local heros = self.battleManager.squad.members
    local heroKeys = {}
    for key, _ in pairs(heros) do
        table.insert(heroKeys, key)
    end
    local times = math.min(self.triggerPlotCfg.playTimes, table.count(heros))
    for i = 1, times do
        local timer = TimerManager:GetInstance():DelayInvoke(function()
            local index = math.random(1, #heroKeys)
            local hero = heros[heroKeys[index]]
            table.remove(heroKeys, index)
            if hero and not IsNull(hero.transform) then
                local evtParams = {}
                evtParams.plotGroupId = self.triggerPlotCfg.plotGroupId
                evtParams.anchor = Vector3(0, 2, 0)
                evtParams.mode = "2DFollowWorld"
                evtParams.followTarget = hero.transform
                EventManager:GetInstance():Broadcast(EventId.PlayPlotBubbleRandomly, evtParams)
            end
        end, (i-1) * self.triggerPlotCfg.playInterval)
        table.insert(self.timers, timer)
    end

    -- self.battleManager:ShowEffectObj(self.meta.dead_effect, self.pos,nil,1,nil)

    -- self:Destroy()
end

function TriggerPlot:Destroy()
    if self.timers then
        for _, timer in ipairs(self.timers) do
            if timer then
                timer:Stop()
            end
        end
        self.timers = nil
    end
end
return TriggerPlot