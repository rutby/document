local FSMachine = require("Common.FSMachine")
local Const = require("Scene.LWBattle.Const")
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
    if self.owner.logic.stageType == Const.CountBattleType.Defense and self.owner.logic.fsm.currStateName == "March" then
        self.owner:SetVelocity(0, -self.owner.cfg.moveSpeed - self.owner.logic.marchSpeed)
    else
        self.owner:SetVelocity(0, -self.owner.cfg.moveSpeed)
    end
    local rot = Quaternion.LookRotation(Vector3.New(0, 0, -1))
    for _, unitProxy in ipairs(self.owner.unitProxies) do
        if unitProxy and not IsNull(unitProxy.transform) then
            unitProxy.transform:DORotateQuaternion(rot, 0.2)
        end
    end
    self.owner:OnMarch()
end

-- function State:Dispose()
-- end

return State