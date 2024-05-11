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

-- function State:OnUpdate(deltaTime)
-- end

-- function State:OnExit()
-- end

function State:OnEnter()
end

-- function State:Dispose()
-- end

return State