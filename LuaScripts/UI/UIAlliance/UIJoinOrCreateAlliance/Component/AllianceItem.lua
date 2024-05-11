---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by guqu.
--- DateTime: 2020/7/24 10:47
---
local AllianceItem = BaseClass("AllianceItem",UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local AllianceFlagItem = require "UI.UIAlliance.UIAllianceFlag.Component.AllianceFlagItem"

local name_path = "nameTxt"
local power_path = "powerTxt"
local people_path = "peopleTxt"
local language_path = "languageTxt"
local flag_path = "flag/AllianceFlag"
local join_btn_path = "JoinButton"
local join_txt_path = "JoinButton/joinText"
local apply_btn_path = "ApplyButton"
local apply_txt_path = "ApplyButton/applyText"
local cancel_btn_path = "CancelButton"
local cancel_txt_path = "CancelButton/cancelText"
local state_obj_path = "stateObj"
local state_text_path = "stateObj/stateText"
local btn_path = "button"
local function OnCreate(self)
    base.OnCreate(self)
    self.name = self:AddComponent(UITextMeshProUGUIEx,name_path)
    self.power = self:AddComponent(UITextMeshProUGUIEx,power_path)
    self.people = self:AddComponent(UITextMeshProUGUIEx,people_path)
    self.language = self:AddComponent(UITextMeshProUGUIEx,language_path)
    self.flag = self:AddComponent(AllianceFlagItem,flag_path)

    self.join_btn = self:AddComponent(UIButton, join_btn_path)
    self.join_btn:SetActive(false)
    self.join_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnClickJoin()
    end)
    self.join_txt = self:AddComponent(UITextMeshProUGUIEx, join_txt_path)
    self.join_txt:SetLocalText(110037)
    self.apply_btn = self:AddComponent(UIButton, apply_btn_path)
    self.apply_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnClickApply()
    end)
    self.apply_txt = self:AddComponent(UITextMeshProUGUIEx, apply_txt_path)
    self.apply_txt:SetLocalText(110090)
    self.apply_btn:SetActive(false)
    self.cancel_btn = self:AddComponent(UIButton, cancel_btn_path)
    self.cancel_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnClickCancel()
    end)
    self.btn = self:AddComponent(UIButton, btn_path)
    self.btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnClickBtn()
    end)
    self.cancel_txt = self:AddComponent(UITextMeshProUGUIEx, cancel_txt_path)
    self.cancel_txt:SetLocalText(GameDialogDefine.CANCEL)
    self.cancel_btn:SetActive(false)

    self.state_obj = self:AddComponent(UIButton, state_obj_path)
    self.state_text = self:AddComponent(UITextMeshProUGUIEx, state_text_path)
end

local function SetItemShow(self, uid,checkType)
    self.allianceId = uid
    local allianceData = self.view.ctrl:GetOneAllianceByUid(self.allianceId)
    self.allianceData = allianceData
    self.name:SetText("[" .. allianceData.abbr .. "]" .. allianceData.allianceName)
    self.power:SetText(string.GetFormattedSeperatorNum(allianceData.fightPower))
    self.people:SetText(allianceData.curMember.."/"..allianceData.maxMember)
    
    if allianceData.language~=nil and allianceData.language~="" then
        self.language:SetLocalText(allianceData.language) 
    else
        self.language:SetLocalText(390254) 
    end
    self.flag:SetData(allianceData.icon)
    if checkType == 0 then
        self.state_obj:SetActive(false)
        if allianceData.applied == 1 then
            self.cancel_btn:SetActive(true)
            self.apply_btn:SetActive(false)
            self.join_btn:SetActive(false)
        elseif allianceData.recruitTotal == 1 then
            self.cancel_btn:SetActive(false)
            self.apply_btn:SetActive(true)
            self.join_btn:SetActive(false)
        else
            self.cancel_btn:SetActive(false)
            self.apply_btn:SetActive(false)
            self.join_btn:SetActive(true)
        end
    else
        self.state_obj:SetActive(true)
        self.cancel_btn:SetActive(false)
        self.apply_btn:SetActive(false)
        self.join_btn:SetActive(false)
        if allianceData.recruitTotal == 1 then
            self.state_text:SetLocalText(390798)
        else
            self.state_text:SetLocalText(390797)
        end
    end
    
end


local function OnClickApply(self)
    self.view.ctrl:SendApplyMessageToServer(self.allianceData.uid,1,self.allianceData.language)
    self.cancel_btn:SetActive(true)
    self.apply_btn:SetActive(false)
    self.join_btn:SetActive(false)
end
local function OnClickCancel(self)
    self.view.ctrl:SendCancelApplyMessageToServer(self.allianceData.uid)
    self.cancel_btn:SetActive(false)
    self.apply_btn:SetActive(true)
    self.join_btn:SetActive(false)
end

local function OnClickJoin(self)
    self.view.ctrl:SendApplyMessageToServer(self.allianceData.uid,0,self.allianceData.language)
end

local function OnClickBtn(self)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceDetail,{ anim = true, isBlur = true}, self.allianceData.allianceName, self.allianceData.uid)
end

local function OnAddListener(self)
    base.OnAddListener(self)
    self:AddUIListener(EventId.CLICK_ALLIANCE_ITEM, self.OnApplyAllianceBack)
end

local function OnRemoveListener(self)
    base.OnRemoveListener(self)
    self:RemoveUIListener(EventId.CLICK_ALLIANCE_ITEM, self.OnApplyAllianceBack)
end

local function OnApplyAllianceBack(self,data)
    if self.allianceId == data then
        local allianceData = self.view.ctrl:GetOneAllianceByUid(self.allianceId)
        self.allianceData = allianceData
        self.state_obj:SetActive(false)
        if allianceData.applied == 1 then
            self.cancel_btn:SetActive(true)
            self.apply_btn:SetActive(false)
            self.join_btn:SetActive(false)
        elseif allianceData.recruitTotal == 1 then
            self.cancel_btn:SetActive(false)
            self.apply_btn:SetActive(true)
            self.join_btn:SetActive(false)
        else
            self.cancel_btn:SetActive(false)
            self.apply_btn:SetActive(false)
            self.join_btn:SetActive(true)
        end
    end
end
AllianceItem.OnCreate = OnCreate
AllianceItem.SetItemShow = SetItemShow
AllianceItem.OnClickJoin =OnClickJoin
AllianceItem.OnClickCancel =OnClickCancel
AllianceItem.OnClickApply = OnClickApply
AllianceItem.OnClickBtn =OnClickBtn
AllianceItem.OnAddListener =OnAddListener
AllianceItem.OnRemoveListener =OnRemoveListener
AllianceItem.OnApplyAllianceBack =OnApplyAllianceBack
return AllianceItem