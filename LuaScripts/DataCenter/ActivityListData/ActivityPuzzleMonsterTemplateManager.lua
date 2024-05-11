--- Created by shimin
--- DateTime: 2023/9/25 15:57
--- 拼图/雷达海盗船表管理器

local ActivityPuzzleMonsterTemplateManager = BaseClass("ActivityPuzzleMonsterTemplateManager")
local ActivityPuzzleMonsterTemplate = require "DataCenter.ActivityListData.ActivityPuzzleMonsterTemplate"

function ActivityPuzzleMonsterTemplateManager:__init()
    self.templateDic = {}
    self.useTableName = nil
    self.isInit = false
    self.typeDic = {}
end

function ActivityPuzzleMonsterTemplateManager:__delete()
    self.templateDic = {}
    self.useTableName = nil
    self.isInit = false
    self.typeDic = {}
end

function ActivityPuzzleMonsterTemplateManager:Startup()
end


function ActivityPuzzleMonsterTemplateManager:GetAllTemplateByType(puzzleType)
    self:InitAllTemplate()
    return self.typeDic[puzzleType]
end

function ActivityPuzzleMonsterTemplateManager:GetTemplateByMonsterId(monsterId)
    self:InitAllTemplate()
    for _, v in pairs(self.templateDic) do
        if v.monsterId == monsterId then
            return v
        end
    end
    return nil
end

function ActivityPuzzleMonsterTemplateManager:GetTemplate(id)
    self:InitAllTemplate()
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

function ActivityPuzzleMonsterTemplateManager:GetTableName()
    if self.useTableName == nil then
        self.useTableName = TableName.ActivityPuzzleMonster
    end
    return self.useTableName
end

--获取所有图鉴表
function ActivityPuzzleMonsterTemplateManager:AddOneTemplate(oneTemplate)
    local item = ActivityPuzzleMonsterTemplate.New()
    item:InitData(oneTemplate)
    if item.id ~= nil then
        self.templateDic[item.id] = item
        if self.typeDic[item.type] == nil then
            self.typeDic[item.type] = {}
        end
        self.typeDic[item.type][item.id] = item
    end
end

function ActivityPuzzleMonsterTemplateManager:InitAllTemplate()
    if not self.isInit then
        self.isInit = true
        self.useTableName = nil
        self.templateDic = {}
        self.typeDic = {}
        if LocalController:instance():getTable(self:GetTableName()) ~= nil then
            LocalController:instance():visitTable(self:GetTableName(), function(id,lineData)
                self:AddOneTemplate(lineData)
            end)
        end
    end
end

return ActivityPuzzleMonsterTemplateManager