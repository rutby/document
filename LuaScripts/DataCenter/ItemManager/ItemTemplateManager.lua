---
--- Created by shimin.
--- DateTime: 2021/6/23 11:51
---
local ItemTemplateManager = BaseClass("ItemTemplateManager")
local ItemTemplate = require "DataCenter.ItemManager.ItemTemplate"
local Localization = CS.GameEntry.Localization
local GlobalData = CS.GameEntry.GlobalData

function ItemTemplateManager:__init()
    self.itemDic = {}--所有itemTemplate
    self.typeTools = {} --存的是GOOD_TYPE和table
    self.storeTools = {} --商店里分类型的道具
    self.commonHeroFrame = {} --英雄通用碎片
    self.heroFrame = {}       --英雄碎片
    self.allianceItemTemplate = {}
    self.useTableName = nil
end

function ItemTemplateManager:__delete()
    self.itemDic = {}--所有itemTemplate
    self.typeTools = {} --存的是GOOD_TYPE和table
    self.storeTools = {} --商店里分类型的道具
    self.commonHeroFrame = {} --英雄通用碎片
    self.heroFrame = {}       --英雄碎片
    self.allianceItemTemplate = {}
    self.useTableName = nil
end

function ItemTemplateManager:GetItemTemplate(id)
    local intId = tonumber(id)
    if self.itemDic[intId] == nil then
        local tableData = LocalController:instance():getTable(self:GetTableName())
        if tableData ~= nil then
            if tableData.data[intId] ~= nil then
                self:AddOneTemplate(tableData.index, tableData.data[intId])
            end
        end
    end
    return self.itemDic[intId]
end

function ItemTemplateManager:AddOneTemplate(indexList, row)
    local item = ItemTemplate:New(indexList, row)
    if item.id ~= nil then
        self.itemDic[item.id] = item
        if self.typeTools[item.type] == nil then
            self.typeTools[item.type] = {}
        end
        table.insert(self.typeTools[item.type], item)
        if item.price > 0 and item.lv > 0 then
            if item.pagehot == ItemHotPage.Yes then
                self:AddStoreItem(UIBagBtnType.Hot, item)
            end
            if item.pages > 0 then
                self:AddStoreItem(item.pages, item)
            end
        end
        if item.price_all > 0  then
            table.insert(self.allianceItemTemplate, item)
        end
        if item.type == GOODS_TYPE.GOODS_TYPE_70 then
            if item.type2 == FrameType.Common then
                if self.commonHeroFrame[item.color] == nil then
                    self.commonHeroFrame[item.color] = {}
                end
                table.insert(self.commonHeroFrame[item.color], item)
            elseif item.type2 == FrameType.HeroFrame then
                self.heroFrame[item.para2] = item
            end
        end
    end
end

function ItemTemplateManager:InitAllTemplate()
    self.itemDic = {}--所有itemTemplate
    self.typeTools = {} --存的是GOOD_TYPE和table
    self.storeTools = {} --商店里分类型的道具
    self.commonHeroFrame = {} --英雄通用碎片
    self.heroFrame = {}       --英雄碎片
    self.allianceItemTemplate = {}
    self.useTableName = nil
    local tableData = LocalController:instance():getTable(self:GetTableName())
    if tableData ~= nil then
        local indexList = tableData.index
        for k, v in pairs(tableData.data) do
            self:AddOneTemplate(indexList, v)
        end
    end
    DataCenter.AllianceShopDataManager:InitAllianceBag()
end

function ItemTemplateManager:AddStoreItem(page,template)
    if self.storeTools[page] == nil then
        self.storeTools[page] = {}
    end
    table.insert(self.storeTools[page],template)
end

function ItemTemplateManager:GetTypeListByType(type)
    return self.typeTools[type] or {}
end

function ItemTemplateManager:GetTypeListByTypes(type, type2)
    local typeList = self:GetTypeListByType(type)
    local list = {}
    for i, v in pairs(typeList) do
        if  v.type2 == type2 then -- v.price >  0 and
            table.insert(list,v)
        end
    end
  return list
end

--通过
function ItemTemplateManager:GetItemByPara(para1)
    if self.itemDic ~= nil then
        for i,v in pairs(self.itemDic) do
            if v.para ~= nil then
                if tonumber(v.para1)  == tonumber(para1)  then
                    return self.itemDic[i]
                end
            end
        end
    end
end

--通过
function ItemTemplateManager:GetItemByParaAndType(para1,type,type2)
    if self.itemDic ~= nil then
        for i,v in pairs(self.itemDic) do
            if v.para ~= nil then
                if tonumber(v.para1)  == tonumber(para1) and tonumber(v.type) == tonumber(type) and tonumber(v.type2) == tonumber(type2)  then
                    return self.itemDic[i]
                end
            end
        end
    end
end


function ItemTemplateManager:GetStoreByBtnType(type)
    return self.storeTools[type]
end

--获取通用碎片
function ItemTemplateManager:GetCommonHeroFrameByColor(color)
    return self.commonHeroFrame[color]
end

--获取英雄碎片
function ItemTemplateManager:GetHeroFrame()
    return self.heroFrame
end

--通过英雄id获取英雄碎片
function ItemTemplateManager:GetHeroFrameTemplateByHeroId(heroId)
    return self.heroFrame[heroId]
end

