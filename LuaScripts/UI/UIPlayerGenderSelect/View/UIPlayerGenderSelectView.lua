--- 修改性别界面
--- Created by shimin.
--- DateTime: 2023/1/12 18:21
---
local UIPlayerGenderSelectView = BaseClass("UIPlayerGenderSelectView",UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray

local title_text_path = "UICommonMiniPopUpTitle/Bg_mid/titleText"
local return_btn_path = "UICommonMiniPopUpTitle/panel"
local close_btn_path = "UICommonMiniPopUpTitle/Bg_mid/CloseBtn"
local free_tip_text_path = "UICommonMiniPopUpTitle/DesName"
local use_diamond_btn_path = "UICommonMiniPopUpTitle/BtnGo/BtnYellow04"
local use_diamond_btn_name_path = "UICommonMiniPopUpTitle/BtnGo/BtnYellow04/btnTxt_yellow_mid_new/btnTxt_yellow_mid_new_text1"
local use_diamond_btn_num_text_path = "UICommonMiniPopUpTitle/BtnGo/BtnYellow04/btnTxt_yellow_mid_new/btnTxt_yellow_mid_new_text2"
local free_btn_path = "UICommonMiniPopUpTitle/BtnGo/BtnGreen01"
local free_btn_name_path = "UICommonMiniPopUpTitle/BtnGo/BtnGreen01/GoRewardName"
local sex_man_path = "GameObject/item1"
local sex_woman_path = "GameObject/item2"
local select_go_path = "SelectGo"
local sex_parent_go_path = "GameObject"

--创建
function UIPlayerGenderSelectView:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
    self:ReInit()
end

-- 销毁
function UIPlayerGenderSelectView:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIPlayerGenderSelectView:ComponentDefine()
    self.title_text = self:AddComponent(UITextMeshProUGUIEx, title_text_path)
    self.return_btn = self:AddComponent(UIButton, return_btn_path)
    self.return_btn:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)
    self.close_btn = self:AddComponent(UIButton, close_btn_path)
    self.close_btn:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)
    self.free_tip_text = self:AddComponent(UITextMeshProUGUIEx, free_tip_text_path)
    self.use_diamond_btn = self:AddComponent(UIButton, use_diamond_btn_path)
    self.use_diamond_btn:SetOnClick(function()
        self:OnUseDiamondBtnClick()
    end)
    self.use_diamond_btn_name = self:AddComponent(UITextMeshProUGUIEx, use_diamond_btn_name_path)
    self.use_diamond_btn_num_text = self:AddComponent(UITextMeshProUGUIEx, use_diamond_btn_num_text_path)
    self.free_btn = self:AddComponent(UIButton, free_btn_path)
    self.free_btn_img = self:AddComponent(UIImage, free_btn_path)
    self.free_btn:SetOnClick(function()
        self:OnFreeBtnClick()
    end)
    self.free_btn_name = self:AddComponent(UITextMeshProUGUIEx, free_btn_name_path)
    self.sex_man = self:AddComponent(UIButton, sex_man_path)
    self.sex_man:SetOnClick(function()
        self:ChangeSex(SexType.Man)
    end)
    self.sex_woman = self:AddComponent(UIButton, sex_woman_path)
    self.sex_woman:SetOnClick(function()
        self:ChangeSex(SexType.Woman)
    end)
    self.select_go = self:AddComponent(UIBaseContainer, select_go_path)
    self.sex_parent_go = self:AddComponent(UIBaseContainer, sex_parent_go_path)
end

function UIPlayerGenderSelectView:ComponentDestroy()
end

function UIPlayerGenderSelectView:DataDefine()
    self.sex = SexType.None
    self.needGray = false
end

function UIPlayerGenderSelectView:DataDestroy()
    self.sex = SexType.None
    self.needGray = false
end
function UIPlayerGenderSelectView:OnEnable()
    base.OnEnable(self)
end

function UIPlayerGenderSelectView:OnDisable()
    base.OnDisable(self)
end

