---
--- Created by shimin.
--- DateTime: 2022/6/13 15:29
--- 英雄委托交付一个子任务
---
local PayForHeroEntrustMessage = BaseClass("PayForHeroEntrustMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
    base.OnCreate(self)
    if param ~= nil then
        self.sfsObj:PutInt("id", param.id)
        self.sfsObj:PutInt("index", param.index)--交付物品的index 从1开始
    end
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    DataCenter.HeroEntrustManager:PayForHeroEntrustHandle(t)
end

PayForHeroEntrustMessage.OnCreate = OnCreate
PayForHeroEntrustMessage.HandleMessage = HandleMessage

return PayForHeroEntrustMessage