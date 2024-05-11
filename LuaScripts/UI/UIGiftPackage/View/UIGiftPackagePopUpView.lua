--[[
礼包弹出View
--]]


local UIGiftPackagePopUpView = BaseClass("UIGiftPackagePopUpView", UIBaseView)
local base = UIBaseView

local UIGainDiamonds = require "UI.UIGiftPackage.Component.UIGainDiamonds"
local UIGiftTypeButton = require "UI.UIGiftPackage.Component.UIGiftTypeButton"
local GiftPackagePagePanel = require "UI.UIGiftPackage.Component.GiftPackagePagePanel"
local WeeklyPackageMain = require "UI.UIGiftPackage.Component.WeeklyPackage.WeeklyPackageMain"
local WeeklyPackageNewMain = require "UI.UIGiftPackage.Component.WeeklyPackageNew.WeeklyPackageNewMain"
local WeekCardMain = require "UI.UIGiftPackage.Component.WeekCard.WeekCardMain"
local HeroMedalPackageMain = require "UI.UIGiftPackage.Component.HeroMedal.HeroMedalPackageMain"
local PaidLotteryMain = require "UI.UIGiftPackage.Component.PaidLottery.PaidLotteryMain"
local UIGolloesMonthCardPanel = require "UI.UIGiftPackage.Component.MonthCard.UIGolloesMonthCardContent"
local UIRobotPackPanel = require "UI.UIGiftPackage.Component.UIRobotPackPanel"
local UIPiggyBankPanel = require "UI.UIGiftPackage.Component.UIPiggyBankPanel"
local UIEnergyBankPanel = require "UI.UIGiftPackage.Component.UIEnergyBankPanel"
local UIGrowthPlanPanel = require "UI.UIGiftPackage.Component.UIGrowthPlanPanel"
local UIScrollPackContent = require "UI.UIScrollPack.Component.UIScrollPackContent"
local HeroMonthCardPanel = require "UI.UIGiftPackage.Component.HeroMonthCard.HeroMonthCardMain"
local CumulativeRecharge = require "UI.UIGiftPackage.Component.CumulativeRecharge"
local DailyCumulativeRecharge = require "UI.UIGiftPackage.Component.DailyCumulativeRecharge.DailyCumulativeRecharge"
local UIKeepPayPanel = require "UI.UIGiftPackage.Component.UIKeepPayPanel"
local UIChainPayPanel = require "UI.UIGiftPackage.Component.UIChainPayPanel"
local DailyPackage = require "UI.UIGiftPackage.Component.DailyPackage"
local UIFirstCharge = require "UI.UIGiftPackage.Component.FirstCharge.UIFirstCharge"
local UILWDailyMustBuyMain = require "UI.UIGiftPackage.Component.DailyMustBuy.UILWDailyMustBuyMain"

local close_path = "UICommonFullTop/CloseBtn"
local title_path = "UICommonFullTop/imgTitle/Common_img_title/titleText"
local scroll_view_path = "UICommonFullTop/Bg2/ScrollView"
local panel_path = "UICommonFullTop/Bg2/List/%s"
local weeklyPackageIemContainer_path = "weeklyPackageItemsContainer"

--Panel 枚举
local PanelEnum =
{
    GainDiamonds = "UIGainDiamonds",
    GiftPackagePagePanel = "GiftPackagePagePanel",
    RobotPackPanel = "UIRobotPackPanel",
    WeeklyPackagePanel = "UIweeklyPackage",
    WeeklyPackageNewPanel = "WeeklyPackageNewPanel",
    WeekCardPanel = "WeekCardPanel",
    HeroMedalPackagePanel = "HeroMedalPackagePanel",
    GolloesMonthCardPanel = "UIGolloesMonthCardPanel",
    PiggyBankPanel = "UIPiggyBankPanel",
    EnergyBankPanel = "UIEnergyBankPanel",
    GrowthPlanPanel = "UIGrowthPlanPanel",
    ScrollPackContent = "UIScrollPackContent",
    ScrollPackContentNew = "UIScrollPackContentNew",
    HeroMonthCardPanel = "HeroMonthCardMain",
    CumulativeRecharge = "CumulativeRecharge",
    DailyCumulativeRecharge = "DailyCumulativeRecharge",
    KeepPayPanel = "KeepPayPanel",
    ChainPayPanel = "ChainPayPanel",
    DailyPackage = "DailyPackage",
    PaidLottery = "PaidLottery",
    FirstCharge = "FirstCharge",
    DailyMustBuy = "DailyMustBuy",
}