function UIPlayerGenderSelectView:ReInit()
    self.title_text:SetLocalText(GameDialogDefine.CHANGE_SEX)
    self.sex = LuaEntry.Player:GetSex()
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.sex_parent_go.rectTransform)
    self:RefreshSexShow()
    self.needCostNum = LuaEntry.Player:GetModifySexCostNum()
    if self.needCostNum > 0 then
        self.free_btn:SetActive(false)
        self.use_diamond_btn:SetActive(true)
        self.use_diamond_btn_name:SetLocalText(GameDialogDefine.CONFIRM)
        self.use_diamond_btn_num_text:SetText(string.GetFormattedSeperatorNum(self.needCostNum))
        self.free_tip_text:SetActive(false)
        if self.needCostNum  > LuaEntry.Player.gold then
            self.use_diamond_btn_num_text:SetColor(Color.New(0.917, 0.26, 0.26, 1))
        else
            self.use_diamond_btn_num_text:SetColor(WhiteColor)
        end
    else
        self.free_btn:SetActive(true)
        self.use_diamond_btn:SetActive(false)
        self.free_btn_name:SetLocalText(GameDialogDefine.CONFIRM)
        self.free_tip_text:SetActive(true)
        self.free_tip_text:SetLocalText(GameDialogDefine.FIRST_CHANGE_SEX_FREE)
    end
end

function UIPlayerGenderSelectView:OnAddListener()
    base.OnAddListener(self)
    self:AddUIListener(EventId.ChangeSex, self.ChangeSexSignal)
    self:AddUIListener(EventId.UpdateGold, self.UpdateGoldSignal)
end

function UIPlayerGenderSelectView:OnRemoveListener()
    base.OnRemoveListener(self)
    self:RemoveUIListener(EventId.ChangeSex, self.ChangeSexSignal)
    self:RemoveUIListener(EventId.UpdateGold, self.UpdateGoldSignal)
end

function UIPlayerGenderSelectView:OnUseDiamondBtnClick()
    if self.sex == LuaEntry.Player:GetSex() then
        self.ctrl:CloseSelf()
    else
        if LuaEntry.Player.gold >= self.needCostNum then
            UIUtil.ShowUseDiamondConfirm(TodayNoSecondConfirmType.BuyUseDialog,Localization:GetString(GameDialogDefine.IS_COST_DIAMOND_CHANGE_SEX,
                    string.GetFormattedSeperatorNum(self.needCostNum)), 2,GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL,
                    function()
                        SexUtil.SendModifySexMessage(self.sex)
                        self.ctrl:CloseSelf()
                    end,
                    function() end)
        else
            GoToUtil.GotoPayTips()
        end
    end
end

function UIPlayerGenderSelectView:OnFreeBtnClick()
    if self.sex ~= LuaEntry.Player:GetSex() then
        SexUtil.SendModifySexMessage(self.sex)
    end
    self.ctrl:CloseSelf()
end

function UIPlayerGenderSelectView:ChangeSexSignal()
    self:ReInit()
end

function UIPlayerGenderSelectView:UpdateGoldSignal()
    self:ReInit()
end

function UIPlayerGenderSelectView:ChangeSex(sexType)
    if self.sex ~= sexType then
        self.sex = sexType
        self:RefreshSexShow()
    end
end

function UIPlayerGenderSelectView:RefreshSexShow()
    if self.sex == SexType.None then
        self.free_btn:SetInteractable(false)
        self.needGray = true
        self.select_go:SetActive(false)
        UIGray.SetGray(self.free_btn.transform, true, false)
    else
        self.select_go:SetActive(true)
        if self.needGray then
            self.needGray = false
            UIGray.SetGray(self.free_btn.transform, false,true)
            self.free_btn:SetInteractable(true)
        end
        if self.sex == SexType.Man then
            self.select_go.transform.position = self.sex_man.transform.position
        elseif self.sex == SexType.Woman then
            self.select_go.transform.position = self.sex_woman.transform.position
        end
    end
end

return UIPlayerGenderSelectView