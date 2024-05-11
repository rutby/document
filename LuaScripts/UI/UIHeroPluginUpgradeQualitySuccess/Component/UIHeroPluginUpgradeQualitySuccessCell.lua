--- Created by shimin
--- DateTime: 2023/7/27 15:06
--- 英雄插件品质升级界面cell

local UIHeroPluginUpgradeQualitySuccessCell = BaseClass("UIHeroPluginUpgradeQualitySuccessCell", UIBaseContainer)
local base = UIBaseContainer
local UIHeroTipsView = require "UI.UIHeroTips.View.UIHeroTipsView"

local this_path = ""
local show_text_path = "show_text"
local show_special_text_path = "show_special_text"
local lock_img_path = "rhombus_img"
local show_value_path = "show_value"

local NormalTextSize = Vector2.New(328, 44)
local SpecialTextSize = Vector2.New(331, 44)
local LongNormalTextSize = Vector2.New(477, 44)
local LongSpecialTextSize = Vector2.New(481, 44)

function UIHeroPluginUpgradeQualitySuccessCell:OnCreate()
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

function UIHeroPluginUpgradeQualitySuccessCell:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIHeroPluginUpgradeQualitySuccessCell:OnEnable()
    base.OnEnable(self)
end

function UIHeroPluginUpgradeQualitySuccessCell:OnDisable()
    base.OnDisable(self)
end

function UIHeroPluginUpgradeQualitySuccessCell:ComponentDefine()
    self.show_text = self:AddComponent(UIText, show_text_path)
    self.show_special_text = self:AddComponent(UIText, show_special_text_path)
    self.lock_img = self:AddComponent(UIImage, lock_img_path)
    self.text_btn = self:AddComponent(UIButton, this_path)
    self.text_btn:SetOnClick(function()
        self:OnTextBtnClick()
    end)
    self.show_value = self:AddComponent(UIText, show_value_path)
end

function UIHeroPluginUpgradeQualitySuccessCell:ComponentDestroy()
end

function UIHeroPluginUpgradeQualitySuccessCell:DataDefine()
    self.param = {}
end

function UIHeroPluginUpgradeQualitySuccessCell:DataDestroy()
    self.param = {}
end

function UIHeroPluginUpgradeQualitySuccessCell:OnAddListener()
    base.OnAddListener(self)
end

function UIHeroPluginUpgradeQualitySuccessCell:OnRemoveListener()
    base.OnRemoveListener(self)
end

function UIHeroPluginUpgradeQualitySuccessCell:ReInit(param)
    self.param = param
    self:Refresh()
end

function UIHeroPluginUpgradeQualitySuccessCell:Refresh()
    if self.param ~= nil then
        if self.param.showValue == nil then
            self.show_text:SetPreferSize(LongNormalTextSize)
            self.show_special_text:SetPreferSize(LongSpecialTextSize)
            self.show_value:SetActive(false)
        else
            self.show_text:SetPreferSize(NormalTextSize)
            self.show_special_text:SetPreferSize(SpecialTextSize)
            self.show_value:SetActive(true)
            self.show_value:SetText(self.param.showValue)
        end
        local showStr = ""
        if self.param.isSpecial then
            self.show_text:SetActive(false)
            self.show_special_text:SetActive(true)
            self.show_special_text:SetText(self.param.showName)
            showStr = self.show_special_text:GetText()
        else
            self.show_text:SetActive(true)
            self.show_text:SetText(self.param.showName)
            self.show_special_text:SetActive(false)
            showStr = self.show_text:GetText()
        end
        self.lock_img:LoadSprite(DataCenter.HeroPluginManager:GetRhombusNameByQuality(self.param.quality), nil, function()
            self.lock_img:SetNativeSize()
        end)
        if string.contains(showStr, UseOmitBtnStr) then
            self.text_btn:SetInteractable(true)
        else
            self.text_btn:SetInteractable(false)
        end
    end
end

function UIHeroPluginUpgradeQualitySuccessCell:OnTextBtnClick()
    local param = UIHeroTipsView.Param.New()
    if self.param.data == nil then
        param.content = self.param.showName
    else
        param.content = self.param.data.showName
    end
    param.dir = UIHeroTipsView.Direction.ABOVE
    param.defWidth = 500
    param.pivot = 0.5
    param.position = self.transform.position + Vector3.New(0, 20, 0)
    param.bindObject = self.text_btn.gameObject
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTips, { anim = false }, param)
end

return UIHeroPluginUpgradeQualitySuccessCell