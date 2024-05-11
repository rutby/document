---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2023/3/25 14:45
---


local HeroEvolveHeroInfo = BaseClass("HeroEvolveHeroInfo", UIBaseView)
local base = UIBaseView
local TabButton = require "UI.UIGovernment.UIGovernmentMain.Component.TabButton"
local HeroAttrTab = require "UI.UIActivityCenterTable.Component.HeroEvolve.HeroEvolveHeroInfo.Component.HeroAttrTab"
local HeroEvolveTab = require "UI.UIActivityCenterTable.Component.HeroEvolve.HeroEvolveHeroInfo.Component.HeroEvolveTab"
local HeroSkillTab = require "UI.UIActivityCenterTable.Component.HeroEvolve.HeroEvolveHeroInfo.Component.HeroSkillTab"

local HeroAttrTab_path = "attrTab"
local HeroEvolveTab_path = "evolveTab"
local HeroSkillTab_path = "skillTab"

local icon_path = "heroInfoIcon"
local time_text_path = "timeText"
local tab_btn_prefix = "TabContent/Btn_"

local back_to_choose_btn_path = "backBtn"
local back_to_choose_btn_text_path = "backBtn/backBtnText"

local panelClass = {HeroEvolveTab, HeroSkillTab, HeroAttrTab}
local prefabPath = {HeroEvolveTab_path, HeroSkillTab_path, HeroAttrTab_path}

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
    self.icon = self:AddComponent(UIImage, icon_path)
    self.timeText = self:AddComponent(UIText, time_text_path)
    self.tabBtns = {}
    for i = 1, 3 do
        local tabBtn = self:AddComponent(TabButton, tab_btn_prefix..i)
        table.insert(self.tabBtns, tabBtn)
    end
    self.panels = {}
    self.back_btn = self:AddComponent(UIButton, back_to_choose_btn_path)
    self.back_btn_text = self:AddComponent(UIText, back_to_choose_btn_text_path)
    self.back_btn_text:SetLocalText(321061)
    self.back_btn :SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnBackClick()
    end)
end

local function ComponentDestroy(self)
    self:HideAllTab()
end

local function DataDefine(self)
    self.curSelectIndex = 1
end

local function DataDestroy(self)
    self.curSelectIndex = 1
end

local function OnAddListener(self)
    base.OnAddListener(self)
    self:AddUIListener(EventId.UpdateGiftPackData, self.OnUpdateGiftPackData)
    self:AddUIListener(EventId.HeroEvolveSuccess, self.HeroEvolveSuccessHandler)

end

local function OnRemoveListener(self)
    self:RemoveUIListener(EventId.UpdateGiftPackData, self.OnUpdateGiftPackData)
    self:RemoveUIListener(EventId.HeroEvolveSuccess, self.HeroEvolveSuccessHandler)
    base.OnRemoveListener(self)
end

local function RefreshView(self)
    self.icon:LoadSprite(self.data.icon, nil, function()
        self.icon:SetNativeSize()
    end)
    self.timeText:SetText(self.data.timeText)
    for k, v in ipairs(self.tabBtns) do
        self.data.tabList[k].callBack = BindCallback(self, self.SetCurSelect)
        v:ReInit(self.data.tabList[k])
    end
    self:RefreshTabButtons()
    self:RefreshTabPanel()
    self:RefreshBackBtn()
end

local function RefreshTabPanel(self)
    for k, v in ipairs(self.panels) do
        v:SetActive(k == self.curSelectIndex)
    end
    if self.panels[self.curSelectIndex] == nil and panelClass[self.curSelectIndex] ~= nil then
        local panel = self:AddComponent(panelClass[self.curSelectIndex], prefabPath[self.curSelectIndex])
        self.panels[self.curSelectIndex] = panel
    end

    if self.panels[self.curSelectIndex] then
        self.panels[self.curSelectIndex]:SetActive(true)
        self.panels[self.curSelectIndex]:SetData()
    end
end

local function HideAllTab(self)
    for k, v in ipairs(self.panels) do
        v:SetActive(false)
    end
end

local function RefreshTabButtons(self)
    for _, v in ipairs(self.tabBtns) do
        v:SetCurSelect(self.curSelectIndex)
    end
end

local function SetCurSelect(self, select)
    if self.curSelectIndex == select then
        return
    end
    self.curSelectIndex = select
    self:RefreshTabButtons()
    self:RefreshTabPanel()
end

local function SetData(self, activityId)
    self.data = HeroEvolveController:GetInstance():GetHeroEvolveHeroInfoData()
    self.activityId = activityId
    self:RefreshView()
end

local function RefreshBackBtn(self)
    local showFlag = HeroEvolveController:GetInstance():NeedShowBackBtn()
    self.back_btn:SetActive(showFlag)
end

local function OnUpdateGiftPackData(self)
    self:RefreshBackBtn()
end

local function HeroEvolveSuccessHandler(self)
    self:RefreshBackBtn()
end

local function OnBackClick(self)
    HeroEvolveController:GetInstance():SetForceShowChoose(true)
    EventManager:GetInstance():Broadcast(EventId.HeroEvolveHeroInfoBack)
end

HeroEvolveHeroInfo.OnBackClick = OnBackClick
HeroEvolveHeroInfo.HeroEvolveSuccessHandler = HeroEvolveSuccessHandler
HeroEvolveHeroInfo.OnUpdateGiftPackData = OnUpdateGiftPackData
HeroEvolveHeroInfo.SetData = SetData
HeroEvolveHeroInfo.RefreshTabButtons = RefreshTabButtons
HeroEvolveHeroInfo.OnCreate = OnCreate
HeroEvolveHeroInfo.OnDestroy = OnDestroy
HeroEvolveHeroInfo.OnEnable = OnEnable
HeroEvolveHeroInfo.OnDisable = OnDisable
HeroEvolveHeroInfo.ComponentDefine = ComponentDefine
HeroEvolveHeroInfo.ComponentDestroy = ComponentDestroy
HeroEvolveHeroInfo.DataDefine = DataDefine
HeroEvolveHeroInfo.DataDestroy = DataDestroy
HeroEvolveHeroInfo.OnAddListener = OnAddListener
HeroEvolveHeroInfo.OnRemoveListener = OnRemoveListener
HeroEvolveHeroInfo.RefreshView = RefreshView
HeroEvolveHeroInfo.SetCurSelect = SetCurSelect
HeroEvolveHeroInfo.RefreshTabPanel = RefreshTabPanel
HeroEvolveHeroInfo.HideAllTab = HideAllTab
HeroEvolveHeroInfo.RefreshBackBtn = RefreshBackBtn

return HeroEvolveHeroInfo