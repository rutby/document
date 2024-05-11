---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by guqu.
--- DateTime: 2020/9/22 14:27
---
local UIAllianceOfficeSelectCtrl = BaseClass("UIAllianceOfficeSelectCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIAllianceOfficeSelect)
end

local function Close(self)
    UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

local function OnSetOfficial(self,uid,index)
    local officialNum = DataCenter.AllianceMemberDataManager:GetOfficialByUid(uid)
    local indexStr = tostring(index)
    if indexStr== officialNum and index>0 then
        UIUtil.ShowTipsId(360114) 
    elseif index>0 then
        SFSNetwork.SendMessage(MsgDefines.AllianceSetRank,uid,4,index)
    else
        local alliance = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
        SFSNetwork.SendMessage(MsgDefines.AllianceDeleteOffical,alliance.uid,4,tonumber(officialNum),uid)
    end
    self:CloseSelf()
end


UIAllianceOfficeSelectCtrl.CloseSelf =CloseSelf
UIAllianceOfficeSelectCtrl.Close =Close
UIAllianceOfficeSelectCtrl.OnSetOfficial = OnSetOfficial
return UIAllianceOfficeSelectCtrl