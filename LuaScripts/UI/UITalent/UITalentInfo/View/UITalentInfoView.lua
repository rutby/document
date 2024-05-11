---
--- pve选择buff页面
--- Created by shimin.
--- DateTime: 2022/5/11 10:25
---

local UITalentInfoView = BaseClass("UITalentInfoView", UIBaseView)
local base = UIBaseView
local UITalentInfoCell =  require "UI.UITalent.UITalentInfo.Component.UITalentInfoCell"
local UITalentInfoTitle =  require "UI.UITalent.UITalentInfo.Component.UITalentInfoTitle"
local TalentGroupInfo = require "UI.UITalent.UITalentInfo.Component.TalentGroupInfo"
local UIGiftPackagePoint = require "UI.UIGiftPackage.Component.UIGiftPackagePoint"
local close_btn_path = "UICommonPopUpTitle/bg_mid/CloseBtn"
local return_btn_path = "UICommonPopUpTitle/panel"
local reset_btn_path = "ResetBtn"
local intro_btn_path = "IntroBtn"
local choose_btn_path = "ChooseBtn"
local package_path = "layout/AdvCell"
local packageDesc_path = "layout/AdvCell/Common_bg1/desc"
local packagePrice_path = "layout/AdvCell/Common_bg1/BuyBtn/BuyBtnLabel"
local packageBuyBtn_path = "layout/AdvCell/Common_bg1/BuyBtn"
local packagePoint_path = "layout/AdvCell/Common_bg1/BuyBtn/UIGiftPackagePoint"

local Localization = CS.GameEntry.Localization

local function OnCreate(self)
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
    self:ReInit()
end

local function OnDestroy(self)
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

local function ComponentDefine(self)
    self.title = self:AddComponent(UITextMeshProUGUIEx, "UICommonPopUpTitle/bg_mid/titleText")
    self.title:SetLocalText(131000)
    self.content = self:AddComponent(UIBaseContainer, 'layout/LoopScroll/Viewport/Content')
    self.scroll_view = self:AddComponent(UILoopListView2, 'layout/LoopScroll')
    self.scroll_view:InitListView(0, function(loopView, index)
        return self:OnGetItemByIndex(loopView, index)
    end)
    self.close_btn = self:AddComponent(UIButton, close_btn_path)
    self.close_btn:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)

    self.return_btn = self:AddComponent(UIButton, return_btn_path)
    self.return_btn:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)
    self.reset_btn = self:AddComponent(UIButton, reset_btn_path)
    self.reset_btn:SetOnClick(function()
        self.ctrl:ResetAll()
    end)

    self.intro_btn = self:AddComponent(UIButton, intro_btn_path)
    self.intro_btn:SetOnClick(function()
        self:OnIntroClick()
    end)

    self.choose_btn = self:AddComponent(UIButton, choose_btn_path)
    self.choose_btn:SetOnClick(function()
        self:OnChooseClick()
    end)
    
    self.packageN = self:AddComponent(UIBaseContainer, package_path)
    self.packageDescN = self:AddComponent(UITextMeshProUGUIEx, packageDesc_path)
    self.packagePriceN = self:AddComponent(UITextMeshProUGUIEx, packagePrice_path)
    self.packageBuyBtnN = self:AddComponent(UIButton, packageBuyBtn_path)
    self.packageBuyBtnN:SetOnClick(function()
        self:OnClickBuyPackageBtn()
    end)
    self.packagePointN = self:AddComponent(UIGiftPackagePoint, packagePoint_path)
end

local function OnGetItemByIndex(self, loopScroll, index)
    index = index + 1 --C#控件索引从0开始 
    if index < 1 or index > #self.showDatalist then
        return nil
    end

    local dt = self.showDatalist[index]

    --标题行-- titleLine
    if dt.type == 1 then
        local item = loopScroll:NewListViewItem('TitleLine')
        local script = self.content:GetComponent(item.gameObject.name, UITalentInfoTitle)
        if script == nil then
            local objectName = self:GetItemNameSequence()
            item.gameObject.name = objectName
            if (not item.IsInitHandlerCalled) then
                item.IsInitHandlerCalled = true
            end

            script = self.content:AddComponent(UITalentInfoTitle, objectName)
        end

        script:SetActive(true)
        script:SetData(dt)
        return item
    end

    --数据行
    local item = loopScroll:NewListViewItem('UITalentInfoCell')
    local script = self.content:GetComponent(item.gameObject.name, UITalentInfoCell)
    if script == nil then
        local objectName = self:GetItemNameSequence()
        item.gameObject.name = objectName
        if (not item.IsInitHandlerCalled) then
            item.IsInitHandlerCalled = true
        end

        script = self.content:AddComponent(UITalentInfoCell, objectName)
    end

    script:SetActive(true)
    script:SetItemShow(dt)
    return item
end

local function GetItemNameSequence(self)
    NameCount = NameCount + 1
    return tostring(NameCount)
