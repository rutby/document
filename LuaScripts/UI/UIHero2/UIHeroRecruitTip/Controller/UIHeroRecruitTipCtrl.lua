---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zhangliheng.
--- DateTime: 7/19/21 2:29 PM
---

local UIHeroRecruitTipCtrl = BaseClass("UIHeroRecruitTipCtrl", UIBaseCtrl)

function UIHeroRecruitTipCtrl:CloseSelf()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeroRecruitTip)
end

--获取奖池英雄列表
function UIHeroRecruitTipCtrl:GetDropRate(lotteryId)
    local lotteryData = DataCenter.LotteryDataManager:GetLotteryDataById(lotteryId)
    if lotteryData == nil or lotteryData.dropHeroInfo == nil then
        return {}
    end
    local rates = lotteryData.rates
    local heroRates = {}
    local itemRates = {}
    for groupId, rate in pairs(rates) do
        local templates = DataCenter.OfficerListTemplateManager:GetValidTemplateInGroup(groupId)
        local totalShowRate = 0
        for _, id in ipairs(templates) do
            local template = DataCenter.OfficerListTemplateManager:GetTemplate(id)
            totalShowRate = totalShowRate + template.show_rate
        end
        for _, id in ipairs(templates) do
            local template = DataCenter.OfficerListTemplateManager:GetTemplate(id)
            if template~=nil and template.hero_id~=nil then
                heroRates[id] = template.show_rate * rate / totalShowRate
            elseif template~=nil and template.good_id~=nil then
                itemRates[id] = template.show_rate * rate / totalShowRate
            end
        end
    end
    return heroRates, itemRates
end

function UIHeroRecruitTipCtrl:GetDropHeroRateList(lotteryId, heroRates)
    local result = {}
    
    if table.count(heroRates) > 0 then
        for k, v in pairs(heroRates) do
            local template = DataCenter.OfficerListTemplateManager:GetTemplate(k)
            if template ~= nil and template.hero_id ~= nil then
                local param = {}
                param.heroId = template.hero_id
                param.rate = string.GetFormattedPercentStrSpecial(v / 100)
                table.insert(result, param)
            end
        end
        local xmlName = HeroUtils.GetHeroXmlName()
        table.sort(result, function (a, b)
            local heroIdA = a.heroId
            local heroIdB = b.heroId
            local seasonA = toInt(GetTableData(xmlName, tonumber(heroIdA), "season"))
            local seasonB = toInt(GetTableData(xmlName, tonumber(heroIdB), "season"))
            if seasonA < seasonB then
                return true
            elseif seasonA == seasonB then
                local rarityA = GetTableData(xmlName, tonumber(heroIdA), "rarity")
                local rarityB = GetTableData(xmlName, tonumber(heroIdB), "rarity")
                if rarityA < rarityB then
                    return true
                elseif rarityA == rarityB then
                    local campA = GetTableData(xmlName, tonumber(heroIdA), "camp")
                    local campB = GetTableData(xmlName, tonumber(heroIdB), "camp")
                    if campA < campB then
                        return true
                    elseif campA == campB then
                        return false
                    end
                end
            end
            return false
        end)
    else
        local lotteryData = DataCenter.LotteryDataManager:GetLotteryDataById(lotteryId)
        if lotteryData == nil or lotteryData.dropHeroInfo == nil then
            return result
        end
        local dropList = string.split(lotteryData.dropHeroInfo, '|')
        for _, v in ipairs(dropList) do
            if v and v ~= '' then
                local vec = string.split(v, ";")
                if table.count(vec) == 2 then
                    local param = {}
                    param.heroId = tonumber(vec[1])
                    param.rate = vec[2].."%"
                    table.insert(result, param)
                elseif table.count(vec) == 1 then
                    local param = {}
                    param.heroId = tonumber(vec[1])
                    param.rate = ""
                    table.insert(result, param)
                end
            end
        end
    end
    
    return result
end

function UIHeroRecruitTipCtrl:GetDropItemRateList(itemRates)
    local result = {}
    for k,v in pairs(itemRates)do
        local template = DataCenter.OfficerListTemplateManager:GetTemplate(k)
        if template ~= nil and template.good_id ~= nil then
            local param = {}
            param.goodId = template.good_id
            param.rate = string.GetFormattedPercentStrSpecial(v / 100)
            param.num = template.good_num
            table.insert(result, param)
        end
    end

    return result
end

--获取奖池掉落概率 [key:英雄稀有度(1-3)或者道具(0标识)， value: 概率]
function UIHeroRecruitTipCtrl:GetDropRateInfo(lotteryId)
    local lotteryData = DataCenter.LotteryDataManager:GetLotteryDataById(lotteryId)
    if lotteryData == nil or lotteryData.dropInfo == nil then
        return nil
    end
    local textRateTitleKey = {[0]='110169', [1]='110122', [2]='110121', [3]='110120', [4]='110167'}
    local dict = {}
    local dropList = string.split(lotteryData.dropInfo, ';')
    for _, v in ipairs(dropList) do
        local dropItem = string.split(v, '|')
        if #dropItem >= 2 then
            local param = {}
            local rarity = toInt(dropItem[1])
            param.rate = dropItem[2].."%"
            param.title = textRateTitleKey[rarity] or ""
            param.icon = string.format(LoadPath.HeroListPath, "UI_Icon_Rarity_"..rarity)
            if rarity == 0 then
                param.icon = string.format(LoadPath.HeroRecruitPath, "Drawcard_icon_all")
            end
            table.insert(dict, param)
            --dict[tonumber(dropItem[1])] = dropItem[2]
        end
    end
    
    return dict
end

--获取奖池掉落的英雄阵营列表
function UIHeroRecruitTipCtrl:GetDropCampInfo(lotteryId)
    local lotteryData = DataCenter.LotteryDataManager:GetLotteryDataById(lotteryId)
    if lotteryData == nil or lotteryData.dropCampInfo == nil then
        return {}
    end

    local campList = string.split(lotteryData.dropCampInfo, '|')
    return campList
end

return UIHeroRecruitTipCtrl