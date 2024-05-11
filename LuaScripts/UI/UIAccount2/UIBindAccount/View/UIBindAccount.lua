---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zhangliheng.
--- DateTime: 8/12/21 9:48 PM
---



local UIBindAccount = BaseClass("UIBindAccount",UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local SDKManager = CS.SDKManager
local Setting = CS.GameEntry.Setting

local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
    self:OnOpen()
end

local function OnDestroy(self)
    self:ComponentDestroy()
    base.OnDestroy(self)
end

local function ComponentDefine(self)
    self.textTitle      = self:AddComponent(UIText, 'UICommonPopUpTitle/bg_mid/titleText')
    self.textTip1       = self:AddComponent(UIText, 'Root/TextTip1')

    self.textBtnEmail    = self:AddComponent(UIText, 'Root/BtnEmail/TextEmail')
    self.textBtnApple    = self:AddComponent(UIText, 'Root/BtnApple/TextApple')
    self.textBtnWeChat   = self:AddComponent(UIText, 'Root/BtnWeChat/TextBtnWeChat')
    self.textBtnFacebook = self:AddComponent(UIText, 'Root/BtnFacebook/TextBtnFacebook')

    self.btnClose  = self:AddComponent(UIButton,  'UICommonPopUpTitle/bg_mid/CloseBtn')
    
    self.btnEmail     = self:AddComponent(UIButton,  'Root/BtnEmail')
    self.btnApple     = self:AddComponent(UIButton,  'Root/BtnApple')
    self.btnWeChat    = self:AddComponent(UIButton,  'Root/BtnWeChat')
    self.BtnFacebook  = self:AddComponent(UIButton,  'Root/BtnFacebook')

    self.textTitle:SetLocalText(280041) 
    --self.textTip1:SetLocalText(208183) 
    
    self.textBtnEmail:SetLocalText(208181) 
    self.textBtnApple:SetLocalText(208180) 
    self.textBtnWeChat:SetLocalText(208179) 
    self.textBtnFacebook:SetLocalText(280052) 

    self.btnClose:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
    
    self.btnEmail:SetOnClick(BindCallback(self, self.OnBtnEmailClick))
    self.btnApple:SetOnClick(BindCallback(self, self.OnBtnAppleClick))
    self.btnWeChat:SetOnClick(BindCallback(self, self.OnBtnWeChatClick))
    self.BtnFacebook:SetOnClick(BindCallback(self, self.OnBtnFacebookClick))
end

local function ComponentDestroy(self)
    self.textTitle      = nil
    self.textTip1       = nil

    self.textBtnEmail    = nil
    self.textBtnApple    = nil
    self.textBtnWeChat   = nil
    self.textBtnFacebook = nil

    self.btnClose  = nil

    self.btnEmail     = nil
    self.btnApple     = nil
    self.btnWeChat    = nil
    self.BtnFacebook  = nil
end

local function OnOpen(self)
    local bindType = self:GetUserData()
    self.bindType = bindType
    self.textTitle:SetLocalText(bindType == AccountBindType.Bind and '280041' or '280050') 
    self.textTip1:SetLocalText(bindType == AccountBindType.Bind and '208183' or '280056') 
end

local function OnBtnEmailClick(self)
    if self.bindType == AccountBindType.Bind then
        local state = DataCenter.AccountManager:GetAccountBindState()
        if state ~= AccountBandState.UnBand then
            return
        end

        UIManager:GetInstance():OpenWindow(UIWindowNames.UICreateAccount, { anim = true, isBlur = true })
    else
        --打开账号列表
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIAccountList, { anim = true })
    end
end

local function OnBtnAppleClick(self)

end

local function OnBtnWeChatClick(self)

end

local function OnBtnFacebookClick(self)

end

local function OnEnable(self)
    base.OnEnable(self)

    local state = DataCenter.AccountManager:GetAccountBindState()
    local gpUid = Setting:GetPrivateString(SettingKeys.GP_USERID, "")
    local fbUid = Setting:GetPrivateString(SettingKeys.FB_USERID, "")
    local wxAppId = Setting:GetPrivateString(SettingKeys.WX_APPID_CACHE, "")
    
    self.textBtnEmail:SetLocalText(state == AccountBandState.UnBand and '208181' or state == AccountBandState.UnCheck and '280125' or '280057') 
    --self.textBtnApple:SetLocalText( '208180) 
    --self.textBtnWeChat:SetLocalText(208179) 
    --self.textBtnFacebook:SetLocalText(280052) 
end

local function OnDisable(self)
    base.OnDisable(self)
end

UIBindAccount.OnCreate= OnCreate
UIBindAccount.OnDestroy = OnDestroy
UIBindAccount.ComponentDefine = ComponentDefine
UIBindAccount.ComponentDestroy = ComponentDestroy
UIBindAccount.OnOpen = OnOpen
UIBindAccount.OnEnable = OnEnable
UIBindAccount.OnDisable = OnDisable

UIBindAccount.OnBtnEmailClick = OnBtnEmailClick
UIBindAccount.OnBtnAppleClick = OnBtnAppleClick
UIBindAccount.OnBtnWeChatClick = OnBtnWeChatClick
UIBindAccount.OnBtnFacebookClick = OnBtnFacebookClick

return UIBindAccount