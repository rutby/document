--- Created by shimin.
--- DateTime: 2023/7/19 10:36
--- 插件排行榜
---
local GetPluginRankMessage = BaseClass("GetPluginRankMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GetPluginRankMessage:OnCreate()
    base.OnCreate(self)
end

function GetPluginRankMessage:HandleMessage(t)
    base.HandleMessage(self, t)
    DataCenter.HeroPluginRankManager:GetPluginRankHandle(t)
end

return GetPluginRankMessage