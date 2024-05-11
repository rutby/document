--- Created by shimin.
--- DateTime: 2023/6/1 19:27
--- 锁英雄插件
---
local LockHeroPluginMessage = BaseClass("LockHeroPluginMessage", SFSBaseMessage)
local base = SFSBaseMessage

function LockHeroPluginMessage:OnCreate(param)
    base.OnCreate(self)
    if param ~= nil then
        self.sfsObj:PutLong("heroUuid", param.heroUuid)--long 英雄uuid
        self.sfsObj:PutInt("index", param.index)--int 插件下标 
    end
end

function LockHeroPluginMessage:HandleMessage(t)
    base.HandleMessage(self, t)
    DataCenter.HeroPluginManager:LockHeroPluginHandle(t)
end

return LockHeroPluginMessage