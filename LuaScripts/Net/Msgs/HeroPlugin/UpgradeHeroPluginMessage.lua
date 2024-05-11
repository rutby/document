--- Created by shimin.
--- DateTime: 2023/6/1 19:27
--- 升级英雄插件
---
local UpgradeHeroPluginMessage = BaseClass("UpgradeHeroPluginMessage", SFSBaseMessage)
local base = SFSBaseMessage

function UpgradeHeroPluginMessage:OnCreate(param)
    base.OnCreate(self)
    if param ~= nil then
        self.sfsObj:PutLong("heroUuid", param.heroUuid)--long 英雄uuid
    end
end

function UpgradeHeroPluginMessage:HandleMessage(t)
    base.HandleMessage(self, t)
    DataCenter.HeroPluginManager:UpgradeHeroPluginHandle(t)
end

return UpgradeHeroPluginMessage