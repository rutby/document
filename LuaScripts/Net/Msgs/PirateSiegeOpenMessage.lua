--开启战斗阶段

local  PirateSiegeOpenMessage = BaseClass("PirateSiegeOpenMessage", SFSBaseMessage)
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
        DataCenter.ActivityDonateSoldierManager:OnHandlePirateSiegeOpenMessage(t)
    end
end

PirateSiegeOpenMessage.OnCreate = OnCreate
PirateSiegeOpenMessage.HandleMessage = HandleMessage

return  PirateSiegeOpenMessage