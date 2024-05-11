---
--- Created by shimin.
--- DateTime: 2020/6/29 20:30
---
local PayPtGoldMessage = BaseClass("PayPtGoldMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
    base.OnCreate(self)

    self.sfsObj:PutUtfString("itemId", param.itemId)
    self.sfsObj:PutUtfString("orderId", param.orderId)
    self.sfsObj:PutUtfString("productId", param.productId)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    DataCenter.PayManager:PayPtGoldMessageHandle(t)
end

PayPtGoldMessage.OnCreate = OnCreate
PayPtGoldMessage.HandleMessage = HandleMessage

return PayPtGoldMessage