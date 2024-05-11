-- 获取捐兵世界面板信息


local GetDonateArmyInfoMessage = BaseClass("GetDonateArmyInfoMessage", SFSBaseMessage)
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
        DataCenter.ActivityDonateSoldierManager:OnGetDonateSoldierInfoViewData(t)
    end

end

GetDonateArmyInfoMessage.OnCreate = OnCreate
GetDonateArmyInfoMessage.HandleMessage = HandleMessage

return GetDonateArmyInfoMessage