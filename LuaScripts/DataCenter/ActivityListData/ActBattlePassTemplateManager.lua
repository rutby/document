---
--- Created by zzl.
--- DateTime: 
---
local ActBattlePassTemplateManager = BaseClass("ActBattlePassTemplateManager", Singleton);
local ActBattlePassTemplate = require "DataCenter.ActivityListData.ActBattlePassTemplate"
local function __init(self)
    self.tempDict ={}
    self.highReward = {}
end

local function __delete(self)
    self.tempDict =nil
    self.highReward = nil
end

local function InitAllTemplate(self)
    LocalController:instance():visitTable(TableName.BattlePass,function(id,lineData)
        local item = ActBattlePassTemplate.New()
        item:InitData(lineData)
        if self.tempDict[item.actId] == nil then
            self.tempDict[item.actId] = {}
        end
        if self.highReward[item.actId] == nil then
            self.highReward[item.actId] = {}
        end
        table.insert(self.tempDict[item.actId],item)
        if item.highReward ~= "" and item.highReward ~= nil then
            table.insert(self.highReward[item.actId],item)
        end
    end)
end

local function GetTemplateById(self, actId,lv)
    if not next(self.tempDict) then
        self:InitAllTemplate()
    end
    local data = self.tempDict[actId]
    for i = 1 ,#data do
        if data[i].level == lv then
            return data[i]
        end
    end
end

local function GetAllTemplateWithPrivilege(self, actId)
    if not next(self.tempDict) then
        self:InitAllTemplate()
    end
    local data = self.tempDict[actId]
    local retList = {}
    for i, v in ipairs(data) do
        if not string.IsNullOrEmpty(v.pay_item) then
            table.insert(retList, v)
        end
    end
    return retList
end

local function GetTemplateHighRewardById(self,actId,lv)
    if not next(self.highReward) then
        self:InitAllTemplate()
    end
    local data = self.highReward[actId]
    table.sort(data,function(a,b)
        if a.level < b.level then
            return true
        end    
        return false
    end)
    return  data
end

local function GetActMaxLv(self,actId)
    local data = self.tempDict[actId]
    return #data
end

ActBattlePassTemplateManager.__init = __init
ActBattlePassTemplateManager.__delete = __delete
ActBattlePassTemplateManager.InitAllTemplate = InitAllTemplate
ActBattlePassTemplateManager.GetTemplateById = GetTemplateById
ActBattlePassTemplateManager.GetTemplateHighRewardById = GetTemplateHighRewardById
ActBattlePassTemplateManager.GetAllTemplateWithPrivilege = GetAllTemplateWithPrivilege
ActBattlePassTemplateManager.GetActMaxLv = GetActMaxLv

return ActBattlePassTemplateManager
