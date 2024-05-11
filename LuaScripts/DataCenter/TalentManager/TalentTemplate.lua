---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2022/6/24 15:29
---

local TalentTemplate = BaseClass("TalentTemplate")
local Localization = CS.GameEntry.Localization

local function __init(self)
    self.id = ""
    self.name = ""
end

local function __delete(self)
    self.id = nil
end

local function InitData(self, row)
    if row == nil then
        return
    end
    self.id = row:getValue("id")
    self.type = row:getValue("type")
    self.group = row:getValue("group")
    self.order = row:getValue("order")
    self.lv = row:getValue("lv")
    self.icon = string.format(LoadPath.ScienceIcons, row:getValue("icon"))
    self.nameStr = row:getValue("name")
    self.name_value = row:getValue("name_value")
    self.descriptionStr = row:getValue("description")
    self.description_value = row:getValue("description_value")
    self.show_type = row:getValue("show_type")
    self.resourceStr = row:getValue("resource")
    self.resourceNeed = {}
    local specialRateStr = row:getValue("special_rate")
    if string.IsNullOrEmpty(specialRateStr) then
        self.special_rate = -1
    else
        self.special_rate = toInt(specialRateStr)
    end
    if not string.IsNullOrEmpty(self.resourceStr) then
        local resourceVec = string.split(self.resourceStr, "|")
        table.walk(resourceVec, function (_, v)
            local tmpVec = string.split(v, ";")
            if table.count(tmpVec) == 2 then
                self.resourceNeed[toInt(tmpVec[1])] = tonumber(tmpVec[2])
            end
        end)
    end

    if string.IsNullOrEmpty(self.name_value) then
        self.name = Localization:GetString(self.nameStr)
    else
        local nameValueVec = string.split(self.name_value, "|")
        local count = table.count(nameValueVec)
        if count == 1 then
            self.name = Localization:GetString(self.nameStr, nameValueVec[1])
        elseif count == 2 then
            self.name = Localization:GetString(self.nameStr, nameValueVec[1], nameValueVec[2])
        elseif count == 3 then
            self.name = Localization:GetString(self.nameStr, nameValueVec[1], nameValueVec[2], nameValueVec[3])
        elseif count == 4 then
            self.name = Localization:GetString(self.nameStr, nameValueVec[1], nameValueVec[2], nameValueVec[3], nameValueVec[4])
        end
    end
    
    
    local descriptionValueVec = {}
    local showTypeVec = {}
    if not string.IsNullOrEmpty(self.description_value) then
        descriptionValueVec = string.split(self.description_value, "|")
    end
    if not string.IsNullOrEmpty(self.show_type) then
        showTypeVec = string.split(self.show_type, "|")
    end
    self.description = ""

    local GetDes = function(desValue, desType)
        if desType == nil or desType == 0 then
            return tostring(desValue)
        end
        if desType == 1 then
            return tostring(desValue).."%"
        end
        if desType == 2 then
            return "+"..tostring(desValue)
        end
        if desType == 3 then
            return "-"..tostring(desValue)
        end
        if desType == 4 then
            return "+"..tostring(desValue).."%"
        end
        if desType == 5 then
            return "-"..tostring(desValue).."%"
        end
    end
    
    local index = 1
    local total = table.count(descriptionValueVec)
    local tmpVec = {}
    while index <= total do
        local desValue = descriptionValueVec[index]
        local showType = showTypeVec[index]
        local para = GetDes(desValue, toInt(showType))
        table.insert(tmpVec, para)
        index = index + 1
    end
    local count = table.count(tmpVec)
    if count == 0 then
        self.description = Localization:GetString(self.descriptionStr)
    elseif count == 1 then
        self.description = Localization:GetString(self.descriptionStr, tmpVec[1])
    elseif count == 2 then
        self.description = Localization:GetString(self.descriptionStr, tmpVec[1], tmpVec[2])
    elseif count == 3 then
        self.description = Localization:GetString(self.descriptionStr, tmpVec[1], tmpVec[2], tmpVec[3])
    elseif count == 4 then
        self.description = Localization:GetString(self.descriptionStr, tmpVec[1], tmpVec[2], tmpVec[3], tmpVec[4])
    end

    self.color = row:getValue("color")
end

TalentTemplate.__init = __init
TalentTemplate.__delete = __delete
TalentTemplate.InitData = InitData

return TalentTemplate