local PanelConf = {
    [PanelEnum.GainDiamonds] = {
        Asset = "Assets/Main/Prefab_Dir/UI/GiftPackage/UIGainDiamonds.prefab",
        Script = UIGainDiamonds,
        Container = "UIGainDiamonds"
    },
    [PanelEnum.GiftPackagePagePanel] = {
        Asset = "Assets/Main/Prefab_Dir/UI/GiftPackage/GiftPackagePagePanel.prefab",
        Script = GiftPackagePagePanel,
        Container = "GiftPackagePagePanel"
    },
    [PanelEnum.RobotPackPanel] = {
        Asset = "Assets/Main/Prefab_Dir/UI/GiftPackage/UIRobotPackPanel.prefab",
        Script = UIRobotPackPanel,
        Container = "UIRobotPackPanel"
    },
    [PanelEnum.WeeklyPackagePanel] = {
        Asset = "Assets/Main/Prefab_Dir/UI/GiftPackage/WeeklyPackageMain.prefab",
        Script = WeeklyPackageMain,
        Container = "UIweeklyPackage"
    },
    [PanelEnum.WeeklyPackageNewPanel] = {
        Asset = "Assets/Main/Prefab_Dir/UI/GiftPackage/WeeklyPackageNew/WeeklyPackageNewMain.prefab",
        Script = WeeklyPackageNewMain,
        Container = "WeeklyPackageNewPanel"
    },
    [PanelEnum.WeekCardPanel] = {
        Asset = "Assets/Main/Prefab_Dir/UI/GiftPackage/WeekCard/WeekCardMain.prefab",
        Script = WeekCardMain,
        Container = "WeekCardPanel"
    },
    [PanelEnum.HeroMedalPackagePanel] = {
        Asset = "Assets/Main/Prefab_Dir/UI/GiftPackage/HeroMedalPackageMain.prefab",
        Script = HeroMedalPackageMain,
        Container = "HeroMedalPackagePanel"
    },
    [PanelEnum.PaidLottery] = {
        Asset = "Assets/Main/Prefab_Dir/UI/GiftPackage/PaidLottery/PaidLotteryMain.prefab",
        Script = PaidLotteryMain,
        Container = "PaidLotteryPanel"
    },
    [PanelEnum.GolloesMonthCardPanel] = {
        Asset = "Assets/Main/Prefab_Dir/UI/GiftPackage/UIGolloesMonthCardItem.prefab",
        Script = UIGolloesMonthCardPanel,
        Container = "UIGolloesMonthCardPanel"
    },
    [PanelEnum.PiggyBankPanel] = {
        Asset = "Assets/Main/Prefab_Dir/UI/GiftPackage/UIPiggyBankPanel.prefab",
        Script = UIPiggyBankPanel,
        Container = "UIPiggyBankPanel"
    },
    [PanelEnum.EnergyBankPanel] = {
        Asset = "Assets/Main/Prefab_Dir/UI/GiftPackage/UIEnergyBankPanel.prefab",
        Script = UIEnergyBankPanel,
        Container = "UIEnergyBankPanel"
    },
    [PanelEnum.GrowthPlanPanel] = {
        Asset = "Assets/Main/Prefab_Dir/UI/GiftPackage/GrowthPlan/UIGrowthPlanPanel.prefab",
        Script = UIGrowthPlanPanel,
        Container = "UIGrowthPlanPanel"
    },
    [PanelEnum.ScrollPackContent] = {
        Asset = "Assets/Main/Prefab_Dir/UI/UIScrollPack/UIScrollPackContent.prefab",
        AssetNew = "Assets/Main/Prefab_Dir/UI/UIScrollPack/UIScrollPackContentNew.prefab",
        Script = UIScrollPackContent,
        Container = "UIScrollPackContent"
    },
    [PanelEnum.ScrollPackContentNew] = {
        Asset = "Assets/Main/Prefab_Dir/UI/UIScrollPack/UIScrollPackContentNew.prefab",
        Script = UIScrollPackContent,
        Container = "UIScrollPackContentNew"
    },
    [PanelEnum.HeroMonthCardPanel] = {
        Asset = "Assets/Main/Prefab_Dir/UI/GiftPackage/HeroMonthCard/HeroMonthCardMain.prefab",
        Script = HeroMonthCardPanel,
        Container = "HeroMonthCardMain"
    },
    [PanelEnum.CumulativeRecharge] = {
        Asset = "Assets/Main/Prefab_Dir/UI/GiftPackage/CumulativeRecharge.prefab",
        Script = CumulativeRecharge,
        Container = "CumulativeRecharge"
    },
    [PanelEnum.DailyCumulativeRecharge] = {
        Asset = "Assets/Main/Prefab_Dir/UI/GiftPackage/DailyCumulativeRecharge.prefab",
        Script = DailyCumulativeRecharge,
        Container = "DailyCumulativeRecharge"
    },
    [PanelEnum.KeepPayPanel] = {
        Asset = "Assets/Main/Prefab_Dir/UI/GiftPackage/KeepPay/UIKeepPayPanel.prefab",
        Script = UIKeepPayPanel,
        Container = "UIKeepPayPanel"
    },
    [PanelEnum.ChainPayPanel] = {
        Asset = "Assets/Main/Prefab_Dir/UI/GiftPackage/ChainPay/UIChainPayPanel.prefab",
        Script = UIChainPayPanel,
        Container = "UIChainPayPanel"
    },
    [PanelEnum.DailyPackage] = {
        Asset = "Assets/Main/Prefab_Dir/UI/GiftPackage/DailyPackage/DailyPackage.prefab",
        Script = DailyPackage,
        Container = "DailyPackage"
    },
    [PanelEnum.FirstCharge] = {
        Asset = "Assets/Main/Prefab_Dir/UI/GiftPackage/FirstCharge/UIFirstCharge.prefab",
        Script = UIFirstCharge,
        Container = "UIFirstChargePanel"
    },
    [PanelEnum.DailyMustBuy] = {
        Asset = "Assets/Main/Prefab_Dir/UI/GiftPackage/DailyMustBuy/DailyMustBuy.prefab",
        Script = UILWDailyMustBuyMain,
        Container = "UILWDailyMustBuyMain"
    },
}

--创建
local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
    -- 设置默认显示的界面
    local userdata = self:GetUserData()
    self.userdata = userdata or {}
    self.curWelfareType = (userdata and userdata["welfareTagType"]) and userdata["welfareTagType"] or WelfareTagType["PackStore"]
    self.targetShowType = userdata and userdata.targetShowType or nil
    self.targetPackageId = userdata and userdata.targetPackageId or nil
    self:ReInit()
end