end

local function ClearScroll(self)
    self.content:RemoveComponents(UITalentInfoCell)
    self.content:RemoveComponents(UITalentInfoTitle)
    self.scroll_view:ClearAllItems()
end

local function ShowScroll(self)
    self:ClearScroll()

    local dataCount = table.count(self.showDatalist)
    if dataCount <= 0 then
        return
    end

    self.scroll_view:SetListItemCount(dataCount, false, false)
    self.scroll_view:RefreshAllShownItem()
end


local function ComponentDestroy(self)
    self:ClearScroll()
end

local function DataDefine(self)
    self.list = {}
    self.packageInfo = nil
end

local function DataDestroy(self)
    self.list = nil
    self.packageInfo = nil
end

local function OnEnable(self)
    base.OnEnable(self)
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function OnAddListener(self)
    base.OnAddListener(self)
    self:AddUIListener(EventId.TalentDataChange, self.doWhenDataRefresh)
    self:AddUIListener(EventId.OnPackageInfoUpdated, self.RefreshPackage)
end

local function OnRemoveListener(self)
    self:RemoveUIListener(EventId.TalentDataChange, self.doWhenDataRefresh)
    self:RemoveUIListener(EventId.OnPackageInfoUpdated, self.RefreshPackage)
    base.OnRemoveListener(self)
end

local function ReInit(self)
    local highLightTalentId = self:GetUserData()
    self.showDatalist, self.hasChoose, self.showReset = self.ctrl:GetPanelData(highLightTalentId)
    self:ShowScroll()
    self.choose_btn:SetActive(self.hasChoose)
    self.reset_btn:SetActive(self.showReset)
    self:RefreshPackage()
end

local function OnClick(self)
    
end

local function doWhenDataRefresh(self)
    self:ReInit()
end

local function RefreshPackage(self)
    self.packageInfo = self.ctrl:GetDisplayPackage()
    if not self.packageInfo then
        self.packageN:SetActive(false)
    else
        self.packageN:SetActive(true)
        self.packageDescN:SetText(self.packageInfo:GetSubNameTxt())
        local price = DataCenter.PayManager:GetDollarText(self.packageInfo:getPrice(), self.packageInfo:getProductID())
        self.packagePriceN:SetText(price)
        self.packagePointN:RefreshPoint(self.packageInfo)
    end
end

local function ShowGroupInfo(self, groupId, index, total, pos, cellW)
    if self.groupInfo == nil then
        self.groupInfo = self:AddComponent(TalentGroupInfo, "GroupInfo")
    end

    self.groupInfo:SetGroupId(groupId, index, total, pos, cellW)
    self.groupInfo:SetActive(true)
end

local function HideGroupInfo(self)
    if self.groupInfo ~= nil then
        self.groupInfo:SetActive(false)
    end
end

local function OnIntroClick(self)
    local strTitle = Localization:GetString("131000")
    local subTitle = ""
    local strContent = Localization:GetString("131007").."\n"..Localization:GetString("131008").."\n"..Localization:GetString("131009")
    UIUtil.ShowIntro(strTitle, subTitle, strContent)
end

local function OnChooseClick(self)
    self:HideGroupInfo()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UITalentChoose)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UITalentChoose)
end

local function OnClickBuyPackageBtn(self)
    if not self.packageInfo then
        return
    end
    
    self.ctrl:BuyGift(self.packageInfo)
end

UITalentInfoView.OnCreate = OnCreate
UITalentInfoView.OnDestroy = OnDestroy
UITalentInfoView.ComponentDefine = ComponentDefine
UITalentInfoView.ComponentDestroy = ComponentDestroy
UITalentInfoView.DataDefine = DataDefine
UITalentInfoView.DataDestroy = DataDestroy
UITalentInfoView.OnEnable = OnEnable
UITalentInfoView.OnDisable = OnDisable
UITalentInfoView.OnAddListener = OnAddListener
UITalentInfoView.OnRemoveListener = OnRemoveListener
UITalentInfoView.ReInit = ReInit
UITalentInfoView.OnClick = OnClick
UITalentInfoView.OnGetItemByIndex = OnGetItemByIndex
UITalentInfoView.GetItemNameSequence = GetItemNameSequence
UITalentInfoView.ClearScroll = ClearScroll
UITalentInfoView.ShowScroll = ShowScroll
UITalentInfoView.ShowGroupInfo = ShowGroupInfo
UITalentInfoView.HideGroupInfo = HideGroupInfo
UITalentInfoView.doWhenDataRefresh = doWhenDataRefresh
UITalentInfoView.RefreshPackage = RefreshPackage
UITalentInfoView.OnIntroClick = OnIntroClick
UITalentInfoView.OnChooseClick = OnChooseClick
UITalentInfoView.OnClickBuyPackageBtn = OnClickBuyPackageBtn

return UITalentInfoView
