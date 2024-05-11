---
--- 账号封禁界面
--- Created by shimin.
--- DateTime: 2020/10/23 17:23
---
local UIAccountBanView = BaseClass("UIAccountBanView",UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local Setting = CS.GameEntry.Setting

local title_path = "UICommonMidPopUpTitle/bg_mid/titleText"
local name_text_path = "ImgBg/NameText"
local name_value_path = "ImgBg/NameText/NameValue"
local server_text_path = "ImgBg/ServerText"
local server_value_path = "ImgBg/ServerText/ServerValue"
local ban_time_text_path = "ImgBg/BanTimeText"
local ban_time_value_path = "ImgBg/BanTimeText/BanTimeValue"
local ban_reason_text_path = "ImgBg/BanReasonText"
local ban_reason_value_path = "ImgBg/BanReasonValue"
local exit_btn_path = "ImgBg/ExitBtn"
local exit_btn_name_path = "ImgBg/ExitBtn/ExitBtnName"
local new_game_btn_path = "ImgBg/NewGameBtn"
local new_game_btn_name_path = "ImgBg/NewGameBtn/NewGameBtnName"
local call_btn_path = "UICommonMidPopUpTitle/bg_mid/CloseBtn"
local call_btn_name_path = "ImgBg/CallBtn/CallBtnName"
local AllTimeBan = "9223372036854775806"

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
    self.title = self:AddComponent(UITextMeshProUGUIEx, title_path)
    self.name_text = self:AddComponent(UITextMeshProUGUIEx, name_text_path)
    self.name_value = self:AddComponent(UITextMeshProUGUIEx, name_value_path)
    self.server_text = self:AddComponent(UITextMeshProUGUIEx, server_text_path)
    self.server_value = self:AddComponent(UITextMeshProUGUIEx, server_value_path)
    self.ban_time_text = self:AddComponent(UITextMeshProUGUIEx, ban_time_text_path)
    self.ban_time_value = self:AddComponent(UITextMeshProUGUIEx, ban_time_value_path)
    self.ban_reason_text = self:AddComponent(UITextMeshProUGUIEx, ban_reason_text_path)
    self.ban_reason_value = self:AddComponent(UITextMeshProUGUIEx, ban_reason_value_path)
    self.exit_btn = self:AddComponent(UIButton, exit_btn_path)
    self.exit_btn_name = self:AddComponent(UITextMeshProUGUIEx, exit_btn_name_path)
    self.new_game_btn = self:AddComponent(UIButton, new_game_btn_path)
    self.new_game_btn_name = self:AddComponent(UITextMeshProUGUIEx, new_game_btn_name_path)
    self.call_btn = self:AddComponent(UIButton, call_btn_path)
    self.call_btn_name = self:AddComponent(UITextMeshProUGUIEx, call_btn_name_path)

    self.exit_btn:SetOnClick(function()  
SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnExitBtnClick()
    end)
    self.new_game_btn:SetOnClick(function()  
SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnNewGameBtnClick()
    end)
    self.call_btn:SetOnClick(function()  
SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnCallBtnClick()
    end)
end

local function ComponentDestroy(self)
    self.title = nil
    self.name_text = nil
    self.name_value = nil
    self.server_text = nil
    self.server_value = nil
    self.ban_time_text = nil
    self.ban_time_value = nil
    self.ban_reason_text = nil
    self.ban_reason_value = nil
    self.exit_btn = nil
    self.exit_btn_name = nil
    self.new_game_btn = nil
    self.new_game_btn_name = nil
    self.call_btn = nil
    self.call_btn_name = nil
end

local function DataDefine(self)
    self.state = nil
end

local function DataDestroy(self)
    self.state = nil
end


local function OnEnable(self)
    base.OnEnable(self)
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function ReInit(self)
    self.reason = self:GetUserData()
    local spl = string.split(self.reason,";")
    local splCount = #spl
    if splCount >= 4 then
        if splCount > 4 then
            self.name_value:SetText(spl[5])
            self.ban_reason_value:SetText(spl[4])
        else
            if spl[3] == "--" then
                self.name_value:SetText(spl[3])
            else
                self.name_value:SetText(spl[4])
            end
           
        end

        if spl[2] == AllTimeBan then
            self.ban_time_value:SetLocalText(280098) 
        else
            local timeCode = tonumber(spl[2])
            if timeCode < 0 then
                self.ban_time_value:SetLocalText(280098) 
            else
                self.ban_time_value:SetText(UITimeManager:GetInstance():TimeStampToTimeForLocal(timeCode * 1000 * 10000 / 10000000))
            end
        end

        local zoneName = CS.GameEntry.Network.ZoneName
        if string.len(zoneName) > 3 then
            zoneName = string.sub(zoneName,3) 
        end
        self.server_value:SetText(zoneName)
    end
    
    self.title:SetLocalText(120069) 
    self.name_text:SetLocalText(100240) 
    self.server_text:SetLocalText(280068) 
    self.exit_btn_name:SetLocalText(110043) 
    self.new_game_btn_name:SetLocalText(280045) 
    self.call_btn_name:SetLocalText(280014) 
    self.ban_reason_text:SetLocalText(100241) 
    self.ban_time_text:SetLocalText(100242) 
end

local function OnExitBtnClick(self)
    CS.ApplicationLaunch.Instance:Quit()
    self.ctrl:CloseSelf()
end

local function OnCallBtnClick(self)
    -- 求助，联系客服
    local lanName = Localization:GetLanguageName()
    if UserSayCodeMap[lanName] then
        CS.HelpManager.Instance:onShowGuest(UserSayCodeMap[lanName])
    else
        CS.HelpManager.Instance:onShowGuest("Account Banned")
    end
end

local function OnNewGameBtnClick(self)
    --SFSNetwork.SendMessage(MsgDefines.NewAccount,{ old = 1,confirm = 2})
    self:ResetData()
    
    
    self.ctrl:CloseSelf()
end

local function ResetData(self)
    Setting:SetString(SettingKeys.GAME_UID, "")
    --Setting:SetString(SettingKeys.UUID, "")
    Setting:SetString(SettingKeys.SERVER_IP, "")
    Setting:SetInt(SettingKeys.SERVER_PORT, 0)
    Setting:SetString(SettingKeys.SERVER_ZONE, "")
    CS.GameEntry.Network.Uid = ""
    --CS.UnityEngine.PlayerPrefs.DeleteAll()
    CS.ApplicationLaunch.Instance:ReStartGame()
end

UIAccountBanView.OnCreate= OnCreate
UIAccountBanView.OnDestroy = OnDestroy
UIAccountBanView.OnEnable = OnEnable
UIAccountBanView.OnDisable = OnDisable
UIAccountBanView.ComponentDefine = ComponentDefine
UIAccountBanView.ComponentDestroy = ComponentDestroy
UIAccountBanView.DataDefine = DataDefine
UIAccountBanView.DataDestroy = DataDestroy
UIAccountBanView.ReInit = ReInit
UIAccountBanView.OnCallBtnClick = OnCallBtnClick
UIAccountBanView.OnExitBtnClick = OnExitBtnClick
UIAccountBanView.OnNewGameBtnClick = OnNewGameBtnClick
UIAccountBanView.ResetData = ResetData

return UIAccountBanView