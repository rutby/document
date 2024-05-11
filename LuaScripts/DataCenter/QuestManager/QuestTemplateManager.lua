---
--- Created by shimin.
--- DateTime: 2021/8/4 17:39
---
local QuestTemplateManager = BaseClass("QuestTemplateManager")
local Localization = CS.GameEntry.Localization

function QuestTemplateManager:__init()
    self.upPowerDataList = nil
end

function QuestTemplateManager:__delete()
    self.upPowerDataList = nil
end

function QuestTemplateManager:GetUpPowerData(level)
    if self.upPowerDataList == nil then
        self:InitUpPowerDataList()
    end

    for _,v in ipairs(self.upPowerDataList) do
        if level >= v.minLevel and level <= v.maxLevel then
            return v
        end
    end
    return nil
end

function QuestTemplateManager:InitUpPowerDataList()
    self.upPowerDataList = {}
    local k2 = LuaEntry.DataConfig:TryGetNum("power_activity", "k2")
    local k1 = LuaEntry.DataConfig:TryGetStr("power_activity", "k1")
    local dataStrList = string.split(k1, "|")
    for _, v in ipairs(dataStrList) do
        local splitList = string.split(v, ";")
        local min_max = string.split(splitList[1], "-")
        local minLevel = toInt(min_max[1])
        local maxLevel = toInt(min_max[2])
        local upPowerData = {}
        upPowerData.minLevel = minLevel
        upPowerData.maxLevel = maxLevel
        upPowerData.data = splitList
        upPowerData.percent = k2
        table.insert(self.upPowerDataList, upPowerData)
    end
end

function QuestTemplateManager:GetTableName()
    return TableName.QuestXml
end

--名字描述
function QuestTemplateManager:GetDesc(row, isChatView, isPreview)
    local show1 = nil
    local show2 = nil
    local show3 = nil
    if row.desctype == QuestDescType.Normal then
        show1 = row.para1
        show2 = row.para2
        show3 = row.para3
    elseif row.desctype == QuestDescType.Build then
        show1 = Localization:GetString(GetTableData(DataCenter.BuildTemplateManager:GetTableName(), row.para1 + row.para2 - 1,"name"))
        show2 = row.para2
        show3 = row.para3
    elseif row.desctype == QuestDescType.Train then
        local template = DataCenter.ArmyTemplateManager:GetArmyTemplate(row.para1)
        if template ~= nil then
            show1 = Localization:GetString(template.name)
        end
        show2 = row.para2
    elseif row.desctype == QuestDescType.HeroUpStar then
        local star,const =  HeroUtils.GetHeroStarAndProgress(row.para1)
        show1 = Localization:GetString("129269",star)
        show2 = row.para2
    elseif row.desctype == QuestDescType.Resource then
        local template = DataCenter.ResourceTemplateManager:GetResourceTemplate(row.para1)
        if template ~= nil then
            show1 = Localization:GetString(template.name)
        end
        show2 = row.para2
    elseif row.desctype == QuestDescType.Science then
        local baseId = CommonUtil.GetScienceBaseType(row.para1)
        local level = CommonUtil.GetScienceLv(row.para1)
        local template = DataCenter.ScienceTemplateManager:GetScienceTemplate(baseId,level)
        if template ~= nil then
            show1 = Localization:GetString(template.name)
        end
        show2 = row.para2
    elseif row.desctype == QuestDescType.Monster then
        local level = DataCenter.MonsterTemplateManager:GetTableValue(row.para1, "level")
        local nameStr = DataCenter.MonsterTemplateManager:GetTableValue(row.para1, "name")
        show1 = Localization:GetString(GameDialogDefine.MONSTER_LEVEL_NAME,level,Localization:GetString(nameStr))
        show2 = row.para2
    elseif row.desctype == QuestDescType.Robot then
        local template = LocalController:instance():getLine(TableName.Robot, row.para1)
        if template ~= nil then
            show1 = Localization:GetString(template:getValue("name"))
        end
        show2 = row.para2
    elseif row.desctype == QuestDescType.HeroName then
        show1 = Localization:GetString(GetTableData(HeroUtils.GetHeroXmlName(), row.para1, "name"))
        show2 = row.para2
    elseif row.desctype == QuestDescType.HeroQuality then
        if row.para1 == 1 then
            show1 = Localization:GetString(156004)
        elseif row.para1 == 2 then
            show1 = Localization:GetString(156003)
        elseif row.para1 == 3 then
            show1 = Localization:GetString(156002)
        elseif row.para1 == 4 then
            show1 = Localization:GetString(156001)
        end
        show2 = row.para2
    elseif row.desctype == QuestDescType.HeroSkill then
        show1 = Localization:GetString(GetTableData(HeroUtils.GetHeroXmlName(),row.para3, "name"))
        show2 = Localization:GetString(GetTableData(TableName.SkillTab, row.para1, 'name'))
        show3 = row.para2
    elseif row.desctype == QuestDescType.Season then
        show1 = row.para2
        show2 = row.para1
        show3 = GetTableData(TableName.Desert, row.para1, 'desert_level')
    elseif row.desctype == QuestDescType.SeasonHero then
        show1 = row.para1
        show2 = row.para2
        local seasonId = DataCenter.SeasonDataManager:GetSeasonId() or 0
        if isPreview == true then
            show3 = seasonId
        else
            show3 = seasonId - 1
        end
    elseif row.desctype == QuestDescType.HeroRank then
        show1 = Localization:GetString(GetTableData(HeroUtils.GetHeroXmlName(), row.para1, "name"))
        show2 = Localization:GetString(HeroUtils.GetMilitaryRankName(tonumber(row.para3)))
    else
        show1 = row.para1
        show2 = row.para2
    end

    local numShow1 = tonumber(show1)
    show1 = numShow1 and string.GetFormattedSeperatorNum(numShow1) or show1
    local numShow2 = tonumber(show2)
    show2 = numShow2 and string.GetFormattedSeperatorNum(numShow2) or show2
    local numShow3 = tonumber(show3)
    show3 = numShow3 and string.GetFormattedSeperatorNum(numShow3) or show3


    local empty1 = show1 == nil or show1 == ""
    local empty2 = show2 == nil or show2 == ""
    local empty3 = show3 == nil or show3 == ""
    if not empty3 then
        return Localization:GetString(row.desc,show1,show2,show3)
    end
    if empty1 and empty2 then
        if isChatView then
            return Localization:GetString(row.desc)
        end

        return Localization:GetString(row.mainshow == "" and row.desc or row.mainshow)
    else
        if isChatView then
            return Localization:GetString(row.desc,show1,show2)
        end
        if row.mainshow ~= "" then
            return Localization:GetString(row.mainshow,show1,show2)
        else
            return Localization:GetString(row.desc,show1,show2)
        end
    end
end


return QuestTemplateManager
