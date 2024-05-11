local FSMachine = require("Common.FSMachine")
local State = {}
State.__index = State
setmetatable(State, FSMachine.State)

function State.Create()
    local copy = {}
    setmetatable(copy, State)
    copy:Init()
    return copy
end

-- function State:Init()
-- end

function State:OnUpdate(deltaTime)
    -- if not self.marching and self.owner.group.GroupPoint == self.owner.cfg.unitCount then
    --     self.marching = true
    --     self.owner:OnMarch()
    --     self.owner:SetVelocity(0, -self.owner.cfg.moveSpeed)
    -- end
end

-- function State:OnExit()
-- end

function State:OnEnter()
    -- self.marching = false
    self.owner:DoSpawn()
end

-- function State:Dispose()
-- end

return State