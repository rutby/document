--- Created by shimin.
--- DateTime: 2023/11/9 21:05
--- 英雄背景故事奖励

local HeroStarStoryManager = BaseClass("HeroStarStoryManager")

function HeroStarStoryManager:__init()
end

function HeroStarStoryManager:__delete()
end

function HeroStarStoryManager:Startup()
end


--初始化信息
function HeroStarStoryManager:InitData(message)

end

--领取奖励
function HeroStarStoryManager:SendGetStoryRewardParam(heroId, curIndex)
	SFSNetwork.SendMessage(MsgDefines.HeroStarStory, heroId, curIndex)
end

--更新领取状态
function HeroStarStoryManager:updateRewardStateHandle(message)
    local errCode = message["errorCode"]
    local heroId = message["heroId"]
    if errCode == nil and  heroId ~= nil then
        local heroData = DataCenter.HeroDataManager:GetHeroById(heroId)
        if heroData ~= nil then
            heroData:UpdateBackStoryRewarDict(message["index"])
			EventManager:GetInstance():Broadcast(EventId.HeroStarStoryResult)
            EventManager:GetInstance():Broadcast(EventId.HeroStationUpdate)
        else

        end
        DataCenter.RewardManager:ShowCommonReward(message)
		 if message["reward"] ~= nil then
            for k,v in pairs(message["reward"]) do
                DataCenter.RewardManager:AddOneReward(v)
            end
        end
       EventManager:GetInstance():Broadcast(EventId.ResourceUpdated)
    else
        UIUtil.ShowTipsId(errCode)
    end
  
end

return HeroStarStoryManager
