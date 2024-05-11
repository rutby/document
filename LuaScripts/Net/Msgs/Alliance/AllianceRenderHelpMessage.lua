---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by guqu.
--- DateTime: 2020/9/11 19:21
---
local AllianceRenderHelpMessage = BaseClass("AllianceRenderHelpMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self,helpId,uid)
    base.OnCreate(self)
    self.sfsObj:PutUtfString("helpId",helpId)
    self.sfsObj:PutUtfString("uid",uid)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    local errCode =  t["errorCode"]
    if errCode ~= nil then
        UIUtil.ShowTipsId(errCode) 
    else
        DataCenter.AllianceHelpDataManager:OnFinishAllianceHelp(t["helpId"])
        EventManager:GetInstance():Broadcast(EventId.AllianceHelpSever)
        EventManager:GetInstance():Broadcast(EventId.UpdateAllianceHelpNum)
    end
end

AllianceRenderHelpMessage.OnCreate = OnCreate
AllianceRenderHelpMessage.HandleMessage = HandleMessage

return AllianceRenderHelpMessage