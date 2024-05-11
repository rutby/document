--- Created by shimin
--- DateTime: 2023/7/26 10:27
--- 英雄插件属性界面Const cell

local UIHeroPluginDesRandomWithoutCell = BaseClass("UIHeroPluginDesRandomWithoutCell", UIBaseContainer)
local base = UIBaseContainer
local UIHeroTipsView = require "UI.UIHeroTips.View.UIHeroTipsView"

local show_text_path = "LeftLayoutGo/show_text"
local show_special_text_path = "LeftLayoutGo/show_special_text"
local lock_img_path = "LeftLayoutGo/SelectGo/LockImg"
local lock_text_path = "RightLayoutGo/lock_text"
local line_go_path = "LineGo"
local text_btn_path = "LeftLayoutGo"
local max_go_path = "RightLayoutGo/max_go"

function UIHeroPluginDesRandomWithoutCell:OnCreate()
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

function UIHeroPluginDesRandomWithoutCell:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIHeroPluginDesRandomWithoutCell:OnEnable()
    base.OnEnable(self)
end

function UIHeroPluginDesRandomWithoutCell:OnDisable()
    base.OnDisable(self)
end

function UIHeroPluginDesRandomWithoutCell:ComponentDefine()
    self.show_text = self:AddComponent(UIText, show_text_path)
    self.show_special_text = self:AddComponent(UIText, show_special_text_path)
    self.lock_img = self:AddComponent(UIImage, lock_img_path)
    self.lock_text = self:AddComponent(UIText, lock_text_path)
    self.line_go = self:AddComponent(UIBaseContainer, line_go_path)
    self.text_btn = self:AddComponent(UIButton, text_btn_path)
    self.text_btn:SetOnClick(function()
        self:OnTextBtnClick()
    end)
    self.max_go = self:AddComponent(UIBaseContainer, max_go_path)
end

function UIHeroPluginDesRandomWithoutCell:ComponentDestroy()
end

function UIHeroPluginDesRandomWithoutCell:DataDefine()
    self.param = {}
end

function UIHeroPluginDesRandomWithoutCell:DataDestroy()
    self.param = {}
end

function UIHeroPluginDesRandomWithoutCell:OnAddListener()
    base.OnAddListener(self)
end

function UIHeroPluginDesRandomWithoutCell:OnRemoveListener()
    base.OnRemoveListener(self)
end

function UIHeroPluginDesRandomWithoutCell:ReInit(param)
    self.param = param
    self:Refresh()
end

function UIHeroPluginDesRandomWithoutCell:Refresh()
    if self.param.visible then
        self:SetActive(true)
        if self.param.data ~= nil then
            if self.param.data.needUnlock then
                self.lock_text:SetActive(true)
                self.lock_text:SetText(self.param.data.showValue)
            else
                self.lock_text:SetActive(false)
            end
            local showStr = ""
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
            if string.contains(showStr, UseOmitBtnStr) then
                self.text_btn:SetInteractable(true)
            else
                self.text_btn:SetInteractable(false)
            end
            if self.param.data.showLine then
                self.line_go:SetActive(true)
            else
                self.line_go:SetActive(false)
            end

            if self.param.data.isMax then
                self.max_go:SetActive(true)
            else
                self.max_go:SetActive(false)
            end
        end
    else
        self:SetActive(false)
    end
end

function UIHeroPluginDesRandomWithoutCell:OnTextBtnClick()
    local param = UIHeroTipsView.Param.New()
    param.content = self.param.data.showName
    param.dir = UIHeroTipsView.Direction.ABOVE
    param.defWidth = 500
    param.pivot = 0.5
    param.position = self.transform.position + Vector3.New(0, 20, 0)
    param.bindObject = self.text_btn.gameObject
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTips, { anim = false }, param)
end

return UIHeroPluginDesRandomWithoutCell