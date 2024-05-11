---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2022/5/11 18:27
---GetCommonShopInfoMessage


local GetCommonShopInfoMessage = BaseClass("GetCommonShopInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, shopType, activityId)
    base.OnCreate(self)
    self.sfsObj:PutInt("type", shopType)
    if activityId then
        self.sfsObj:PutInt("activityId", activityId)
    end
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    local errCode =  t["errorCode"]
    if errCode ~= nil then
        UIUtil.ShowTipsId(errCode)
    else
        DataCenter.CommonShopManager:UpdateOneShopInfo(t)
    end
end

GetCommonShopInfoMessage.OnCreate = OnCreate
GetCommonShopInfoMessage.HandleMessage = HandleMessage

return GetCommonShopInfoMessage
