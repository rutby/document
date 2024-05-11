


---BuffBeTaunt 被嘲讽buff：


local base = require("Scene.LWBattle.Buff.BuffBase")
---@class Scene.LWBattle.Buff.BuffBeTaunt : Scene.LWBattle.Buff.BuffBase
local BuffBeTaunt = BaseClass("BuffBeTaunt",base)


function BuffBeTaunt:__init(logic,mgr,unit,meta,id,param)
    self.logic = logic
    self.target = param
end


function BuffBeTaunt:__delete()
    self:Destroy()
end


function BuffBeTaunt:Destroy()
    base.Destroy(self)
    self.target=nil
end

--buff更新（override）
function BuffBeTaunt:OnUpdate()
    if (not self.target) or self.target:GetCurBlood()<=0 then
        self:End()
    end
end

--buff生效结算（override）
function BuffBeTaunt:OnStart()
    self.unit:SetTauntTarget(self.target)
end

--buff消失结算（override）
function BuffBeTaunt:OnEnd()
    self.unit:SetTauntTarget(nil)
end



return BuffBeTaunt