---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2023/11/6 10:21
---

local UIVitaResidentOverviewPanel = BaseClass("UIVitaResidentOverviewPanel", UIBaseContainer)
local base = UIBaseContainer
local UIHeroTipsView = require "UI.UIHeroTips.View.UIHeroTipsView"
local Localization = CS.GameEntry.Localization

local head_path = "Head"
local desc1_path = "layout/Desc1"
local desc2_path = "layout/Desc2"
local satisfaction_slider_path = "SatisfactionSlider"
local satisfaction_btn_path = "SatisfactionSlider/SatisfactionBtn"
local stamina_slider_path = "StaminaBg/StaminaSlider"
local stamina_title_path = "StaminaBg/StaminaTitle"
local stamina_arrow_path = "StaminaBg/StaminaTitle/StaminaArrow"
local stamina_desc_path = "StaminaBg/StaminaDesc"
local stamina_btn_path = "StaminaBg/StaminaBtn"
local mood_slider_path = "MoodBg/MoodSlider"
local mood_title_path = "MoodBg/MoodTitle"
local mood_arrow_path = "MoodBg/MoodTitle/MoodArrow"
local mood_desc_path = "MoodBg/MoodDesc"
local mood_btn_path = "MoodBg/MoodBtn"
local sick_title_path = "SickTitle"
local sick_desc_path = "SickDesc"

local ColorBrown = Color.New(0.4980392, 0.3843138, 0.3058824)
local ColorRed = Color.New(0.9843137, 0.2313726, 0.2313726)

local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
end

local function OnDestroy(self)
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

local function OnEnable(self)
    base.OnEnable(self)
    self.active = true
    self:Refresh()
end

local function OnDisable(self)
    self.active = false
    base.OnDisable(self)
end

local function ComponentDefine(self)
    self.head_text = self:AddComponent(UITextMeshProUGUIEx, head_path)
    self.head_text:SetLocalText(450227)
    self.desc_text1 = self:AddComponent(UITextMeshProUGUIEx, desc1_path)
    self.desc_text1:SetText(Localization:GetString("450228"))
    self.desc_text2 = self:AddComponent(UITextMeshProUGUIEx, desc2_path)
    self.desc_text2:SetText(Localization:GetString("450229"))
    self.satisfaction_slider = self:AddComponent(UISlider, satisfaction_slider_path)
    self.satisfaction_btn = self:AddComponent(UIButton, satisfaction_btn_path)
    self.satisfaction_btn:SetOnClick(function()
        self:OnSatisfactionClick()
    end)
    self.stamina_slider = self:AddComponent(UISlider, stamina_slider_path)
    self.stamina_title_text = self:AddComponent(UITextMeshProUGUIEx, stamina_title_path)
    self.stamina_title_text:SetLocalText(450239)
    self.stamina_arrow_image = self:AddComponent(UIImage, stamina_arrow_path)
    self.stamina_desc_text = self:AddComponent(UITextMeshProUGUIEx, stamina_desc_path)
    self.stamina_btn = self:AddComponent(UIButton, stamina_btn_path)
    self.stamina_btn:SetOnClick(function()
        self:OnStaminaClick()
    end)
    self.mood_slider = self:AddComponent(UISlider, mood_slider_path)
    self.mood_title_text = self:AddComponent(UITextMeshProUGUIEx, mood_title_path)
    self.mood_title_text:SetLocalText(450240)
    self.mood_arrow_image = self:AddComponent(UIImage, mood_arrow_path)
    self.mood_desc_text = self:AddComponent(UITextMeshProUGUIEx, mood_desc_path)
    self.mood_btn = self:AddComponent(UIButton, mood_btn_path)
    self.mood_btn:SetOnClick(function()
        self:OnMoodClick()
    end)
    self.sick_title_text = self:AddComponent(UITextMeshProUGUIEx, sick_title_path)
    self.sick_desc_text = self:AddComponent(UITextMeshProUGUIEx, sick_desc_path)
    self.sick_desc_text:SetLocalText(450241)
end

local function ComponentDestroy(self)

end

local function DataDefine(self)
    
end

local function DataDestroy(self)
    
end

local function OnAddListener(self)
    base.OnAddListener(self)
end

local function OnRemoveListener(self)
    base.OnRemoveListener(self)
end

