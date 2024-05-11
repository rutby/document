---
--- Created by zzl.
--- DateTime: 
---
local UIWoundedCompensateCtrl = BaseClass("UIWoundedCompensateCtrl", UIBaseCtrl)


local function CloseSelf(self)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIWoundedCompensate, {anim = true})
end

local function Close(self)
    UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

local function JumpToActivity(self, overviewInfo)
    --self:CloseSelf()
    DataCenter.DailyActivityManager:JumpToActOverview(overviewInfo.type)
end


UIWoundedCompensateCtrl.CloseSelf = CloseSelf
UIWoundedCompensateCtrl.Close = Close
UIWoundedCompensateCtrl.JumpToActivity = JumpToActivity

return UIWoundedCompensateCtrl