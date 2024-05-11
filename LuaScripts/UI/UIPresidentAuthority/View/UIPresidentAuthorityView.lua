---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2023/4/8 18:30
---


local base = UIBaseView
local UIPresidentAuthorityView = BaseClass("UIPresidentAuthorityView", base)--Variable

local title_path = "UICommonMiniPopUpTitle/Bg_mid/titleText"
local closeBtn_path = "UICommonMiniPopUpTitle/Bg_mid/CloseBtn"
local bgBtn_path = "UICommonMiniPopUpTitle/panel"

local activeBtn_path = "offset/activeBtn"
local activeBtn_text_path = "offset/activeBtn/activeBtnText"

local skill_icon_path = "offset/skillIconBg/skillIcon"
local skill_name_path = "offset/skillName"
local skill_desc_path = "offset/skillDesc"

local in_cd_path = "offset/inCd"
local in_cd_title_path = "offset/inCd/skillLeftTitle"
local in_cd_text_path = "offset/inCd/skillLeftTime"

local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
    self:RefreshView()
end

local function OnDestroy(self)
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

local function ComponentDefine(self)
    self.titleN = self:AddComponent(UITextMeshProUGUIEx, title_path)
    self.titleN:SetLocalText(305040)
    self.closeBtnN = self:AddComponent(UIButton, closeBtn_path)
    self.closeBtnN:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self.ctrl:CloseSelf()
    end)
    self.bgBtnN = self:AddComponent(UIButton, bgBtn_path)
    self.bgBtnN:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)

    self.skill_icon = self:AddComponent(UIImage, skill_icon_path)
    self.skill_name = self:AddComponent(UIText, skill_name_path)
    self.skill_desc = self:AddComponent(UIText, skill_desc_path)

    self.in_cd = self:AddComponent(UIBaseContainer, in_cd_path)
    self.in_cd_title = self:AddComponent(UIText, in_cd_title_path)
    self.in_cd_text = self:AddComponent(UIText, in_cd_text_path)
    self.in_cd_title:SetLocalText(305038)

    self.activeBtn = self:AddComponent(UIButton, activeBtn_path)
    self.activeBtn_text = self:AddComponent(UIText, activeBtn_text_path)
    self.activeBtn_text:SetLocalText(120204)
    self.activeBtn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnActiveClick()
    end)
    self.timer_action = function(temp)
        self:RefreshTime()
    end
end

local function ComponentDestroy(self)
    self:DeleteTimer()
end

local function DataDefine(self)
    
end

local function DataDestroy(self)
end


local function OnActiveClick(self)
    self.ctrl:ActiveSkill()
end

local function RefreshView(self)
    self.data = self.ctrl:GetPanelData()
    
    self.skill_icon:LoadSprite(self.data.skillIcon)
    self.skill_name:SetLocalText(self.data.skillName or "")
    self.skill_desc:SetText(self.data.skillDesc or "")
    self.activeBtn:SetActive(not self.data.isInCd)
    self.in_cd:SetActive(self.data.isInCd)

    if self.data.isInCd then
        self:AddTimer()
        self:RefreshTime()
    else
        self:DeleteTimer()
    end
end

local function DeleteTimer(self)
    if self.timer ~= nil then
        self.timer:Stop()
        self.timer = nil
    end
end

local function AddTimer(self)
    self:DeleteTimer()
    self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action , self, false,false,false)
    self.timer:Start()
end

local function RefreshTime(self)
    if self.data.isInCd then
        local timeLeft = self.data.endTime - UITimeManager:GetInstance():GetServerTime()
        if timeLeft > 0 then
            local timeStr = UITimeManager:GetInstance():MilliSecondToFmtString(timeLeft)
            self.in_cd_text:SetText(timeStr)
        else
            self:DeleteTimer()
            self.activeBtn:SetActive(true)
            self.in_cd:SetActive(false)
        end
    else
        self:DeleteTimer()
        self.activeBtn:SetActive(true)
        self.in_cd:SetActive(false)
    end
end

UIPresidentAuthorityView.DeleteTimer = DeleteTimer
UIPresidentAuthorityView.AddTimer = AddTimer
UIPresidentAuthorityView.RefreshTime = RefreshTime
UIPresidentAuthorityView.OnCreate = OnCreate
UIPresidentAuthorityView.OnDestroy = OnDestroy
UIPresidentAuthorityView.ComponentDefine = ComponentDefine
UIPresidentAuthorityView.ComponentDestroy = ComponentDestroy
UIPresidentAuthorityView.DataDefine = DataDefine
UIPresidentAuthorityView.DataDestroy = DataDestroy
UIPresidentAuthorityView.RefreshView = RefreshView
UIPresidentAuthorityView.OnActiveClick = OnActiveClick

return UIPresidentAuthorityView