-- 销毁
local function OnDestroy(self)
    EventManager:GetInstance():Broadcast(EventId.RefreshGoldStoreRed)
    self:SetPanelActive()
    self:ClearScroll()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

local function ComponentDefine(self)
    self.close_btn = self:AddComponent(UIButton, close_path)
    self.close_btn:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)
    self.title_text = self:AddComponent(UITextMeshProUGUIEx, title_path)
    self.title_text:SetLocalText(320005)
    
    self.weeklyPackageItemsContainer = self:AddComponent(UIBaseContainer, weeklyPackageIemContainer_path)
    self.weeklyPackageItemsContainer:SetActive(false)

    self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
    self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
        self:OnCreateCell(itemObj, index)
    end)
    self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
        self:OnDeleteCell(itemObj, index)
    end)
end

local function ComponentDestroy(self)
    self.close_btn = nil
    self.scroll_view = nil
end


local function DataDefine(self)
    self.panels = {}
    self.showMainType = ""
    self.showSubType = ""
    self.goldExchangeId = ""
    self.welfarelist = {}
    self.curTypeButtonId = nil
    self.showButtonType = nil
    self.selectTypeIndex = nil
    self.typeCells = {}
    self.curWelfareType = nil
    self.curRechargeId = nil
end

local function DataDestroy(self)
    self.panels = nil
    self.showMainType = nil
    self.showSubType = nil
    self.goldExchangeId = nil
    self.welfarelist = nil
    self.curTypeButtonId = nil
    self.showButtonType = nil
    self.selectTypeIndex = nil
    self.typeCells = nil
    self.curWelfareType = nil
    self.curRechargeId = nil
end

local function OnEnable(self)
    base.OnEnable(self)
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function OnAddListener(self)
    base.OnAddListener(self)
    self:AddUIListener(EventId.UpdateGiftPackData, self.OnUpdateGiftPackData)
    self:AddUIListener(EventId.RefreshWelfareRedDot, self.OnRefreshWelfareRedDot)
    self:AddUIListener(EventId.GoGiftPackagePop, self.GotoButtonType)
    self:AddUIListener(EventId.FreeWeeklyPackage, self.DailyPackageFree)
end


local function OnRemoveListener(self)
    self:RemoveUIListener(EventId.UpdateGiftPackData, self.OnUpdateGiftPackData)
    self:RemoveUIListener(EventId.RefreshWelfareRedDot, self.OnRefreshWelfareRedDot)
    self:RemoveUIListener(EventId.GoGiftPackagePop, self.GotoButtonType)
    self:RemoveUIListener(EventId.FreeWeeklyPackage, self.DailyPackageFree)
    base.OnRemoveListener(self)
end

local function ReInit(self)
    if self.targetPackageId ~= nil then
        local targetPack = GiftPackManager.get(self.targetPackageId)
        if targetPack then
            local rechargeLine = targetPack:getRechargeLineData()
            if rechargeLine then
                self.curRechargeId = rechargeLine.id
                self.curWelfareType = rechargeLine.type
            else
                if targetPack:IsWeeklyPackage() then
                    self.curWelfareType = WelfareTagType.WeeklyPackage
                elseif targetPack:IsWeeklyPackageNew() then
                    self.curWelfareType = WelfareTagType.WeeklyPackageNew
                end
            end
        end
    end
    
    self:ShowTypeButton()
    
    -- 滚动至需要选中的按钮
    if self.curWelfareType ~= nil then
        for index, v in ipairs(self.welfarelist) do
            if self.curWelfareType == v:getType() then
                local toIndex = math.max(index - 2, 1)
                self.scroll_view:ScrollToCell(toIndex, 2000)
                break
            end
        end
    end
end

local function GotoButtonType(self,type, noScroll)
    for index, v in ipairs(self.welfarelist) do
        if type == v:getType() then
            local toIndex = math.max(index - 2, 1)
            self.curWelfareType = v:getType()
            if noScroll then
                self.scroll_view:ScrollToCell(toIndex, 20000)
                TimerManager:GetInstance():DelayInvoke(function()
                    self.typeCells[index]:SetSelect(true)
                    self.typeCells[index]:OnClick()
                end, 0.2)
            else
                self.scroll_view:ScrollToCell(toIndex, 2000)
                TimerManager:GetInstance():DelayInvoke(function()
                    self.typeCells[index]:SetSelect(true)
                    self.typeCells[index]:OnClick()
                end, 0.6)
            end
            break
        end
    end
end

local function OnUpdateGiftPackData(self)
    if not self.ctrl then
        return
    end
    if self.curWelfareType == WelfareTagType.GrowthPlan then
        self:ShowGrowthPlanPanel()
    elseif self.curWelfareType == WelfareTagType.PackStore then
        self:RefreshGiftPanel()
    elseif self.curWelfareType == WelfareTagType.ScrollPack then
        local packs = GiftPackageData.GetAllAvailablePackageByRechargeId(self.curRechargeId, false)
        if packs[1] then
            local packId = packs[1]:getID()
            local packInfo = GiftPackManager.get(packId)
            local popup_Image = packInfo:getPopupImageH()
            if popup_Image == "SellDarkVipNew" then
                self:ShowScrollPackContentNew()
            else
                self:ShowScrollPackContent()
            end
        else
            self.ctrl:CloseSelf()
        end
        
    elseif self.curWelfareType == WelfareTagType.HeroMonthCardNew then
        self:ShowHeroMonthCardPanel()
    elseif self.curWelfareType == WelfareTagType.DailyPackage then
        self:ShowDailyPackagePanel()
    elseif self.curWelfareType == WelfareTagType.WeekCard then
        self:ShowWeekCardPanel()
    elseif self.curWelfareType == WelfareTagType.FirstCharge then
        self:ShowFirstChargePanel()
    elseif self.curWelfareType == WelfareTagType.DailyMustBuy then
        self:ShowDailyMustBuyPanel()
    elseif self.curWelfareType == WelfareTagType.WeeklyPackageNew then
        self:ShowWeeklyPackageNewPanel()
    else
        self.ctrl:CloseSelf()
    end
    self:OnRefreshWelfareRedDot()
