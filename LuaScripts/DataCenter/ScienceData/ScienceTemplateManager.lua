---
--- Created by shimin.
--- DateTime: 2021/6/8 15:21
---
local ScienceTemplateManager = BaseClass("ScienceTemplateManager");
local Setting = CS.GameEntry.Setting
local Localization = CS.GameEntry.Localization
local ScienceTabTemplate = require "DataCenter.ScienceData.ScienceTabTemplate"
local ScienceTemplate = require "DataCenter.ScienceData.ScienceTemplate"

local LineTabName = "LineTab"

function ScienceTemplateManager:__init()
    self.scienceTemplateDic ={}
    self.scienceTabTemplateDic ={}
    self.lineTab = {}--画出科技的连线关系
    self.initFinish = {}--表是否初始化完成
    self.useTableName = nil
    self.useTabTableName = nil
end

function ScienceTemplateManager:__delete()
    self.scienceTemplateDic ={}
    self.scienceTabTemplateDic ={}
    self.lineTab = {}--画出科技的连线关系
    if self.delayInitTimer then
        self.delayInitTimer:Stop()
        self.delayInitTimer = nil
    end
    self.initFinish = {}
    self.useTableName = nil
    self.useTabTableName = nil
end

function ScienceTemplateManager:DelayInitAllTemplate()
    self.delayInitTimer = TimerManager:GetInstance():DelayInvoke(function()
        --初始化科技表
        self:InitAllTemplate()
    end, 5)
end

function ScienceTemplateManager:InitAllTemplate()
    self:TryInitAllTab()
    self:TryInitAllScience()
end

function ScienceTemplateManager:GetScienceTemplate(id, lv)
    self:TryInitAllScience()
    if lv == nil or lv <= 0 then
        lv = 1
    end
    local intId = CommonUtil.GetScienceBaseType(tonumber(id)) + lv
    if self.scienceTemplateDic[intId] == nil then
        local tableData = LocalController:instance():getTable(self:GetTableName())
        if tableData ~= nil then
            if tableData.data[intId] ~= nil then
                self:AddOneTemplate(tableData.index, tableData.data[intId])
            end
        end
    end
    return self.scienceTemplateDic[intId]
end

function ScienceTemplateManager:AddOneTemplate(indexList, row)
    local item = ScienceTemplate:New(indexList, row)
    if item.id ~= nil then
        self.scienceTemplateDic[item.id] = item

        local tab = item.tab
        if self.lineTab[tab] == nil then
            self.lineTab[tab] = {}
        end
        local positionX = item.position[1]
        local positionY = item.position[2]
        if positionX ~= nil and positionX > 0 and positionY ~= nil and positionY >0 then
            if self.lineTab[tab][positionX] == nil then
                self.lineTab[tab][positionX] = {}
            end
            self.lineTab[tab][positionX][positionY] = CommonUtil.GetScienceBaseType(item.id)
        end
    end
end

function ScienceTemplateManager:GetScienceTabTemplate(id)
    self:TryInitAllTab()
    if self.scienceTabTemplateDic[id] == nil then
        local tableData = LocalController:instance():getTable(self:GetTabTableName())
        if tableData ~= nil then
            if tableData.data[id] ~= nil then
                self:AddOneTabTemplate(tableData.index, tableData.data[id])
            end
        end
    end
    return self.scienceTabTemplateDic[id]
end

function ScienceTemplateManager:AddOneTabTemplate(indexList, row)
    local item = ScienceTabTemplate:New(indexList, row)
    if item.id ~= nil then
        self.scienceTabTemplateDic[item.id] = item
    end
end


--获取当前可以显示的Tab
function ScienceTemplateManager:GetCurShowTab(scienceType, buildId)
    self:TryInitAllTab()
    local result = {}
    for k,v in pairs(self.scienceTabTemplateDic) do
        if v.type == scienceType and (buildId == nil or v:IsInBuilding(buildId)) then
            if DataCenter.HeroPluginManager:IsUnlockScienceWithoutLimit(v.id) then
                table.insert(result,v)
            else
                local unlockCondition = v:GetUnlockCondition()
                if unlockCondition ~= nil then
                    if unlockCondition.conditionType == ScienceTabShowConditionType.AllianceBattle then
                        if DataCenter.ScienceDataManager:CheckIfBattleScienceOpen() then
                            table.insert(result, v)
                        end
                    elseif unlockCondition.conditionType == ScienceTabShowConditionType.Season then
                        if unlockCondition.paramList ~= nil then
                            local serverId = LuaEntry.Player.serverId
                            for k1, v1 in ipairs(unlockCondition.paramList) do
                                if v1.minServerId <= serverId and v1.maxServerId >= serverId then
                                    local season = DataCenter.SeasonDataManager:GetSeason() or 0
                                    local day = DataCenter.SeasonDataManager:GetSeasonDurationDay() + 1
                                    if v1.season < season or (v1.season == season and  v1.day <= day) then
                                        table.insert(result, v)
                                    end
                                    break
                                end
                            end
                        end
                    else
                        table.insert(result, v)
                    end
                end
            end
        end
    end
    
    table.sort(result, function(a, b)
        if a.order ~= b.order then
            return a.order < b.order
        else
            return a.id < b.id
        end
    end)

    if self.initFinish[LineTabName] == nil then
        self:InitTabLine()
    end
    
    return result
