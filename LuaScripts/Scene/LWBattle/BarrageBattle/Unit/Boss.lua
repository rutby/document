---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by w.
--- DateTime: 2022/12/21 11:39
---

local base = require("Scene.LWBattle.BarrageBattle.Unit.Zombie")
---@class Scene.LWBattle.BarrageBattle.Unit.Boss
local Boss = BaseClass("Boss",base)


function Boss:Init(battleMgr, guid, meta)
    base.Init(self,battleMgr, guid, meta)
    self.isBoss=true
    EventManager:GetInstance():Broadcast(EventId.BossEnterBattle)
end

function Boss:DestroyData()
    self.isBoss=nil
    base.DestroyData(self)
end


return Boss