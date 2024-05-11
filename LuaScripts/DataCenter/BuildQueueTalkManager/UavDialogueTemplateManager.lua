---
--- Created by shimin.
--- DateTime: 2021/7/5 19:21
---
local UavDialogueTemplateManager = BaseClass("UavDialogueTemplateManager");

local function __init(self)
    self.uavDialogueTemplateDic ={}
    self.isSort = {}
end

local function __delete(self)
    self.uavDialogueTemplateDic =nil
    self.isSort = nil
end

local function InitAllTemplate(self)
    self.uavDialogueTemplateDic ={}
    LocalController:instance():visitTable(TableName.UavDialogue,function(id,lineData)
        local item = UavDialogueTemplate.New()
        item:InitData(lineData)
        if self.uavDialogueTemplateDic[item.type] == nil then
            self.uavDialogueTemplateDic[item.type] = {}
        end
        table.insert(self.uavDialogueTemplateDic[item.type],item)
    end)
end

local function GetUavDialogueListByType(self,type)
    if self.isSort[type] == nil then
        if self.uavDialogueTemplateDic[type] ~= nil then
            table.sort(self.uavDialogueTemplateDic[type],function (a,b)
                return a.order < b.order
            end)
        end
        self.isSort[type] = true
    end
    return self.uavDialogueTemplateDic[type]
end

UavDialogueTemplateManager.__init = __init
UavDialogueTemplateManager.__delete = __delete
UavDialogueTemplateManager.InitAllTemplate = InitAllTemplate
UavDialogueTemplateManager.GetUavDialogueListByType = GetUavDialogueListByType

return UavDialogueTemplateManager
