--- Created by shimin.
--- DateTime: 2024/2/27 11:47
--- 领取背景故事奖励 

local HeroStarStoryMessage = BaseClass("HeroStarStoryMessage", SFSBaseMessage)
local base = SFSBaseMessage

function HeroStarStoryMessage:OnCreate(heroId,index)
    base.OnCreate(self)
    self.sfsObj:PutInt("heroId", heroId)
    if index then
        self.sfsObj:PutInt("index", index)
    end
end

function HeroStarStoryMessage:HandleMessage(t)
    base.HandleMessage(self, t)
    DataCenter.HeroStarStoryManager:updateRewardStateHandle(t)
end

return HeroStarStoryMessage