local Infection = {}
Infection.__index = Infection

function Infection.Create(trap, amount, newTrapId)
    local copy = {}
    setmetatable(copy, Infection)
    copy:Init(trap, amount, newTrapId)
    return copy
end

function Infection:Init(trap, amount, newTrapId)
    self.trap = trap
    self.amount = amount
    self.newTrapId = newTrapId
end

function Infection:Dispose()
    self.trap = nil
end

function Infection:OnCollide()
end

return Infection