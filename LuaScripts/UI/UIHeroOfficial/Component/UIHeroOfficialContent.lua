---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2023/2/16 19:51
---

local UIHeroOfficialContent = BaseClass("UIHeroOfficialContent", UIBaseContainer)
local base = UIBaseContainer
local UIHeroOfficialSlot = require "UI.UIHeroOfficial.Component.UIHeroOfficialSlot"
local UIHeroOfficialDetail = require "UI.UIHeroOfficial.Component.UIHeroOfficialDetail"
local UIHeroOfficialLockTip = require "UI.UIHeroOfficial.Component.UIHeroOfficialLockTip"
local UIHeroOfficialFetterTip = require "UI.UIHeroOfficial.Component.UIHeroOfficialFetterTip"
local UIHeroOfficialCounterTip = require "UI.UIHeroOfficial.Component.UIHeroOfficialCounterTip"
local Localization = CS.GameEntry.Localization

local slot_path = "UIHeroOfficialSlot_%s"
local info_path = "Info"
local desc_path = "Desc"
local detail_path = "UIHeroOfficialDetail"
local lock_tip_path = "UIHeroOfficialLockTip"
local fetter_tip_path = "UIHeroOfficialFetterTip"
local counter_tip_path = "UIHeroOfficialCounterTip"

local SLOT_COUNT = 12
local TIP_OFFSET_X = 50

local function OnCreate(self)
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

local function OnDestroy(self)
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

local function OnEnable(self)
    base.OnEnable(self)
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function ComponentDefine(self)
    self.slots = {}
    for i = 1, SLOT_COUNT do
        self.slots[i] = self:AddComponent(UIHeroOfficialSlot, string.format(slot_path, i))
        self.slots[i]:SetOnClick(function()
            SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
            self:OnSlotClick(i)
        end)
    end
    self.info_btn = self:AddComponent(UIButton, info_path)
    self.info_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnInfoClick()
    end)
    self.desc_text = self:AddComponent(UITextMeshProUGUIEx, desc_path)
    self.detail = self:AddComponent(UIHeroOfficialDetail, detail_path)
    self.lock_tip = self:AddComponent(UIHeroOfficialLockTip, lock_tip_path)
    self.fetter_tip = self:AddComponent(UIHeroOfficialFetterTip, fetter_tip_path)
    self.counter_tip = self:AddComponent(UIHeroOfficialCounterTip, counter_tip_path)
end

local function ComponentDestroy(self)
    self.slots = nil
    self.info_btn = nil
    self.desc_text = nil
    self.detail = nil
    self.lock_tip = nil
    self.fetter_tip = nil
    self.counter_tip = nil
end

local function DataDefine(self)
    self.camp = -1
end

local function DataDestroy(self)
    self.camp = nil
end

local function OnAddListener(self)
    base.OnAddListener(self)
end

local function OnRemoveListener(self)
    base.OnRemoveListener(self)
end

local function ReInit(self)
    self.detail:SetActive(false)
    self.lock_tip:SetActive(false)
    self.fetter_tip:SetActive(false)
    self.counter_tip:SetActive(false)

    local nextTemplate = DataCenter.HeroOfficialManager:GetNextTemplate()
    if nextTemplate ~= nil then
        local campName = HeroUtils.GetCampNameAndDesc(nextTemplate.camp)
        self.desc_text:SetLocalText(133001, "Lv." .. nextTemplate.unlockLv, campName)
        self.desc_text:SetActive(true)
    else
        self.desc_text:SetActive(false)
    end
end

local function SetCamp(self, camp)
    self.camp = camp
    self:Refresh()
end

local function Refresh(self)
    if self.camp == -1 then
        return
    end
    for i = 1, SLOT_COUNT do
        self.slots[i]:SetData(self.camp, i)
    end
end

local function ShowDetail(self, pos)
    self.detail:SetData(self.camp, pos)
    self.detail:Show()
end

local function ShowLockTip(self, pos)
    local position = self.slots[pos].rectTransform.position
    if position.x < Screen.width / 2 then
        position.x = position.x + TIP_OFFSET_X
        self.lock_tip.root_anim.rectTransform.pivot = Vector2.New(0, 0.5)
        self.lock_tip.left_arrow_go:SetActive(true)
        self.lock_tip.right_arrow_go:SetActive(false)
    else
        position.x = position.x - TIP_OFFSET_X
        self.lock_tip.root_anim.rectTransform.pivot = Vector2.New(1, 0.5)
        self.lock_tip.left_arrow_go:SetActive(false)
        self.lock_tip.right_arrow_go:SetActive(true)
    end
    self.lock_tip.root_anim.rectTransform.position = position
    self.lock_tip:SetData(self.camp, pos)
    self.lock_tip:Show()
end

local function ShowFetterTip(self, pos)
    --local rootPos = self.fetter_tip.root_anim.rectTransform.position
    --rootPos.x = self.slots[pos].rectTransform.position.x - TIP_OFFSET_X
    --local arrowPos = self.fetter_tip.arrow_go.rectTransform.anchoredPosition
    --arrowPos.y = self.slots[pos].rectTransform.anchoredPosition.y
    --self.fetter_tip.root_anim.rectTransform.position = rootPos
    --self.fetter_tip.arrow_go.rectTransform.anchoredPosition = arrowPos
    self.fetter_tip:SetData(self.camp, pos)
    self.fetter_tip:Show()
end

local function ShowCounterTip(self, pos)
    local position = self.slots[pos].rectTransform.position
    position.x = position.x + TIP_OFFSET_X
    position.y = position.y - 90
    self.counter_tip.root_anim.rectTransform.position = position
    self.counter_tip:SetData(self.camp, pos)
    self.counter_tip:Show()
end

local function OnInfoClick(self)
    UIUtil.ShowIntro(Localization:GetString("133000"), "", Localization:GetString("133045"))
end

local function OnSlotClick(self, pos)
    local buildingLv = DataCenter.HeroOfficialManager:GetBuildingLv()
    local template = DataCenter.HeroOfficialManager:GetTemplate(self.camp, pos)
    if template.type == 1 then
        if buildingLv >= template.unlockLv then
            self:ShowDetail(pos)
        else
            self:ShowLockTip(pos)
        end
    elseif template.type == 2 then
        self:ShowFetterTip(pos)
    elseif template.type == 3 then
        self:ShowCounterTip(pos)
    end
end

UIHeroOfficialContent.OnCreate = OnCreate
UIHeroOfficialContent.OnDestroy = OnDestroy
UIHeroOfficialContent.OnEnable = OnEnable
UIHeroOfficialContent.OnDisable = OnDisable
UIHeroOfficialContent.ComponentDefine = ComponentDefine
UIHeroOfficialContent.ComponentDestroy = ComponentDestroy
UIHeroOfficialContent.DataDefine = DataDefine
UIHeroOfficialContent.DataDestroy = DataDestroy
UIHeroOfficialContent.OnAddListener = OnAddListener
UIHeroOfficialContent.OnRemoveListener = OnRemoveListener

UIHeroOfficialContent.ReInit = ReInit
UIHeroOfficialContent.SetCamp = SetCamp
UIHeroOfficialContent.Refresh = Refresh
UIHeroOfficialContent.ShowDetail = ShowDetail
UIHeroOfficialContent.ShowLockTip = ShowLockTip
UIHeroOfficialContent.ShowFetterTip = ShowFetterTip
UIHeroOfficialContent.ShowCounterTip = ShowCounterTip
UIHeroOfficialContent.OnInfoClick = OnInfoClick
UIHeroOfficialContent.OnSlotClick = OnSlotClick

return UIHeroOfficialContent