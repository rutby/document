---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zzl.
--- DateTime: 
---
local UIVIPRewardPopUpView = BaseClass("UIVIPRewardPopUpView",UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

local panel_btn = "UICommonMiniPopUpTitle/panel"
local title_path = "UICommonMiniPopUpTitle/Bg_mid/titleText"
local return_btn_path = "UICommonMiniPopUpTitle/Bg_mid/CloseBtn"
local today_text_path = "layout/todayContent/today_text"
local today_num_path = "layout/todayContent/todayNum"
local continue_day_text_path = "layout/continueContent/continue_day_text"
local continue_day_num_path = "layout/continueContent/continue_dayNum"
local tomorrow_text_path = "layout/tomorrowContent/tomorrow_text"
local tomorrow_num_path = "layout/tomorrowContent/tomorrowNum"
local des_text_path = "des_text"

function UIVIPRewardPopUpView:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
    self:ReInit()
end

function UIVIPRewardPopUpView:ComponentDefine()
    self.panel_btn = self:AddComponent(UIButton, panel_btn)
    self.panel_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self.ctrl:CloseSelf()
    end)
    self.return_btn = self:AddComponent(UIButton, return_btn_path)
    self.return_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self.ctrl:CloseSelf()
    end)
    self._title_txt = self:AddComponent(UITextMeshProUGUIEx, title_path)
    self.today_text = self:AddComponent(UITextMeshProUGUIEx, today_text_path)
    self.continue_day_text = self:AddComponent(UITextMeshProUGUIEx, continue_day_text_path)
    self.tomorrow_text = self:AddComponent(UITextMeshProUGUIEx, tomorrow_text_path)

    self.today_num = self:AddComponent(UITextMeshProUGUIEx, today_num_path)
    self.continue_day_num = self:AddComponent(UITextMeshProUGUIEx, continue_day_num_path)
    self.tomorrow_num = self:AddComponent(UITextMeshProUGUIEx, tomorrow_num_path)

    self.des_text = self:AddComponent(UITextMeshProUGUIEx, des_text_path)
end

function UIVIPRewardPopUpView:DataDefine()

end

function UIVIPRewardPopUpView:OnDestroy()
    base.OnDestroy(self)
end

function UIVIPRewardPopUpView:OnEnable()
    base.OnEnable(self)
end

function UIVIPRewardPopUpView:OnDisable()
    base.OnDisable(self)
end

function UIVIPRewardPopUpView:ReInit()
    local vipInfo = DataCenter.VIPManager:GetVipData()
    if vipInfo ~= nil then
        self._title_txt:SetLocalText(128027)
        self.today_text:SetText(Localization:GetString("320223")..": ")
        self.continue_day_text:SetText(Localization:GetString(320224)..": ")
        self.tomorrow_text:SetText(Localization:GetString(320233)..": ")
        self.des_text:SetLocalText(320234)
        self.today_num:SetText(string.GetFormattedSeperatorNum(DataCenter.VIPManager:TodayPoint()))
        self.continue_day_num:SetText(string.GetFormattedSeperatorNum(vipInfo:GetLoginDays()))
        self.tomorrow_num:SetText(string.GetFormattedSeperatorNum(DataCenter.VIPManager:TomorrowPoint()))
        self.des_text:SetLocalText(320234)
    end
end

return UIVIPRewardPopUpView