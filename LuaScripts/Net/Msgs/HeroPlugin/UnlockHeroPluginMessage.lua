--- Created by shimin.
--- DateTime: 2023/6/1 19:27
--- 解锁英雄插件
---
local UnlockHeroPluginMessage = BaseClass("UnlockHeroPluginMessage", SFSBaseMessage)
local base = SFSBaseMessage

function UnlockHeroPluginMessage:OnCreate(param)
    base.OnCreate(self)
    if param ~= nil then
        self.sfsObj:PutLong("heroUuid", param.heroUuid)--long 英雄uuid
        self.sfsObj:PutInt("index", param.index)--int 插件下标
    end
end

function UnlockHeroPluginMessage:HandleMessage(t)
    base.HandleMessage(self, t)
    DataCenter.HeroPluginManager:UnlockHeroPluginHandle(t)
end

return UnlockHeroPluginMessage