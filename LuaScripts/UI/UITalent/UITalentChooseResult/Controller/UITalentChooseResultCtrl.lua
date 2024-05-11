
local UITalentChooseResultCtrl = BaseClass("UITalentChooseResultCtrl", UIBaseCtrl)

local function CloseSelf(self)
	UIManager.Instance:DestroyWindow(UIWindowNames.UITalentChooseResult)
end

UITalentChooseResultCtrl.CloseSelf = CloseSelf
UITalentChooseResultCtrl.Close = Close

return UITalentChooseResultCtrl