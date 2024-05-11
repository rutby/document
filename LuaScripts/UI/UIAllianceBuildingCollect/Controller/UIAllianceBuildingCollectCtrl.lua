--UIAllianceCitySelectCtrl.lua

local UIAllianceBuildingCollectCtrl = BaseClass("UIAllianceBuildingCollectCtrl", UIBaseCtrl)

local function CloseSelf(self)
	UIManager.Instance:DestroyWindow(UIWindowNames.UIAllianceBuildingCollect)
end

local function Close(self)
	UIManager.Instance:DestroyWindowByLayer(UILayer.Normal, false)
end

UIAllianceBuildingCollectCtrl.CloseSelf = CloseSelf
UIAllianceBuildingCollectCtrl.Close = Close

return UIAllianceBuildingCollectCtrl