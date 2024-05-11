--- 章节表管理器
--- Created by shimin
--- DateTime: 2023/5/10 14:35
local ChapterTemplateManager = BaseClass("ChapterTemplateManager")
local ChapterTemplate = require "DataCenter.ChapterTaskData.ChapterTemplate"

function ChapterTemplateManager:__init()
    self.templateDic = {}--<章节id,ChapterTemplate>
    self.questTemplateDic = {}--<任务id, ChapterTemplate>
    self.chapterNum = 0--章节总数
    self.useTableName = nil--章节总数
    self.isInit = false
end

function ChapterTemplateManager:__delete()
    self.templateDic = {}--<章节id,ChapterTemplate>
    self.questTemplateDic = {}--<任务id, ChapterTemplate>
    self.chapterNum = 0
    self.useTableName = nil
    self.isInit = false
end

--通过任务id获取章节表
function ChapterTemplateManager:GetChapterTemplateByQuestId(questId)
    self:TransAllTemplates()
    return self.questTemplateDic[questId]
end

--通过章节id获取章节表
function ChapterTemplateManager:GetChapterTemplate(id)
    self:TransAllTemplates()
    return self.templateDic[id]
end

--获取章节总数
function ChapterTemplateManager:GetChapterAllNum()
    if self.chapterNum == 0 then
        self:TransAllTemplates()
        self.chapterNum = table.count(self.templateDic)
    end
    return self.chapterNum
end

--获取章节表的名字
function ChapterTemplateManager:GetTableName()
    if self.useTableName == nil then
        self.useTableName = LuaEntry.Player:GetABTestTableName(TableName.Chapter)
    end
    return self.useTableName
end

--初始化所有章节表
function ChapterTemplateManager:TransAllTemplates()
    if not self.isInit then
        self.isInit = true
        self.templateDic = {}
        self.questTemplateDic = {}
        self.chapterNum = 0
        LocalController:instance():visitTable(self:GetTableName(), function(id,lineData)
            local item = ChapterTemplate.New()
            item:InitData(lineData)
            if item.chapter ~= nil then
                self.templateDic[item.chapter] = item
                for k,v in ipairs(item.quest) do
                    self.questTemplateDic[v] = item
                end
            end
        end)
    end
end

return ChapterTemplateManager
