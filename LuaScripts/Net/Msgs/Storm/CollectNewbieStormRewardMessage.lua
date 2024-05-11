--- 领取暴风雪奖励
--- Created by shimin.
--- DateTime: 2023/11/10 11:22
local CollectNewbieStormRewardMessage = BaseClass("CollectNewbieStormRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

function CollectNewbieStormRewardMessage:OnCreate(param)
    base.OnCreate(self)
    if param ~= nil then
        self.sfsObj:PutInt("newbieStormId", param.newbieStormId)
    end
end

function CollectNewbieStormRewardMessage:HandleMessage(t)
    base.HandleMessage(self, t)
    DataCenter.StormManager:CollectNewbieStormRewardHandle(t)
end

return CollectNewbieStormRewardMessage