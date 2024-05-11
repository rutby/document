---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by mac.
--- DateTime: 9/24/21 11:27 AM
---
local ResLackItemBase = BaseClass("ResLackItemBase")
local Localization = CS.GameEntry.Localization

function ResLackItemBase:__init( configId ) 
    configId = configId or ""
    self._config = LocalController:instance():getLine(TableName.Res_Lack_Tips, configId)
end

function ResLackItemBase:__delete()
    self._config = nil
end



function ResLackItemBase:GetOrder()
    return tonumber(self._config:getValue("order")) or 1
end

--[[
    检测是否符合资源不足提示的要求
]]
function ResLackItemBase:CheckIsOk( _resType, _needCnt )
    
end

--[[
    补充的方式
]]
function ResLackItemBase:TodoAction(SceneID,pos,zoom,time,onComplete)
    if SceneID == SceneManagerSceneID.City then
        GoToUtil.GotoCityPos(pos,zoom,time,onComplete)
    elseif SceneID == SceneManagerSceneID.World then
        GoToUtil.GotoWorldPos(createAction)
    end
end

function ResLackItemBase:GetTips()
    return self._config:getValue("tips") or 0
end

function ResLackItemBase:GetName()
    if (self._config == nil) then
        return ""
    end
    local tips = self._config:getValue("tips") or 0
    local name = ""
    if tips == ResLackGoToType.Science then
        local template = DataCenter.ScienceTemplateManager:GetScienceTemplate(self._config:getValue("para1"))
        if template ~= nil then
            return Localization:GetString(self._config:getValue("name"),Localization:GetString(template.name))
        end
    elseif tips == ResLackGoToType.Build then
        local level = 0
        local buildId = self._config:getValue("para1")
        local buildData = DataCenter.BuildManager:GetFunbuildByItemID(buildId)
        if buildData ~= nil then
            level = buildData.level
        end
        return Localization:GetString(GetTableData(DataCenter.BuildTemplateManager:GetTableName(), buildId + level,"name"))
    elseif tips == ResLackGoToType.ResourceBagUse
            or tips == ResLackGoToType.HeroEquipItemUse then
        local itemId = 0
        local para1 = self._config:getValue("para1")
        local str = string.split(para1,";")
        for i = 1 ,#str do
            local item = DataCenter.ItemData:GetItemById(tonumber(str[i]))
            if item then
                itemId = tonumber(str[i])
                break
            end
        end
        if itemId ~= 0 then
            return DataCenter.ItemTemplateManager:GetName(itemId)
        end
    elseif tips == ResLackGoToType.ResourceBuyItem then
        local itemId = tonumber(self._config:getValue("para1"))
        if itemId ~= 0 then
            return DataCenter.ItemTemplateManager:GetName(itemId)
        end
    end
    name = self._config:getValue("name") or ""
    return Localization:GetString(name)
end


function ResLackItemBase:GetIcon()
    local tips = self._config:getValue("tips") or 0
    if tips == ResLackGoToType.Build then
        return DataCenter.BuildManager:GetBuildIconPath(self._config:getValue("para1"), 1), Vector3.New(0.5, 0.5, 0.5)
    elseif tips == ResLackGoToType.BuyPveStamina or tips == ResLackGoToType.GoBuildGetStamina then
        return DataCenter.RewardManager:GetPicByType(RewardType.FORMATION_STAMINA), Vector3.New(0.8, 0.8, 0.8)
    end
    
    local pic = self._config:getValue("pic") or ""
    if (string.IsNullOrEmpty(pic)) then
        return pic, Vector3.New(1,1,1)
    end
    if string.startswith(pic, "pic") then
        return string.format(LoadPath.BuildIconOutCity, pic), Vector3.New(1,1,1)
    end
    return string.format(LoadPath.ResLackIcons, pic), Vector3.New(1,1,1)
end

function ResLackItemBase:GetDesc()
    local tips = self._config:getValue("tips") or 0
    if tips == ResLackGoToType.ResourceBagUse
        or tips == ResLackGoToType.HeroEquipItemUse then
        local itemId = 0
        local para1 = self._config:getValue("para1")
        local str = string.split(para1,";")
        for i = 1 ,#str do
            local item = DataCenter.ItemData:GetItemById(tonumber(str[i]))
            if item then
                itemId = tonumber(str[i])
                break
            end
        end
        if itemId ~= 0 then
            return DataCenter.ItemTemplateManager:GetDes(itemId)
        end
    else
        if tips == ResLackGoToType.ResourceBuyItem then
            local itemId = tonumber(self._config:getValue("para1"))
            if itemId ~= 0 then
                return DataCenter.ItemTemplateManager:GetDes(itemId)
            end
        end
    end

    return Localization:GetString(self._config:getValue("des"))
end

function ResLackItemBase:GetGroup()
    if (self._config == nil) then
        return ""
    end
    local group = self._config:getValue("group") or ""
    return group
end

function ResLackItemBase:GetBtnNameType()
    local tips = self:GetTips()
    if tips == ResLackGoToType.ResourceBagBuy or tips == ResLackGoToType.BuildBuyItem or tips == ResLackGoToType.BuyPveStamina or tips == ResLackGoToType.ResBuyItem then    --钻石购买
        return 2
    else
        return 1
    end
end

function ResLackItemBase:GetId()
    return self._config:getValue("id")
end

function ResLackItemBase:GetTips()
    return self._config:getValue("tips")
end

function ResLackItemBase:GetBtnName()
    return Localization:GetString(self._config:getValue("btn_name"))
end

return ResLackItemBase