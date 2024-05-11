---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2023/4/24 11:52
---

local OfficerListTemplate = BaseClass("OfficerListTemplate")
local OfficerConditionHero = require "DataCenter.OfficerListManager.OfficerConditionHero"
local OfficerConditionServer = require "DataCenter.OfficerListManager.OfficerConditionServer"

local function __init(self)
    self.id = 0
    self.officer_id = 0
    self.show_rate = 0
    self.condition = {}
end

local function __delete(self)
    self.id = 0
    self.officer_id = 0
    self.show_rate = 0
    self.condition = {}
end

local function InitData(self,row)
    if row ==nil then
        return
    end
    self.id = tonumber(row:getValue("id"))
    self.group_id = tonumber(row:getValue("group_id"))
    self.hero_id = tonumber(row:getValue("officer_id"))
    self.good_id = tonumber(row:getValue("goods"))
    self.good_num = tonumber(row:getValue("goods_num"))
    self.show_rate = tonumber(row:getValue("show_rate"))
    local conditionStr = row:getValue("condition")
    if not string.IsNullOrEmpty(conditionStr) then
        local conditionVec = string.split(conditionStr, "|")
        for _, v in ipairs(conditionVec) do
            local tempVec = string.split(v, ";")
            if table.count(tempVec) > 0 then
                local type = toInt(tempVec[1])
                if type == OfficerListConditionType.Condition_Hero then
                    local conditionHero = OfficerConditionHero.New()
                    conditionHero:InitData(tempVec)
                    table.insert(self.condition, conditionHero)
                elseif type == OfficerListConditionType.Condition_Server then
                    local conditionServer = OfficerConditionServer.New()
                    conditionServer:InitData(tempVec)
                    table.insert(self.condition, conditionServer)
                end
            end
        end
    end
end

local function IsValid(self)
    for _, v in ipairs(self.condition) do
        if v and not v:IsValid() then
            return false
        end
    end
    return true
end

OfficerListTemplate.__init = __init
OfficerListTemplate.__delete = __delete
OfficerListTemplate.InitData = InitData
OfficerListTemplate.IsValid = IsValid

return OfficerListTemplate