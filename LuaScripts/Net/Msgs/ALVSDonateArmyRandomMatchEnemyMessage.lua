-- 获取捐兵活动信息

local ALVSDonateArmyRandomMatchEnemyMessage = BaseClass("ALVSDonateArmyRandomMatchEnemyMessage", SFSBaseMessage)
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
        DataCenter.ActivityALVSDonateSoldierManager:OnHandleALVSDonateArmyRandomMatchEnemyMessage(t)
    end

end

ALVSDonateArmyRandomMatchEnemyMessage.OnCreate = OnCreate
ALVSDonateArmyRandomMatchEnemyMessage.HandleMessage = HandleMessage

return ALVSDonateArmyRandomMatchEnemyMessage