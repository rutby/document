---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zzl
--- DateTime:
--- 
local UIMiningGiftPackagePopUpView = BaseClass("UIMiningGiftPackagePopUpView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UICommonItemChange = require "UI.UICommonItem.UICommonItemChange"
local UIGiftPackagePoint = require "UI.UIGiftPackage.Component.UIGiftPackagePoint"


local close_path = "Close"
local back_path = "Back"
local bg_path = "UIScrollPackContent/Bg"
local title_path = "UIScrollPackContent/Title"
local title1_path = "UIScrollPackContent/Title1"
local scroll_view_path = "UIScrollPackContent/ScrollView"
local buy_btn_path = "UIScrollPackContent/BuyButton"
local buy_text_path = "UIScrollPackContent/BuyButton/BuyButtonText"

local point_path = "UIScrollPackContent/BuyButton/UIGiftPackagePoint"

local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
    self:ReInit()
end

local function OnDestroy(self)
    self:ClearScroll()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

local function OnEnable(self)
    base.OnEnable(self)
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function ComponentDefine(self)
    self.close_btn = self:AddComponent(UIButton, close_path)
    self.close_btn:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)
    self.back_btn = self:AddComponent(UIButton, back_path)
    self.back_btn:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)
    
    self.bg_image = self:AddComponent(UIImage, bg_path)
    self.title_text = self:AddComponent(UIText, title_path)
    self.title1_txt = self:AddComponent(UIText,title1_path)
    self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
    self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
        self:OnCreateCell(itemObj, index)
    end)
    self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
        self:OnDeleteCell(itemObj, index)
    end)
    self.buy_btn = self:AddComponent(UIButton, buy_btn_path)
    self.buy_btn:SetOnClick(function()
        self:OnBuyClick()
    end)
    self.buy_text = self:AddComponent(UIText, buy_text_path)
    self.point_rect = self:AddComponent(UIGiftPackagePoint,point_path)
end

local function ComponentDestroy(self)
    self.bg_image = nil
    self.title_text = nil
    self.scroll_view = nil
    self.buy_btn = nil
    self.buy_text = nil
    self.point_rect = nil
end

local function DataDefine(self)
    self.rewardList = nil
    self.packageInfo = nil
end

local function DataDestroy(self)
    self.rewardList = nil
    self.timer_action = nil
end

local function OnAddListener(self)
    base.OnAddListener(self)
    self:AddUIListener(EventId.ActBattlePassRefresh, self.ReInit)
    self:AddUIListener(EventId.DesertForceRefresh, self.RefreshSeasonPass)
end

local function OnRemoveListener(self)
    self:RemoveUIListener(EventId.ActBattlePassRefresh, self.ReInit)
    self:RemoveUIListener(EventId.DesertForceRefresh, self.RefreshSeasonPass)
    base.OnRemoveListener(self)
end

local function ReInit(self)
    self.actId,self.giftId = self:GetUserData()
    self.actListData = DataCenter.ActivityListDataManager:GetActivityDataById(tostring(self.actId))
    if self.actListData then
        self.title_text:SetLocalText(self.actListData.name)
        
        self.packageInfo = GiftPackageData.get(self.giftId)
    end
    self.title1_txt:SetLocalText(375067)
    if self.packageInfo then
        self.buy_btn:SetActive(true)
        local price = DataCenter.PayManager:GetDollarText(self.packageInfo:getPrice(), self.packageInfo:getProductID())
        self.buy_text:SetText(price)
        self.point_rect:RefreshPoint(self.packageInfo)
    end
    self.rewardList = DataCenter.MiningManager:GetSpecialReward(self.actId)
    self:ShowCells()
end

local function ShowCells(self)
    local count = table.count(self.rewardList)
    if count > 0 then
        self.scroll_view:SetTotalCount(count)
        self.scroll_view:RefillCells()
    end
end

local function ClearScroll(self)
    self.scroll_view:ClearCells()
    self.scroll_view:RemoveComponents(UICommonItemChange)
end

local function OnCreateCell(self, itemObj, index)
    itemObj.name = tostring(index)
    local item = self.scroll_view:AddComponent(UICommonItemChange, itemObj)
    item:ReInit(self.rewardList[index])
end

local function OnDeleteCell(self, itemObj, index)
    self.scroll_view:RemoveComponent(itemObj.name, UICommonItemChange)
end

local function OnBuyClick(self)
    if self.packageInfo then
        self.ctrl:CloseSelf()
        DataCenter.PayManager:CallPayment(self.packageInfo, UIWindowNames.UIMiningGiftPackagePopUp)
    end
end

UIMiningGiftPackagePopUpView.OnCreate = OnCreate
UIMiningGiftPackagePopUpView.OnDestroy = OnDestroy
UIMiningGiftPackagePopUpView.ComponentDefine = ComponentDefine
UIMiningGiftPackagePopUpView.DataDefine = DataDefine
UIMiningGiftPackagePopUpView.DataDestroy = DataDestroy
UIMiningGiftPackagePopUpView.OnAddListener = OnAddListener
UIMiningGiftPackagePopUpView.OnRemoveListener = OnRemoveListener
UIMiningGiftPackagePopUpView.ReInit = ReInit
UIMiningGiftPackagePopUpView.ShowCells = ShowCells
UIMiningGiftPackagePopUpView.ClearScroll = ClearScroll
UIMiningGiftPackagePopUpView.OnCreateCell = OnCreateCell
UIMiningGiftPackagePopUpView.OnDeleteCell = OnDeleteCell
UIMiningGiftPackagePopUpView.OnBuyClick = OnBuyClick
UIMiningGiftPackagePopUpView.OnEnable = OnEnable
UIMiningGiftPackagePopUpView.OnDisable = OnDisable
UIMiningGiftPackagePopUpView.ComponentDestroy = ComponentDestroy
return UIMiningGiftPackagePopUpView