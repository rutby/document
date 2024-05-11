local UIRobotWarsIntroCtrl = BaseClass("UIRobotWarsIntroCtrl", UIBaseCtrl)

local robotWarsIntro = {
	{
		imgPath = "",
		desc = "110374",
	},
	{
		imgPath = "",
		desc = "110375",
	},
	{
		imgPath = "",
		desc = "110376",
	},
	{
		imgPath = "",
		desc = "110377",
	},
	{
		imgPath = "",
		desc = "110378",
	},
	{
		imgPath = "",
		desc = "110379",
	}
}

local function CloseSelf(self)
	UIManager.Instance:DestroyWindow(UIWindowNames.UIRobotWarsIntro)
end

local function Close(self)
	UIManager.Instance:DestroyWindowByLayer(UILayer.Normal, false)
end

local function GetIntroList(self)
	return robotWarsIntro
end

UIRobotWarsIntroCtrl.CloseSelf = CloseSelf
UIRobotWarsIntroCtrl.Close = Close
UIRobotWarsIntroCtrl.GetIntroList = GetIntroList

return UIRobotWarsIntroCtrl