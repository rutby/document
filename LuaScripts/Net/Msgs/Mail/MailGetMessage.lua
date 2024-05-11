---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by mac.
--- DateTime: 1/18/22 12:29 PM
---
local MailGetMessage = BaseClass("MailGetMessage", SFSBaseMessage)

local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization
local function OnCreate(self, mailId, mailType, senderUid)
    base.OnCreate(self)
 
    self.sfsObj:PutUtfString("uid", mailId)
    self.sfsObj:PutUtfString("type", mailType)
    self.sfsObj:PutUtfString("toUser", senderUid)
end

local function HandleMessage(self, message)
    base.HandleMessage(self, message)
    if (message == nil or table.count(message.msg) == 0) then
        UIUtil.ShowTipsId(390508)
        return
    end 
    
    local serverData = message.msg[1]
    if not serverData then
        return
    end
    local mailInfo = require "DataCenter.MailData.MailInfo".New()
    mailInfo:ParseBaseData(serverData)
    if mailInfo.type == MailType.NEW_FIGHT or mailInfo.type == MailType.SHORT_KEEP_FIGHT_MAIL or mailInfo.type == MailType.ELITE_FIGHT_MAIL then
        local version = mailInfo:GetMailExt():GetVersion()
        if version==nil or version<=0 then
            UIUtil.ShowTipsId(390843)
            return
        end
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIShareMail, NormalBlurPanelAnim,mailInfo)
end

MailGetMessage.OnCreate = OnCreate
MailGetMessage.HandleMessage = HandleMessage

return MailGetMessage