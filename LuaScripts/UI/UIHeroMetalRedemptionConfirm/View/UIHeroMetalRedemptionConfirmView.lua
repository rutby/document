--- Created by shimin
--- DateTime: 2023/7/21 17:46
--- 英雄勋章/海报兑换最终确认界面

local UIHeroMetalRedemptionConfirmView = BaseClass("UIHeroMetalRedemptionConfirmView", UIBaseView)
local base = UIBaseView
local UIHeroMetalRedemptionMetalCell = require "UI.UIHeroMetalRedemption.Component.UIHeroMetalRedemptionMetalCell"

local title_text_path = "UICommonMiniPopUpTitle/Bg_mid/titleText"
local close_btn_path = "UICommonMiniPopUpTitle/Bg_mid/CloseBtn"
local panel_btn_path = "UICommonMiniPopUpTitle/panel"
local content_text_path = "DesName"
local left_btn_path = "BtnGo/LeftBtn"
local left_btn_text_path = "BtnGo/LeftBtn/LeftBtnName"
local right_btn_path = "BtnGo/RightBtn"
local right_btn_text_path = "BtnGo/RightBtn/RightBtnName"
local item_cell_path = "bg/UIHeroMetalRedemptionMetalCell"

function UIHeroMetalRedemptionConfirmView:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
    self:ReInit()
end

function UIHeroMetalRedemptionConfirmView:ComponentDefine()
    self.panel_btn = self:AddComponent(UIButton, panel_btn_path)
    self.panel_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self.ctrl:CloseSelf()
    end)
    self.title_text = self:AddComponent(UITextMeshProUGUIEx, title_text_path)
    self.close_btn = self:AddComponent(UIButton, close_btn_path)
    self.close_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self.ctrl:CloseSelf()
    end)
    self.item_cell = self:AddComponent(UIHeroMetalRedemptionMetalCell, item_cell_path)
    self.left_btn = self:AddComponent(UIButton, left_btn_path)
    self.left_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnLeftBtnClick()
    end)
    self.right_btn = self:AddComponent(UIButton, right_btn_path)
    self.right_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self.ctrl:CloseSelf()
    end)
    self.content_text = self:AddComponent(UIText, content_text_path)
    self.left_btn_text = self:AddComponent(UIText, left_btn_text_path)
    self.right_btn_text = self:AddComponent(UIText, right_btn_text_path)
end

function UIHeroMetalRedemptionConfirmView:ComponentDestroy()
end

function UIHeroMetalRedemptionConfirmView:DataDefine()
    self.param = {}
end

function UIHeroMetalRedemptionConfirmView:DataDestroy()
    self.param = {}
end

function UIHeroMetalRedemptionConfirmView:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIHeroMetalRedemptionConfirmView:OnEnable()
    base.OnEnable(self)
end

function UIHeroMetalRedemptionConfirmView:OnDisable()
    base.OnDisable(self)
end

function UIHeroMetalRedemptionConfirmView:OnAddListener()
    base.OnAddListener(self)
end

function UIHeroMetalRedemptionConfirmView:OnRemoveListener()
    base.OnRemoveListener(self)
end

function UIHeroMetalRedemptionConfirmView:ReInit()
    self.param = self:GetUserData()
    self.left_btn_text:SetLocalText(GameDialogDefine.CONFIRM)
    self.right_btn_text:SetLocalText(GameDialogDefine.CANCEL)
    self.title_text:SetLocalText(GameDialogDefine.PROMPT_TITLE)
    if self.param.tabType == UIHeroMetalRedemptionTabType.HeroPage then
        self.content_text:SetLocalText(GameDialogDefine.HERO_PLUGIN_HERO_PAGE_CONFIRM_DES)
    elseif self.param.tabType == UIHeroMetalRedemptionTabType.Metal then
        self.content_text:SetLocalText(GameDialogDefine.HERO_PLUGIN_METAL_CONFIRM_DES)
    end
    
    local itemParam = {}
    itemParam.num = self.param.count
    itemParam.itemId = DataCenter.HeroMedalRedemptionManager:GetRedemptionItemId()
    itemParam.template = DataCenter.ItemTemplateManager:GetItemTemplate(itemParam.itemId)
    if itemParam.template ~= nil then
        itemParam.color = itemParam.template.color
    end
    self.item_cell:ReInit(itemParam)
end

function UIHeroMetalRedemptionConfirmView:OnLeftBtnClick()
    if self.param.tabType == UIHeroMetalRedemptionTabType.HeroPage then
        DataCenter.HeroMedalRedemptionManager:SendHeroPosterExchangeToken(self.param.heroArr)
    elseif self.param.tabType == UIHeroMetalRedemptionTabType.Metal then
        DataCenter.HeroMedalRedemptionManager:SendHeroMedalExchangeToken(self.param.costGoods)
    end
    if self.param.flyCallback ~= nil then
        local startPos = self.item_cell.transform.position
        self.param.flyCallback(startPos, self.param.count)
    end
    self.ctrl:CloseSelf()
end

return UIHeroMetalRedemptionConfirmView