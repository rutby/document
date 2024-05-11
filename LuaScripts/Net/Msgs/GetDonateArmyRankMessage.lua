-- 获取捐兵世界面板信息


local GetDonateArmyRankMessage = BaseClass("GetDonateArmyRankMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, type)
    base.OnCreate(self)

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
        DataCenter.ActivityDonateSoldierManager:OnGetDonateSoldierRankData(t)
    end

end

GetDonateArmyRankMessage.OnCreate = OnCreate
GetDonateArmyRankMessage.HandleMessage = HandleMessage

return GetDonateArmyRankMessage