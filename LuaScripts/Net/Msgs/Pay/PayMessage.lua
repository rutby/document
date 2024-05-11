---
--- Created by shimin.
--- DateTime: 2020/7/1 15:23
---
local PayMessage = BaseClass("PayAmazonMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
    base.OnCreate(self)
    self.sfsObj:PutUtfString("orderId", param.orderId)
    self.sfsObj:PutUtfString("productId", param.productId)
    self.sfsObj:PutUtfString("purchaseTime", param.purchaseTime)
    self.sfsObj:PutUtfString("signData", param.signData)
    self.sfsObj:PutUtfString("signature", param.signature)
    self.sfsObj:PutUtfString("itemId", param.itemId)

    local _currency = DataCenter.PayManager:__GetLocalCurrencyCode() or ""
    local _localPrice = DataCenter.PayManager:GetLocalCurrency(param.productId) or ""
    self.sfsObj:PutUtfString("pay_countryOfAccountOfPlatform", "")
    self.sfsObj:PutUtfString("pay_closingCurrency", _currency)
    self.sfsObj:PutUtfString("pay_PriceOfClosingCurrency", _localPrice)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    DataCenter.PayManager:PayMessageHandle(t)
end

PayMessage.OnCreate = OnCreate
PayMessage.HandleMessage = HandleMessage

return PayMessage