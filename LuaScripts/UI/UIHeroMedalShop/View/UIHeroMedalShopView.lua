local UIHeroMedalShopView = BaseClass("UIHeroMedalShopView", UIBaseView)
local base = UIBaseView
local UIHeroMedalShopScrollCell = require "UI.UIHeroMedalShop.Component.UIHeroMedalShopScrollCell"
local UIHeroMedalShopItem = require "UI.UIHeroMedalShop.Component.UIHeroMedalShopItem"
local Localization = CS.GameEntry.Localization
local UIGiftPackagePoint = require "UI.UIGiftPackage.Component.UIGiftPackagePoint"

-- 关闭按钮
local close_btn_Path = "UICommonPopUpTitle/bg_mid/CloseBtn"
local title_path = "UICommonPopUpTitle/bg_mid/titleText"
local panel_path = "UICommonPopUpTitle/panel"
-- 礼包部分
local packageCell_path = "Bg/AdvCell"
local packageNameTxt_path = "Bg/AdvCell/Common_bg1/NameText"
-- local packageImgB_path = "Bg/AdvCell/Common_bg1/packageIcon"
-- local resourceImgB_path = "Bg/AdvCell/Common_bg1/resourceIcon"
local packageDescTxt_path = "Bg/AdvCell/Common_bg1/DesText"
local packageBuyBtn_path = "Bg/AdvCell/Common_bg1/BuyBtn"
local packageBuyBtnTxt_path = "Bg/AdvCell/Common_bg1/BuyBtn/BuyBtnLabel"
-- local packageCloseBtn_path = "Bg/AdvCell/CloseBtnBg/PackageCloseBtn"
local packageJumpBtn_path = "Bg/AdvCell/Common_bg1/jumpBtn"
-- 礼包cell容器节点
local cell_scroll_content_path = "Bg/ScrollView/Viewport/Content"
-- 滑动区域scrollview节点路径
local scroll_path = "Bg/ScrollView"

local daily_reward_btn_path = "ControlTitle/DailyRewardBtn"
local daily_reward_btn_text_path = "ControlTitle/DailyRewardBtn/Text";

local daily_reward_btn_deactive_path = "ControlTitle/DailyRewardBtnDeactive"
local daily_reward_btn_deactive_text_path = "ControlTitle/DailyRewardBtnDeactive/DeactiveText";

local item_count_label_path = "UseItemNode/ItemNumText"
local item_count_btn_path = "UseItemNode"
local point_path = "Bg/AdvCell/Common_bg1/BuyBtn/UIGiftPackagePoint"

local function OnCreate(self)
    base.OnCreate(self)
    self:GenerateCurrentShowData()
    self:ComponentDefine()
    self:RefreshCell()
    self:CheckDailyRewardBtnState()
    self:SetItemNumStr()
    self:TryShowPackage()
    DataCenter.HeroMedalShopDataManager:OnRequestData()
end

local function OnDestroy(self)
    self:ClearScroll()
    self.close_btn = nil
    self.packageCell = nil
    self.packageNameTxt = nil
    self.packageImgB = nil
    self.resourceImgB = nil
    self.packageDescTxt = nil
    self.packageBuyBtn = nil
    self.packageBuyBtnTxt = nil
    -- self.packageCloseBtn = nil
    self.packageJumpBtn = nil
    self.cell_scroll_content = nil
    self.scrollView = nil
    self.daily_reward_btn = nil
    self.daily_reward_btn_text = nil
    self.daily_reward_btn_deactive = nil
    self.daily_reward_btn_deactive_text = nil
    self.item_count_label = nil
    self.item_count_btn = nil
    self.panel = nil
    self.daily_reward_btnAnim = nil

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
    self:AddUIListener(EventId.UpdateHeroMedalShopItem, self.OnBuyItemRefreshView)
    self:AddUIListener(EventId.UpdateGiftPackData, self.OnBuyPackageSucc)
    self:AddUIListener(EventId.UpdateHeroMedalShopDailyReward, self.CheckDailyRewardBtnState)
end

local function OnRemoveListener(self)
    self:RemoveUIListener(EventId.UpdateHeroMedalShopDailyReward, self.CheckDailyRewardBtnState)
    self:RemoveUIListener(EventId.UpdateGiftPackData, self.OnBuyPackageSucc)
    self:RemoveUIListener(EventId.UpdateHeroMedalShopItem, self.OnBuyItemRefreshView)
    base.OnRemoveListener(self)
end

local itemNameSequence = 1

local function GetItemNameSequence(self)
    itemNameSequence = itemNameSequence + 1
    if itemNameSequence > 99999999 then
        itemNameSequence = 1
    end
    return tostring(itemNameSequence)
end


