local MotionPart = {}
MotionPart.__index = MotionPart

---@param rootTrans boolean 是否为根结点
function MotionPart.Create(trap, partTrans, rootTrans)
    local copy = {}
    setmetatable(copy, MotionPart)
    copy:Init(trap, partTrans, rootTrans)
    return copy
end

function MotionPart:Init(trap, partTrans, rootTrans)
    self.trap = trap
    self.trans = partTrans
    self.rootTrans = rootTrans
    self.transValid = not IsNull(self.trans)
    self.go = partTrans.gameObject
    self.motions = {}
    self.lpos =Vector3(partTrans:Get_localPosition())
    self.lrot =Quaternion(partTrans:Get_localRotation())
    self.ldir =Vector3(partTrans:Get_forward()) -- read only
    self.actived = true
end

function MotionPart:Dispose()
    for _, motion in ipairs(self.motions) do
        motion:Dispose()
    end
    self.motions = nil
    self.trap = nil
    self.cfg = nil
    self.trans = nil
    self.transValid = nil
    self.go = nil
end

function MotionPart:AddMotion(motionCfg)
    local motion = motionCfg.class.Create(self, motionCfg)
    table.insert(self.motions, motion)
end

function MotionPart:OnUpdate(dt)
    for _, motion in ipairs(self.motions) do
        motion:OnUpdate(dt)
    end
end

function MotionPart:IsDirty()
    return self.posDirty or self.rotDirty
end

function MotionPart:SyncView()
    if not self.transValid then return end
    if self.posDirty then
        self.trans:Set_localPosition(self.lpos.x, self.lpos.y, self.lpos.z)
        self.posDirty = false
    end
    if self.rotDirty then
        self.trans:Set_localRotation(self.lrot:Split())
        self.ldir = Vector3(self.trans:Get_forward())
        self.rotDirty = false
    end
end

return MotionPart