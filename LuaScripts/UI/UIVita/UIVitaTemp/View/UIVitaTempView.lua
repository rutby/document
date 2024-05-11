---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2023/11/2 17:33
---

local UIVitaTemp = BaseClass("UIVitaTemp", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

local title_path = "UICommonMiniPopUpTitle/Bg_mid/titleText"
local close_path = "UICommonMiniPopUpTitle/Bg_mid/CloseBtn"
local return_path = "UICommonMiniPopUpTitle/panel"
local desc1_path = "Desc1"
local desc2_path = "Desc2"
local temp1_path = "Temp1"
local temp2_path = "Temp2"
local info_path = "Info"

local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
end

local function OnDestroy(self)
    self:DataDestroy()
    self:ComponentDestroy()
    base.OnDestroy(self)
end

local function OnEnable(self)
    base.OnEnable(self)
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function ComponentDefine(self)
    self.title_text = self:AddComponent(UITextMeshProUGUIEx, title_path)
    self.title_text:SetLocalText(137000)
    self.close_btn = self:AddComponent(UIButton, close_path)
    self.close_btn:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)
    self.return_btn = self:AddComponent(UIButton, return_path)
    self.return_btn:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)
    self.desc1_text = self:AddComponent(UIText, desc1_path)
    self.desc1_text:SetLocalText(137002)
    self.desc2_text = self:AddComponent(UIText, desc2_path)
    self.desc2_text:SetLocalText(137003)
    self.temp1_text = self:AddComponent(UIText, temp1_path)
    self.temp2_text = self:AddComponent(UIText, temp2_path)
    self.info_btn = self:AddComponent(UIButton, info_path)
    self.info_btn:SetOnClick(function()
        self:OnInfoClick()
    end)
end

local function ComponentDestroy(self)
    
end

local function DataDefine(self)
    self.timer = TimerManager:GetInstance():GetTimer(VitaDefines.RefreshInterval, self.TimerAction, self, false, false, false)
    self.timer:Start()
    self:TimerAction()
end

local function DataDestroy(self)
    if self.timer then
        self.timer:Stop()
        self.timer = nil
    end
end

local function OnAddListener(self)
    base.OnAddListener(self)
end

local function OnRemoveListener(self)
    base.OnRemoveListener(self)
end

local function Refresh(self)
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local temp = DataCenter.VitaManager:GetTemp(curTime)
    local envTemp =DataCenter.VitaManager:GetEnvTemp(curTime)
    self.temp1_text:SetText(string.format("%.1f%s", temp, VitaUtil.GetTempSymbol()))
    self.temp2_text:SetText(string.format("%.1f%s", envTemp, VitaUtil.GetTempSymbol()))
end

local function TimerAction(self)
    self:Refresh()
end

local function OnInfoClick(self)
    UIUtil.ShowIntro(Localization:GetString("137000"), "", Localization:GetString("137004"))
end

UIVitaTemp.OnCreate = OnCreate
UIVitaTemp.OnDestroy = OnDestroy
UIVitaTemp.OnEnable = OnEnable
UIVitaTemp.OnDisable = OnDisable
UIVitaTemp.ComponentDefine = ComponentDefine
UIVitaTemp.ComponentDestroy = ComponentDestroy
UIVitaTemp.DataDefine = DataDefine
UIVitaTemp.DataDestroy = DataDestroy
UIVitaTemp.OnAddListener = OnAddListener
UIVitaTemp.OnRemoveListener = OnRemoveListener

UIVitaTemp.Refresh = Refresh
UIVitaTemp.TimerAction = TimerAction
UIVitaTemp.OnInfoClick = OnInfoClick

return UIVitaTemp