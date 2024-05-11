---
--- Created by shimin.
--- DateTime: 2020/6/30 18:55
---
local PayIOSMessage = BaseClass("PayIOSMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
    base.OnCreate(self)

    self.sfsObj:PutUtfString("orderId", param.orderId)--平台生成
    self.sfsObj:PutUtfString("sSignedData", param.sSignedData)--平台验证
    self.sfsObj:PutUtfString("productId", param.productId)--zuanshi_1 zuanshi_2 ...
    self.sfsObj:PutUtfString("itemId", param.itemId)--9001 9902 ...
    local _currency = DataCenter.PayManager:__GetLocalCurrencyCode() or ""
    local _localPrice = DataCenter.PayManager:GetLocalCurrency(param.productId) or ""
    self.sfsObj:PutUtfString("pay_countryOfAccountOfPlatform", "")
    self.sfsObj:PutUtfString("pay_closingCurrency", _currency)
    self.sfsObj:PutUtfString("pay_PriceOfClosingCurrency", _localPrice)

    if param.toUID ~= nil and param.toUID ~= "" then
        --送礼包给某人
        self.sfsObj:PutUtfString("toUID", param.toUID)
    end
    if param.subscribeUid ~= nil and param.subscribeUid ~= "" then
        --订阅
        self.sfsObj:PutUtfString("subscribeUid", param.subscribeUid)
    end
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    DataCenter.PayManager:PayMessageHandle(t)
end

PayIOSMessage.OnCreate = OnCreate
PayIOSMessage.HandleMessage = HandleMessage

return PayIOSMessage