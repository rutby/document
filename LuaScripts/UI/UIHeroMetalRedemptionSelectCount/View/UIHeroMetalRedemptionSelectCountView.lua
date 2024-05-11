--- Created by shimin
--- DateTime: 2023/7/20 21:46
--- 英雄勋章/海报兑换选择数量界面

local UIHeroMetalRedemptionSelectCountView = BaseClass("UIHeroMetalRedemptionSelectCountView", UIBaseView)
local base = UIBaseView

local UIHeroMetalRedemptionHeroCell = require "UI.UIHeroMetalRedemption.Component.UIHeroMetalRedemptionHeroCell"
local UIHeroMetalRedemptionMetalCell = require "UI.UIHeroMetalRedemption.Component.UIHeroMetalRedemptionMetalCell"

local title_text_path = "UICommonMidPopUpTitle/bg_mid/titleText"
local panel_btn_path = "UICommonMidPopUpTitle/panel"
local close_btn_path = "UICommonMidPopUpTitle/bg_mid/CloseBtn"
local hero_page_cell_path = "Root/UIHeroMetalRedemptionHeroCell"
local hero_metal_cell_path = "Root/UIHeroMetalRedemptionMetalCell"
local slider_path = "Root/Slider"
local exchange_btn_path = "Root/BtnExchange"
local exchange_text_path = "Root/BtnExchange/TextBtnExchange"
local add_btn_path = "Root/AddBtn"
local sub_btn_path = "Root/SubBtn"
local max_btn_path = "Root/MaxBtn"
local max_text_path = "Root/MaxBtn/MaxBtnText"
local desc_text_path = "Root/DescText"
local metal_name_text_path = "Root/UIHeroMetalRedemptionMetalCell/MetalTextName"
local hero_page_name_text_path = "Root/UIHeroMetalRedemptionHeroCell/HeroPageTextName"


function UIHeroMetalRedemptionSelectCountView:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
    self:ReInit()
end

function UIHeroMetalRedemptionSelectCountView:ComponentDefine()
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
    self.hero_page_cell = self:AddComponent(UIHeroMetalRedemptionHeroCell, hero_page_cell_path)
    self.hero_metal_cell = self:AddComponent(UIHeroMetalRedemptionMetalCell, hero_metal_cell_path)
    self.slider = self:AddComponent(UISlider, slider_path)
    self.slider:SetOnValueChanged(function (value)
        self:OnValueChange(value)
    end)
    self.exchange_btn = self:AddComponent(UIButton, exchange_btn_path)
    self.exchange_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnExchangeBtnClick()
    end)
    self.add_btn = self:AddComponent(UIButton, add_btn_path)
    self.add_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Add)
        self:OnAddBtnClick()
    end)
    self.sub_btn = self:AddComponent(UIButton, sub_btn_path)
    self.sub_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Dec)
        self:OnSubBtnClick()
    end)
    self.max_btn = self:AddComponent(UIButton, max_btn_path)
    self.max_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnMaxBtnClick()
    end)
    self.max_text = self:AddComponent(UIText, max_text_path)
    self.exchange_text = self:AddComponent(UIText, exchange_text_path)
    self.desc_text = self:AddComponent(UIText, desc_text_path)
    self.metal_name_text = self:AddComponent(UIText, metal_name_text_path)
    self.hero_page_name_text = self:AddComponent(UIText, hero_page_name_text_path)
end

function UIHeroMetalRedemptionSelectCountView:ComponentDestroy()
end

function UIHeroMetalRedemptionSelectCountView:DataDefine()
    self.param = {}
end

function UIHeroMetalRedemptionSelectCountView:DataDestroy()
    self.param = {}
end

function UIHeroMetalRedemptionSelectCountView:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIHeroMetalRedemptionSelectCountView:OnEnable()
    base.OnEnable(self)
end

function UIHeroMetalRedemptionSelectCountView:OnDisable()
    base.OnDisable(self)
end

function UIHeroMetalRedemptionSelectCountView:OnAddListener()
    base.OnAddListener(self)
end

function UIHeroMetalRedemptionSelectCountView:OnRemoveListener()
    base.OnRemoveListener(self)
end

function UIHeroMetalRedemptionSelectCountView:ReInit()
    self.param = self:GetUserData()
    self.max_text:SetLocalText(GameDialogDefine.MAX_)
    self.exchange_text:SetLocalText(GameDialogDefine.CONFIRM)
    self:Refresh()
end

function UIHeroMetalRedemptionSelectCountView:Refresh()
    if self.param.tabType == UIHeroMetalRedemptionTabType.HeroPage then
        self.title_text:SetLocalText(GameDialogDefine.HERO_PAGE_REDEMPTION)
        self.hero_page_cell:SetActive(true)
        self.hero_metal_cell:SetActive(false)
        local param = {}
        param.num = self.param.num
        param.heroId = self.param.heroId
        param.rarity = self.param.rarity
        param.camp = self.param.camp
        param.quality = self.param.quality
        self.hero_page_cell:ReInit(param)
        self.desc_text:SetLocalText(GameDialogDefine.PLEASE_SELECT_REDEMPTION_HERO_PAGE_NUM)
        self.hero_page_name_text:SetText(HeroUtils.GetHeroNameByConfigId(self.param.heroId))
    elseif self.param.tabType == UIHeroMetalRedemptionTabType.Metal then
        self.title_text:SetLocalText(GameDialogDefine.METAL_REDEMPTION)
        self.hero_page_cell:SetActive(false)
        self.hero_metal_cell:SetActive(true)
        local param = {}
        param.num = self.param.num
        param.itemId = self.param.itemId
        param.template = self.param.template
        param.color = self.param.color
        self.hero_metal_cell:ReInit(param)
        self.desc_text:SetLocalText(GameDialogDefine.PLEASE_SELECT_REDEMPTION_METAL_NUM)
        self.metal_name_text:SetText(DataCenter.ItemTemplateManager:GetName(self.param.itemId))
    end
    self:RefreshNum()
end

function UIHeroMetalRedemptionSelectCountView:OnExchangeBtnClick()
    if self.param.callback ~= nil then
        self.param.callback(self.param.num)
    end
    self.ctrl:CloseSelf()
end

function UIHeroMetalRedemptionSelectCountView:OnAddBtnClick()
    if self.param.num < self.param.count then
        self.param.num = self.param.num + 1
        self:RefreshNum()
    end
end
function UIHeroMetalRedemptionSelectCountView:OnSubBtnClick()
    if self.param.num > 0 then
        self.param.num = self.param.num - 1
        self:RefreshNum()
    end
end
function UIHeroMetalRedemptionSelectCountView:OnMaxBtnClick()
    if self.param.num ~= self.param.count then
        self.param.num = self.param.count
        self:RefreshNum()
    end
end

function UIHeroMetalRedemptionSelectCountView:RefreshNum(noChangeSlider)
    if self.param.tabType == UIHeroMetalRedemptionTabType.HeroPage then
        self.hero_page_cell:SetSelectNum(self.param.num)
    elseif self.param.tabType == UIHeroMetalRedemptionTabType.Metal then
        self.hero_metal_cell:SetSelectNum(self.param.num)
    end
    if not noChangeSlider then
        self.slider:SetValue(self.param.num / self.param.count)
    end
end

function UIHeroMetalRedemptionSelectCountView:OnValueChange(val)
    local inputCount = math.floor(val * self.param.count + 0.5)
    if self.param.num ~= inputCount then
        self.param.num = inputCount
        self:RefreshNum(true)
    end
end


return UIHeroMetalRedemptionSelectCountView