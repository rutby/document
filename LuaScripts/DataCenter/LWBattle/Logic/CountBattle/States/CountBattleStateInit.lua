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
    self:InitCamera()
    self:InitInput()
end

function State:InitCamera()
    -- camera params
    local height = 20
    local fov = 60
    local rotation = 45

    local camera = self.owner.battleMgr.camera
    camera.fieldOfView = fov
    camera.transform:Set_eulerAngles(rotation, 0, 0)
    self.owner.camera = camera

    --local hudCamera = self.owner.battleMgr.hudCamera
    --hudCamera.fieldOfView = fov

    local touchCamera = self.owner.battleMgr.touchCamera
    touchCamera.CanMoveing = false
    touchCamera.CamZoom = height
    touchCamera.LodLevel = 1
    local offsetZ = height / math.tan(rotation * math.pi / 180)
    touchCamera:SetZoomParams(1, height, offsetZ, 25)
    touchCamera.CamZoomMin=20
end

function State:InitInput()
    local touchInput = self.owner.battleMgr.touchCamera.touchInput
    self.onFingerDown = function(pos) self.owner:OnFingerDown(pos) end
    self.onFingerUp = function() self.owner:OnFingerUp() end

    touchInput:OnFingerDown('+', self.onFingerDown)
    touchInput:OnFingerUp('+', self.onFingerUp)
end

function State:Dispose()
    local touchCamera = self.owner.battleMgr.touchCamera
    if touchCamera then
        touchCamera.CanMoveing = true
        
        local touchInput = touchCamera.touchInput
        if touchInput then
            if self.onFingerDown then
                touchInput:OnFingerDown('-', self.onFingerDown)
            end
            if self.onFingerUp then
                touchInput:OnFingerUp('-', self.onFingerUp)
            end
        end
    end
end

return State