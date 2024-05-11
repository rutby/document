--- Created by shimin
--- DateTime: 2023/7/17 20:38
--- 英雄插件品质详情界面cell

local UIHeroPluginQualityTipCell = BaseClass("UIHeroPluginQualityTipCell", UIBaseContainer)
local base = UIBaseContainer
local UIHeroTipsView = require "UI.UIHeroTips.View.UIHeroTipsView"

local this_path = ""
local show_text_path = "show_text"
local show_special_text_path = "show_special_text"
local lock_img_path = "rhombus_img"
local line_go_path = "LineGo"

function UIHeroPluginQualityTipCell:OnCreate()
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

function UIHeroPluginQualityTipCell:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIHeroPluginQualityTipCell:OnEnable()
    base.OnEnable(self)
end

function UIHeroPluginQualityTipCell:OnDisable()
    base.OnDisable(self)
end

function UIHeroPluginQualityTipCell:ComponentDefine()
    self.show_text = self:AddComponent(UIText, show_text_path)
    self.show_special_text = self:AddComponent(UIText, show_special_text_path)
    self.lock_img = self:AddComponent(UIImage, lock_img_path)
    self.line_go = self:AddComponent(UIBaseContainer, line_go_path)
    self.text_btn = self:AddComponent(UIButton, this_path)
    self.text_btn:SetOnClick(function()
        self:OnTextBtnClick()
    end)
end

function UIHeroPluginQualityTipCell:ComponentDestroy()
end

function UIHeroPluginQualityTipCell:DataDefine()
    self.param = {}
end

function UIHeroPluginQualityTipCell:DataDestroy()
    self.param = {}
end

function UIHeroPluginQualityTipCell:OnAddListener()
    base.OnAddListener(self)
end

function UIHeroPluginQualityTipCell:OnRemoveListener()
    base.OnRemoveListener(self)
end

function UIHeroPluginQualityTipCell:ReInit(param)
    self.param = param
    self:Refresh()
end

function UIHeroPluginQualityTipCell:Refresh()
    if self.param ~= nil then
        local showStr = ""
        if self.param.data == nil then
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
            if self.param.showLine then
                self.line_go:SetActive(true)
            else
                self.line_go:SetActive(false)
            end
        else
            if self.param.data.isSpecial then
                self.show_text:SetActive(false)
                self.show_special_text:SetActive(true)
                self.show_special_text:SetText(self.param.data.showName)
                showStr = self.show_special_text:GetText()
            else
                self.show_text:SetActive(true)
                self.show_text:SetText(self.param.data.showName)
                self.show_special_text:SetActive(false)
                showStr = self.show_text:GetText()
            end
            self.lock_img:LoadSprite(DataCenter.HeroPluginManager:GetRhombusNameByQuality(self.param.data.quality), nil, function()
                self.lock_img:SetNativeSize()
            end)
            if self.param.data.showLine then
                self.line_go:SetActive(true)
            else
                self.line_go:SetActive(false)
            end
        end
        if string.contains(showStr, UseOmitBtnStr) then
            self.text_btn:SetInteractable(true)
        else
            self.text_btn:SetInteractable(false)
        end
    end
end

function UIHeroPluginQualityTipCell:OnTextBtnClick()
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

return UIHeroPluginQualityTipCell