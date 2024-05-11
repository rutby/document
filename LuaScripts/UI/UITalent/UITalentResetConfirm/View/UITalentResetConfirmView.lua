local UITalentResetConfirmView = BaseClass("UITalentResetConfirmView",UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray

local title_path = "UICommonMiniPopUpTitle/Bg_mid/titleText"
local return_btn_path = "UICommonMiniPopUpTitle/panel"
local close_btn_path = "UICommonMiniPopUpTitle/Bg_mid/CloseBtn"
local tips_txt_path = "DesName"

local confirm_btn_path = "BtnGo/Confirm_btn"
local confirm_btn_text_path = "BtnGo/Confirm_btn/Confirm_btn_text"
local confirm_btn_text1_path = "BtnGo/Confirm_btn/Confirm_btn_text1"
local diamond_num_text_path = "BtnGo/Confirm_btn/Text_num"
local free_num_text_path = "FreeNumText"
local function OnCreate(self)
    base.OnCreate(self)
    self.title = self:AddComponent(UITextMeshProUGUIEx,title_path)
    self.tips_txt = self:AddComponent(UITextMeshProUGUIEx,tips_txt_path)
    self.title:SetLocalText(100378)
    self.close_btn = self:AddComponent(UIButton, close_btn_path)
    self.return_btn = self:AddComponent(UIButton, return_btn_path)
    self.confirm_btn = self:AddComponent(UIButton, confirm_btn_path)
    self.confirm_btn_text = self:AddComponent(UITextMeshProUGUIEx, confirm_btn_text_path)
    self.confirm_btn_text1 = self:AddComponent(UITextMeshProUGUIEx, confirm_btn_text1_path)
    self.diamond_num_text = self:AddComponent(UITextMeshProUGUIEx, diamond_num_text_path)
    self.free_num_text = self:AddComponent(UITextMeshProUGUIEx, free_num_text_path)
    self.confirm_btn_text:SetLocalText(GameDialogDefine.CONFIRM)
    self.confirm_btn_text1:SetLocalText(GameDialogDefine.CONFIRM)
    self.confirm_btn:SetOnClick(function ()
        if self.param.onResetClick then
            self.param.onResetClick()
        end
        self.ctrl:CloseSelf()
    end)
    self.close_btn:SetOnClick(function ()
        self.ctrl:CloseSelf()
    end)
    self.return_btn:SetOnClick(function ()
        self.ctrl:CloseSelf()
    end)
end

local function OnDestroy(self)
    base.OnDestroy(self)
end

local function OnEnable(self)
    base.OnEnable(self)
    self:RefreshView()
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function RefreshView(self)
    self.param = self:GetUserData()
    self.diamond_num_text:SetActive(self.param.needDiamond > 0)
    self.diamond_num_text:SetText(string.GetFormattedSeperatorNum(self.param.needDiamond))
    self.confirm_btn_text:SetActive(self.param.needDiamond > 0)
    self.confirm_btn_text1:SetActive(self.param.needDiamond <= 0)
    self.tips_txt:SetLocalText(self.param.tip1)

    if string.IsNullOrEmpty(self.param.tip2) then
        self.free_num_text:SetText("")
    else
        self.free_num_text:SetText(self.param.tip2)
    end
end

UITalentResetConfirmView.OnCreate = OnCreate
UITalentResetConfirmView.OnDestroy = OnDestroy
UITalentResetConfirmView.OnEnable = OnEnable
UITalentResetConfirmView.OnDisable = OnDisable
UITalentResetConfirmView.RefreshView = RefreshView

return UITalentResetConfirmView