local UIActMonsterTowerTaskCtrl = BaseClass("UIActMonsterTowerTaskCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
	UIManager.Instance:DestroyWindow(UIWindowNames.UIActMonsterTowerTask)
end

local function Close(self)
	UIManager.Instance:DestroyWindowByLayer(UILayer.Normal, false)
end

UIActMonsterTowerTaskCtrl.CloseSelf = CloseSelf
UIActMonsterTowerTaskCtrl.Close = Close
return UIActMonsterTowerTaskCtrl