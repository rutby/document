---
--- 
--- Created by zzl.
--- DateTime: 
---
local UISettingChangeUidView = BaseClass("UISettingChangeUidView",UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

local txt_title_path ="UICommonPopUpTitle/bg_mid/titleText"
local close_btn_path = "UICommonPopUpTitle/bg_mid/CloseBtn"
local return_btn_path = "UICommonPopUpTitle/panel"
local input_path = "ImgBg/InputField"
local redemption_btn_path = "ImgBg/ConfirmBtn"
local ipInputPath="ImgBg/Inputs/Ip/InputField1"
local portInputPath="ImgBg/Inputs/Port/InputField2"
local zoneInputPath="ImgBg/Inputs/Zone/InputField3"
local uidInuptPath="ImgBg/Inputs/Uid/InputField4"
local back_toggle_path = "ImgBg/backToggle"
--创建
local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
    self:ReInit()
end

-- 销毁
local function OnDestroy(self)
    self:ComponentDestroy()
    base.OnDestroy(self)
end

local function ComponentDefine(self)
    self.txt_title = self:AddComponent(UIText, txt_title_path)
    self.close_btn = self:AddComponent(UIButton, close_btn_path)
    self.return_btn = self:AddComponent(UIButton, return_btn_path)
    self.input = self:AddComponent(UIInput, input_path)
    self.redemption_btn = self:AddComponent(UIButton, redemption_btn_path)

    self.close_btn:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)
    self.return_btn:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)
    self.redemption_btn:SetOnClick(function()
        self:OnRedemptionBtnClick()
    end)
    self.debugInput =  self:AddComponent(UIBaseContainer,"ImgBg/Inputs")
    self.onlineInput =  self:AddComponent(UIBaseContainer,input_path)
    self.ipInput = self:AddComponent(UIInput, ipInputPath)
    self.portInput= self:AddComponent(UIInput, portInputPath)
    self.zoneInput= self:AddComponent(UIInput, zoneInputPath)
    self.uidInput= self:AddComponent(UIInput, uidInuptPath)
    self.back_toggle = self:AddComponent(UIToggle, back_toggle_path)
    self.back_toggle:SetIsOn(false)
    self.back_toggle:SetOnValueChanged(function(tf)
        self:ToggleControlBorS()
    end)
    self.isDebug = false--内网
end

local function ComponentDestroy(self)
    self.txt_title = nil
    self.close_btn = nil
    self.return_btn = nil
    self.input = nil
    self.redemption_btn = nil
end

local function OnEnable(self)
    base.OnEnable(self)
    self:ToggleControlBorS()
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function ToggleControlBorS(self)
    self.isDebug = self.back_toggle:GetIsOn()
    self:ReInit()
end

local function ReInit(self)
    --self.txt_title:SetLocalText(110004)
    self.input:SetText("")
    self.ipInput:SetText("")
    self.portInput:SetText("")
    self.zoneInput:SetText("")
    self.uidInput:SetText("")
    self.debugInput:SetActive(self.isDebug)
    self.onlineInput:SetActive(self.isDebug ==false)
end


local function OnRedemptionBtnClick(self)
    if self.isDebug then
        self:OnChangeClick()
    else
        local temp = self.input:GetText()
        if temp~=nil and temp~="" then
            self.ctrl:OnClick(temp)
        end
    end
end

local function OnChangeClick(self)
    local ip=self.ipInput:GetText()
    local port = self.portInput:GetText()
    local zone = self.zoneInput:GetText()
    local uid = self.uidInput:GetText()
    if ip=="" or port=="" or zone== "" then
        return
    end
    port = tonumber(port);
    Setting:SetString(SettingKeys.GAME_UID, uid);
    Setting:SetString(SettingKeys.SERVER_IP, ip);
    Setting:SetInt(SettingKeys.SERVER_PORT, port);
    Setting:SetString(SettingKeys.SERVER_ZONE, zone);
    LuaEntry.DataConfig:ClearMd5()
    CS.GameEntry.Sound:StopAllSounds()
    CS.ApplicationLaunch.Instance:ReStartGame()
end
UISettingChangeUidView.OnCreate= OnCreate
UISettingChangeUidView.OnDestroy = OnDestroy
UISettingChangeUidView.OnEnable = OnEnable
UISettingChangeUidView.OnDisable = OnDisable
UISettingChangeUidView.ComponentDefine = ComponentDefine
UISettingChangeUidView.ComponentDestroy = ComponentDestroy
UISettingChangeUidView.ReInit = ReInit
UISettingChangeUidView.ToggleControlBorS = ToggleControlBorS
UISettingChangeUidView.OnRedemptionBtnClick = OnRedemptionBtnClick
UISettingChangeUidView.OnChangeClick =OnChangeClick

return UISettingChangeUidView