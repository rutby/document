---
--- Created by shimin.
--- DateTime: 2020/7/1 11:20
---
local PayTestMessage = BaseClass("PayTestMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
    base.OnCreate(self)
    self.sfsObj:PutUtfString("itemId", param.itemId)
    self.sfsObj:PutUtfString("orderId", param.orderId)
    if param.selfOrderId ~= nil and param.selfOrderId ~= "" then
        self.sfsObj:PutUtfString("selfOrderId", param.selfOrderId)
    end
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    DataCenter.PayManager:PayMessageHandle(t,true)
end

PayTestMessage.OnCreate = OnCreate
PayTestMessage.HandleMessage = HandleMessage

return PayTestMessage