---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2021/6/10 17:41
---
local UIAllianceInviteListCtrl = BaseClass("UIAllianceInviteListCtrl", UIBaseCtrl)
local function CloseSelf(self)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIAllianceInviteList)
end

local function Close(self)
    UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

local function InitData(self)
    self:OnSendSearchMessage("",0)
end

local function OnSendSearchMessage(self,name,type)
    local lang = "en"
    local allianceData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
    if allianceData~=nil then
        local aLang = allianceData.language
        LocalController:instance():visitTable("language",function (k,v)
            local mark= v.mark
            local lang_id = v.lang_id
            if mark~=0 and lang_id == aLang then
                lang = v.lang_ma
            end
        end)
        --
        --local languageList = DataTable:GetCsvDt("language")
        --if languageList~=nil and languageList.Rows then
        --    table.walk(languageList.Rows,function (k,v)
        --        local mark= v:TryGetInt("mark")
        --        local lang_id = v:GetString("lang_id")
        --        if mark~=0 and lang_id == aLang then
        --            lang = v:GetString("lang_ma")
        --        end
        --    end)
        --end
    end
    SFSNetwork.SendMessage(MsgDefines.AllianceSearchUser,name,lang,1,type)
end
local function GetAllianceInviteIdList(self,sortType)
    return DataCenter.AllianceTempListManager:GetAllianceInviteIdList(sortType)
end

local function OnPlayerDetailClick(self,uid)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIPlayerInfo,{ anim = true, hideTop = true},uid)
end


UIAllianceInviteListCtrl.InitData = InitData
UIAllianceInviteListCtrl.CloseSelf = CloseSelf
UIAllianceInviteListCtrl.Close = Close
UIAllianceInviteListCtrl.OnPlayerDetailClick = OnPlayerDetailClick
UIAllianceInviteListCtrl.OnSendSearchMessage =OnSendSearchMessage
UIAllianceInviteListCtrl.GetAllianceInviteIdList = GetAllianceInviteIdList
return UIAllianceInviteListCtrl