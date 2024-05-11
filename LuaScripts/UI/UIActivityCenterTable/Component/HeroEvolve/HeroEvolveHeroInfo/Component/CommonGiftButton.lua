---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2023/3/27 14:16
---

local CommonGiftButton = BaseClass("CommonGiftButton",UIBaseContainer)
local base = UIBaseContainer
local UIGiftPackagePoint = require "UI.UIGiftPackage.Component.UIGiftPackagePoint"

local btn_path = ""
local money_text_path = "Btn_Text_Money"
local score_path = "UIGiftPackagePoint"

local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
end

local function ComponentDefine(self)
    self.btn = self:AddComponent(UIButton, btn_path)
    self.money_text = self:AddComponent(UIText, money_text_path)
    self.score = self:AddComponent(UIGiftPackagePoint, score_path)
    self.btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnClick()
    end)
end

local function ComponentDestroy(self)

end

local function OnDestroy(self)
    self:ComponentDestroy()
    base.OnDestroy(self)
end

local function OnEnable(self)
    base.OnEnable(self)
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function OnAddListener(self)
    base.OnAddListener(self)
    self:AddUIListener(EventId.UpdateGiftPackData, self.RefreshView)
end

local function OnRemoveListener(self)
    self:RemoveUIListener(EventId.UpdateGiftPackData, self.RefreshView)
    base.OnRemoveListener(self)
end

local function OnClick(self)
    local packageInfo = GiftPackageData.get(self.giftId)
    if packageInfo then
        self.callBack(packageInfo)
    end
end

local function SetData(self, data, num, callBack)
    self.giftId = data
    self.num = num or 1
    self.callBack = callBack
    self:RefreshView()
end

local function RefreshView(self)
    local packageInfo = GiftPackageData.get(self.giftId)
    if packageInfo then
        self:SetActive(true)
        local price = DataCenter.PayManager:GetDollarText(packageInfo:getPrice(), packageInfo:getProductID())
        self.money_text:SetText(price)
        --积分
        self.score:RefreshPoint(packageInfo)
    else
        self:SetActive(false)
    end
end

CommonGiftButton.OnCreate = OnCreate
CommonGiftButton.OnDestroy = OnDestroy
CommonGiftButton.OnEnable = OnEnable
CommonGiftButton.OnDisable = OnDisable
CommonGiftButton.ComponentDefine =ComponentDefine
CommonGiftButton.ComponentDestroy =ComponentDestroy
CommonGiftButton.OnAddListener =OnAddListener
CommonGiftButton.OnRemoveListener =OnRemoveListener
CommonGiftButton.SetData = SetData
CommonGiftButton.RefreshView = RefreshView
CommonGiftButton.OnClick = OnClick

return CommonGiftButton