end

local function ShowGiftPanel(self)
    self:SetPanelActive(PanelEnum.GiftPackagePagePanel);
    if self.panels[PanelEnum.GiftPackagePagePanel] then
        local param = {}
        param.showMainType = self.showMainType
        param.showSubType = self.showSubType
        param.goldExchangeId = self.goldExchangeId
        param.welfareTagType = self.curWelfareType
        param.targetShowType = self.targetShowType
        param.targetPackageId = self.targetPackageId
        self.targetShowType = nil
        self.targetPackageId = nil
        param.callBack = function() self:CallBackActive() end
        self.panels[PanelEnum.GiftPackagePagePanel]:ReInit(param)
    else
        self:LoadPanel(PanelEnum.GiftPackagePagePanel)
    end
end

local function RefreshGiftPanel(self)
    if self.panels[PanelEnum.GiftPackagePagePanel] then
        self.panels[PanelEnum.GiftPackagePagePanel]:RefreshScroll()
    else
        self:LoadPanel(PanelEnum.GiftPackagePagePanel)
    end
end

local function ShowWeeklyPackagePanel(self)
    self:SetPanelActive(PanelEnum.WeeklyPackagePanel);
    if self.panels[PanelEnum.WeeklyPackagePanel] then
        self.panels[PanelEnum.WeeklyPackagePanel]:ReInit(self.targetPackageId)
        self.targetPackageId = nil
    else
        self:LoadPanel(PanelEnum.WeeklyPackagePanel)
    end
end

local function ShowWeeklyPackageNewPanel(self)
    self:SetPanelActive(PanelEnum.WeeklyPackageNewPanel);
    if self.panels[PanelEnum.WeeklyPackageNewPanel] then
        self.panels[PanelEnum.WeeklyPackageNewPanel]:ReInit(self.targetPackageId)
        self.targetPackageId = nil
    else
        self:LoadPanel(PanelEnum.WeeklyPackageNewPanel)
    end
end

local function RefreshWeeklyPackageNewPanel(self)
    if self.panels[PanelEnum.WeeklyPackageNewPanel] then
        self.panels[PanelEnum.WeeklyPackageNewPanel]:RefreshScrollData()
    else
        self:LoadPanel(PanelEnum.WeeklyPackageNewPanel)
    end
end

local function ShowWeekCardPanel(self)
    self:SetPanelActive(PanelEnum.WeekCardPanel)
    if self.panels[PanelEnum.WeekCardPanel] then
        self.panels[PanelEnum.WeekCardPanel]:ReInit()
        self.targetPackageId = nil
    else
        self:LoadPanel(PanelEnum.WeekCardPanel)
    end
end

local function ShowHeroMedalPackagePanel(self)
    self:SetPanelActive(PanelEnum.HeroMedalPackagePanel);
    if self.panels[PanelEnum.HeroMedalPackagePanel] then
        self.panels[PanelEnum.HeroMedalPackagePanel]:ReInit()
    else
        self:LoadPanel(PanelEnum.HeroMedalPackagePanel)
    end
end

local function ShowPaidLotteryPanel(self)
    self:SetPanelActive(PanelEnum.PaidLottery);
    if self.panels[PanelEnum.PaidLottery] then
        self.panels[PanelEnum.PaidLottery]:SetData(self.curRechargeId)
    else
        self:LoadPanel(PanelEnum.PaidLottery)
    end
    DataCenter.PaidLotteryManager:GetPaidLotteryInfoReq()
end

local function ShowGolloesMonthCardPanel(self, tempData)
    self:SetPanelActive(PanelEnum.GolloesMonthCardPanel);
    if self.panels[PanelEnum.GolloesMonthCardPanel] then
        local param = {}
        param.monthCardInfo = tempData
        param.callBack = function() self:CallBackActive() end
        self.panels[PanelEnum.GolloesMonthCardPanel]:ReInit(param, self)
    else
        self:LoadPanel(PanelEnum.GolloesMonthCardPanel)
    end
end 

local function ShowPremiumPackPanel(self)
    self:SetPanelActive(PanelEnum.GiftPackagePagePanel);
    if self.panels[PanelEnum.GiftPackagePagePanel] then
        local param = GiftPackagePagePanel.Param.New()
        param.showMainType = self.showMainType
        param.showSubType = self.showSubType
        param.goldExchangeId = self.goldExchangeId
        param.welfareTagType = self.curWelfareType
        param.callBack = function() self:CallBackActive() end
        self.panels[PanelEnum.GiftPackagePagePanel]:ReInit(param)
    else
        self:LoadPanel(PanelEnum.GiftPackagePagePanel)
    end
end

local function ShowRobotPackPanel(self, data)
    self:SetPanelActive(PanelEnum.RobotPackPanel);
    if self.panels[PanelEnum.RobotPackPanel] then
        self.panels[PanelEnum.RobotPackPanel]:ReInit(data, self)
    else
        self:LoadPanel(PanelEnum.RobotPackPanel)
    end
end

