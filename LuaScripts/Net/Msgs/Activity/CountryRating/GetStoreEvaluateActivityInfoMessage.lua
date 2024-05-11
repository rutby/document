--- 
--- Created by zzl.
--- DateTime: 2023/10/18 18:33
---
local GetStoreEvaluateActivityInfoMessage = BaseClass("GetStoreEvaluateActivityInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GetStoreEvaluateActivityInfoMessage:OnCreate(activityId)
    base.OnCreate(self)
    self.sfsObj:PutInt("activityId",activityId)
end

function GetStoreEvaluateActivityInfoMessage:HandleMessage(t)
    base.HandleMessage(self, t)
    local errCode =  t["errorCode"]
    if errCode ~= nil then
        UIUtil.ShowTipsId(errCode)
    else
        DataCenter.CountryRatingData:ParseData(t)
    end
end

return GetStoreEvaluateActivityInfoMessage