---
--- Created by shimin.
--- DateTime: 2020/6/29 19:00
---
local PayBeforeCheckMessage = BaseClass("PayBeforeCheckMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, productId, payCurrency, chooseItem, isRegister,steamId,language)
    base.OnCreate(self)

    self.sfsObj:PutUtfString("productId", productId)
    self.sfsObj:PutUtfString("payCurrency", payCurrency)
    if chooseItem ~= nil and chooseItem ~= "" then
        self.sfsObj:PutUtfString("chooseItem", chooseItem)
    end
    if isRegister ~= 0 then
        self.sfsObj:PutInt("isRegister", 1)
    else
        self.sfsObj:PutInt("isRegister", 0)
    end
    if steamId~=nil and language~=nil then
        self.sfsObj:PutUtfString("steamId",steamId)
        self.sfsObj:PutUtfString("language",language)
    end
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    local errCode =  t["errorCode"]
    if errCode ~= nil then
        if tostring(errCode) == "120397" then
            UIUtil.ShowTips(Localization:GetString(errCode, t["errorPara2"]))
        else
            UIUtil.ShowTipsId(errCode) 
        end
    else
        DataCenter.PayManager:PayBeforeCheckMessageHandle(t)
    end
    
end

PayBeforeCheckMessage.OnCreate = OnCreate
PayBeforeCheckMessage.HandleMessage = HandleMessage

return PayBeforeCheckMessage