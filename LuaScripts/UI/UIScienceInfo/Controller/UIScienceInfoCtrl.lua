local UIScienceInfoCtrl = BaseClass("UIScienceInfoCtrl", UIBaseCtrl)

local function CloseSelf(self)
	UIManager.Instance:DestroyWindow(UIWindowNames.UIScienceInfo,{anim = true})
end

local function Close(self)
	UIManager.Instance:DestroyWindowByLayer(UILayer.Background, false)
end

UIScienceInfoCtrl.CloseSelf = CloseSelf
UIScienceInfoCtrl.Close = Close

return UIScienceInfoCtrl