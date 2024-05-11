---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by guqu.
--- DateTime: 2020/11/13 15:40
---
local UIAllianceDetailCtrl = BaseClass("UIAllianceDetailCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIAllianceDetail,{anim = true})
end

local function Close(self)
    UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

local function SendSearchMessageToServer(self,type,page,key,language)

    SFSNetwork.SendMessage(MsgDefines.AlSearch,type,page,key,language)
end

local function GetAllianceData(self,uid)
    return DataCenter.AllianceTempListManager:GetSearchAllianceDataByUid(uid)
end

local function OnAllianceMemberClick(self,uid)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceMemberDetail,{ anim = true, isBlur = true },uid, AllianceMemberOpenType.OtherAlMember)
    self:CloseSelf()
end

local function OnLeaderMailClick(self,leaderUid,leaderName)
    if not leaderUid or leaderUid == "" then
        UIUtil.ShowTipsId(390870) 
        return
    end
    local userId = leaderUid
    local roomId = ChatManager2:GetInstance().Room:GetPrivateRoomByUserId(userId)
    local param = {}
    param["roomId"] = roomId
    param["userId"] = userId
    param["username"] = leaderName
    GoToUtil.GotoOpenView(UIWindowNames.UIChatNew,{anim = false, isBlur = true, hideTop = true ,UIMainAnim = UIMainAnimType.AllHide},param)
    
    --UIManager:GetInstance():OpenWindow(UIWindowNames.UIMailSend,{anim = true},MailType.MAIL_SELF_SEND,leaderUid,leaderName)
end

UIAllianceDetailCtrl.CloseSelf =CloseSelf
UIAllianceDetailCtrl.Close =Close
UIAllianceDetailCtrl.GetAllianceData =GetAllianceData
UIAllianceDetailCtrl.OnAllianceMemberClick =OnAllianceMemberClick
UIAllianceDetailCtrl.SendSearchMessageToServer =SendSearchMessageToServer
UIAllianceDetailCtrl.OnLeaderMailClick =OnLeaderMailClick
return UIAllianceDetailCtrl