--捐士兵

--[[

	传参
		"soldiers"         //sfs arr
		[
			  "armyId"		//string 士兵id
			  "count"       //int 捐的数量	
		]
	返回
		"selfScore" 		  //long 自己的积分
		"selfAllianceScore"   //long 己方联盟积分

]]

local  ALVSDonateArmyMessage = BaseClass("ALVSDonateArmyMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, soldiers)
    base.OnCreate(self)

    local soldierArray = SFSArray.New()
    table.walk(soldiers,function (k,v)
        local obj = SFSObject.New()
        obj:PutUtfString("armyId", v.armyId)
        obj:PutInt("count", v.count)
        soldierArray:AddSFSObject(obj)
    end)
    self.sfsObj:PutSFSArray("soldiers", soldierArray)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)

    local errCode =  t["errorCode"]
    if errCode ~= nil then
        --错误码处理
        UIUtil.ShowTipsId(errCode)
        
    else
        --正常逻辑
        DataCenter.ActivityALVSDonateSoldierManager:OnHandleALVSDonateSoldierMessage(t)
        UIUtil.ShowTipsId(372818)
    end
end

ALVSDonateArmyMessage.OnCreate = OnCreate
ALVSDonateArmyMessage.HandleMessage = HandleMessage

return  ALVSDonateArmyMessage