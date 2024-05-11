--- Created by shimin.
--- DateTime: 2023/6/1 19:27
--- 随机英雄插件
---
local RefineHeroPluginMessage = BaseClass("RefineHeroPluginMessage", SFSBaseMessage)
local base = SFSBaseMessage

function RefineHeroPluginMessage:OnCreate(param)
    base.OnCreate(self)
    if param ~= nil then
        self.sfsObj:PutLong("heroUuid", param.heroUuid)--long 英雄uuid
    end
end

function RefineHeroPluginMessage:HandleMessage(t)
    base.HandleMessage(self, t)
    DataCenter.HeroPluginManager:RefineHeroPluginHandle(t)
end

return RefineHeroPluginMessage