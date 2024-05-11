
local UIGrowthPlanBuyPanelView = BaseClass("UIGrowthPlanBuyPanelView", UIBaseView)
local base = UIBaseView
local UIGray = CS.UIGray
local UICommonItem = require "UI.UICommonItem.UICommonItem"

local titleTxt_path = "UICommonMiniPopUpTitle/Bg_mid/titleText"
local returnBtn_path = "UICommonMiniPopUpTitle/panel"
local closeBtn_path = "UICommonMiniPopUpTitle/Bg_mid/CloseBtn"
local txtDes_path = "UICommonMiniPopUpTitle/DesName"
local txtNum_path = "UICommonMiniPopUpTitle/contentBg/txtNum"
local buyBtn_path = "UICommonMiniPopUpTitle/BtnGo/btnBuy"
local txtBuy_path = "UICommonMiniPopUpTitle/BtnGo/btnBuy/btnText"

function UIGrowthPlanBuyPanelView:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
    self:ReInit()
end

function UIGrowthPlanBuyPanelView:ComponentDefine()
    self.title_text = self:AddComponent(UITextMeshProUGUIEx, titleTxt_path)
    self.title_text:SetLocalText(470076)
    self.return_btn = self:AddComponent(UIButton, returnBtn_path)
    self.return_btn:SetOnClick(function()
        CS.GameEntry.Sound:PlayEffect(SoundAssets.Music_Effect_Button)
        self.ctrl:CloseSelf()
    end)
    self.close_btn = self:AddComponent(UIButton, closeBtn_path)
    self.close_btn:SetOnClick(function()
        CS.GameEntry.Sound:PlayEffect(SoundAssets.Music_Effect_Button)
        self.ctrl:CloseSelf()
    end)
    self.txtDes = self:AddComponent(UITextMeshProUGUIEx, txtDes_path)
    self.txtDes:SetLocalText(470064)
    self.txtNum = self:AddComponent(UITextMeshProUGUIEx, txtNum_path)
    self.buyBtn = self:AddComponent(UIButton, buyBtn_path)
    self.buyBtn:SetOnClick(function()
        self:OnClickBuyBtn()
    end)
    self.txtBuy = self:AddComponent(UITextMeshProUGUIEx, txtBuy_path)
end

function UIGrowthPlanBuyPanelView:ComponentDestroy()
end

function UIGrowthPlanBuyPanelView:DataDefine()
    self.param = self:GetUserData()
end

function UIGrowthPlanBuyPanelView:DataDestroy()

end

function UIGrowthPlanBuyPanelView:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIGrowthPlanBuyPanelView:OnEnable()
    base.OnEnable(self)
end

function UIGrowthPlanBuyPanelView:OnDisable()
    base.OnDisable(self)
end

function UIGrowthPlanBuyPanelView:OnAddListener()
    base.OnAddListener(self)
end

function UIGrowthPlanBuyPanelView:OnRemoveListener()
    base.OnRemoveListener(self)
end

function UIGrowthPlanBuyPanelView:ReInit()
    self.txtNum:SetText("x"..self.param.count)
    self.txtBuy:SetText(DataCenter.PayManager:GetDollarText(self.param.pack:getPrice(), self.param.pack:getProductID()))
end

function UIGrowthPlanBuyPanelView:OnClickBuyBtn()
    DataCenter.PayManager:CallPayment(self.param.pack, UIWindowNames.UIGrowthPlanBuyPanel)
    self.ctrl:CloseSelf()
end

return UIGrowthPlanBuyPanelView