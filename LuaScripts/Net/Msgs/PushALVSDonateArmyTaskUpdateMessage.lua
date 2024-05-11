--捐兵任务进度或状态变化推送

--[[

	"taskId"
	"state"
	"num"

]]

local  PushALVSDonateArmyTaskUpdateMessage = BaseClass("PushALVSDonateArmyTaskUpdateMessage", SFSBaseMessage)
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
        DataCenter.ActivityALVSDonateSoldierManager:OnHandlePushALVSDonateArmyTaskUpdateMessage(t)
    end
end

PushALVSDonateArmyTaskUpdateMessage.OnCreate = OnCreate
PushALVSDonateArmyTaskUpdateMessage.HandleMessage = HandleMessage

return  PushALVSDonateArmyTaskUpdateMessage