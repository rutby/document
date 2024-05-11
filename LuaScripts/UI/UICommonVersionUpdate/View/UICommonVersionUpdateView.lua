---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zzl.
--- DateTime: 2020/11/9 14:46
---
local UICommonVersionUpdateView = BaseClass("UICommonVersionUpdateView",UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
function UICommonVersionUpdateView:OnCreate()
    base.OnCreate(self)
    self.title = self:AddComponent(UIText,"UICommonMiniPopUpTitle/Bg_mid/titleText")
    self.tips_txt = self:AddComponent(UIText, "UICommonMiniPopUpTitle/DesName")
    self.btn_1 = self:AddComponent(UIButton, "UICommonMiniPopUpTitle/BtnGo/LeftBtn")
    self.btn_1_txt = self:AddComponent(UIText,"UICommonMiniPopUpTitle/BtnGo/LeftBtn/LeftBtnName")
    self.btn_1:SetOnClick(function()
        self:OnBtnClick()
    end)
    self.btn_2 = self:AddComponent(UIButton,  "UICommonMiniPopUpTitle/BtnGo/RightBtn")
    self.btn_2_txt = self:AddComponent(UIText,"UICommonMiniPopUpTitle/BtnGo/RightBtn/RightBtnName")
    self.btn_2:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)
    self.close_btn = self:AddComponent(UIButton, "UICommonMiniPopUpTitle/Bg_mid/CloseBtn")
    self.return_btn = self:AddComponent(UIButton, "UICommonMiniPopUpTitle/panel")
    self.close_btn:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)
    self.return_btn:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)
end

function UICommonVersionUpdateView:OnDestroy()
    self.titleText =nil
    self.tipText = nil
    self.text1 =nil
    self.text2 =nil
    self.action1 = nil
    self.closeAction = nil
    self.action2 =nil
    self.title = nil
    self.tips_txt = nil
    self.btn_1 = nil
    self.btn_1_txt = nil
    self.btn_2 = nil
    self.btn_2_txt = nil
    self.close_btn = nil
    self.return_btn = nil
    self.closeIsShow = nil
    base.OnDestroy(self)
end

function UICommonVersionUpdateView:OnEnable()
    base.OnEnable(self)
    self:RefreshData()
end

function UICommonVersionUpdateView:OnDisable()
    base.OnDisable(self)
end

function UICommonVersionUpdateView:SetData(tipText,titleText)
    self.titleText =titleText
    self.tipText = tipText
end

function UICommonVersionUpdateView:RefreshData()
    if self.titleText~=nil and self.titleText~="" then
        self.title:SetLocalText(self.titleText)
    else
        self.title:SetLocalText(100378)
    end
    
    self.tips_txt:SetLocalText(110327,self.tipText)
    
    self.btn_1_txt:SetLocalText(110003)
    
    self.btn_2_txt:SetLocalText(GameDialogDefine.CANCEL)
end

function UICommonVersionUpdateView:OnBtnClick()
    CS.UnityEngine.Application.OpenURL(CS.GameEntry.GlobalData.downloadurl)
end

return UICommonVersionUpdateView