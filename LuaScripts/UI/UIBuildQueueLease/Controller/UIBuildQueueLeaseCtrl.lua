--- Created by shimin.
--- DateTime: 2023/12/20 20:44
--- 租赁建筑队列界面

local UIBuildQueueLeaseCtrl = BaseClass("UIBuildQueueLeaseCtrl", UIBaseCtrl)

function UIBuildQueueLeaseCtrl:CloseSelf()
	UIManager:GetInstance():DestroyWindow(UIWindowNames.UIBuildQueueLease)
end

return UIBuildQueueLeaseCtrl