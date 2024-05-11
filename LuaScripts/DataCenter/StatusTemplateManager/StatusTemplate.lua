---
--- Created by shimin
--- DateTime: 2023/4/10 21:31
--- buff状态表
---
local StatusTemplate = BaseClass("StatusTemplate")
local Localization = CS.GameEntry.Localization
function StatusTemplate:__init()
    self.id = 0--状态id
    self.type = 0--状态类型
    self.type2 = 0
    self.time = 0
    self.effect = ""
    self.effect_num = ""
    self.group = 0
    self.priority = ""
    self.name = ""
    self.description = ""
    self.overlap = ""
    self.subgroup = ""
    self.desc_para = ""
    self.icon = ""
    self.buff_is_green = ""
    self.buff_is_add = ""
    self.trigger_type = ""
    self.trigger_param = ""
    self.icon_show = ""--使用玩技能后弹出结果的图标
end

function StatusTemplate:__delete()
    self.id = 0--状态id
    self.type = 0--状态类型
    self.type2 = 0
    self.time = 0
    self.effect = ""
    self.effect_num = ""
    self.group = 0
    self.priority = ""
    self.name = ""
    self.description = ""
    self.overlap = ""
    self.subgroup = ""
    self.desc_para = ""
    self.icon = ""
    self.buff_is_green = ""
    self.buff_is_add = ""
    self.trigger_type = ""
    self.trigger_param = ""
    self.icon_show = ""--使用玩技能后弹出结果的图标
end

function StatusTemplate:InitData(row)
    if row == nil then
        return
    end
    self.id = row:getValue("id") or 0
    self.type = row:getValue("type") or 0
    self.type2 = row:getValue("type2") or 0
    self.time = row:getValue("time") or 0
    self.effect = row:getValue("effect") or ""
    self.effect_num = row:getValue("effect_num") or ""
    self.group = row:getValue("group") or 0
    self.priority = row:getValue("priority") or ""
    self.name = row:getValue("name") or ""
    self.description = row:getValue("description") or ""
    self.overlap = row:getValue("overlap") or ""
    self.subgroup = row:getValue("subgroup") or ""
    self.desc_para = row:getValue("desc_para") or ""
    self.icon = row:getValue("icon") or ""
    self.buff_is_green = row:getValue("buff_is_green") or ""
    self.buff_is_add = row:getValue("buff_is_add") or ""
    self.trigger_type = row:getValue("trigger_type") or ""
    self.trigger_param = row:getValue("trigger_param") or ""
    self.icon_show = row:getValue("icon_show") or ""
    self.descList = {}
    local descListStr = tostring(self.description)
    local descStrs = string.split(descListStr, "|")
    for _, str in ipairs(descStrs) do
        table.insert(self.descList, str)
    end
    self.descValuesList = {}
    local descValuesListStr = tostring(self.desc_para)
    local descValuesStr = string.split(descValuesListStr, "|")
    for _, str in ipairs(descValuesStr) do
        local values = {}
        for _, spl in ipairs(string.split(tostring(str), ";")) do
            table.insert(values, spl)
        end
        table.insert(self.descValuesList, values)
    end
end

function StatusTemplate:GetUIMainIcon()
    return string.format(LoadPath.UIMainNew, self.icon)
end

function StatusTemplate:GetShowIcon()
    return string.format(LoadPath.UIMainNew, self.icon_show)
end

function StatusTemplate:GetDesc()
    local lines = {}
    for i, desc in ipairs(self.descList) do
        local line = ""
        local values = self.descValuesList[i] or {}
        local strs = {}
        for _, value in ipairs(values) do
            table.insert(strs, value)
        end
        if #strs > 0 then

            if string.contains(Localization:GetString(desc), "{") then
                line = Localization:GetString(desc, table.unpack(strs))
            else
                line = Localization:GetString(desc) ..table.unpack(strs)
            end
        else
            line = Localization:GetString(desc)
        end
        table.insert(lines, line)
    end
    if #lines > 0 then
        return string.join(lines, "\n")
    else
        return ""
    end
end

return StatusTemplate