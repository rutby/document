---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2022/11/8 16:18
---
local AllianceCityTemplate = BaseClass("AllianceCityTemplate")

local function __init(self)
    self.id = 0
    self.city_id = 0
    self.em_desertId = 0
end

local function __delete(self)
    self.id = nil
    self.city_id = nil
    self.em_desertId = nil
end

local function InitData(self, row)
    if row == nil then
        return
    end
    self.id = row:getValue("id")
    self.city_id = row:getValue("city_id")
    self.em_desertId = row:getValue("em_desertid")
end

AllianceCityTemplate.__init = __init
AllianceCityTemplate.__delete = __delete
AllianceCityTemplate.InitData = InitData

return AllianceCityTemplate