local function Refresh(self)
    self.data = DataCenter.OpinionManager:GetData()
    self.satisfaction_slider:SetValue(self.data:GetSatisfaction() / 100)
    
    local staminaPercent = DataCenter.VitaManager:GetAverageStaminaPercent()
    local lastStaminaPercent = DataCenter.VitaManager:GetLastAverageStaminaPercent()
    self.stamina_slider:SetValue(staminaPercent)
    self.stamina_arrow_image:LoadSprite(string.format(LoadPath.UIVita, staminaPercent >= lastStaminaPercent and "survivor_icon_jia" or "survivor_icon_jian"))
    if staminaPercent < 0.5 then
        self.stamina_desc_text:SetLocalText(450236)
        self.stamina_desc_text:SetColor(ColorRed)
    else
        self.stamina_desc_text:SetLocalText(450235)
        self.stamina_desc_text:SetColor(ColorBrown)
    end
    
    local moodPercent = DataCenter.VitaManager:GetAverageMoodPercent()
    local lastMoodPercent = DataCenter.VitaManager:GetLastAverageMoodPercent()
    self.mood_slider:SetValue(moodPercent)
    self.mood_arrow_image:LoadSprite(string.format(LoadPath.UIVita, moodPercent >= lastMoodPercent and "survivor_icon_jia" or "survivor_icon_jian"))
    if moodPercent < 0.5 then
        self.mood_desc_text:SetLocalText(450238)
        self.mood_desc_text:SetColor(ColorRed)
    else
        self.mood_desc_text:SetLocalText(450235)
        self.mood_desc_text:SetColor(ColorBrown)
    end
    
    local _, _, residentSickCount, _ = DataCenter.VitaManager:GetResidentCount()
    self.sick_title_text:SetLocalText(450234,"<color=#482e28>"..residentSickCount)
end

local function TimerAction(self)
    if self.active then
        self:Refresh()
    end
end

local function OnSatisfactionClick(self)
    local param = UIHeroTipsView.Param.New()
    param.content = Localization:GetString("450231")
    param.dir = UIHeroTipsView.Direction.ABOVE
    param.defWidth = 400
    param.pivot = 0.5
    param.position = self.satisfaction_btn.transform.position
    param.bindObject = self.satisfaction_btn.gameObject
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTips, { anim = false }, param)
end

local function OnStaminaClick(self)
    local param = UIHeroTipsView.Param.New()
    param.content = Localization:GetString("450232")
    param.dir = UIHeroTipsView.Direction.ABOVE
    param.defWidth = 400
    param.pivot = 0.5
    param.position = self.stamina_btn.transform.position
    param.bindObject = self.stamina_btn.gameObject
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTips, { anim = false }, param)
end

local function OnMoodClick(self)
    local param = UIHeroTipsView.Param.New()
    param.content = Localization:GetString("450233")
    param.dir = UIHeroTipsView.Direction.ABOVE
    param.defWidth = 400
    param.pivot = 0.5
    param.position = self.mood_btn.transform.position
    param.bindObject = self.mood_btn.gameObject
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTips, { anim = false }, param)
end

UIVitaResidentOverviewPanel.OnCreate = OnCreate
UIVitaResidentOverviewPanel.OnDestroy = OnDestroy
UIVitaResidentOverviewPanel.OnEnable = OnEnable
UIVitaResidentOverviewPanel.OnDisable = OnDisable
UIVitaResidentOverviewPanel.ComponentDefine = ComponentDefine
UIVitaResidentOverviewPanel.ComponentDestroy = ComponentDestroy
UIVitaResidentOverviewPanel.DataDefine = DataDefine
UIVitaResidentOverviewPanel.DataDestroy = DataDestroy
UIVitaResidentOverviewPanel.OnAddListener = OnAddListener
UIVitaResidentOverviewPanel.OnRemoveListener = OnRemoveListener

UIVitaResidentOverviewPanel.Refresh = Refresh
UIVitaResidentOverviewPanel.TimerAction = TimerAction

UIVitaResidentOverviewPanel.OnSatisfactionClick = OnSatisfactionClick
UIVitaResidentOverviewPanel.OnStaminaClick = OnStaminaClick
UIVitaResidentOverviewPanel.OnMoodClick = OnMoodClick

return UIVitaResidentOverviewPanel