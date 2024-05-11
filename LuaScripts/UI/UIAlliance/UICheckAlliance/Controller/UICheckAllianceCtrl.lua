---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by guqu.
--- DateTime: 2020/7/24 10:47
---
local UICheckAllianceCtrl = BaseClass("UICheckAllianceCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization
local function CloseSelf(self)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UICheckAlliance)
end

local function Close(self)
    UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end


local function InitData(self)
    self:SendSearchMessageToServer(1,1,"",0, true)
end


local function GetAllianceIdList(self)
    local list = DataCenter.AllianceTempListManager:GetSearchAllianceIdList()
    return list
end

local function SendSearchMessageToServer(self,type,page,key,language, isRecommend)

    SFSNetwork.SendMessage(MsgDefines.AlSearch,type,page,key,language, isRecommend)
end


local function GetOneAllianceByUid(self,uid)
    return DataCenter.AllianceTempListManager:GetSearchAllianceDataByUid(uid)
end


UICheckAllianceCtrl.CloseSelf =CloseSelf
UICheckAllianceCtrl.Close =Close
UICheckAllianceCtrl.GetAllianceIdList =GetAllianceIdList
UICheckAllianceCtrl.InitData =InitData
UICheckAllianceCtrl.SendSearchMessageToServer =SendSearchMessageToServer
UICheckAllianceCtrl.GetOneAllianceByUid =GetOneAllianceByUid
return UICheckAllianceCtrl