local VfxPool = {}
VfxPool.__index = VfxPool

local Resource = CS.GameEntry.Resource

function VfxPool.Create(resPath, amount)
    local copy = {}
    setmetatable(copy, VfxPool)
    copy:Init(resPath, amount)
    return copy
end

function VfxPool:Init(resPath, amount)
    self.amount = amount
    self.handles = {}
    self.gameObjects = {}
    self.transforms = {}
    for i = 1, self.amount do
        local handle = Resource:InstantiateAsync(resPath)
        handle:completed('+', function(handle)
            if IsNull(handle.gameObject) then
                handle:Destroy()
                return
            end
            local gameObject = handle.gameObject
            gameObject:SetActive(false)
            -- 默认挂了AutoDisable组件
            local transform = handle.gameObject.transform
            table.insert(self.gameObjects, gameObject)
            table.insert(self.transforms, transform)
        end)
        table.insert(self.handles, handle)
    end
end

function VfxPool:Dispose()
    if self.handles then
        for _, handle in ipairs(self.handles) do
            if not IsNull(handle) then
                handle:Destroy()
            end
        end
    end
    self.handles = nil
    self.gameObjects = nil
    self.transforms = nil
end

function VfxPool:Play(pos, dir)
    if not self.gameObjects or not self.transforms then return end
    if #self.gameObjects <= 0 or #self.transforms <= 0 then return end

    local idx = 1
    for i, gameObject in ipairs(self.gameObjects) do
        if not gameObject.activeSelf then
            idx = i
            break
        end
    end

    local gameObject = self.gameObjects[idx]
    local transform = self.transforms[idx]

    gameObject:SetActive(false)
    gameObject:SetActive(true)
    transform:Set_position(pos:Split())
    transform:Set_forward(dir:Split())
end

return VfxPool