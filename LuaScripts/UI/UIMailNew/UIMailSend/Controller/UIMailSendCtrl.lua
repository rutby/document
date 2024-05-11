---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by guq.
--- DateTime: 2020/12/17 22:10
---
local UIMailSendCtrl = BaseClass("UIMailSendCtrl", UIBaseCtrl)

local function CloseSelf(self)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIMailSend)
end

local function Close(self)
    UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

local function OnSendClick(self,type,uid,name,title,content, allianceId)
    local curTime = math.floor(UITimeManager:GetInstance():GetServerTime())
    if type == MailType.MAIL_SELF_SEND then
        SFSNetwork.SendMessage(MsgDefines.MailSend,name,title,content,"",uid,curTime,type)
    elseif type == MailType.MAIL_ALLIANCE_ALL then
        SFSNetwork.SendMessage(MsgDefines.MailSend,name,title,content,allianceId,"",curTime,type)
    elseif type == MailType.MAIL_PRESIDENT_SEND then
        SFSNetwork.SendMessage(MsgDefines.MailSend,"",title,content,"","",curTime,type)
    end
    UIUtil.ShowTipsId(GameDialogDefine.SEND_SUCCESS)
    self:CloseSelf()
end


UIMailSendCtrl.CloseSelf =CloseSelf
UIMailSendCtrl.Close =Close
UIMailSendCtrl.OnSendClick = OnSendClick
return UIMailSendCtrl