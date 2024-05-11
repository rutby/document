---
--- 角色登陆
--- Created by zzl.
--- DateTime: 
---
local UIRoleLoginView = BaseClass("UIRoleLoginView",UIBaseView)
local base = UIBaseView
local Setting = CS.GameEntry.Setting
local Localization = CS.GameEntry.Localization
local txt_title_path ="UICommonMiniPopUpTitle/Bg_mid/titleText"
local close_btn_path = "UICommonMiniPopUpTitle/Bg_mid/CloseBtn"
local return_btn_path = "UICommonMiniPopUpTitle/panel"
local rolesLoginTips_txt_path = "UICommonMiniPopUpTitle/Txt_RolesLoginTips"
local name_txt_path = "UICommonMiniPopUpTitle/Txt_Name"
local head_path = "UICommonMiniPopUpTitle/UIPlayerHead/HeadIcon"
local left_btn_path = "UICommonMiniPopUpTitle/BtnGo/LeftBtn"
local left_txt_path = "UICommonMiniPopUpTitle/BtnGo/LeftBtn/LeftBtnName"
local right_btn_path = "UICommonMiniPopUpTitle/BtnGo/RightBtn"
local right_txt_path = "UICommonMiniPopUpTitle/BtnGo/RightBtn/RightBtnName"

--创建
function UIRoleLoginView:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
    self:ReInit()
end

-- 销毁
function UIRoleLoginView:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIRoleLoginView:ComponentDefine()
    self.txt_title = self:AddComponent(UITextMeshProUGUIEx, txt_title_path)
    self.close_btn = self:AddComponent(UIButton, close_btn_path)
    self.return_btn = self:AddComponent(UIButton, return_btn_path)

    self.close_btn:SetOnClick(function()  
        self.ctrl:CloseSelf()
    end)

    self.return_btn:SetOnClick(function()  
        self.ctrl:CloseSelf()
    end)
    self.headIconN 			= self:AddComponent(UIPlayerHead,head_path)
    self._rolesLoginTips_txt =  self:AddComponent(UITextMeshProUGUIEx,rolesLoginTips_txt_path)
    self._name_txt       =  self:AddComponent(UITextMeshProUGUIEx,name_txt_path)
    
    self._left_btn = self:AddComponent(UIButton,left_btn_path)
    self._right_btn = self:AddComponent(UIButton,right_btn_path)
    self._left_btn:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)
    self._right_btn:SetOnClick(function()
        self:OnClickLogin()
    end)
    self._left_txt = self:AddComponent(UITextMeshProUGUIEx,left_txt_path)
    self._right_txt = self:AddComponent(UITextMeshProUGUIEx,right_txt_path)
end

function UIRoleLoginView:ComponentDestroy()
    self.txt_title = nil
    self.close_btn = nil
    self.return_btn = nil
    self._rolesLoginTips_txt = nil
    self._name_txt = nil
    self.headIconN = nil
    self._left_btn = nil
    self._right_btn = nil
    self._left_txt = nil
    self._right_txt = nil
end

function UIRoleLoginView:DataDefine()
end

function UIRoleLoginView:DataDestroy()
end

function UIRoleLoginView:OnEnable()
    base.OnEnable(self)
end

function UIRoleLoginView:OnDisable()
    base.OnDisable(self)
end

function UIRoleLoginView:ReInit()
    local param = self:GetUserData()
    self.param = param
    self._left_txt:SetLocalText(100289)
    self._right_txt:SetLocalText(100288)
    self.headIconN:SetData(param.gameUid,param.pic,param.picVer)
    self.txt_title:SetLocalText(208228)
    self._rolesLoginTips_txt:SetLocalText(208229)
    if param.alAbbr~=nil and param.alAbbr~="" then
        self._name_txt:SetText("["..param.alAbbr.."]"..param.gameUserName)
    else
        self._name_txt:SetText(param.gameUserName)
    end
end

function UIRoleLoginView:OnClickLogin()
    Setting:SetString(SettingKeys.GAME_UID, self.param.gameUid)
    Setting:SetString(SettingKeys.GAME_ACCOUNT, self.param.gameUserName)
    Setting:SetPrivateInt(SettingKeys.ACCOUNT_STATUS, AccountBandState.Band)
    Setting:SetString(SettingKeys.SERVER_IP, self.param.ip)
    Setting:SetInt(SettingKeys.SERVER_PORT, self.param.port)
    Setting:SetString(SettingKeys.SERVER_ZONE, self.param.zone)
    LuaEntry.DataConfig:ClearMd5()
    SFSNetwork.SendMessage(MsgDefines.UserCleanPost)
end

return UIRoleLoginView