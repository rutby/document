---
--- Created by shimin
--- DateTime: 2021/7/22 21:37
---
local ResourceTemplate = BaseClass("ResourceTemplate")

local function __init(self)
    self.id = 0 --id（资源类型）
    self.name = ""--名字
    self.description = "" --描述
    self.icon = ""--资源图标
    self.out_building = {}--可以产出资源的建筑（民居会有两种方式产出资源，但是只配置一遍）
end

local function __delete(self)
    self.id = nil
    self.name = nil
    self.description = nil
    self.icon = nil
    self.out_building = nil
end

local function InitData(self,row)
    if row ==nil then
        return
    end
    self.id = row:getValue("id")
    self.name = row:getValue("name")
    self.description = row:getValue("description")
    self.icon = row:getValue("icon")
    self.out_building = row:getValue("out_building")
end

ResourceTemplate.__init = __init
ResourceTemplate.__delete = __delete
ResourceTemplate.InitData = InitData

return ResourceTemplate