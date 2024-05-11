


---BuffProperty 作用号buff：能够改变作用号值的buff
---

local base = require("Scene.LWBattle.Buff.BuffBase")
---@class Scene.LWBattle.Buff.BuffProperty : Scene.LWBattle.Buff.BuffBase
local BuffProperty = BaseClass("BuffProperty",base)


function BuffProperty:__init(logic,mgr,unit,meta,id,property)
    self.logic=logic
    local battleType = logic:GetPVEType()
    if battleType==PVEType.Skirmish or battleType==PVEType.FakePVP then
        self.property = {}--战斗回放的作用号由后端提供，前端无需计算
    else
        self.property = property
    end
end


function BuffProperty:__delete()
    self:Destroy()
end


function BuffProperty:Destroy()
    base.Destroy(self)
end


--buff生效结算（override）
function BuffProperty:OnStart()
    for k,_ in pairs(self.property) do
        self.mgr:RegisterPropertyBuff(k,self)
    end
end

--buff消失结算（override）
function BuffProperty:OnEnd()
    for k,_ in pairs(self.property) do
        self.mgr:UnregisterPropertyBuff(k,self)
    end
end

function BuffProperty:GetPropertyValue(propertyType)
    return self.property[propertyType] or 0
end


return BuffProperty