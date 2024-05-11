
local UIMoveCityCtrl = BaseClass("UIMoveCityCtrl", UIBaseCtrl)

local function CloseSelf(self)
	DataCenter.GuideManager:SetNoShowUIMain(GuideSetUIMainAnim.Show)
	UIManager:GetInstance():DestroyWindow(UIWindowNames.UIMoveCity,{anim = true,UIMainAnim = UIMainAnimType.ChangeAllShow})
	if CS.SceneManager.World then
		CS.SceneManager.World:QuitFocus(LookAtFocusTime)
	end
end

local function Close(self)
	UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end


UIMoveCityCtrl.CloseSelf = CloseSelf
UIMoveCityCtrl.Close = Close

return UIMoveCityCtrl