local function ComponentDefine(self)
    -- 关闭按钮
    self.close_btn = self:AddComponent(UIButton, close_btn_Path)
    self.close_btn:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)
    self.panel = self:AddComponent(UIButton, panel_path)
    self.panel:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)
    self.title_label = self:AddComponent(UITextMeshProUGUIEx, title_path)
    self.title_label:SetText(Localization:GetString("320826"))

    -- 礼包部分
    self.packageCell = self:AddComponent(UIBaseContainer, packageCell_path)
    self.packageNameTxt = self:AddComponent(UITextMeshProUGUIEx, packageNameTxt_path)
    -- self.packageImgB = self:AddComponent(UIImage, packageImgB_path)
    -- self.resourceImgB = self:AddComponent(UIImage,resourceImgB_path)
    self.packageDescTxt = self:AddComponent(UITextMeshProUGUIEx, packageDescTxt_path)
    self.packageBuyBtn = self:AddComponent(UIButton, packageBuyBtn_path)
    self.packageBuyBtn:SetOnClick(function()
        if self.packageInfo then
            self.ctrl:BuyGift(self.packageInfo)
        end
    end)
    self.packageBuyBtnTxt = self:AddComponent(UITextMeshProUGUIEx, packageBuyBtnTxt_path)
    -- self.packageCloseBtn = self:AddComponent(UIButton, packageCloseBtn_path)
    -- self.packageCloseBtn:SetOnClick(function()
    --     self.ctrl:CloseSelf()
    -- end)
    self.packageJumpBtn = self:AddComponent(UIButton, packageJumpBtn_path)
    self.packageJumpBtn:SetOnClick(function()
        self:OnClickJumpToPackBtn()
    end)

    self.score = self:AddComponent(UIGiftPackagePoint, point_path)

    self.cell_scroll_content = self:AddComponent(UIBaseContainer, cell_scroll_content_path)
    
    -- 滑动区域scrollview
    self.scrollView = self:AddComponent(UILoopListView2, scroll_path)
    self.scrollView:InitListView(0, function(loopView, index)
        return self:OnGetItemByIndex(loopView, index)
    end)

    self.daily_reward_btn = self:AddComponent(UIButton, daily_reward_btn_path)
    self.daily_reward_btn:SetOnClick(function()
        self.ctrl:GetDailyReward()
    end)
    self.daily_reward_btnAnim = self:AddComponent(UIAnimator, daily_reward_btn_path)
    self.daily_reward_btnAnim:Play("V_ui_zhoukabaoxiang_01_idle", 0, 0)

    self.daily_reward_btn_text = self:AddComponent(UITextMeshProUGUIEx, daily_reward_btn_text_path)
    self.daily_reward_btn_text:SetText(Localization:GetString("320227"))
    
    self.daily_reward_btn_deactive = self:AddComponent(UIButton, daily_reward_btn_deactive_path)
    self.daily_reward_btn_deactive:SetOnClick(function()
        UIUtil.ShowTipsId(110461)
    end)
    self.daily_reward_btn_deactive_text = self:AddComponent(UITextMeshProUGUIEx, daily_reward_btn_deactive_text_path)
    self.daily_reward_btn_deactive_text:SetText(Localization:GetString("110461"))
    
    self.item_count_label = self:AddComponent(UITextMeshProUGUIEx, item_count_label_path)
    self.item_count_btn = self:AddComponent(UIButton, item_count_btn_path)
    self.item_count_btn:SetOnClick(function ()
        self:OnAddItemBtnClick()
    end)
end

-- 每日奖励领奖模块显示隐藏
local function CheckDailyRewardBtnState(self)
    local canshow_bubble = DataCenter.HeroMedalShopDataManager:GetCanShowHeroMedalBubble()
    if canshow_bubble then
        self.daily_reward_btn:SetActive(true)
        self.daily_reward_btn_deactive:SetActive(false)
    else
        self.daily_reward_btn:SetActive(false)
        self.daily_reward_btn_deactive:SetActive(true)
    end
end

-- 购买勋章后刷新界面 同步购买次数数据
local function OnBuyItemRefreshView(self)
    self:SetItemNumStr()
    self:GenerateCurrentShowData()
    self.scrollView:RefreshAllShownItem()
end

-- 设置道具数量/道具上线字符串
local function SetItemNumStr(self)
    local currNumStr = tostring(self.ctrl:GetCurrItemNum())
    local maxNumStr = tostring(self.ctrl:GetItemMaxNum())
    self.item_count_label:SetText(string.GetFormattedSeperatorNum(currNumStr) .. "/" .. string.GetFormattedSeperatorNum(maxNumStr))
end

