---
--- Created by shimin
--- DateTime: 2021/7/29 8:28
---
local BirthPointTemplate = BaseClass("BirthPointTemplate")

local function __init(self)
    self.id = 0 --
    self.x = 0
    self.y = 0
end

local function __delete(self)
    self.id = nil
    self.x = nil
    self.y = nil
end

local function InitData(self,row)
    if row ==nil then
        return
    end
    self.id = row:getValue("id")
    self.x = row:getValue("X")
    self.y = row:getValue("Y")
end

BirthPointTemplate.__init = __init
BirthPointTemplate.__delete = __delete
BirthPointTemplate.InitData = InitData

return BirthPointTemplate