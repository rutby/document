--UISeasonHeroPreviewCtrl.lua

local UISeasonHeroPreviewCtrl = BaseClass("UISeasonHeroPreviewCtrl", UIBaseCtrl)

local function CloseSelf(self)
	UIManager.Instance:DestroyWindow(UIWindowNames.UISeasonHeroPreview)
end

local function Close(self)
	UIManager.Instance:DestroyWindowByLayer(UILayer.Normal, false)
end


local function SortHero(self, heroConfigA, heroConfigB, redPointA, redPointB, isMap)
	if redPointA ~= redPointB then
		return redPointA == true
	end
	if heroConfigA == nil or heroConfigB == nil then
		return false
	end
	if heroConfigA == nil or heroConfigB == nil then
		return false
	end
	if heroConfigA.rarity ~= heroConfigB.rarity then
		return heroConfigA.rarity < heroConfigB.rarity
	end
	if isMap then
		if heroConfigA.season ~= heroConfigB.season then
			return heroConfigA.season > heroConfigB.season
		end
	end

	if heroConfigA.quality ~= heroConfigB.quality then
		return heroConfigA.quality > heroConfigB.quality
	end

	if heroConfigA.level ~= heroConfigB.level then
		return heroConfigA.level > heroConfigB.level
	end

	if heroConfigA.camp ~= heroConfigB.camp then
		return heroConfigA.camp < heroConfigB.camp
	end

	if heroConfigA.rarity ~= heroConfigB.rarity then
		return heroConfigA.rarity < heroConfigB.rarity
	end

	if heroConfigA.heroId ~= heroConfigB.heroId then
		return heroConfigA.heroId < heroConfigB.heroId
	end
	return false
end

UISeasonHeroPreviewCtrl.CloseSelf = CloseSelf
UISeasonHeroPreviewCtrl.Close = Close

UISeasonHeroPreviewCtrl.SortHero = SortHero

return UISeasonHeroPreviewCtrl