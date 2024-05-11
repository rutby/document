local FSMachine = require("Common.FSMachine")
local State = {}
State.__index = State
setmetatable(State, FSMachine.State)

local Consts = require("DataCenter.LWBattle.Logic.CountBattle.CountBattleConsts")

function State.Create()
    local copy = {}
    setmetatable(copy, State)
    copy:Init()
    return copy
end

-- function State:Init()
-- end

-- function State:Dispose()
-- end

-- function State:OnUpdate(deltaTime)
-- end

function State:OnExit()
    if self.timer then
        self.timer:Stop()
    end
    self.timer = nil
end

function State:OnEnter(callBack)
    local owner = self.owner
    owner.camera.transform:Set_eulerAngles(Consts.CAMERA_X_ANGLE, 0, 0)

    local camPos = owner.cfg.initPos + Consts.FOLLOW_VIEW_OFFSET
    owner.camera.transform:Set_position(camPos:Split())

    local staticMgr = owner.staticMgr
    local viewTile = SceneUtils.WorldToTile(camPos + Consts.SCENE_VIEW_OFFSET + Vector3.New(0, 0, -30))
    self.timer = TimerManager:GetInstance():GetTimer(3, function()
        staticMgr:OnUpdate(viewTile.x, viewTile.y)
    end, self, false, true)
    self.timer:Start()

    if callBack then
        callBack()
    end
end

return State