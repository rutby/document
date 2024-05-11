--- Created by shimin.
--- DateTime: 2023/6/1 19:27
--- 保存英雄插件
---
local SaveHeroPluginMessage = BaseClass("SaveHeroPluginMessage", SFSBaseMessage)
local base = SFSBaseMessage

function SaveHeroPluginMessage:OnCreate(param)
    base.OnCreate(self)
    if param ~= nil then
        self.sfsObj:PutLong("heroUuid", param.heroUuid)--long 英雄uuid
        self.sfsObj:PutInt("type", param.type)--int 1 保留 2 丢弃
    end
end

function SaveHeroPluginMessage:HandleMessage(t)
    base.HandleMessage(self, t)
    DataCenter.HeroPluginManager:SaveHeroPluginHandle(t)
end

return SaveHeroPluginMessage