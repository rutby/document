
local UIHeroPosterExchangePopCtrl = BaseClass("UIHeroPosterExchangePopCtrl", UIBaseCtrl)

local function CloseSelf(self)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeroPosterExchangePop)
end

local function GetPanelData(self)
    
end

UIHeroPosterExchangePopCtrl.CloseSelf = CloseSelf
UIHeroPosterExchangePopCtrl.GetPanelData = GetPanelData

return UIHeroPosterExchangePopCtrl