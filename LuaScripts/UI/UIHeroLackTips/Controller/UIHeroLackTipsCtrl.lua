---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2022/11/15 15:58
---

local UIHeroLackTipsCtrl = BaseClass("UIHeroLackTipsCtrl", UIBaseCtrl)

local function CloseSelf(self)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeroLackTips)
end

local function Close(self)
    UIManager:GetInstance():DestroyWindowByLayer(UILayer.Background)
end

local function GetPanelData(self, configs, heroId, needDebrisNum, onGo)
    local result = {}
    local configList = {}
    result["configList"] = configList
    result["heroId"] = heroId
    local debrisId = HeroUtils.GetHeroDebrisIdByHeroId(heroId)
    local template = DataCenter.ItemTemplateManager:GetItemTemplate(debrisId)

    if needDebrisNum == nil then
        needDebrisNum = HeroUtils.GetJigsawCost(debrisId)
    end
    result["needDebrisNum"] = needDebrisNum
    result["onGo"] = onGo
    result["debrisIcon"] = string.format(LoadPath.ItemPath, template.icon)
    result["debrisId"] = debrisId
    
    for _, v in ipairs(configs) do
        local configId = v.configId
        local template = DataCenter.HeroLackTipTemplateManager:GetTemplate(configId)
        local para = {}
        para.order = template.order
        para.name = template.name
        para.icon = string.format(LoadPath.ResLackIcons, template.pic)
        para.btn_name = template.btn_name
        para.id = template.id
        para.lackTipItem = v
        table.insert(configList, para)
    end
    
    table.sort(result, function (k, v)
        return k.order < v.order
    end)
    return result
end

UIHeroLackTipsCtrl.CloseSelf = CloseSelf
UIHeroLackTipsCtrl.Close = Close
UIHeroLackTipsCtrl.GetPanelData = GetPanelData

return UIHeroLackTipsCtrl