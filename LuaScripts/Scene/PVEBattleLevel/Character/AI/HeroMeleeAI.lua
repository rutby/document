---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1022.
--- DateTime: 2023/6/13 16:50
---英雄近战AI
local base = require("Scene.PVEBattleLevel.Character.AI.HeroRumbleAI")
local HeroMeleeAI = BaseClass("HeroMeleeAI",base)

function HeroMeleeAI:CheckFollowFindEnemy(isPlayerMoving)
    return (not isPlayerMoving and not self.m_isMoving) or self.isFirstMove or (self.m_isMoving and self.m_target:IsAttacking())
end

return HeroMeleeAI