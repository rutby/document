


---ZombieCommonAI 丧尸通用AI
---@class Scene.LWBattle.AI.ZombieCommonAI
local ZombieCommonAI = BaseClass("ZombieCommonAI")
local Const = require("Scene.LWBattle.Const")

function ZombieCommonAI:__init(unit)
    self.unit=unit
    self.targetCache = nil
end

function ZombieCommonAI:__delete()
    self.unit=nil
    self.targetCache = nil
end

--获取目标：如果被嘲讽且普攻，则目标是嘲讽目标；否则正常索敌
function ZombieCommonAI:GetTarget(skill)
    local needRefresh
    if self.unit.monsterMeta.monster_type == Const.MonsterType.Boss then
        needRefresh = true
    else
        if self.targetCache == nil then
            needRefresh = true
        else
            if self.targetCache.GetCurBlood then
                -- unit
                if self.targetCache:GetCurBlood() <= 0 then
                    needRefresh = true
                end
            else
                -- table
                if table.IsNullOrEmpty(self.targetCache) then
                    needRefresh = true
                else
                    for _, unit in ipairs(self.targetCache) do
                        if unit:GetCurBlood() <= 0 then
                            needRefresh = true
                            break
                        end
                    end
                end
            end
        end
    end
    
    if needRefresh then
        if skill:IsNormalAttack() then
            local tauntTarget = self.unit:GetTauntTarget()
            if tauntTarget then
                self.targetCache = tauntTarget
            end
        end
        self.targetCache = skill:SearchTargetIgnoreRange()
    end
    return self.targetCache
end

return ZombieCommonAI