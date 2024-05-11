-- 新捐兵宣战请求

local PushALVSDonateArmyMatchSuccess = BaseClass("PushALVSDonateArmyMatchSuccess", SFSBaseMessage)
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
        DataCenter.ActivityALVSDonateSoldierManager:OnHandlePushALVSDonateArmyMatchSuccess(t)
    end

end

PushALVSDonateArmyMatchSuccess.OnCreate = OnCreate
PushALVSDonateArmyMatchSuccess.HandleMessage = HandleMessage

return PushALVSDonateArmyMatchSuccess