local function OnGetItemByIndex(self, loopScroll, index)
    index = index + 1 --C#控件索引从0开始 
    if index < 1 or index > #self.dataList then
        return nil
    end
    local dt = self.dataList[index]
    if dt.type == 0 then
        -- 带倒计时的标题
        local cellName = ""
        if dt.hasStarted == true then
            --已经开始的标题cell和没开始的cell样式不一样
            cellName = 'UIHeroMedalShopCell0'
        else
            cellName = 'UIHeroMedalShopCell1'
        end
        local item = loopScroll:NewListViewItem(cellName)
        local script = self.cell_scroll_content:GetComponent(item.gameObject.name, UIHeroMedalShopScrollCell)
        if script == nil then
            local objectName = self:GetItemNameSequence()
            item.gameObject.name = objectName
            if (not item.IsInitHandlerCalled) then
                item.IsInitHandlerCalled = true
            end

            script = self.cell_scroll_content:AddComponent(UIHeroMedalShopScrollCell, objectName)
        end

        script:SetActive(true)
        script:SetData(dt)
        return item
    else
        -- grid内容
        local item = loopScroll:NewListViewItem('UIHeroMedalShopCell2')
        local script = self.cell_scroll_content:GetComponent(item.gameObject.name, UIHeroMedalShopItem)
        if script == nil then
            local objectName = self:GetItemNameSequence()
            item.gameObject.name = objectName
            if (not item.IsInitHandlerCalled) then
                item.IsInitHandlerCalled = true
            end

            script = self.cell_scroll_content:AddComponent(UIHeroMedalShopItem, objectName)
        end

        script:SetActive(true)
        script:SetData(dt)
        return item
    end
end

local function ClearScroll(self)
    self.cell_scroll_content:RemoveComponents(UIHeroMedalShopScrollCell)
    self.cell_scroll_content:RemoveComponents(UIHeroMedalShopItem)
    self.scrollView:ClearAllItems()
end

local function RefreshCell(self)
    -- 首先清理滑动区域
    self:ClearScroll()

    local dataCount = table.count(self.dataList)
    self.scrollView:SetListItemCount(dataCount, false, false)
end

-- 刷新当前应该显示在界面里面cell的数据列表
local function GenerateCurrentShowData(self)
    self.dataList = self.ctrl:GetPanelData()
end

local function OnAddItemBtnClick(self)
    local itemId = DataCenter.HeroMedalShopDataManager:GetHeroMedalItemId()
    local lackTab = {}
    local param = {}
    param.type = ResLackType.Item
    param.id = tonumber(itemId)
    param.targetNum = self.ctrl:GetItemMaxNum()
    table.insert(lackTab, param)
    GoToResLack.GoToItemResLackList(lackTab)
end

local function OnBuyPackageSucc(self)
    self:RefreshCell()
    self:TryShowPackage()
    self:SetItemNumStr()
end

local function TryShowPackage(self)
    self.packageInfo = self.ctrl:GetQuickPackageInfo(self.resourceType)
    if self.packageInfo then
        self.score:RefreshPoint(self.packageInfo)
        self.packageCell:SetActive(true)
        self.packageNameTxt:SetLocalText(self.packageInfo:getName())
        -- local packageIcon = self.packageInfo:getPopupImageB()
        -- if packageIcon == "" then
        --     self.packageImgB:SetActive(true)
        --     self.resourceImgB:SetActive(false)
        -- else
        --     local iconPath = string.format("Assets/Main/Sprites/Resource/UIResource_Banner_band_%s.png", packageIcon)
        --     self.resourceImgB:LoadSprite(iconPath)
        --     self.packageImgB:SetActive(false)
        --     self.resourceImgB:SetActive(true)
        -- end
        --local iconPath = string.format("Assets/Main/Sprites/Resource/Resource_Banner_%s.png", packageIcon)
        --self.packageImgB:LoadSprite(iconPath)
        self.packageDescTxt:SetText(self.packageInfo:getDescText())
        local price = DataCenter.PayManager:GetDollarText(self.packageInfo:getPrice(), self.packageInfo:getProductID())
        self.packageBuyBtnTxt:SetText(price)

        --积分
        self.score:RefreshPoint(self.packageInfo)
    else
        self.packageCell:SetActive(false)
    end
end


UIHeroMedalShopView.OnCreate = OnCreate
UIHeroMedalShopView.OnDestroy = OnDestroy
UIHeroMedalShopView.OnAddListener = OnAddListener
UIHeroMedalShopView.OnRemoveListener = OnRemoveListener
UIHeroMedalShopView.OnEnable = OnEnable
UIHeroMedalShopView.OnDisable = OnDisable
UIHeroMedalShopView.ComponentDefine = ComponentDefine
UIHeroMedalShopView.OnGetItemByIndex = OnGetItemByIndex
UIHeroMedalShopView.ClearScroll = ClearScroll
UIHeroMedalShopView.RefreshCell = RefreshCell
UIHeroMedalShopView.GenerateCurrentShowData = GenerateCurrentShowData
UIHeroMedalShopView.GetItemNameSequence = GetItemNameSequence
UIHeroMedalShopView.CheckDailyRewardBtnState = CheckDailyRewardBtnState
UIHeroMedalShopView.SetItemNumStr = SetItemNumStr
UIHeroMedalShopView.OnAddItemBtnClick = OnAddItemBtnClick
UIHeroMedalShopView.OnBuyPackageSucc = OnBuyPackageSucc
UIHeroMedalShopView.TryShowPackage = TryShowPackage
UIHeroMedalShopView.OnBuyItemRefreshView = OnBuyItemRefreshView

return UIHeroMedalShopView;