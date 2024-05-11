---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2022/6/27 11:20
---

local TalentTypeTemplate = BaseClass("TalentTypeTemplate")

local function __init(self)
    self.id = 0
    self.type = ""
    self.order = 0
    self.name = ""
end

local function __delete(self)
    self.id = nil
    self.type = nil
    self.order = nil
    self.name = nil
end

local function InitData(self, row)
    if row == nil then
        return
    end
    self.id = row:getValue("id")
    self.type = row:getValue("type")
    self.order = row:getValue("order")
    self.name = row:getValue("name")
end

TalentTypeTemplate.__init = __init
TalentTypeTemplate.__delete = __delete
TalentTypeTemplate.InitData = InitData

return TalentTypeTemplate