local function ShowPiggyBankPanel(self)
    self:SetPanelActive(PanelEnum.PiggyBankPanel)
    if self.panels[PanelEnum.PiggyBankPanel] then
        self.panels[PanelEnum.PiggyBankPanel]:ReInit(self)
    else
        self:LoadPanel(PanelEnum.PiggyBankPanel)
    end
end

local function ShowEnergyBankPanel(self)
    self:SetPanelActive(PanelEnum.EnergyBankPanel)
    if self.panels[PanelEnum.EnergyBankPanel] then
        self.panels[PanelEnum.EnergyBankPanel]:ReInit(self)
    else
        self:LoadPanel(PanelEnum.EnergyBankPanel)
    end
end

local function ShowGrowthPlanPanel(self)
    self:SetPanelActive(PanelEnum.GrowthPlanPanel)
    if self.panels[PanelEnum.GrowthPlanPanel] then
        local packId = GetTableData("recharge", self.curRechargeId, "para1")
        self.panels[PanelEnum.GrowthPlanPanel]:ReInit(self, packId)
    else
        self:LoadPanel(PanelEnum.GrowthPlanPanel)
    end
end

local function ShowHeroMonthCardPanel(self)
    self:SetPanelActive(PanelEnum.HeroMonthCardPanel)
    if self.panels[PanelEnum.HeroMonthCardPanel] then
        self.panels[PanelEnum.HeroMonthCardPanel]:ReInit(true)
    else
        self:LoadPanel(PanelEnum.HeroMonthCardPanel)
    end
end

local function ShowCumulativeRechargePanel(self)
    self:SetPanelActive(PanelEnum.CumulativeRecharge)
    if self.panels[PanelEnum.CumulativeRecharge] then
        local id = GetTableData("recharge", self.curRechargeId, "para2")
        self.panels[PanelEnum.CumulativeRecharge]:ReInit(self.welfarelist,tonumber(id),self.selectTypeIndex,self.curRechargeId)
    else
        self:LoadPanel(PanelEnum.CumulativeRecharge)
    end
end

local function ShowDailyCumulativeRechargePanel(self)
    self:SetPanelActive(PanelEnum.DailyCumulativeRecharge)
    if self.panels[PanelEnum.DailyCumulativeRecharge] then
        local id = GetTableData("recharge", self.curRechargeId, "para2")
        self.panels[PanelEnum.DailyCumulativeRecharge]:ReInit(self.welfarelist,tonumber(id),self.selectTypeIndex,self.curRechargeId)
    else
        self:LoadPanel(PanelEnum.DailyCumulativeRecharge)
    end
end

local function ShowKeepPayPanel(self)
    self:SetPanelActive(PanelEnum.KeepPayPanel)
    if self.panels[PanelEnum.KeepPayPanel] then
        local id = GetTableData("recharge", self.curRechargeId, "para2")
        self.panels[PanelEnum.KeepPayPanel]:ReInit(tonumber(id))
    else
        self:LoadPanel(PanelEnum.KeepPayPanel)
    end
end

local function ShowChainPayPanel(self)
    self:SetPanelActive(PanelEnum.ChainPayPanel)
    if self.panels[PanelEnum.ChainPayPanel] then
        local actId = GetTableData("recharge", self.curRechargeId, "para3")
        self.panels[PanelEnum.ChainPayPanel]:ReInit(tonumber(actId))
    else
        self:LoadPanel(PanelEnum.ChainPayPanel)
    end
end

local function ShowScrollPackContent(self)
    self:SetPanelActive(PanelEnum.ScrollPackContent)
    if self.panels[PanelEnum.ScrollPackContent] then
        local packs = GiftPackageData.GetAllAvailablePackageByRechargeId(self.curRechargeId, false)
        if packs[1] then
            local packId = packs[1]:getID()
            self.panels[PanelEnum.ScrollPackContent]:SetData(packId)
        else
            self.ctrl:CloseSelf()
        end
    else
        self:LoadPanel(PanelEnum.ScrollPackContent)
    end
end

local function ShowScrollPackContentNew(self)
    self:SetPanelActive(PanelEnum.ScrollPackContentNew)
    if self.panels[PanelEnum.ScrollPackContentNew] then
        local packs = GiftPackageData.GetAllAvailablePackageByRechargeId(self.curRechargeId, false)
        if packs[1] then
            local packId = packs[1]:getID()
            self.panels[PanelEnum.ScrollPackContentNew]:SetData(packId)
        else
            self.ctrl:CloseSelf()
        end
    else
        self:LoadPanel(PanelEnum.ScrollPackContentNew)
    end
end

local function ShowDailyPackagePanel(self)
    self:SetPanelActive(PanelEnum.DailyPackage)
    if self.panels[PanelEnum.DailyPackage] then
        self.panels[PanelEnum.DailyPackage]:ReInit(self.welfarelist)
    else
        self:LoadPanel(PanelEnum.DailyPackage)
    end
end

local function DailyPackageFree(self)
    if self.panels[PanelEnum.DailyPackage] then
        self.panels[PanelEnum.DailyPackage]:RefreshTop()
    end
end

local function ShowFirstChargePanel(self)
    self:SetPanelActive(PanelEnum.FirstCharge)
    if self.panels[PanelEnum.FirstCharge] then
        self.panels[PanelEnum.FirstCharge]:ReInit(self.curRechargeId)
    else
        self:LoadPanel(PanelEnum.FirstCharge)
    end
end

local function ShowDailyMustBuyPanel(self)
    self:SetPanelActive(PanelEnum.DailyMustBuy)
    if self.panels[PanelEnum.DailyMustBuy] then
        self.panels[PanelEnum.DailyMustBuy]:ReInit(self.curRechargeId)
    else
        self:LoadPanel(PanelEnum.DailyMustBuy)
    end
