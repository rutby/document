---
--- 改变绑定邮箱界面
--- Created by shimin.
--- DateTime: 2020/10/19 17:04
---
local UIChangeMailView = BaseClass("UIChangeMailView",UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

local txt_title_path ="ImgBg/TxtTitle"
local close_btn_path = "ImgBg/BtnClose"
local return_btn_path = "Panel"
local confirm_btn_path = "ImgBg/ConfirmBtn"
local confirm_btn_name_path = "ImgBg/ConfirmBtn/ConfirmBtnName"
local username_input_path = "ImgBg/InputFieldUsername"
local username_text_path = "ImgBg/InputFieldUsername/UsernameText"
local username_hold_text_path = "ImgBg/InputFieldUsername/UsernamePlaceholder"
local password_input_path = "ImgBg/InputFieldPassword"
local password_text_path = "ImgBg/InputFieldPassword/PasswordText"
local password_hold_text_path = "ImgBg/InputFieldPassword/PasswordPlaceholder"

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
    self.confirm_btn = self:AddComponent(UIButton, confirm_btn_path)
    self.confirm_btn_name = self:AddComponent(UIText, confirm_btn_name_path)
    self.username_input = self:AddComponent(UIInput, username_input_path)
    self.username_text = self:AddComponent(UIText, username_text_path)
    self.username_hold_text = self:AddComponent(UIText, username_hold_text_path)
    self.password_input = self:AddComponent(UIInput, password_input_path)
    self.password_text = self:AddComponent(UIText, password_text_path)
    self.password_hold_text = self:AddComponent(UIText, password_hold_text_path)

    self.close_btn:SetOnClick(function()  
        self.ctrl:CloseSelf()
    end)
    self.return_btn:SetOnClick(function()  
        self.ctrl:CloseSelf()
    end)
    self.confirm_btn:SetOnClick(function()  
SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnConfirmBtnClick()
    end)
end

local function ComponentDestroy(self)
    self.txt_title = nil
    self.close_btn = nil
    self.return_btn = nil
    self.confirm_btn = nil
    self.confirm_btn_name = nil
    self.username_input = nil
    self.username_text = nil
    self.username_hold_text = nil
    self.password_input = nil
    self.password_text = nil
    self.password_hold_text = nil
end

local function OnEnable(self)
    base.OnEnable(self)
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function ReInit(self)
    self.txt_title:SetLocalText(280114) 
    self.username_text:SetLocalText(280115) 
    self.password_text:SetLocalText(280116) 
    self.confirm_btn_name:SetLocalText(280108) 
    self.username_hold_text:SetLocalText(280102) 
    self.password_hold_text:SetLocalText(280104) 
end

local function OnConfirmBtnClick(self)
    local username = self.username_input:GetText()
    local password = self.password_input:GetText()
    --验证用户名格式是否合法
    if username == nil or username == "" then
        UIUtil.ShowTipsId(280122) 
    else
        if self.ctrl:CheckPwd(password) then
            SFSNetwork.SendMessage(MsgDefines.AccountChangeMail,{newEmail = username,pwd = password})
        end
    end
end

local function OnAddListener(self)
    base.OnAddListener(self)
    self:AddUIListener(EventId.AccountChangeMailEvent, self.AccountChangeMailEventSignal)
end


local function OnRemoveListener(self)
    base.OnRemoveListener(self)
    self:RemoveUIListener(EventId.AccountChangeMailEvent, self.AccountChangeMailEventSignal)
end

local function AccountChangeMailEventSignal(self) 
    self.ctrl:CloseSelf()
end

UIChangeMailView.OnCreate= OnCreate
UIChangeMailView.OnDestroy = OnDestroy
UIChangeMailView.OnEnable = OnEnable
UIChangeMailView.OnDisable = OnDisable
UIChangeMailView.ComponentDefine = ComponentDefine
UIChangeMailView.ComponentDestroy = ComponentDestroy
UIChangeMailView.OnConfirmBtnClick = OnConfirmBtnClick
UIChangeMailView.ReInit = ReInit
UIChangeMailView.OnAddListener = OnAddListener
UIChangeMailView.OnRemoveListener = OnRemoveListener
UIChangeMailView.AccountChangeMailEventSignal = AccountChangeMailEventSignal

return UIChangeMailView