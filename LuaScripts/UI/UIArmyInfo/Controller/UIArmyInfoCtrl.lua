local UIArmyInfoCtrl = BaseClass("UIArmyInfoCtrl", UIBaseCtrl)

local function CloseSelf(self)
	UIManager.Instance:DestroyWindow(UIWindowNames.UIArmyInfo, {anim = true,UIMainAnim = UIMainAnimType.ChangeAllShow})
end

local function Close(self)
	UIManager.Instance:DestroyWindowByLayer(UILayer.Normal, false)
end

local function GetTotalArmyNum(self)
	return DataCenter.ArmyManager:GetTotalArmyNum()
end

local function GetTotalReserveArmyNum(self)
	return DataCenter.ArmyManager:GetReserveArmyNum()
end
UIArmyInfoCtrl.CloseSelf = CloseSelf
UIArmyInfoCtrl.Close = Close
UIArmyInfoCtrl.GetTotalArmyNum = GetTotalArmyNum
UIArmyInfoCtrl.GetTotalReserveArmyNum = GetTotalReserveArmyNum

return UIArmyInfoCtrl