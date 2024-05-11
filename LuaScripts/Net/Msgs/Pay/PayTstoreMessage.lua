---
--- Created by shimin.
--- DateTime: 2020/6/30 20:47
---
local PayTstoreMessage = BaseClass("PayTstoreMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
    base.OnCreate(self)
    self.sfsObj:PutUtfString("txid", param.txid)
    self.sfsObj:PutUtfString("signdata", param.signdata)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    DataCenter.PayManager:PayTstoreMessageHandle(t)
    
end

PayTstoreMessage.OnCreate = OnCreate
PayTstoreMessage.HandleMessage = HandleMessage

return PayTstoreMessage