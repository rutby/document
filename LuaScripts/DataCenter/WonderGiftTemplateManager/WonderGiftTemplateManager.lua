---
--- Created by shimin
--- DateTime: 2023/3/17 17:37
--- 王座礼包表管理器
---
local WonderGiftTemplateManager = BaseClass("WonderGiftTemplateManager")
local WonderGiftTemplate = require "DataCenter.WonderGiftTemplateManager.WonderGiftTemplate"

function WonderGiftTemplateManager:__init()
    self.templateDic = {}
end

function WonderGiftTemplateManager:__delete()
    self.templateDic = {}
end

function WonderGiftTemplateManager:GetTemplate(id)
    local numId = tonumber(id)
    if self.templateDic[numId]== nil then
        local oneTemplate = LocalController:instance():getLine(TableName.WonderGift, tostring(id))
        if oneTemplate~=nil then
            local item = WonderGiftTemplate.New()
            item:InitData(oneTemplate)
            if item.id ~=nil then
                self.templateDic[item.id] = item
            end
        end
    end
    return self.templateDic[numId]
end

return WonderGiftTemplateManager