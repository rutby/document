---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by mac.
--- DateTime: 7/22/21 2:48 PM
---
local UIAlLeaderCongratulateCtrl = BaseClass("UIAlLeaderCongratulateCtrl", UIBaseCtrl)

local function CloseSelf(self)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIAlLeaderCongratulate)
end

local function Close(self)
    UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

UIAlLeaderCongratulateCtrl.CloseSelf = CloseSelf
UIAlLeaderCongratulateCtrl.Close = Close

return UIAlLeaderCongratulateCtrl