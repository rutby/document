--领取捐兵贡献奖励

--[[

	传参
		"type"         		//int 1领取初级奖励 2领取精英奖励
		"idArr"				//int arr stageArr里id的数组  领取全部的时候传多个

	返回
		"reward"		 	  //sfs arr 领取获得的奖励
		"type"         		  原样返回
		"idArr"

]]

local  ReceiveALVSDonateArmyStageRewardMessage = BaseClass("ReceiveALVSDonateArmyStageRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, type, idArray)
    base.OnCreate(self)

    local sfsIdArr = SFSArray.New()
    for _, v in pairs(idArray) do
        sfsIdArr:AddInt(v)
    end
    self.sfsObj:PutInt("type", type)
    self.sfsObj:PutSFSArray("idArr", sfsIdArr)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)

    local errCode =  t["errorCode"]
    if errCode ~= nil then
        --错误码处理
        UIUtil.ShowTipsId(errCode)
        
    else
        --正常逻辑
        DataCenter.ActivityALVSDonateSoldierManager:OnHandleALVSReceiveDonateArmyStageRewardMessage(t)
    end
end

ReceiveALVSDonateArmyStageRewardMessage.OnCreate = OnCreate
ReceiveALVSDonateArmyStageRewardMessage.HandleMessage = HandleMessage

return  ReceiveALVSDonateArmyStageRewardMessage