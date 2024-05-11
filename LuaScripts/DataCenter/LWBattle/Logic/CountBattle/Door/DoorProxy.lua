local DoorProxy = {}
DoorProxy.__index = DoorProxy

local Resource = CS.GameEntry.Resource
local PASS_VFX = "Assets/Main/Prefabs/LWCountBattle/Doors/VfxPassDoor.prefab"
local BLUE_CIRCLE_VFX = "Assets/Main/Prefabs/LWCountBattle/Doors/Eff_xinshou_guangquan_lan.prefab"

function DoorProxy.Create(pos, width, args, resPath, soilderId)
    local copy = {}
    setmetatable(copy, DoorProxy)
    copy:Init(pos, width, args, resPath, soilderId)
    return copy
end

local doorOpChar = { '+', '-', 'x', '÷' }

function DoorProxy:Init(pos, width, args, resPath, soilderId)
    self.pos = pos
    self.lastZ = pos.z
    self.width = width
    self.args = args
    self.soilderId = soilderId
    self.handles = {}
    self.circleHandles = {}
    self.simpleAnims = {}
    self.transforms = {}
    self.circleTransforms = {}
    if args[1] <= 4 then
        table.insert(self.handles, Resource:InstantiateAsync(resPath))
        self.handles[1]:completed('+', function(handle)
            self.gameObject = handle.gameObject
            self.transform = self.gameObject.transform
            self.transform:Set_position(pos.x, pos.y, pos.z)
            -- self.transform:Set_localScale(width, 1, 1)
            self.textMesh = self.gameObject:GetComponentInChildren(typeof(CS.SuperTextMesh))
            self.textMesh.text = doorOpChar[args[1]].." "..args[2]
            
            table.insert(self.transforms, self.transform)
        end)
    else
        for i = 1, self.args[2] do
            local handle = Resource:InstantiateAsync(self.args[3].prefab)
            handle:completed('+', function(handle)
                self.gameObject = handle.gameObject
                self.transform = self.gameObject.transform
                local lx = math.ceil((i - 1) * 0.5) * self.args[3].radius * 2 * (i % 2 == 0 and 1 or -1)
                self.transform:Set_position(pos.x + lx, pos.y, pos.z)
                self.transform:Set_eulerAngles(0, 180, 0)
                self.gameObject:GetComponentInChildren(typeof(CS.SimpleAnimation)):Play(self.args[3].idleAnim)

                table.insert(self.transforms, self.transform)

                local circleHandle = Resource:InstantiateAsync("Assets/Main/Prefabs/LWCountBattle/Huds/GroupCircleBlue.prefab")
                circleHandle:completed('+', function(handle)
                    local gameObject = handle.gameObject
                    local transform = handle.gameObject.transform
                    transform.position = self.transform.position + Vector3.up * 0.1
                    transform.localScale = Vector3.one * 3
                    transform:DOScale(Vector3.one * 3.5, 0.5):SetLoops(-1, CS.DG.Tweening.LoopType.Yoyo)
                    
                    table.insert(self.circleTransforms, transform)
                end)
                table.insert(self.circleHandles, circleHandle)

                local simpleAnim = handle.gameObject:GetComponentInChildren(typeof(CS.SimpleAnimation))
                if not IsNull(simpleAnim) then
                    if not string.IsNullOrEmpty(self.currAnim) then
                        simpleAnim:Play(self.currAnim)
                    end
                    table.insert(self.simpleAnims, simpleAnim)
                end
            end)
            table.insert(self.handles, handle)
        end
    end
    self.passed = false
end

function DoorProxy:TryPassDefense(x, z)
    if self.passed then
        return false
    end

    if z < self.pos.z or z > self.lastZ then
        return false
    end

    local lx = self.pos.x - self.width * 0.5
    local rx = self.pos.x + self.width * 0.5
    if x < lx or x >= rx then
        return false
    end

    self.passed = true
    return true
end

function DoorProxy:TryPass(x, z, lastZ)
    if self.passed then
        return false
    end
    if z < self.pos.z or lastZ > self.pos.z then
        return false
    end
    
    local lx = self.pos.x - self.width * 0.5
    local rx = self.pos.x + self.width * 0.5
    if x < lx or x >= rx then
        return false
    end

    self.passed = true
    return true
end

local _FUNC = {
    ['+'] = function(groupProxy, arg)
        if arg <= 0 then return end
        groupProxy:DoSpawn(arg)
    end,
    ['-'] = function(groupProxy, arg)
        if arg <= 0 then return end
        groupProxy:DoDespawn(arg)
    end,
    ['x'] = function(groupProxy, arg)
        if arg == 1 then return end
        local point = groupProxy:GetPoint()
        local num = math.floor(point * arg)
        groupProxy:DoSpawn(num - point)
    end,
    ['÷'] = function(groupProxy, arg)
        if arg == 1 then return end
        local point = groupProxy:GetPoint()
        local num = math.floor((point / arg) + 0.01)
        groupProxy:DoDespawn(point - num)
    end,
}

function DoorProxy:PlayAnim(anim, fade)
    self.currAnim = anim
    if self.simpleAnims then
        for _, simpleAnim in ipairs(self.simpleAnims) do
            if not IsNull(simpleAnim) then
                simpleAnim:CrossFade(anim, fade or 0)
            end
        end
    end
end

function DoorProxy:DoFunc(groupProxy)
    if self.args[1] <= 4 then
        local func = _FUNC[doorOpChar[self.args[1]]]
        func(groupProxy, tonumber(self.args[2]))

        local x = self.pos.x
        local z = self.pos.z
        local handle = Resource:InstantiateAsync(PASS_VFX)
        handle:completed('+', function()
            handle.gameObject.transform:Set_position(x, 0, z)
        end)
    else
        groupProxy:DoSpawn(self.args[2], self.args[3])
    end
end

function DoorProxy:UpdatePos(x, y, z)
    if self.transforms then
        for _, transform in ipairs(self.transforms) do
            transform:Set_position(x, y, z)
        end
    end

    if self.circleTransforms then
        for _, transform in ipairs(self.circleTransforms) do
            transform:Set_position(x, y + 0.1, z)
        end
        
    end
end

function DoorProxy:Dispose()
    if self.circleHandles then
        for _, handle in ipairs(self.circleHandles) do
            if not IsNull(handle) then
                handle:Destroy()
            end
        end
    end
    self.circleHandles = nil

    if self.handles then
        for _, handle in ipairs(self.handles) do
            if not IsNull(handle) then
                handle:Destroy()
            end
        end
    end
    self.handles = nil

    self.gameObject = nil
    self.transform = nil
    self.textMesh = nil
    self.args = nil
    self.width = nil
    self.pos = nil
    self.enabled = nil
    
    self.simpleAnims = nil
    self.transforms = nil
    self.circleTransforms = nil
end

return DoorProxy