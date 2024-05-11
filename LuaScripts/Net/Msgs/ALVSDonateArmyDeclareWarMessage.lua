-- 新捐兵宣战请求

local ALVSDonateArmyDeclareWarMessage = BaseClass("ALVSDonateArmyDeclareWarMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, allianceId, type)
    base.OnCreate(self)
    self.sfsObj:PutUtfString("allianceId", allianceId)
    self.sfsObj:PutInt("type", type)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)

    local errCode = t["errorCode"]
    if errCode ~= nil then
        --错误码处理
        UIUtil.ShowTipsId(errCode)

    else
        --正常逻辑
        DataCenter.ActivityALVSDonateSoldierManager:OnHandleALVSDonateArmyDeclareWarMessage(t)
    end

end

ALVSDonateArmyDeclareWarMessage.OnCreate = OnCreate
ALVSDonateArmyDeclareWarMessage.HandleMessage = HandleMessage

return ALVSDonateArmyDeclareWarMessage