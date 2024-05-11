local UIHospitalCtrl = BaseClass("UIHospitalCtrl", UIBaseCtrl)

local function CloseSelf(self)
	if self.curScene ~= nil and self.curScene == CurScene.PVEScene then --在PVE界面，不显示主UI
		UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHospital, {anim = false, UIMainAnim = UIMainAnimType.AllHide})
	else
		UIManager.Instance:DestroyWindow(UIWindowNames.UIHospital)
	end
end

local function Close(self)
	UIManager.Instance:DestroyWindowByLayer(UILayer.Background, false)
end

local function GetHospitalQueue(self)
	return DataCenter.QueueDataManager:GetQueueByType(NewQueueType.Hospital)
end

local function InitData(self, curScene)
	self.curScene = curScene or nil
end

UIHospitalCtrl.CloseSelf = CloseSelf
UIHospitalCtrl.Close = Close
UIHospitalCtrl.GetHospitalQueue = GetHospitalQueue
UIHospitalCtrl.InitData = InitData

return UIHospitalCtrl