-- 获取对决双方联盟成员积分信息

--[[

	传参
		无
	返回
		"rankArr"  			//sfs arr 玩家积分排行数据
		[
			"uid"
			"score"    			//long 积分
			"name"
			"pic"
			"picVer"	
			"headSkinId"
			"headSkinET"	
			"serverId" 			//int 玩家所属服
			"allianceId"        //string 联盟id
		]
		"scoreInfo"				// sfs obj 积分数据    
		{
			"selfScore" 		  //long 自己的积分
			"selfAllianceScore"   //long 己方联盟积分
			"vsAllianceScore"     //long 敌方联盟积分
		}

]]

local GetDonateArmyScoreInfoMessage = BaseClass("GetDonateArmyScoreInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
    base.OnCreate(self)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)

    local errCode =  t["errorCode"]
    if errCode ~= nil then
        --错误码处理
        UIUtil.ShowTipsId(errCode)
        
    else
        --正常逻辑
        DataCenter.ActivityDonateSoldierManager:OnHandleGetDonateArmyScoreInfoMessage(t)
    end
end

GetDonateArmyScoreInfoMessage.OnCreate = OnCreate
GetDonateArmyScoreInfoMessage.HandleMessage = HandleMessage

return GetDonateArmyScoreInfoMessage