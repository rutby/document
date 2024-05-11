--- Created by shimin.
--- DateTime: 2023/9/19 11:27
--- 英雄选择阵营

local HeroChooseCampMessage = BaseClass("HeroChooseCampMessage", SFSBaseMessage)
local base = SFSBaseMessage

function HeroChooseCampMessage:OnCreate(param)
    base.OnCreate(self)
    self.sfsObj:PutLong("heroUuid", param.heroUuid)
    self.sfsObj:PutInt("chooseCamp", param.chooseCamp)
end

function HeroChooseCampMessage:HandleMessage(message)
    base.HandleMessage(self, message)
    DataCenter.HeroDataManager:HeroChooseCampHandle(message)
end

return HeroChooseCampMessage