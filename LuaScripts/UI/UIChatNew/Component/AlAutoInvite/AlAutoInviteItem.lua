---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2022/7/14 17:39
---

local AlAutoInviteItem = BaseClass("AlAutoInviteItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local AllianceFlagItem = require "UI.UIAlliance.UIAllianceFlag.Component.AllianceFlagItem"
local ChatUserName = require "UI.UIChatNew.Component.ChatItem.ChatUserName"

local chatShareNode_path = "ChatShareNode"
local shareTitle_path = "ChatShareNode/Image/ShareTitle"
local countryFlag_path = "ChatShareNode/inviteNode/countryFlag"
local allianceFlag_path = "ChatShareNode/inviteNode/AllianceFlag"
local recruitTip_path = "ChatShareNode/inviteNode/announce"
local peopleNum_path = "ChatShareNode/inviteNode/people/peopleNum"
local detailBtn_path = "ChatShareNode/inviteNode/detailBtn"
local detailBtnTxt_path = "ChatShareNode/inviteNode/detailBtn/detailBtnTxt"
local joinBtn_path = "ChatShareNode/inviteNode/joinBtn"
local joinBtnTxt_path = "ChatShareNode/inviteNode/joinBtn/joinBtnTxt"
local playerHead_path = "ChatHead/Image"
local playerHeadFg_path = "ChatHead/HeadFg"
local playerNation_path = "ChatHead/nation"
local _cp_chatNameLayout = "ChatNameLayout"
local playerHeadBtn_path = "ChatHead"

-- 创建
local function OnCreate(self)
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

-- 销毁
local function OnDestroy(self)
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

--控件的定义
local function ComponentDefine(self)
    self.chatShareNodeN = self:AddComponent(UIBaseContainer, chatShareNode_path)
    self.shareTitleN = self:AddComponent(UIText, shareTitle_path)
    self.countryFlagN = self:AddComponent(UIImage, countryFlag_path)
    self.allianceFlagN = self:AddComponent(AllianceFlagItem, allianceFlag_path)
    self.recruitTipN = self:AddComponent(UIText, recruitTip_path)
    self.peopleNumN = self:AddComponent(UIText, peopleNum_path)
    self.detailBtnN = self:AddComponent(UIButton, detailBtn_path)
    self.detailBtnN:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnClickDetailBtn()
    end)
    self.detailBtnTxtN = self:AddComponent(UIText, detailBtnTxt_path)
    self.detailBtnTxtN:SetLocalText(100092)
    self.joinBtnN = self:AddComponent(UIButton, joinBtn_path)
    self.joinBtnN:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnClickJoinBtn()
    end)
    self.joinBtnTxtN = self:AddComponent(UIText, joinBtnTxt_path)
    self.joinBtnTxtN:SetLocalText(110037)
    self.playerHeadN = self:AddComponent(UIPlayerHead, playerHead_path)
    self.playerHeadFgN = self:AddComponent(UIImage, playerHeadFg_path)
    self.playerNationN = self:AddComponent(UIImage, playerNation_path)
    self._chatNameLayout = self:AddComponent(ChatUserName, _cp_chatNameLayout)
    self.playerHeadBtnN = self:AddComponent(UIButton, playerHeadBtn_path)
    self.playerHeadBtnN:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnClickPlayerHeadBtn()
    end)
end

--控件的销毁
local function ComponentDestroy(self)
    
end

--变量的定义
local function DataDefine(self)
    
end

--变量的销毁
local function DataDestroy(self)
    
end

local function OnAddListener(self)
    base.OnAddListener(self)
    --self:AddUIListener(EventId.OnClaimRewardEffFinish, self.RefreshNeed)

end

local function OnRemoveListener(self)
    --self:RemoveUIListener(EventId.OnClaimRewardEffFinish, self.RefreshNeed)
    base.OnRemoveListener(self)
end


local function SetItem(self, inviteInfo)
    self.inviteInfo = inviteInfo

    if not LuaEntry.Player:IsHideCountryFlag() then
        self.countryFlagN:SetActive(true)
        local nationTemplate = DataCenter.NationTemplateManager:GetNationTemplate(inviteInfo.country)
        self.countryFlagN:LoadSprite(nationTemplate:GetNationFlagPath())
    else
        self.countryFlagN:SetActive(false)
    end
    self.allianceFlagN:SetData(inviteInfo.icon)
    self.shareTitleN:SetText("[" .. inviteInfo.abbr .. "]" .. inviteInfo.allianceName)
    if string.IsNullOrEmpty(inviteInfo.intro) then
        self.recruitTipN:SetLocalText(390799)
    else
        self.recruitTipN:SetText(inviteInfo.intro)
    end
    self.peopleNumN:SetText(inviteInfo.curMember .. "/" .. inviteInfo.maxMember)
    
    local _userInfo = ChatManager2:GetInstance().User:getChatUserInfo(inviteInfo.playerUid, true)
    if (self._chatNameLayout) then
        self._chatNameLayout:UpdateName(_userInfo, inviteInfo)
    end
    self.playerHeadN:SetData(inviteInfo.playerUid, inviteInfo.pic, inviteInfo.picVer)
    local tempFg = inviteInfo:GetHeadBgImg()
    if tempFg then
        self.playerHeadFgN:SetActive(true)
        self.playerHeadFgN:LoadSprite(tempFg)
    else
        self.playerHeadFgN:SetActive(false)
    end
    if not LuaEntry.Player:IsHideCountryFlag() then
        self.playerNationN:SetActive(true)
        local playerNation = DataCenter.NationTemplateManager:GetNationTemplate(inviteInfo.playerNation)
        local flagPath = playerNation:GetNationFlagPath()
        self.playerNationN:LoadSprite(flagPath)
    else
        self.playerNationN:SetActive(false)
    end
end

local function OnClickDetailBtn(self)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceDetail,{ anim = true, isBlur = true},self.inviteInfo.allianceName, self.inviteInfo.allianceId)
end

local function OnClickJoinBtn(self)
    if LuaEntry.Player:IsInAlliance() then
        UIUtil.ShowMessage(Localization:GetString("390503"),2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
            DataCenter.AllianceAutoInviteManager:AcceptAllianceAutoInviteReq(self.inviteInfo.allianceId)
            self.view.ctrl:CloseSelf()
        end)
    else
        DataCenter.AllianceAutoInviteManager:AcceptAllianceAutoInviteReq(self.inviteInfo.allianceId)
        self.view.ctrl:CloseSelf()
    end
end

function AlAutoInviteItem:OnClickPlayerHeadBtn()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIOtherPlayerInfo, self.inviteInfo.playerUid)
end

AlAutoInviteItem.OnCreate = OnCreate
AlAutoInviteItem.OnDestroy = OnDestroy
AlAutoInviteItem.ComponentDefine = ComponentDefine
AlAutoInviteItem.ComponentDestroy = ComponentDestroy
AlAutoInviteItem.DataDefine = DataDefine
AlAutoInviteItem.DataDestroy = DataDestroy
AlAutoInviteItem.OnAddListener = OnAddListener
AlAutoInviteItem.OnRemoveListener = OnRemoveListener

AlAutoInviteItem.SetItem = SetItem
AlAutoInviteItem.OnClickDetailBtn = OnClickDetailBtn
AlAutoInviteItem.OnClickJoinBtn = OnClickJoinBtn

return AlAutoInviteItem