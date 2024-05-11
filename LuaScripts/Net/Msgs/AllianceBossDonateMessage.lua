-- 获取联盟boss活动信息

local  AllianceBossDonateMessage = BaseClass("AllianceBossDonateMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, activityId, itemId, num)
    base.OnCreate(self)
    self.sfsObj:PutInt("activityId", activityId)
    self.sfsObj:PutInt("itemId", itemId)
    self.sfsObj:PutInt("num", num)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)

    local errCode =  t["errorCode"]
    if errCode ~= nil then
        --错误码处理
        UIUtil.ShowTipsId(errCode)
        
    else
        --正常逻辑
        DataCenter.AllianceBossManager:OnHandleAllianceBossDonateMessage(t)
    end
end

AllianceBossDonateMessage.OnCreate = OnCreate
AllianceBossDonateMessage.HandleMessage = HandleMessage

return  AllianceBossDonateMessage