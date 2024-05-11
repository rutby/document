--- Created by shimin
--- DateTime: 2023/6/5 15:20
--- 随机英雄插件表管理器

local RandomPlugTemplateManager = BaseClass("RandomPlugTemplateManager")
local RandomPlugTemplate = require "DataCenter.HeroPluginManager.RandomPlugTemplate"

function RandomPlugTemplateManager:__init()
    self.templateDic = {}
    self.useTableName = nil
    self.groupTemplate = {}--<groupId, {min = template, max = template, list = <lv, template>}>
    self.mainTemplate = {}--<level, <template>>主词条
    self.randomTemplate = {}--<template>随机词条
end

function RandomPlugTemplateManager:__delete()
    self.templateDic = {}
    self.useTableName = nil
    self.groupTemplate = {}--<groupId, {min = template, max = template}>
    self.mainTemplate = {}--<level, <template>>主词条
    self.randomTemplate = {}--<template>随机词条
end

function RandomPlugTemplateManager:Startup()
end

function RandomPlugTemplateManager:GetTemplate(id)
    local numId = tonumber(id)
    if self.templateDic[numId] == nil then
        if LocalController:instance():getTable(self:GetTableName()) ~= nil then
            local oneTemplate = LocalController:instance():getLine(self:GetTableName(), tostring(id))
            self:AddOneTemplate(oneTemplate)
        end
    end
    return self.templateDic[numId]
end

function RandomPlugTemplateManager:GetTableName()
    if self.useTableName == nil then
        self.useTableName = TableName.RandomPlug
    end
    return self.useTableName
end

function RandomPlugTemplateManager:TransAllTemplates()
    self.templateDic = {}
    self.useTableName = nil
    self.groupTemplate = {}
    self.mainTemplate = {}
    self.randomTemplate = {}
    LocalController:instance():visitTable(self:GetTableName(),function(id, oneTemplate)
        self:AddOneTemplate(oneTemplate)
    end)
end

function RandomPlugTemplateManager:AddOneTemplate(oneTemplate)
    if oneTemplate ~= nil then
        local item = RandomPlugTemplate.New()
        item:InitData(oneTemplate)
        if item.id ~=nil then
            self.templateDic[item.id] = item
            if item.effect_group > 0 then
                if self.groupTemplate[item.effect_group] == nil then
                    self.groupTemplate[item.effect_group] = {}
                    self.groupTemplate[item.effect_group].min = item
                    self.groupTemplate[item.effect_group].max = item
                    self.groupTemplate[item.effect_group].list = {}
                    self.groupTemplate[item.effect_group].list[item.lv] = item
                else
                    if self.groupTemplate[item.effect_group].min.lv > item.lv then
                        self.groupTemplate[item.effect_group].min = item
                    end
                    if self.groupTemplate[item.effect_group].max.lv < item.lv then
                        self.groupTemplate[item.effect_group].max = item
                    end
                    if self.groupTemplate[item.effect_group].list == nil then
                        self.groupTemplate[item.effect_group].list = {}
                    end
                    self.groupTemplate[item.effect_group].list[item.lv] = item
                end
            end
            if item.type1 == HeroPluginOutType.Const then
                if self.mainTemplate[item.lv] == nil then
                    self.mainTemplate[item.lv] = {item}
                else
                    table.insert(self.mainTemplate[item.lv], item)
                end
            elseif item.type1 == HeroPluginOutType.Random then
                table.insert(self.randomTemplate, item)
            end
        end
    end
end

function RandomPlugTemplateManager:GetAllGroupTemplate()
    return self.groupTemplate
end

function RandomPlugTemplateManager:GetTemplateByGroupAndLevel(group, level)
    if self.groupTemplate[group] ~= nil and self.groupTemplate[group].list ~= nil then
        return self.groupTemplate[group].list[level]
    end 
    return nil
end
--获取同组最大的表
function RandomPlugTemplateManager:GetMaxTemplateByGroup(group)
    if self.groupTemplate[group] ~= nil then
        return self.groupTemplate[group].max
    end
    return nil
end

--通过等级获取主词条
function RandomPlugTemplateManager:GetMainTemplateByLevel(level)
    return self.mainTemplate[level]
end

--获取所有随机词条
function RandomPlugTemplateManager:GetAllRandomTemplate()
    return self.randomTemplate
end

return RandomPlugTemplateManager