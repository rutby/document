---
--- Pve Trigger
---
---@class DataCenter.LWTriggerItem.LWTriggerItemTemplate
---@field type number
---@field para string
---@field paraArray number[]
local LWTriggerItemTemplate = BaseClass("LWTriggerItemTemplate")
local TriggerEnum = require("Scene.LWBattle.ParkourBattle.TriggerEvent.TriggerEnum")

local function __init(self)
    
end

local function __delete(self)
    if self.contact_sound then
        self.contact_sound:Delete()
        self.contact_sound = nil
    end
end

local function InitData(self, row)
    if row == nil then
        return
    end

    self.id = tonumber(row:getValue("id")) or 0
    self.type = tonumber(row:getValue("type")) or 0
    self.para = row:getValue("para")
    self.mutual_group = row:getValue("mutual_group")
    self.desc = row:getValue("desc")
    self.text = row:getValue("text")
    self.icon = row:getValue("icon")
    self.effect = row:getValue("effect")
    self.dead_effect = row:getValue("dead_effect")
    self.contact_sound = StringPool.New(row:getValue("contact_sound"),";")
    if self.type == TriggerEnum.EventType.ThreeChoices then
        local strArr = string.split(self.para, "|")
        self.paraArray = {}
        if #strArr > 0 then
            for i = 1, #strArr do
                table.insert(self.paraArray, tonumber(strArr[i]))
            end
        end
    end
end


LWTriggerItemTemplate.__init = __init
LWTriggerItemTemplate.__delete = __delete
LWTriggerItemTemplate.InitData = InitData


return LWTriggerItemTemplate