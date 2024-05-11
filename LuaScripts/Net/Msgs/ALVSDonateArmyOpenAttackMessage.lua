-- 新捐兵盟主或r4开启迎战

local ALVSDonateArmyOpenAttackMessage = BaseClass("ALVSDonateArmyOpenAttackMessage", SFSBaseMessage)
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
        DataCenter.ActivityALVSDonateSoldierManager:OnHandleALVSDonateArmyOpenAttackMessage(t)
    end
end

ALVSDonateArmyOpenAttackMessage.OnCreate = OnCreate
ALVSDonateArmyOpenAttackMessage.HandleMessage = HandleMessage

return ALVSDonateArmyOpenAttackMessage