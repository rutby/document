---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by guqu.
--- DateTime: 2020/7/15 15:38
---

local UIResourceBagCtrl = BaseClass("UIResourceBagCtrl", UIBaseCtrl)

local function CloseSelf(self)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIResourceBag)
end

local function Close(self)
    UIManager:GetInstance():DestroyWindowByLayer(UILayer.Background)
end

local function GetQuickPackageInfo(self, resourceType)
    local packageTb = GiftPackageData.GetResourcePacks(resourceType)
    if packageTb and #packageTb > 0 then
        return packageTb[1]
    end
end

local function BuyGift(self,info)
    DataCenter.PayManager:CallPayment(info, UIWindowNames.UIResourceBag)
end

UIResourceBagCtrl.CloseSelf =CloseSelf
UIResourceBagCtrl.Close =Close

UIResourceBagCtrl.GetQuickPackageInfo = GetQuickPackageInfo
UIResourceBagCtrl.BuyGift = BuyGift

return UIResourceBagCtrl