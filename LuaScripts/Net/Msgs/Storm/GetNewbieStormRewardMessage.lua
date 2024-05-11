--- 获取暴风雪展示奖励
--- Created by shimin.
--- DateTime: 2023/11/10 11:22
local GetNewbieStormRewardMessage = BaseClass("GetNewbieStormRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GetNewbieStormRewardMessage:OnCreate(param)
    base.OnCreate(self)
    if param ~= nil then
        self.sfsObj:PutInt("newbieStormId", param.newbieStormId)
    end
end

function GetNewbieStormRewardMessage:HandleMessage(t)
    base.HandleMessage(self, t)
    DataCenter.StormManager:GetNewbieStormRewardHandle(t)
end

return GetNewbieStormRewardMessage