---
--- Created by shimin
--- DateTime: 2021/7/29 8:28
---
local VipTemplate = BaseClass("VipTemplate")

local function __init(self)
    self.id = 0
    self.point = 0
    self.level = 0
    self.icon = ""
    self.reward1 = 0
    self.reward2 = ""
    self.display = ""
    self.effect = {}
end

local function __delete(self)
    self.id = nil
    self.point = nil
    self.level = nil
    self.icon = nil
    self.reward1 = nil
    self.reward2 = nil
    self.display = nil
    self.effect = nil
end

local function InitData(self,row,isOpen)
    if row ==nil then
        return
    end
    self.id = row:getValue("id")
    self.point = row:getValue("point")
    self.level = self.id
    self.icon = row:getValue("icon")
    --local reward1Str = row:getValue("reward1")
    --self.reward1 = string.split(reward1Str,"|")
    if isOpen then
        self.reward2 = row:getValue("reward2_new")
    else
        self.reward2 = row:getValue("reward2")
    end
    local displayStr = row:getValue("display")
    self.display = string.split(displayStr,"|")
    local effectStr = row:getValue("effect")
    local str =  string.split(effectStr,"|")
    local temp = {}
    for i, v in ipairs(str) do
        local param = string.split(v,";")
        temp[i] = {}
        temp[i].id = param[1]
        temp[i].value = tonumber(param[2])
        temp[i].descID = GetTableData(TableName.EffectNumDesc, param[1], "des")
        --self.effect[i].negative = GetTableData(TableName.Affect_Num, param[1], "negative")
        temp[i].num_type = GetTableData(TableName.EffectNumDesc, param[1], "type")
        temp[i].isNew = false
    end

    for i, v in ipairs(temp) do
        for k = 1, #self.display do
            if tonumber(self.display[k]) == tonumber(v.id) then
                temp[i].isNew = true
            end
        end
    end
    for k = 1, #self.display do
        for i, v in ipairs(temp) do
            if tonumber(self.display[k]) == tonumber(v.id) then
                table.insert(self.effect,v)
            end
        end
    end
    for i = #temp, 1,-1 do
        if temp[i].isNew == true then
            table.remove(temp,i)
        end
    end
    for i = 1, #temp do
        table.insert(self.effect,temp[i])
    end
end

VipTemplate.__init = __init
VipTemplate.__delete = __delete
VipTemplate.InitData = InitData

return VipTemplate