end

local function LoadPanel(self, targetPanel)
    local tempConf = PanelConf[targetPanel]
    if not self.panels[targetPanel] then
        if not self.panelModels then
            self.panelModels = {}
        end
        if self.panelModels[targetPanel] then
            return
        end
        local assetPath = tempConf.Asset
        self.panelModels[targetPanel] = self:GameObjectInstantiateAsync(assetPath, function(request)
            if request.isError then
                return
            end

            local go = request.gameObject
            go.gameObject:SetActive(false)
            local tempContainer = self:AddComponent(UIBaseContainer, string.format(panel_path, tempConf.Container))
            go.transform:SetParent(tempContainer.transform)
            go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
            go.transform:Set_sizeDelta(0, 0)
            go.transform:Set_anchoredPosition(0, 0)
            go.name = targetPanel
            local cell = tempContainer:AddComponent(tempConf.Script, go.name)

            self.panels[targetPanel] = cell
            self:ShowClickTypeButtonList()
        end)
    end
end

local function ClearScroll(self)
    self.typeCells = {}
    self.scroll_view:ClearCells()--清循环列表数据
    self.scroll_view:RemoveComponents(UIGiftTypeButton)--清循环列表gameObject
end

local function ShowTypeButton(self)
    self.welfarelist = self.ctrl:GetTypeButtonList() -- GetTypeButtonList() 这个目前返回的是福利中心数据类的集合

    self:ClearScroll()
    local count = #self.welfarelist
    if count > 0 then
        self.scroll_view:SetTotalCount(count)
        self.scroll_view:RefillCells()
    end
end

local function OnCreateCell(self, itemObj, index)
    itemObj.name = tostring(index)
    local cellItem = self.scroll_view:AddComponent(UIGiftTypeButton, itemObj)
    local param = {}
    param.welfare_data = self.welfarelist[index]
    param.callBack = function(trans, welfareType, rechargeId, cellIndex)
        self:TypeButtonCallBack(trans, welfareType, rechargeId, cellIndex)
    end
    local rechargeId = param.welfare_data:getID()
    if self.selectTypeIndex == nil and self.curWelfareType == param.welfare_data:getType() then
        local select = true
        
        if self.curRechargeId ~= nil then
            select = (self.curRechargeId == rechargeId)
        end
        
        if select then
            param.needClick = true
            self.selectTypeIndex = index
            self.curWelfareType = nil
            self.curRechargeId = nil
        end
    else
        param.needClick = false
    end
    param.index = index
    param.redDotNum = self.welfarelist[index]:getRedDotNum()
    if param.welfare_data:getType() == WelfareTagType.HeroMonthCardNew and DataCenter.HeroMonthCardManager:ShowNewFlag() then
        param.newFlag = true
    elseif param.welfare_data:getType() == WelfareTagType.KeepPay then
        local id = GetTableData("recharge", rechargeId, "para2")
        local data = DataCenter.KeepPayManager:GetData(id)
        param.newFlag = (data and data:IsNew())
    elseif param.welfare_data:getType() == WelfareTagType.ChainPay then
        local actId = GetTableData("recharge", rechargeId, "para3")
        local data = DataCenter.ChainPayManager:GetData(actId) 
        param.newFlag = (data and data:IsNew())
    elseif param.welfare_data:getType() == WelfareTagType.GrowthPlan then
        local packId = GetTableData("recharge", rechargeId, "para1")
        local str = Setting:GetPrivateString(SettingKeys.GROWTH_PLAN_VISITED .. packId, "")
        param.newFlag = string.IsNullOrEmpty(str)
    end
    cellItem:ReInit(param)
    self.typeCells[index] = cellItem
    if self.selectTypeIndex and not param.needClick and self.selectTypeIndex == index and self.curWelfareType == param.welfare_data:getType() then
        cellItem:SetSelect(true)
    end
end


local function OnDeleteCell(self, itemObj, index)
    self.typeCells[index] = nil
    self.scroll_view:RemoveComponent(itemObj.name, UIGiftTypeButton)
end

local function TypeButtonCallBack(self, trans, wTagType, rechargeId, cellIndex)
    if self.curWelfareType ~= wTagType or self.curRechargeId ~= rechargeId then
        self:SetTypeSelect(self.selectTypeIndex, false)
        self.selectTypeIndex = cellIndex
        self:SetTypeSelect(cellIndex, true)
        self.curWelfareType = wTagType
        self.curRechargeId = rechargeId
        self:ShowClickTypeButtonList()
        EventManager:GetInstance():Broadcast(EventId.CacheGoldStoreOpenType, self.curWelfareType)
    end
end

