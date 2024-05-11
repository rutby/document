---
--- 推送区域热点消息
--- Created by shimin
--- DateTime: 2023/3/3 15:11
---

local PushAreaHotNewAddMessage = BaseClass("PushAreaHotNewAddMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushAreaHotNewAddMessage:OnCreate()
    base.OnCreate(self)
end

function PushAreaHotNewAddMessage:HandleMessage(t)
    base.HandleMessage(self, t)
    DataCenter.WorldNewsDataManager:PushAreaHotNewAddHandle(t)
end
return PushAreaHotNewAddMessage