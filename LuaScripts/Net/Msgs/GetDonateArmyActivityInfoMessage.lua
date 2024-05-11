-- 获取捐兵活动信息

--[[
    传参
		无
	返回
		"stageArr"              //sfs arr 贡献奖励信息
		[
			"id"				//int
			"normalReward"      //sfs arr 初级奖励
			[]
			"specialReward"		//sfs arr 精英奖励
			[]
			"normalState"		//int 初级奖励领取状态 0未领取 1已领取
			"specialState"		//int 精英奖励领取状态 0未领取 1已领取
			"needAllianceScore" 	//long 领奖需要的联盟积分
			"needUserScore" 		//long 领奖需要的个人积分
			"goodsId"			//string 解锁精英奖励需要的道具id
			"goodsNum"			//int 需要的道具数量
		]
		"soldierScoreArr"       //sfs arr 捐兵对应积分
		[
            "armyId"            //string 兵种id
            "score"             //int 一个兵加的分
		]
		"taskInfo"				//sfs obj 捐兵任务信息
		{
			"taskId"			//int 任务id  当前没任务不下发该字段
			"num"				//int 任务进度 当前没任务不下发该字段
			"state"				//int 任务状态 0未完成 1完成未领奖 2已领奖 当前没任务不下发该字段
			"reward"            //sfs arr 任务奖励 当前没任务不下发该字段
			"maxTaskNum"		//int 最多累计任务数量
			"taskNum"           //int 当前剩余任务数量
			"nextRecoverTime"   //long 下次任务恢复时间 单位ms  当任务满时该字段值为0 
		}
		"expeditionOpenTime"    //long 远征开启时间
-- ]]

local GetDonateArmyActivityInfoMessage = BaseClass("GetDonateArmyActivityInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
    base.OnCreate(self)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)

    local errCode = t["errorCode"]
    if errCode ~= nil then
        --错误码处理
        UIUtil.ShowTipsId(errCode)

    else
        --正常逻辑
        DataCenter.ActivityDonateSoldierManager:OnHandleGetDonateArmyActivityInfoMessage(t)
    end

end

GetDonateArmyActivityInfoMessage.OnCreate = OnCreate
GetDonateArmyActivityInfoMessage.HandleMessage = HandleMessage

return GetDonateArmyActivityInfoMessage