local UIActMonsterTowerRankCtrl = BaseClass("UIActMonsterTowerRankCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
	UIManager.Instance:DestroyWindow(UIWindowNames.UIActMonsterTowerRank)
end

local function Close(self)
	UIManager.Instance:DestroyWindowByLayer(UILayer.Normal, false)
end

UIActMonsterTowerRankCtrl.CloseSelf = CloseSelf
UIActMonsterTowerRankCtrl.Close = Close
return UIActMonsterTowerRankCtrl