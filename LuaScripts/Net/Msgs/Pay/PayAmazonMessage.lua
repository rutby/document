---
--- Created by shimin.
--- DateTime: 2020/6/30 20:56
---
local PayAmazonMessage = BaseClass("PayAmazonMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
    base.OnCreate(self)

    self.sfsObj:PutUtfString("orderId", param.orderId)
    self.sfsObj:PutUtfString("productType", param.productType)
    self.sfsObj:PutUtfString("sku", param.sku)
    self.sfsObj:PutUtfString("itemId", param.itemId)
    self.sfsObj:PutUtfString("amazonUserId", param.amazonUserId)
    self.sfsObj:PutUtfString("purchaseTime", param.purchaseTime)
    if param.toUID ~= nil and param.toUID ~= "" then
        --送礼包给某人
        self.sfsObj:PutUtfString("toUID", param.toUID)
    end
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    DataCenter.PayManager:PayMessageHandle(t)
end

PayAmazonMessage.OnCreate = OnCreate
PayAmazonMessage.HandleMessage = HandleMessage

return PayAmazonMessage