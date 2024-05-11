
local UIHeroAdvanceOneKeySuccessCtrl = BaseClass("UIHeroAdvanceOneKeySuccessCtrl", UIBaseCtrl)

local function CloseSelf(self)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeroAdvanceOneKeySuccess)
    EventManager:GetInstance():Broadcast(EventId.OnOneKeyAdvanceSuccessClosed)
end

local function GetPanelData(self, heroArr)
    local heroes = {}
    table.walk(heroArr, function (_, v)
        local heroInfo = DataCenter.HeroDataManager:GetHeroByUuid(v.uuid)
        if heroInfo ~= nil then
            table.insert(heroes, heroInfo)
        end
    end)

    local campA = nil
    local campB = nil
    table.sort(heroes, function(heroA, heroB)
        if heroA.quality ~= heroB.quality then
            return heroA.quality > heroB.quality
        end

        if heroA.level ~= heroB.level then
            return heroA.level > heroB.level
        end

        campA = heroA.camp
        campB = heroB.camp
        if campA ~= campB then
            return campA < campB
        end

        if heroA.rarity ~= heroB.rarity then
            return heroA.rarity < heroB.rarity
        end

        if heroA.heroId ~= heroB.heroId then
            return heroA.heroId < heroB.heroId
        end

        return heroA.uuid < heroB.uuid
    end)
    return heroes
end

UIHeroAdvanceOneKeySuccessCtrl.CloseSelf = CloseSelf
UIHeroAdvanceOneKeySuccessCtrl.GetPanelData = GetPanelData

return UIHeroAdvanceOneKeySuccessCtrl