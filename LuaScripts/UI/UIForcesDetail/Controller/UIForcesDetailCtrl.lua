local UIForcesDetailCtrl = BaseClass("UIForcesDetailCtrl", UIBaseCtrl)

local function CloseSelf(self)
	UIManager.Instance:DestroyWindow(UIWindowNames.UIForcesDetail,{anim = true,UIMainAnim = UIMainAnimType.ChangeAllShow})
end

local function CloseAll(self)
	UIManager.Instance:DestroyWindow(UIWindowNames.UIForcesDetail)
	UIManager.Instance:DestroyWindow(UIWindowNames.UIPlayerInfo)
end

local function Close(self)
	UIManager.Instance:DestroyWindowByLayer(UILayer.Normal, false)
end


UIForcesDetailCtrl.CloseSelf = CloseSelf
UIForcesDetailCtrl.Close = Close
UIForcesDetailCtrl.CloseAll = CloseAll

return UIForcesDetailCtrl