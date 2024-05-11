---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2021/9/15 16:38
---UISeasonPassPackageView.lua

local base = UIBaseView--Variable
local UISeasonPassPackageView = BaseClass("UISeasonPassPackageView", base)--Variable
local Localization = CS.GameEntry.Localization
local UIGiftPackagePoint = require "UI.UIGiftPackage.Component.UIGiftPackagePoint"

local PackageConf = {
    [1] = {
        Title = "320606",
        Content = {
            "320605",
        },
        BuyTip = "",
    },
    [2] = {
        Title = "320607",
        Content = {
            "320605",
            "320604",
            "320629",
        },
        BuyTip = "320627",
    },
    [3] = {
        Title = "320607",
        Content = {
            "320605",
            "320604",
            "320629",
        },
        BuyTip = "320627",
    },
}

local closeBtn_path = "closeBtn"
local package_path = "offset/layout/package"

local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
    self:InitUI()
end

local function OnDestroy(self)
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

local function ComponentDefine(self)
    self.closeBtnN = self:AddComponent(UIButton, closeBtn_path)
    self.closeBtnN:SetOnClick(function()
        self:OnClickCloseBtn()
    end)
    self.packageTbN = {}
    for i = 1, 3 do
        local package = self:AddComponent(UIBaseContainer, package_path .. i)
        local name = package:AddComponent(UIText, "name")
        local buyBtn = package:AddComponent(UIButton, "buy")
        local activated = package:AddComponent(UIText, "activated")
        local packagePoint = package:AddComponent(UIGiftPackagePoint, "buy/UIGiftPackagePoint")
        local buyTip = package:AddComponent(UIText, "buyTip")
        activated:SetLocalText(280124)
        buyBtn:SetOnClick(function()
            self:OnClickBuyBtn(i)
        end)
        local priceTxt = package:AddComponent(UIText, "buy/buyTxt")
        local tips = {}
        for j = 1, 4 do
            local tip = package:AddComponent(UIText, "tips/tips_" .. j)
            table.insert(tips, tip)
        end
        
        local newPackage = {
            rootN = package,
            nameN = name,
            buyBtnN = buyBtn,
            priceN = priceTxt,
            tipsTbN = tips,
            activatedTipN = activated,
            packageGiftN = packagePoint,
            tipN = buyTip,
        }
        table.insert(self.packageTbN, newPackage)
    end
    
end

local function ComponentDestroy(self)
    
end

local function DataDefine(self)
    self.activityId = nil
    self.passInfo = nil
end

local function DataDestroy(self)
    self.activityId = nil
    self.passInfo = nil
end

--  [[
local function OnAddListener(self)
    base.OnAddListener(self)
    --self:AddUIListener(EventId.OnCommonShopRedChange, self.RefreshToggleRed)
end

local function OnRemoveListener(self)
    --self:RemoveUIListener(EventId.OnCommonShopRedChange, self.RefreshToggleRed)
    base.OnRemoveListener(self)
end
--]]

local function InitUI(self)
    self.activityId = self:GetUserData()
    
    self.passInfo = DataCenter.SeasonPassManager:GetSeasonPassInfo(self.activityId)
    if not self.passInfo then
        return
    end
    local packageIdList = self.passInfo.packageIds
    
    local unlock = self.passInfo.passInfo.unlock
    for i, v in ipairs(self.packageTbN) do
        local tempPackage = GiftPackManager.get(packageIdList[i])
        v.rootN:SetActive(tempPackage)
        if tempPackage then
            v.nameN:SetLocalText(PackageConf[i].Title)

            for m, n in ipairs(v.tipsTbN) do
                if m <= #PackageConf[i].Content then
                    n:SetActive(true)
                    n:SetLocalText(PackageConf[i].Content[m])
                else
                    n:SetActive(false)
                end
            end

            if string.IsNullOrEmpty(PackageConf[i].BuyTip) then
                v.tipN:SetText("")
            else
                v.tipN:SetLocalText(PackageConf[i].BuyTip)
            end

            local price = DataCenter.PayManager:GetDollarText(tempPackage:getPrice(), tempPackage:getProductID())
            v.priceN:SetText(price)
            v.packageGiftN:RefreshPoint(tempPackage)
        end
    end

    if unlock == 0 then
        self.packageTbN[3].rootN:SetActive(false)
        self.packageTbN[1].buyBtnN:SetActive(true)
        self.packageTbN[1].activatedTipN:SetActive(false)
        self.packageTbN[2].buyBtnN:SetActive(true)
        self.packageTbN[2].activatedTipN:SetActive(false)
    elseif unlock == 1 then
        self.packageTbN[2].rootN:SetActive(false)
        self.packageTbN[1].buyBtnN:SetActive(false)
        self.packageTbN[1].activatedTipN:SetActive(true)
        self.packageTbN[3].buyBtnN:SetActive(true)
        self.packageTbN[3].activatedTipN:SetActive(false)
    end
end



local function OnClickCloseBtn(self)
    self.ctrl:CloseSelf()
end

local function OnClickBuyBtn(self, packageIndex)
    local packageId = self.passInfo.packageIds[packageIndex]
    local packageInfo = GiftPackageData.get(packageId)
    DataCenter.PayManager:CallPayment(packageInfo, UIWindowNames.UISeasonPassPackage)
    self.ctrl:CloseSelf()
end

UISeasonPassPackageView.OnCreate = OnCreate 
UISeasonPassPackageView.OnDestroy = OnDestroy
--UISeasonPassPackageView.OnAddListener = OnAddListener
--UISeasonPassPackageView.OnRemoveListener = OnRemoveListener
UISeasonPassPackageView.ComponentDefine = ComponentDefine
UISeasonPassPackageView.ComponentDestroy = ComponentDestroy
UISeasonPassPackageView.DataDefine = DataDefine
UISeasonPassPackageView.DataDestroy = DataDestroy
UISeasonPassPackageView.OnAddListener = OnAddListener
UISeasonPassPackageView.OnRemoveListener = OnRemoveListener

UISeasonPassPackageView.InitUI = InitUI
UISeasonPassPackageView.OnClickCloseBtn = OnClickCloseBtn
UISeasonPassPackageView.OnClickBuyBtn = OnClickBuyBtn

return UISeasonPassPackageView