end

function ScienceTemplateManager:TryInitAllTab()
    if self.initFinish[TableName.APSScienceTab] == nil then
        self.initFinish[TableName.APSScienceTab] = true
        local tableData = LocalController:instance():getTable(self:GetTabTableName())
        if tableData ~= nil then
            local indexList = tableData.index
            for k, v in pairs(tableData.data) do
                self:AddOneTabTemplate(indexList, v)
            end
        end
    end
end

function ScienceTemplateManager:GetTabState(id, buildUuid)
    --有setting说明已解锁
    local status = self:GetScienceTabSetting(id)
    if status == ScienceTabState.UnLock then
        return ScienceTabState.UnLock
    else
        --有科技说明已解锁
        local template = self:GetScienceTabTemplate(id)
        if template ~= nil then
            local pro= self:GetScienceTabPro(id)
            if pro > 0 then
                return ScienceTabState.UnLock
            end

            local isLockSeeFit = true
            if template.unlock_see ~= nil and template.unlock_see[1] ~= nil then
                local preTab = self:GetScienceTabTemplate(template.unlock_see[1])
                if preTab then
                    local tempPro = self:GetScienceTabPro(template.unlock_see[1])
                    if tempPro * 100 < template.unlock_see[2] then
                        isLockSeeFit = false
                    end
                end
            end

            if isLockSeeFit then
                local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(buildUuid)
                local levelUnlock = true
                local lockedTip = ""
                if template.unlock_level[1] ~= nil then
                    if buildData.level < template.unlock_level[1][1] then
                        levelUnlock = false
                        lockedTip = Localization:GetString("130041", 
                                Localization:GetString(GetTableData(DataCenter.BuildTemplateManager:GetTableName(), BuildingTypes.FUN_BUILD_SCIENE + template.unlock_level[1][1],"name")), template.unlock_level[1][1]) .. "\n"
                    end
                end
                local progUnlock = true
                if template.unlock_level[2] ~= nil and template.unlock_level[2][2] ~= nil then
                    local preTab = self:GetScienceTabTemplate(template.unlock_level[2][1])
                    if preTab ~= nil then
                        local tempPro = self:GetScienceTabPro(template.unlock_level[2][1])
                        if tempPro * 100 < template.unlock_level[2][2] then
                            progUnlock = false
                            lockedTip = lockedTip .. Localization:GetString("200570", Localization:GetString(preTab.name), template.unlock_level[2][2].. "%")
                        end
                    end
                end

                if (not levelUnlock) or (not progUnlock) then
                    return ScienceTabState.LockShow, lockedTip
                else
                    return ScienceTabState.UnLock
                end
            else
                return ScienceTabState.Lock
            end
        end
    end
    return ScienceTabState.Lock
    
end
function ScienceTemplateManager:GetScienceTabSetting(id)
    return Setting:GetInt(LuaEntry.Player.uid .. SettingKeys.SCIENCE_TAB_UNLOCK..id, ScienceTabState.Lock)
end

function ScienceTemplateManager:SetScienceTabSetting(id)
    return Setting:SetInt(LuaEntry.Player.uid .. SettingKeys.SCIENCE_TAB_UNLOCK..id, ScienceTabState.UnLock)
end

--获取科技树进度
function ScienceTemplateManager:GetScienceTabPro(id)
    if self.initFinish[LineTabName] == nil then
        self:InitTabLine()
    end
    local result = 0
    local list = self.lineTab[id]
    if list ~= nil then
        local total = 0
        local now = 0
        for k,v in pairs(list) do
            for k1,v1 in pairs(v) do
                local level = DataCenter.ScienceManager:GetScienceLevel(v1)
                now = now + level
                local scienceTemplate = self:GetScienceTemplate(v1,1)
                if scienceTemplate ~= nil then
                    total = total + scienceTemplate.max_level
                end
            end
        end
        if total > 0 then
            result = now / total
        end
    end
    return result
end

function ScienceTemplateManager:TryInitAllScience()
    if self.initFinish[TableName.ScienceNew] == nil then
        self.initFinish[TableName.ScienceNew] = true
        local tableData = LocalController:instance():getTable(self:GetTableName())
        if tableData ~= nil then
            local indexList = tableData.index
            for k, v in pairs(tableData.data) do
                self:AddOneTemplate(indexList, v)
            end
        end
    end
end

function ScienceTemplateManager:InitTabLine()
    self.initFinish[LineTabName] = true
    self:TryInitAllScience()
end

--获取科技tab中所有科技id
function ScienceTemplateManager:GetLineListByTab(tab)
    if self.initFinish[LineTabName] == nil then
        self:InitTabLine()
    end
    return self.lineTab[tab]
end

function ScienceTemplateManager:GetTableName()
    if self.useTableName == nil then
        self.useTableName = TableName.ScienceNew
    end
    return self.useTableName
end

function ScienceTemplateManager:GetTabTableName()
    if self.useTabTableName == nil then
        self.useTabTableName = TableName.APSScienceTab
    end
    return self.useTabTableName
end

return ScienceTemplateManager
