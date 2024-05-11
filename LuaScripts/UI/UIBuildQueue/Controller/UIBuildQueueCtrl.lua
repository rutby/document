--- Created by shimin.
--- DateTime: 2023/12/20 15:26
--- 建筑队列界面

local UIBuildQueueCtrl = BaseClass("UIBuildQueueCtrl", UIBaseCtrl)

function UIBuildQueueCtrl:CloseSelf()
	UIManager:GetInstance():DestroyWindow(UIWindowNames.UIBuildQueue)
end

return UIBuildQueueCtrl