local function ShowClickTypeButtonList(self)
    self.showMainType = ""
    self.showSubType = ""
    self.goldExchangeId = ""
    if self.curWelfareType == WelfareTagType["PackStore"] then -- 礼包商城
        self.goldExchangeId = self.userdata.goldExchangeId or ""
        self:ShowGiftPanel()
    elseif self.curWelfareType == WelfareTagType["WeeklyPackage"] then
        self:ShowWeeklyPackagePanel()
    elseif self.curWelfareType == WelfareTagType["WeeklyPackageNew"] then
        self:ShowWeeklyPackageNewPanel()
    elseif self.curWelfareType == WelfareTagType.WeekCard then
        self:ShowWeekCardPanel()
    elseif self.curWelfareType == WelfareTagType.HeroMedalPackage then
        self:ShowHeroMedalPackagePanel()
    elseif self.curWelfareType == WelfareTagType.PaidLottery then
        self:ShowPaidLotteryPanel()
    elseif self.curWelfareType == WelfareTagType["PremiumPack"] then -- 礼包商城
        self:ShowPremiumPackPanel()
    elseif self.curWelfareType == WelfareTagType["RobotPack"] then
        local dataList = GiftPackageData.getRobotPacksByRechargeId(self.curRechargeId)
        if dataList ~= nil and #dataList > 0 then
            local data = dataList[1]
            self:ShowRobotPackPanel(data)
        end
    elseif self.curWelfareType == WelfareTagType.MonthCard then
        local golloesMonthCard = DataCenter.MonthCardNewManager:GetGolloesMonthCard()
        self:ShowGolloesMonthCardPanel(golloesMonthCard)
    elseif self.curWelfareType == WelfareTagType.PiggyBank then
        self:ShowPiggyBankPanel()
    elseif self.curWelfareType == WelfareTagType.EnergyBank then
        self:ShowEnergyBankPanel()
    elseif self.curWelfareType == WelfareTagType.GrowthPlan then
        self:ShowGrowthPlanPanel()
    elseif self.curWelfareType == WelfareTagType.ScrollPack then
        local packs = GiftPackageData.GetAllAvailablePackageByRechargeId(self.curRechargeId, false)
        if packs[1] then
            local packId = packs[1]:getID()
            local packInfo = GiftPackManager.get(packId)
            local popup_Image = packInfo:getPopupImageH()
            if popup_Image == "SellDarkVipNew" then
                self:ShowScrollPackContentNew()
            else
                self:ShowScrollPackContent()
            end
        end
    elseif self.curWelfareType == WelfareTagType.HeroMonthCardNew then
        self:ShowHeroMonthCardPanel()
    elseif self.curWelfareType == WelfareTagType.CumulativeRecharge then
        self:ShowCumulativeRechargePanel()
    elseif self.curWelfareType == WelfareTagType.DailyCumulativeRecharge then
        self:ShowDailyCumulativeRechargePanel()
    elseif self.curWelfareType == WelfareTagType.KeepPay then
        self:ShowKeepPayPanel()
    elseif self.curWelfareType == WelfareTagType.ChainPay then
        self:ShowChainPayPanel()
    elseif self.curWelfareType == WelfareTagType.DailyPackage then
        self:ShowDailyPackagePanel()
    elseif self.curWelfareType == WelfareTagType.FirstCharge then
        self:ShowFirstChargePanel()
    elseif self.curWelfareType == WelfareTagType.DailyMustBuy then
        self:ShowDailyMustBuyPanel()
    else
        self:ShowGiftPanel()
    end
end

local function SetPanelActive(self, panel)
    for k, v in pairs(self.panels) do
        v:SetActive(k == panel)
    end
end

local function CallBackActive(self, rechargeId)
    if self.welfareTagType == WelfareTagType["PremiumPack"] or 
        self.welfareTagType == WelfareTagType["PackStore"] then
        self:SetPanelActive(PanelEnum.GiftPackagePagePanel)
    elseif self.welfareTagType == WelfareTagType["RobotPack"] then
        self:SetPanelActive(PanelEnum.RobotPackPanel)
    elseif self.welfareTagType == WelfareTagType["MonthCard"] then
        self:SetPanelActive(PanelEnum.GolloesMonthCardPanel)
    elseif self.welfareTagType == WelfareTagType["PiggyBank"] then
        self:SetPanelActive(PanelEnum.PiggyBankPanel)
    elseif self.welfareTagType == WelfareTagType["EnergyBank"] then
        self:SetPanelActive(PanelEnum.EnergyBankPanel)
    elseif self.welfareTagType == WelfareTagType["WeeklyPackage"] then
        self:SetPanelActive(PanelEnum.WeeklyPackagePanel)
    elseif self.welfareTagType == WelfareTagType["HeroMedalPackage"] then
        self:SetPanelActive(PanelEnum.HeroMedalPackagePanel)
    elseif self.welfareTagType == WelfareTagType["GrowthPlan"] then
        self:SetPanelActive(PanelEnum.GrowthPlanPanel)
    elseif self.welfareTagType == WelfareTagType.HeroMonthCardNew then
        self:SetPanelActive(PanelEnum.HeroMonthCardPanel)
    elseif self.welfareTagType == WelfareTagType["ScrollPack"] then
        self:SetPanelActive(PanelEnum.ScrollPackContent, rechargeId)
    elseif self.welfareTagType == WelfareTagType["CumulativeRecharge"] then
        self:SetPanelActive(PanelEnum.CumulativeRecharge)
    elseif self.welfareTagType == WelfareTagType["DailyCumulativeRecharge"] then
        self:SetPanelActive(PanelEnum.DailyCumulativeRecharge)
    elseif self.welfareTagType == WelfareTagType["KeepPay"] then
        self:SetPanelActive(PanelEnum.KeepPay)
    elseif self.welfareTagType == WelfareTagType["ChainPay"] then
        self:SetPanelActive(PanelEnum.ChainPay)
    elseif self.welfareTagType == WelfareTagType["DailyPackage"] then
        self.SetPanelActive(PanelEnum.DailyPackage)
    elseif self.welfareTagType == WelfareTagType["FirstCharge"] then
        self.SetPanelActive(PanelEnum.FirstCharge)
    end
end

local function SetTypeSelect(self,index,value)
    if self.typeCells[index] ~= nil then
        self.typeCells[index]:SetSelect(value)
    end
end

local function OnRefreshWelfareRedDot(self)
    for index, cell in pairs(self.typeCells) do
        local redDotNum = self.welfarelist[index]:getRedDotNum()
        cell:SetRedDot(redDotNum)
    end
end

