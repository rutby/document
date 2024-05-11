---
--- Created by zzl.
--- DateTime: 
---
local UIActivityOverviewCtrl = BaseClass("UIActivityOverviewCtrl", UIBaseCtrl)


local function CloseSelf(self)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIActivityOverview, {anim = true})
end

local function Close(self)
    UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

local function JumpToActivity(self, overviewInfo)
    DataCenter.DailyActivityManager:JumpToActOverview(overviewInfo.type)
end

UIActivityOverviewCtrl.CloseSelf = CloseSelf
UIActivityOverviewCtrl.Close = Close
UIActivityOverviewCtrl.JumpToActivity = JumpToActivity

return UIActivityOverviewCtrl