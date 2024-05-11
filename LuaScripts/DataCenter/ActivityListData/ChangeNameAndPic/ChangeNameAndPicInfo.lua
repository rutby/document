--- Created by shimin.
--- DateTime: 2023/10/9 17:41
--- 改头换面活动数据

local ChangeNameAndPicInfo = BaseClass("ChangeNameAndPicInfo")

function ChangeNameAndPicInfo:__init()
    self.activityId = 0--活动id
    self.changeName = ChangeNameAndPicType.No--int 是否改过名 0 1
    self.uploadPic = ChangeNameAndPicType.No--int 是否上传过头像 0 1
    self.reward = {}-- sfs arr 活动奖励
    self.rewardStatus = ChangeNameAndPicType.No--int 是否领取过奖励 0 1
end

function ChangeNameAndPicInfo:__delete()
    self.activityId = 0--活动id
    self.changeName = ChangeNameAndPicType.No--int 是否改过名 0 1
    self.uploadPic = ChangeNameAndPicType.No--int 是否上传过头像 0 1
    self.reward = {}-- sfs arr 活动奖励
    self.rewardStatus = ChangeNameAndPicType.No--int 是否领取过奖励 0 1
end

function ChangeNameAndPicInfo:ParseInfo(message)
    if message["activityId"] ~= nil then
        self.activityId = message["activityId"]
    end
    if message["changeName"] ~= nil then
        self.changeName = message["changeName"]
    end
    if message["uploadPic"] ~= nil then
        self.uploadPic = message["uploadPic"]
    end
    if message["reward"] ~= nil then
        self.reward = DataCenter.RewardManager:ReturnRewardParamForView(message["reward"])
    end
    if message["rewardStatus"] ~= nil then
        self.rewardStatus = message["rewardStatus"]
    end
end

return ChangeNameAndPicInfo