--  [[周礼包缓存
local function GetWeeklyPackageModel(self, path)
    if not self.weeklyPackageItemDic or not self.weeklyPackageItemDic[path] then
        return nil
    end
    local tempList = self.weeklyPackageItemDic[path]
    local retModel = nil
    if #tempList > 0 then
        retModel = tempList[1]
        table.remove(tempList, 1)
    end
    return retModel
end

local function RecycleOneWeeklyPackageModel(self, strPath, model)
    if not self.weeklyPackageItemDic then
        self.weeklyPackageItemDic = {}
    end
    if not self.weeklyPackageItemDic[strPath] then
        self.weeklyPackageItemDic[strPath] = {}
    end

    local go = model.gameObject
    if not IsNull(go.gameObject) then
        go.gameObject:SetActive(false)
        go.transform:SetParent(self.weeklyPackageItemsContainer.transform)
        table.insert(self.weeklyPackageItemDic[strPath], model)
    end
end

--]]

UIGiftPackagePopUpView.OnCreate = OnCreate
UIGiftPackagePopUpView.OnDestroy = OnDestroy
UIGiftPackagePopUpView.OnEnable = OnEnable
UIGiftPackagePopUpView.OnDisable = OnDisable
UIGiftPackagePopUpView.ComponentDefine = ComponentDefine
UIGiftPackagePopUpView.ComponentDestroy = ComponentDestroy
UIGiftPackagePopUpView.DataDefine = DataDefine
UIGiftPackagePopUpView.DataDestroy = DataDestroy
UIGiftPackagePopUpView.OnAddListener = OnAddListener
UIGiftPackagePopUpView.OnRemoveListener = OnRemoveListener

UIGiftPackagePopUpView.ReInit = ReInit
UIGiftPackagePopUpView.OnUpdateGiftPackData = OnUpdateGiftPackData
UIGiftPackagePopUpView.ShowGiftPanel = ShowGiftPanel
UIGiftPackagePopUpView.RefreshGiftPanel = RefreshGiftPanel
UIGiftPackagePopUpView.ShowPremiumPackPanel = ShowPremiumPackPanel
UIGiftPackagePopUpView.ShowRobotPackPanel = ShowRobotPackPanel
UIGiftPackagePopUpView.ShowPiggyBankPanel = ShowPiggyBankPanel
UIGiftPackagePopUpView.ShowEnergyBankPanel = ShowEnergyBankPanel
UIGiftPackagePopUpView.ShowGrowthPlanPanel = ShowGrowthPlanPanel
UIGiftPackagePopUpView.ShowScrollPackContent = ShowScrollPackContent
UIGiftPackagePopUpView.TypeButtonCallBack = TypeButtonCallBack
UIGiftPackagePopUpView.ClearScroll = ClearScroll
UIGiftPackagePopUpView.ShowTypeButton = ShowTypeButton
UIGiftPackagePopUpView.ShowClickTypeButtonList = ShowClickTypeButtonList
UIGiftPackagePopUpView.ShowHeroMonthCardPanel = ShowHeroMonthCardPanel
UIGiftPackagePopUpView.ShowCumulativeRechargePanel = ShowCumulativeRechargePanel
UIGiftPackagePopUpView.ShowDailyCumulativeRechargePanel = ShowDailyCumulativeRechargePanel
UIGiftPackagePopUpView.ShowKeepPayPanel = ShowKeepPayPanel
UIGiftPackagePopUpView.ShowChainPayPanel = ShowChainPayPanel
UIGiftPackagePopUpView.OnCreateCell = OnCreateCell
UIGiftPackagePopUpView.OnDeleteCell = OnDeleteCell
UIGiftPackagePopUpView.SetPanelActive = SetPanelActive
UIGiftPackagePopUpView.CallBackActive = CallBackActive
UIGiftPackagePopUpView.SetTypeSelect = SetTypeSelect
UIGiftPackagePopUpView.ShowGolloesMonthCardPanel = ShowGolloesMonthCardPanel
UIGiftPackagePopUpView.ShowWeeklyPackagePanel = ShowWeeklyPackagePanel
UIGiftPackagePopUpView.ShowWeeklyPackageNewPanel = ShowWeeklyPackageNewPanel
UIGiftPackagePopUpView.RefreshWeeklyPackageNewPanel = RefreshWeeklyPackageNewPanel
UIGiftPackagePopUpView.ShowWeekCardPanel = ShowWeekCardPanel
UIGiftPackagePopUpView.ShowHeroMedalPackagePanel = ShowHeroMedalPackagePanel
UIGiftPackagePopUpView.ShowDailyPackagePanel = ShowDailyPackagePanel
UIGiftPackagePopUpView.DailyPackageFree = DailyPackageFree
UIGiftPackagePopUpView.OnRefreshWelfareRedDot = OnRefreshWelfareRedDot
UIGiftPackagePopUpView.GotoButtonType = GotoButtonType
UIGiftPackagePopUpView.GetWeeklyPackageModel = GetWeeklyPackageModel
UIGiftPackagePopUpView.RecycleOneWeeklyPackageModel = RecycleOneWeeklyPackageModel
UIGiftPackagePopUpView.LoadPanel = LoadPanel
UIGiftPackagePopUpView.ShowPaidLotteryPanel = ShowPaidLotteryPanel
UIGiftPackagePopUpView.ShowFirstChargePanel = ShowFirstChargePanel
UIGiftPackagePopUpView.ShowDailyMustBuyPanel = ShowDailyMustBuyPanel
UIGiftPackagePopUpView.ShowScrollPackContentNew = ShowScrollPackContentNew

return UIGiftPackagePopUpView