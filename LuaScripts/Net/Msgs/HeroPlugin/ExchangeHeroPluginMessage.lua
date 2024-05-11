--- Created by shimin.
--- DateTime: 2023/6/1 19:27
--- 交换英雄插件
---
local ExchangeHeroPluginMessage = BaseClass("ExchangeHeroPluginMessage", SFSBaseMessage)
local base = SFSBaseMessage

function ExchangeHeroPluginMessage:OnCreate(param)
    base.OnCreate(self)
    if param ~= nil then
        self.sfsObj:PutLong("heroUuidA", param.heroUuidA)--long 英雄uuid
        self.sfsObj:PutLong("heroUuidB", param.heroUuidB)--long 英雄uuid
    end
end

function ExchangeHeroPluginMessage:HandleMessage(t)
    base.HandleMessage(self, t)
    DataCenter.HeroPluginManager:ExchangeHeroPluginHandle(t)
end

return ExchangeHeroPluginMessage