function ItemTemplateManager:GetName(itemId,isScale,Num)
    local template = self:GetItemTemplate(itemId)
    if template ~= nil then
        local name = template.name
        local nameLink = template.name_link
        if nameLink ~= nil and #nameLink > 0 then
            local ret = ""
            for k,v in ipairs(nameLink) do
                ret = ret + Localization:GetString(v)
            end
            return ret
        end

        local nameValue = template.name_value
        if nameValue ~= nil and table.count(nameValue) > 0 then
            for k,v in pairs(nameValue) do
                local vec1 =  string.split(v,";")
                if vec1 == nil or #vec1 == 0 then
                    return Localization:GetString(tostring(k))
                elseif #vec1 == 1 then
                    if isScale and Num ~= 1 then
                        local value = string.gsub(vec1[1],"%,","")
                        return Localization:GetString(tostring(k),string.GetFormattedSeperatorNum(tonumber(value) * Num))
                    else
                        return Localization:GetString(tostring(k),vec1[1])
                    end
                elseif #vec1 == 2 then
                    return Localization:GetString(tostring(k),vec1[1],vec1[2])
                elseif #vec1 == 3 then
                    return Localization:GetString(tostring(k),vec1[1],vec1[2],vec1[3])
                end
            end
            return Localization:GetString(name)
        end
        
        if template.type == GOODS_TYPE.GOODS_TYPE_99 or template.type == GOODS_TYPE.GOODS_TYPE_93 then
            return Localization:GetString(name, HeroUtils.GetHeroNameByConfigId(template.para2))
        end
        
        if template.type == GOODS_TYPE.GOODS_TYPE_201 then
            return Localization:GetString(name, HeroUtils.GetHeroNameByConfigId(template.para1))
        end
        
        return Localization:GetString(name)
    end
end


function ItemTemplateManager:GetDes(itemId)
    local template = self:GetItemTemplate(itemId)
    if template == nil or template.description == "" then
        return ""
    end
    
    local desc = template.description
    if template.type == GOODS_TYPE.GOODS_TYPE_99 then
        return Localization:GetString(desc, template.para1,  HeroUtils.GetHeroNameByConfigId(template.para2))
    elseif  template.type == GOODS_TYPE.GOODS_TYPE_204  then 
        local baseNum =  DataCenter.BuildManager:GetAdaptiveBoxBaseNumByGroupAndLevel(tonumber(template.para1) ,DataCenter.BuildManager.MainLv)
        if baseNum ~= nil then 
            local retNum = template.para2 * baseNum
            return Localization:GetString(desc,string.GetFormattedStr(retNum))
        end 
    end
    
    return Localization:GetString(desc)
end

function ItemTemplateManager:GetToolBgByColor(color)
    if color == ItemColor.WHITE then
        return "Assets/Main/Sprites/ItemIcons/Common_img_quality_empty"
    elseif color == ItemColor.GREEN then
        return "Assets/Main/Sprites/ItemIcons/Common_img_quality_green"
    elseif color == ItemColor.BLUE then
        return "Assets/Main/Sprites/ItemIcons/Common_img_quality_blue"
    elseif color == ItemColor.PURPLE then
        return "Assets/Main/Sprites/ItemIcons/Common_img_quality_purple"
    elseif color == ItemColor.ORANGE then
        return "Assets/Main/Sprites/ItemIcons/Common_img_quality_orange"
    elseif color == ItemColor.GOLDEN then
        return "Assets/Main/Sprites/ItemIcons/Common_img_quality_golden"
    end
    return "Assets/Main/Sprites/ItemIcons/Common_img_quality_empty"
end

--获取加速时间（毫秒）
function ItemTemplateManager:GetShowTime(para1,para2)
    if para2 == "m" then
        return tonumber(para1) * 60000      -- 60 * 1000
    elseif para2 == "h" then
        return tonumber(para1) * 3600000    --60 * 60 * 1000
    elseif para2 == "d" then
        return tonumber(para1) * 86400000   --24 * 60 * 60 * 1000
    end
end

function ItemTemplateManager:IsNewVersionGoods(version)
    if version == nil or version == "" then
        return false
    end
    local tempVec1 = string.split(version,".")
    local tempVec2 = string.split(GlobalData.version,".")
    if #tempVec1 == #tempVec2 then
        for i = 1,#tempVec1 do
            if tonumber(tempVec1[i]) > tonumber(tempVec2[i]) then
                UIUtil.ShowTipsId(120034) 
                return true
            end
        end
    end
    return false
end

function ItemTemplateManager:GetAllianceItemTemplate()
    if self.allianceItemTemplate ~= nil then
        table.sort(self.allianceItemTemplate,function (a,b)
            return a.alliance_order > b.alliance_order
        end)
    end
    return self.allianceItemTemplate
end

function ItemTemplateManager:GetIconPath(itemId)
    local itemInfo = self:GetItemTemplate(itemId)
    if itemInfo == nil or itemInfo["icon"] == nil then
        return DataCenter.ResourceManager:GetResourceIconByType(ResourceType.Electricity)
    end
    return string.format(LoadPath.ItemPath, itemInfo["icon"])
end

function ItemTemplateManager:GetAllianceItemIconPath(aItemType)
    if aItemType == RewardType.ALLIANCE_POINT then
        return string.format(LoadPath.UIAlliance, "UIAlliance_icon_alliance_point")
    elseif aItemType == RewardType.ALLIANCE_DONATE then
        return string.format(LoadPath.UIAlliance, "UIAlliance_icon_acc")
    elseif aItemType == RewardType.ALLIANCE_SCIENCE_TECH_POINT then
        return string.format(LoadPath.UIScience, "UITechnology_icon_TechPoint")
    end
end

function ItemTemplateManager:GetTableName()
    if self.useTableName == nil then
        self.useTableName = TableName.GoodsTab
    end
    return self.useTableName
end

return ItemTemplateManager
