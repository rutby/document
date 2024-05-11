-- 新捐兵宣战请求

local PushALVSDonateArmyBattleStart = BaseClass("PushALVSDonateArmyBattleStart", SFSBaseMessage)
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
        DataCenter.ActivityALVSDonateSoldierManager:OnHandlePushALVSDonateArmyBattleStart(t)
    end

end

PushALVSDonateArmyBattleStart.OnCreate = OnCreate
PushALVSDonateArmyBattleStart.HandleMessage = HandleMessage

return PushALVSDonateArmyBattleStart