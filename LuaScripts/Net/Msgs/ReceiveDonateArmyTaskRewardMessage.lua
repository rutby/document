--领取捐兵活动任务奖励

--[[

	传参
		无
	返回
		"reward"  		//sfs arr 领取获得的奖励

		"taskInfo"
			同上

]]

local ReceiveDonateArmyTaskRewardMessage = BaseClass("ReceiveDonateArmyTaskRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
    base.OnCreate(self)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)

    local errCode =  t["errorCode"]
    if errCode ~= nil then
        --错误码处理
        UIUtil.ShowTipsId(errCode)
        
    else
        --正常逻辑
        DataCenter.ActivityDonateSoldierManager:OnHandleReceiveDonateArmyTaskRewardMessage(t)
    end
end

ReceiveDonateArmyTaskRewardMessage.OnCreate = OnCreate
ReceiveDonateArmyTaskRewardMessage.HandleMessage = HandleMessage

return ReceiveDonateArmyTaskRewardMessage