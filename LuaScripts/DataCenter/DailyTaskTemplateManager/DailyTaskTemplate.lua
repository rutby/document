---
--- Created by shimin
--- DateTime: 2022/2/23 15:12
---
local DailyTaskTemplate = BaseClass("DailyTaskTemplate")

local function __init(self)
    self.id = 0 --任务id
    self.name = ""--任务标题名字
    self.desc = ""--任务描述
    self.gotype2 = QuestGoType.None--跳转类型
    self.gopara = {}--跳转参数 ;划分
    self.para2 = 0--描述参数2
    self.order = 0--排序
    self.point = 0 --自动领奖
    self.icon = ""
    self.show = QuestShowType.No 
	self.list = 0
end

local function __delete(self)
    self.id = nil
    self.name = nil
    self.desc = nil
    self.gotype2 = nil
    self.gopara = nil
    self.para2 = nil
    self.order = nil
    self.point = nil
    self.icon = nil
    self.show = nil
	self.list = nil
end

local function InitData(self,row)
    if row ==nil then
        return
    end
    self.id = row:getValue("id")
    self.name = row:getValue("name","")
    self.desc = row:getValue("desc","")
    self.gotype2 = row:getValue("gotype2")
    self.gopara = row:getValue("gopara")
    self.para2 = row:getValue("para2")
    self.order = row:getValue("order")
    self.point = row:getValue("point")
    self.icon = row:getValue("icon")
    self.show = row:getValue("show")
	self.list = row:getValue("list")
end

DailyTaskTemplate.__init = __init
DailyTaskTemplate.__delete = __delete
DailyTaskTemplate.InitData = InitData

return DailyTaskTemplate