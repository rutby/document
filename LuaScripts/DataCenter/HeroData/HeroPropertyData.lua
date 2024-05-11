---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by admin.
--- DateTime: 2022/12/12 15:19
---

---@class HeroPropertyData
local HeroPropertyData = BaseClass("HeroPropertyData")

local function __init(self,propertyData)
    if propertyData == nil then
        self.propertyData = {}
    else
        self.propertyData = propertyData
    end
end

local function __delete(self)
    self.propertyData = nil
end

local function GetProperty(self,propertyType)
    if self.propertyData == nil or not self.propertyData[propertyType] then
        return 0
    end
    return self.propertyData[propertyType]
end

local function GetAllProperty(self)
    return DeepCopy(self.propertyData)
end

local function SetProperty(self,propertyType,value)
    if self.propertyData[propertyType] ~= value then
        self.isDirty = true
    end
    self.propertyData[propertyType] = value
end

local function Clear(self)
    self.propertyData = { }
    self.isDirty = false
end

local function ClearDirtyState(self)
    self.isDirty = false
end

local function WalkAllProperties(self,func)
    if self.propertyData == nil then
        return
    end
    for k,v in pairs(self.propertyData) do
        func(k,v)
    end
end


HeroPropertyData.__init = __init
HeroPropertyData.__delete = __delete
HeroPropertyData.GetProperty = GetProperty
HeroPropertyData.GetAllProperty = GetAllProperty
HeroPropertyData.SetProperty = SetProperty
HeroPropertyData.Clear = Clear
HeroPropertyData.ClearDirtyState = ClearDirtyState
HeroPropertyData.WalkAllProperties = WalkAllProperties

return HeroPropertyData