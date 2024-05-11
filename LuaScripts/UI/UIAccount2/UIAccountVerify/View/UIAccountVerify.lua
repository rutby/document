---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zhangliheng.
--- DateTime: 9/27/21 11:28 AM
---


local UIAccountVerify = BaseClass("UIAccountVerify",UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local OptionData = CS.UnityEngine.UI.Dropdown.OptionData
local VERIFY_CODE_LEN = 6


local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
end

local function OnDestroy(self)
    self:ComponentDestroy()
    base.OnDestroy(self)
end

local function ComponentDefine(self)
    self.textTitle = self:AddComponent(UITextMeshProUGUIEx, 'UICommonMiniPopUpTitle/Bg_mid/titleText')
    
    self.TextTip1  = self:AddComponent(UITextMeshProUGUIEx, 'UICommonMiniPopUpTitle/TextTip1')
    self.TextTip2  = self:AddComponent(UITextMeshProUGUIEx, 'UICommonMiniPopUpTitle/TextTip2')
    self.textBtnSubmit = self:AddComponent(UITextMeshProUGUIEx, 'UICommonMiniPopUpTitle/BtnGo/BtnSubmit/TextSubmit')
    self.textChangeMail = self:AddComponent(UITextMeshProUGUIEx, 'UICommonMiniPopUpTitle/BtnGo/BtnChangeMail/TextChangeMail')
    
    self.panelBack = self:AddComponent(UIButton, "UICommonMiniPopUpTitle/panel")
    self.btnClose = self:AddComponent(UIButton, 'UICommonMiniPopUpTitle/Bg_mid/CloseBtn')
    self.btnSubmit = self:AddComponent(UIButton, 'UICommonMiniPopUpTitle/BtnGo/BtnSubmit')
    self.btnChangeMail = self:AddComponent(UIButton, 'UICommonMiniPopUpTitle/BtnGo/BtnChangeMail')

    self.inputField = self:AddComponent(UITMPInput, 'Root/InputField')
    self.btnClose:SetOnClick(BindCallback(self.ctrl, self.ctrl.Close))
    self.btnSubmit:SetOnClick(BindCallback(self, self.OnBtnSubmitClick))
    self.btnChangeMail:SetOnClick(BindCallback(self, self.OnBtnChangeMailClick))
    self.panelBack:SetOnClick(BindCallback(self.ctrl, self.ctrl.Close))

    self.boxTexts = {}
    for k=1, VERIFY_CODE_LEN do
        local textBox = self:AddComponent(UITextMeshProUGUIEx, 'Root/NodeVerifyBox/Box'.. k .. '/Text' .. k)
        table.insert(self.boxTexts, textBox)
    end
    
    self.textTitle:SetLocalText(280109) 
    self.TextTip1:SetLocalText(208190) 
    
    self.textBtnSubmit:SetLocalText(280108) 
    self.textChangeMail:SetLocalText(208197) 
    
    self.inputField:SetOnValueChange(BindCallback(self, self.OnValueChange))
end

local function ComponentDestroy(self)
end

local function OnEnable(self)
    base.OnEnable(self)
    --verifyType:1,登陆；2,绑定账号；3,忘记密码
    local mail,verifyType = self:GetUserData()
    self.mail = mail
    self.verifyType = verifyType
    if self.verifyType == 1 then
        self.TextTip2:SetLocalText(208209,mail)
    elseif self.verifyType == 2 then
        self.TextTip2:SetLocalText(208191,mail)
    elseif self.verifyType == 3 then
        self.TextTip2:SetLocalText(208205,mail)
    end
    self.TextTip1:SetActive(verifyType ~= 3)
    self.btnChangeMail:SetActive(verifyType == 2)
    self.inputField:SetText('')
end

local function OnBtnSubmitClick(self)
    local code = self.inputField:GetText()
    if code == nil or code == '' or string.len(code) < 6 then
        --UIUtil.ShowTipsId() 
        return
    end
    
    --检测验证码
    if self.verifyType == 1 then
        --登陆验证
        SFSNetwork.SendMessage(MsgDefines.AccountLoginNew,{mail = self.mail,code = code})
    elseif self.verifyType == 2 then
        --绑定游戏验证
        SFSNetwork.SendMessage(MsgDefines.AccountVerify, code)
    else
        --忘记密码验证
        SFSNetwork.SendMessage(MsgDefines.CheckAccountMailVerifyCode,{mail = self.mail,code = code} )
    end
end

local function OnBtnChangeMailClick(self)
    self.ctrl:CloseSelf()
    if self.verifyType == 1 then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIAddAccount,{anim = true,isBlur = true},110008)
    elseif self.verifyType == 2 then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UICreateAccount,{ anim = true, isBlur = true })
    else
        UIManager:GetInstance():OpenWindow(UIWindowNames.UISettingAccount,{ anim = true,isBlur = true })
    end
end

local function OnValueChange(self, value)
    local len = string.len(value)
    for k, v in ipairs(self.boxTexts) do
        v:SetText( k<=len and value:sub(k, k) or '')
    end
end

UIAccountVerify.OnCreate= OnCreate
UIAccountVerify.OnDestroy = OnDestroy
UIAccountVerify.OnEnable = OnEnable

UIAccountVerify.ComponentDefine = ComponentDefine
UIAccountVerify.ComponentDestroy = ComponentDestroy

UIAccountVerify.OnBtnSubmitClick = OnBtnSubmitClick
UIAccountVerify.OnBtnChangeMailClick = OnBtnChangeMailClick
UIAccountVerify.OnValueChange = OnValueChange

return UIAccountVerify