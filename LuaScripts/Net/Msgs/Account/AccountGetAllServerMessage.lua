---
--- Created by zzl.
--- DateTime: 
---
--- 获取服务器列表
local AccountGetAllServerMessage = BaseClass("AccountGetAllServerMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self,type,page)
    base.OnCreate(self)
    self.sfsObj:PutInt("type", type)
    self.sfsObj:PutInt("page", page)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    if t["errorCode"] then
        UIUtil.ShowTipsId(t["errorCode"])
        return
    end
    DataCenter.AccountManager:AccountGetAllServerHandle(t)
end

AccountGetAllServerMessage.OnCreate = OnCreate
AccountGetAllServerMessage.HandleMessage = HandleMessage

return AccountGetAllServerMessage