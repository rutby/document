
local UICrossDesertServerCtrl = BaseClass("UICrossDesertServerCtrl", UIBaseCtrl)

local function CloseSelf(self)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UICrossDesertServer)
end

UICrossDesertServerCtrl.CloseSelf = CloseSelf

return UICrossDesertServerCtrl