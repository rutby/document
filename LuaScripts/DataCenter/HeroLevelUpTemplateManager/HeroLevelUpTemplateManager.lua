--- Created by shimin
--- DateTime: 2023/9/4 18:13
--- 英雄升级表管理器

local HeroLevelUpTemplateManager = BaseClass("HeroLevelUpTemplateManager")
local HeroLevelUpTemplate = require "DataCenter.HeroLevelUpTemplateManager.HeroLevelUpTemplate"

function HeroLevelUpTemplateManager:__init()
    self.templateDic = {}
    self.useTableName = nil
    self.isInit = false
    self.rankToLevel = {}--品质对应最大等级
    self.mainLvToLevel = {}--
end

function HeroLevelUpTemplateManager:__delete()
    self.templateDic = {}
    self.useTableName = nil
    self.isInit = false
    self.rankToLevel = {}--排行对应等级
    self.mainLvToLevel = {}
end

function HeroLevelUpTemplateManager:Startup()
end

function HeroLevelUpTemplateManager:GetTemplate(id)
    self:TransAllTemplates()
    local numId = tonumber(id)
    if self.templateDic[numId]== nil then
        if LocalController:instance():getTable(self:GetTableName()) ~= nil then
            local oneTemplate = LocalController:instance():getLine(self:GetTableName(), tostring(id))
            if oneTemplate~=nil then
                self:AddOneTemplate(oneTemplate)
            end
        end
    end
    return self.templateDic[numId]
end

function HeroLevelUpTemplateManager:GetTableName()
    if self.useTableName == nil then
        local configOpenState = LuaEntry.DataConfig:CheckSwitch("ABtest_heroes_levelup")
        if configOpenState then
            self.useTableName = TableName.NewHeroesLevelUp_B
        else
            self.useTableName = TableName.NewHeroesLevelUp
        end
    end
    return self.useTableName
end

--获取所有图鉴表
function HeroLevelUpTemplateManager:AddOneTemplate(oneTemplate)
    local item = HeroLevelUpTemplate.New()
    item:InitData(oneTemplate)
    if item.id ~= nil then
        self.templateDic[item.id] = item
        if item.break_require_base ~= 0 then
            local param = {}
            param.needLv = item.break_require_base
            param.level = item.id
            table.insert(self.mainLvToLevel, param)
        end
    end
end

function HeroLevelUpTemplateManager:TransAllTemplates()
    if not self.isInit then
        self.isInit = true
        self.useTableName = nil
        self.templateDic = {}
        self.rankToLevel = {}--作用号对应装饰表
        self.mainLvToLevel = {}
        if LocalController:instance():getTable(self:GetTableName()) ~= nil then
            LocalController:instance():visitTable(self:GetTableName(), function(id,lineData)
                self:AddOneTemplate(lineData)
            end)
            if self.mainLvToLevel[1] ~= nil then
                table.sort(self.mainLvToLevel, function(a, b)  
                    return a.level < b.level
                end)
            end
        end
    end
end

function HeroLevelUpTemplateManager:GetMaxLevelByMainLv()
    self:TransAllTemplates()
    local mainLv = DataCenter.BuildManager.MainLv
    for k,v in ipairs(self.mainLvToLevel) do
        if mainLv < v.needLv then
            return v.level
        end
    end
   
    return HeroMaxLevel
end

function HeroLevelUpTemplateManager:GetNeedMainLv()
    self:TransAllTemplates()
    local mainLv = DataCenter.BuildManager.MainLv
    for k,v in ipairs(self.mainLvToLevel) do
        if mainLv < v.needLv then
            return v.needLv
        end
    end

    return 0
end


return HeroLevelUpTemplateManager