---
--- 兑换码界面
--- Created by shimin.
--- DateTime: 2020/9/27 14:39
---
local UISettingRedemptionCodeView = BaseClass("UISettingRedemptionCodeView",UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

local txt_title_path ="ImgBg/TxtTitle"
local close_btn_path = "ImgBg/BtnClose"
local return_btn_path = "Panel"
local des_path = "ImgBg/DecText"
local input_path = "ImgBg/InputField"
local redemption_btn_path = "ImgBg/ConfirmBtn"
local redemption_name_path = "ImgBg/ConfirmBtn/ConfirmBtnName"

--创建
local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
    self:ReInit()
end

-- 销毁
local function OnDestroy(self)
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

local function ComponentDefine(self)
    self.txt_title = self:AddComponent(UIText, txt_title_path)
    self.close_btn = self:AddComponent(UIButton, close_btn_path)
    self.return_btn = self:AddComponent(UIButton, return_btn_path)
    self.des = self:AddComponent(UIText, des_path)
    self.input = self:AddComponent(UIInput, input_path)
    self.redemption_btn = self:AddComponent(UIButton, redemption_btn_path)
    self.redemption_name = self:AddComponent(UIText, redemption_name_path)

    self.close_btn:SetOnClick(function()  
        self.ctrl:CloseSelf()
    end)
    self.return_btn:SetOnClick(function()  
        self.ctrl:CloseSelf()
    end)
    self.redemption_btn:SetOnClick(function()  
SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnRedemptionBtnClick()
    end)
    self.input:SetOnEndEdit(function (value)
        self:InputListener(value)
    end)
end

local function ComponentDestroy(self)
    self.txt_title = nil
    self.close_btn = nil
    self.return_btn = nil
    self.des = nil
    self.input = nil
    self.redemption_btn = nil
    self.redemption_name = nil
end


local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnEnable(self)
    base.OnEnable(self)
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function ReInit(self)
    self.txt_title:SetLocalText(110004) 
    self.des:SetLocalText(120013) 
    self.redemption_name:SetLocalText(110029) 
    self.input:SetText("")
    self.redemption_btn:SetInteractable(false)
end

local function OnAddListener(self)
    base.OnAddListener(self)
end

local function OnRemoveListener(self)
    base.OnRemoveListener(self)
end

local function InputListener(self)
    local temp = self.input:GetText()
    if temp ~= nil and temp ~= "" then
        self.redemption_btn:SetInteractable(true)
    else
        self.redemption_btn:SetInteractable(false)
    end
end

local function OnRedemptionBtnClick(self)
    local temp = self.input:GetText()
    if temp ~= nil and temp ~= "" then
        UIUtil.ShowTipsId(120011) 
    else
        UIUtil.ShowTipsId(110005) 
    end
end

UISettingRedemptionCodeView.OnCreate= OnCreate
UISettingRedemptionCodeView.OnDestroy = OnDestroy
UISettingRedemptionCodeView.OnEnable = OnEnable
UISettingRedemptionCodeView.OnDisable = OnDisable
UISettingRedemptionCodeView.OnAddListener = OnAddListener
UISettingRedemptionCodeView.OnRemoveListener = OnRemoveListener
UISettingRedemptionCodeView.ComponentDefine = ComponentDefine
UISettingRedemptionCodeView.ComponentDestroy = ComponentDestroy
UISettingRedemptionCodeView.DataDefine = DataDefine
UISettingRedemptionCodeView.DataDestroy = DataDestroy
UISettingRedemptionCodeView.ReInit = ReInit
UISettingRedemptionCodeView.InputListener = InputListener
UISettingRedemptionCodeView.OnRedemptionBtnClick = OnRedemptionBtnClick


return UISettingRedemptionCodeView