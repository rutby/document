---
--- Created by shimin
--- DateTime: 2021/11/10 20:33
---
local UnlockBtnTemplate = BaseClass("UnlockBtnTemplate")

local function __init(self)
    self.id = 0
    self.unlock_noviceboot = {}
    self.unlock_building = {}
end

local function __delete(self)
    self.id = 0
    self.unlock_noviceboot = nil
    self.unlock_building = nil
end

local function InitData(self,row)
    if row ==nil then
        return
    end
    self.id = row:getValue("id")
    self.unlock_noviceboot = row:getValue("unlock_noviceboot")
    self.unlock_building = row:getValue("unlock_building")
end

UnlockBtnTemplate.__init = __init
UnlockBtnTemplate.__delete = __delete
UnlockBtnTemplate.InitData = InitData

return UnlockBtnTemplate