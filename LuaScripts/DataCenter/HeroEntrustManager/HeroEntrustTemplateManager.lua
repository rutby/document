---
--- Created by shimin.
--- DateTime: 2022/6/13 11:25
--- 英雄委托表管理器
---
local HeroEntrustTemplateManager = BaseClass("HeroEntrustTemplateManager")
local HeroEntrustTemplate = require "DataCenter.HeroEntrustManager.HeroEntrustTemplate"

function HeroEntrustTemplateManager:__init()
    self.templateDic = {}
end

function HeroEntrustTemplateManager:__delete()
    self.templateDic = {}
end

function HeroEntrustTemplateManager:GetHeroEntrustTemplate(id)
    if id ~= nil then
        local numId = tonumber(id)
        if self.templateDic[numId] == nil then
            local oneTemplate = LocalController:instance():getLine(TableName.HeroEntrust,tostring(id))
            if oneTemplate ~= nil then
                local template = HeroEntrustTemplate.New()
                template:InitData(oneTemplate)
                if template.id ~= nil then
                    self.templateDic[template.id] = template
                end
            end
        end
        return self.templateDic[numId]
    end
end

--获取英雄委托世界坐标
function HeroEntrustTemplateManager:GetHeroEntrustPosition(id)
    local template = self:GetHeroEntrustTemplate(id)
    if template ~= nil then
        return template:GetPosition()
    end
end

return HeroEntrustTemplateManager
