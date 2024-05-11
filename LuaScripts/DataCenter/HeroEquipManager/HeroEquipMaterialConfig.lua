---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by admin.
--- DateTime: 2024/3/27 9:11
---

local HeroEquipMaterialConfig = BaseClass("HeroEquipMaterialConfig")

function HeroEquipMaterialConfig:__init()
    self.id = 0
    self.category = 0
    self.quality = 0
    self.combineNum = 0
    self.breakNum = 0
end

function HeroEquipMaterialConfig:__delete()
    self.id = 0
    self.category = 0
    self.quality = 0
    self.combineNum = 0
    self.breakNum = 0
end

function HeroEquipMaterialConfig:InitData(row)
    self.id = toInt(row:getValue("id"))
    self.unlock_level = toInt(row:getValue("category"))
    self.quality = toInt(row:getValue("quality"))
    self.combineNum = toInt(row:getValue("combine"))
    self.breakNum = toInt(row:getValue("break"))
end

return HeroEquipMaterialConfig