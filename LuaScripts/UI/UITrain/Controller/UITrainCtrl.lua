local UITrainCtrl = BaseClass("UITrainCtrl", UIBaseCtrl)

function UITrainCtrl:CloseSelf()
	UIManager.Instance:DestroyWindow(UIWindowNames.UITrain)
end

--点击训练按钮后关闭界面
function UITrainCtrl:IsClosePanelWhenTrain()
	local needMainLv = LuaEntry.DataConfig:TryGetNum("train_troop_close_level", "k1")
	if needMainLv >= DataCenter.BuildManager.MainLv then
		return true
	end
	return false
end

return UITrainCtrl