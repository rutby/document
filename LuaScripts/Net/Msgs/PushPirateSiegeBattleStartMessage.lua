--开启战斗阶段

local  PushPirateSiegeBattleStartMessage = BaseClass("PushPirateSiegeBattleStartMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, soldiers)
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
        DataCenter.ActivityDonateSoldierManager:OnHandlePushPirateSiegeBattleStart(t)
    end
end

PushPirateSiegeBattleStartMessage.OnCreate = OnCreate
PushPirateSiegeBattleStartMessage.HandleMessage = HandleMessage

return  PushPirateSiegeBattleStartMessage