---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2022/11/4 15:56
---

local UIPVEPowerLackItem = BaseClass("UIPVEPowerLackItem", UIBaseContainer)
local base = UIBaseContainer

local BgStart_path = "BgStart"
local BgOver_path = "BgOver"
local BgFirst_path = "BgFirst"
local recommend_path = "Recommend"
local icon_path = "Icon"
local name_path = "Name"
local btn_path = "Btn"
local btnFirst_path = "BtnFirst"
local btnText_path = "Btn/btnText"
local btnFirstText_path = "BtnFirst/btnFirstText"

local function OnCreate(self)
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

local function OnDestroy(self)
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

local function ComponentDefine(self)
    self.BgStart = self:AddComponent(UIBaseContainer, BgStart_path)
    self.BgOver = self:AddComponent(UIBaseContainer, BgOver_path)
    self.BgFirst = self:AddComponent(UIBaseContainer, BgFirst_path)
    self.recommend_go = self:AddComponent(UIBaseContainer, recommend_path)
    self.icon_btn = self:AddComponent(UIButton, icon_path)
    self.icon_btn:SetOnClick(function()
        self:OnClick()
    end)
    self.name_text = self:AddComponent(UITextMeshProUGUIEx, name_path)
    self.btnText_text = self:AddComponent(UITextMeshProUGUIEx, btnText_path)
    self.btnFirstText_text = self:AddComponent(UITextMeshProUGUIEx, btnFirstText_path)
    self.btnText_text:SetLocalText(470097)
    self.btnFirstText_text:SetLocalText(470097)
    self.btnFirst = self:AddComponent(UIButton, btnFirst_path)
    self.btnFirst:SetOnClick(function()
        self:OnClick()
    end)
    self.btn = self:AddComponent(UIButton, btn_path)
    self.btn:SetOnClick(function()
        self:OnClick()
    end)
end

local function ComponentDestroy(self)
    self.bg_go = nil
    self.recommend_go = nil
    self.icon_btn = nil
    self.name_text = nil
    self.btnFirst = nil
    self.btn = nil
end

local function DataDefine(self)
    self.data = nil
end

local function DataDestroy(self)
    self.data = nil
end

local function OnEnable(self)
    base.OnEnable(self)
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function OnAddListener(self)
    base.OnAddListener(self)
end

local function OnRemoveListener(self)
    base.OnRemoveListener(self)
end

local function SetData(self, data)
    self.data = data
    self.name_text:SetLocalText(data.template.name)
    self.btn:SetActive(data.showBtn)

    local pic = ""
    if data.tip == PvePowerLackTipType.FirstPay then
        -- 首充特殊处理
        self.icon_btn:SetActive(false)
        self.btn:SetActive(false)
        self.btnFirst:SetActive(true)
        self.BgStart:SetActive(false)
        self.BgOver:SetActive(false)
        self.BgFirst:SetActive(true)
        self.recommend_go:SetActive(false)
        pic = string.IsNullOrEmpty(data.template.para2) and data.template.pic or data.template.para2
    else
        self.icon_btn:SetActive(true)
        self.btn:SetActive(true)
        self.btnFirst:SetActive(false)
        self.BgFirst:SetActive(false)
        if data.showBg then
            self.BgOver:SetActive(false)
            self.BgStart:SetActive(true)
            self.recommend_go:SetActive(data.recommended)
            pic = data.template.pic
        else
            self.BgStart:SetActive(false)
            self.BgOver:SetActive(true)
            self.recommend_go:SetActive(false)
            pic = string.IsNullOrEmpty(data.template.para2) and data.template.pic or data.template.para2
        end
    end

    self.icon_btn:LoadSprite(string.format(LoadPath.UIPve, pic))
end

local function OnClick(self)
    if self.data and self.data.onClick then
        self.data.onClick()
    end
end

UIPVEPowerLackItem.OnCreate = OnCreate
UIPVEPowerLackItem.OnDestroy = OnDestroy
UIPVEPowerLackItem.ComponentDefine = ComponentDefine
UIPVEPowerLackItem.ComponentDestroy = ComponentDestroy
UIPVEPowerLackItem.DataDefine = DataDefine
UIPVEPowerLackItem.DataDestroy = DataDestroy
UIPVEPowerLackItem.OnEnable = OnEnable
UIPVEPowerLackItem.OnDisable = OnDisable
UIPVEPowerLackItem.OnAddListener = OnAddListener
UIPVEPowerLackItem.OnRemoveListener = OnRemoveListener

UIPVEPowerLackItem.SetData = SetData
UIPVEPowerLackItem.OnClick = OnClick

return UIPVEPowerLackItem