---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zhangliheng.
--- DateTime: 7/7/21 6:58 PM
---


local UIHeroRecruitView = BaseClass("UIHeroRecruitView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UITabCell = require "UI.UIHero2.UIHeroRecruit.Component.UITabCell"
local UITopItem = require "UI.UIHero2.UIHeroRecruit.Component.UITopItem"
local CampRecruitBgPath = "Assets/Main/TextureEx/UIHeroRecruitBg/%s.png"
local ResourceManager = CS.GameEntry.Resource
local btnOnePos = nil
local UICommonItem = require "UI.UICommonItem.UICommonItem"
local UIHeroTipsView = require "UI.UIHeroTips.View.UIHeroTipsView"
local sendMsgTime = 0 -- 发抽卡消息不能连点和抽卡消息返回后，抽卡结果界面打开前不能点击

local gold_btn_path = "Root/TopBar/TopBarList/GoldBar"
local gold_num_text_path = "Root/TopBar/TopBarList/GoldBar/root/resourceNum"

local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
    self.ctrl:GetDataFromServer()
    self:OnOpen()
end

local function OnDestroy(self)
    self:CloseBarAni()
    -- self:ResetBarPos()

    self:ComponentDestroy()

    if self.heroSpineRequest ~= nil then
        self.heroSpineRequest:Destroy()
        self.heroSpineRequest = nil
    end
    self:DataDestroy()

    base.OnDestroy(self)
end

local function ComponentDefine(self)
    local gray_image = self:AddComponent(UIImage,"Gray")
    self.gray = gray_image:GetMaterial()
    local btnBack = self:AddComponent(UIButton, "Root/TopBar/closeBtn")
    btnBack:SetOnClick(BindCallback(self, self.ClosePanel))
    self.textTitle       = self:AddComponent(UITextMeshProUGUIEx, "Root/TopBar/TextTitle")
    self.imgBg           = self:AddComponent(UIImage, 'Root/ImgBg')
    self.heroSpine       = self:AddComponent(UIBaseContainer, 'Root/ImgBg/HeroSpineContainer')
    self.scrollViewTab   = self:AddComponent(UIScrollView, "Root/BottomBar/TabContent/ScrollView")
    self.btnRecruitOneImg = self:AddComponent(UIImage, "Root/CenterContentContainer/BtnRecruitOne")
    self.btnRecruitOne   = self:AddComponent(UIButton, "Root/CenterContentContainer/BtnRecruitOne")
    self.btnRecruitTenImg = self:AddComponent(UIImage, "Root/CenterContentContainer/BtnRecruitTen")
    self.btnRecruitTen   = self:AddComponent(UIButton, "Root/CenterContentContainer/BtnRecruitTen")
    if btnOnePos == nil then
        btnOnePos = self.btnRecruitOne.transform.localPosition
    end
    self.textBtn1        = self:AddComponent(UITextMeshProUGUIEx, "Root/CenterContentContainer/BtnRecruitOne/GameObject/TextBtn1")
    self.textBtn2        = self:AddComponent(UITextMeshProUGUIEx, "Root/CenterContentContainer/BtnRecruitTen/GameObject/TextBtn2")
    self.icon_go1    = self:AddComponent(UIImage, "Root/CenterContentContainer/BtnRecruitOne/GameObject/icon_go1")
    self.imgCostItem1    = self:AddComponent(UIImage, "Root/CenterContentContainer/BtnRecruitOne/GameObject/icon_go1/ImgCostItem1")
    self.textCost1       = self:AddComponent(UITextMeshProUGUIEx, "Root/CenterContentContainer/BtnRecruitOne/GameObject/TextCost1")
    self.imgCostItem2    = self:AddComponent(UIImage, "Root/CenterContentContainer/BtnRecruitTen/GameObject/icon_go/ImgCostItem2")
    self.textCost2       = self:AddComponent(UITextMeshProUGUIEx, "Root/CenterContentContainer/BtnRecruitTen/GameObject/TextCost2")
    self.textTimeOpen    = self:AddComponent(UITextMeshProUGUIEx, "Root/RightPanel/BtnChange/TextTimeOpen")
    self.recruitOneFreeText = self:AddComponent(UITextMeshProUGUIEx, "Root/CenterContentContainer/BtnRecruitOne/GameObject/FreeRecruitText")
    self.recruitOneFreeCountDownText = self:AddComponent(UITextMeshProUGUIEx, "Root/CenterContentContainer/BtnRecruitOne/NextFreeCountDownText")
    self.recruitOneFreeTimesText = self:AddComponent(UITextMeshProUGUIEx, "Root/CenterContentContainer/BtnRecruitOne/FreeRecruitTimesText")
    self.btnRecruitOneRedPoint = self:AddComponent(UIBaseContainer, "Root/CenterContentContainer/BtnRecruitOne/BtnRecruitOneRedPoint")
    self.btnRecruitTenRedPoint = self:AddComponent(UIBaseContainer, "Root/CenterContentContainer/BtnRecruitTen/BtnRecruitTenRedPoint")
    self.recruitOneFreeText:SetLocalText(GameDialogDefine.FREE)
    self.scrollViewTab:SetOnItemMoveIn(BindCallback(self, self.OnCreateCell))
    self.scrollViewTab:SetOnItemMoveOut(BindCallback(self, self.OnDeleteCell))
    self.btnRecruitOne:SetOnClick(BindCallback(self, self.OnBtnRecruitOneClick))
    self.btnRecruitTen:SetOnClick(BindCallback(self, self.OnBtnRecruitTenClick))

    self.heroCardContent = self:AddComponent(UIBaseContainer, "Root/CenterContentContainer")

    self.textTitle:SetLocalText(110021)
    self.textBtn1:SetLocalText(110115)

    self.topBar = self:AddComponent(UIBaseContainer, "Root/TopBar")
    self.bottomBar = self:AddComponent(UIBaseContainer, "Root/BottomBar")
    self.topBarPos = self:AddComponent(UIBaseContainer, "Root/TopBarPos")
    self.bottomBarPos = self:AddComponent(UIBaseContainer, "Root/BottomBarPos")
    self:ResetBarPos()

    self.packageContent = self:AddComponent(UIBaseContainer, "Root/CenterContentContainer/packageContent")
    self.packageNameText = self:AddComponent(UITextMeshProUGUIEx, "Root/CenterContentContainer/packageContent/GiftPackageContent/PackageNameText")
    self.packageDiscountTip = self:AddComponent(UIBaseContainer, "Root/CenterContentContainer/packageContent/GiftPackageContent/DiscountTip")
    self.packageDiscountTipText = self:AddComponent(UITextMeshProUGUIEx, "Root/CenterContentContainer/packageContent/GiftPackageContent/DiscountTip/DiscountTipText")
    self.giftPackageItemScroll = self:AddComponent(UIScrollView,"Root/CenterContentContainer/packageContent/GiftPackageContent/CellScroll")
    self.giftPackageItemScroll:SetOnItemMoveIn(function(itemObj, index)
        self:OnPackageCreateCell(itemObj, index)
    end)
    self.giftPackageItemScroll:SetOnItemMoveOut(function(itemObj, index)
        self:OnPackageDeleteCell(itemObj, index)
    end)
    self.payBtn = self:AddComponent(UIButton, "Root/CenterContentContainer/packageContent/GiftPackageContent/PayBtn")
    self.payBtn:SetOnClick(function()
        self:OnPayBtnClick()
    end)
    self.payBtnPriceText = self:AddComponent(UITextMeshProUGUIEx, "Root/CenterContentContainer/packageContent/GiftPackageContent/PayBtn/PayBtnPriceText")

    self.luckyContent = self:AddComponent(UIBaseContainer, "Root/CenterContentContainer/luckyContent")
    self.lickyFill = self:AddComponent(UIImage, "Root/CenterContentContainer/luckyContent/Slider/FillArea/Fill")
    self.luckyNum = self:AddComponent(UITextMeshProUGUIEx, "Root/CenterContentContainer/luckyContent/luckynum")
    self.luckyImage = self:AddComponent(UIButton, "Root/CenterContentContainer/luckyContent/luckyImage")

    self.itemBar = self:AddComponent(UITopItem, "Root/TopBar/TopBarList/ItemBar")
    self.itemBar:SetOnClick(BindCallback(self, self.OnItemBarClick))

    self.rateBtn = self:AddComponent(UIButton, "Root/CenterContentContainer/rateBtn")
    self.rateBtn:SetOnClick(function()
        self:OnRateBtnClick()
    end)

    self.luckyImage:SetOnClick(function()
        self:OnLuckyBtnClick()
    end)

    self.canClick = true

    self.gold_btn = self:AddComponent(UIButton, gold_btn_path)
    self.gold_btn:SetOnClick(function()
        self:OnGoldBtnClick()
    end)
    self.gold_num_text = self:AddComponent(UITextMeshProUGUIEx, gold_num_text_path)
end

local function ComponentDestroy(self)
    self.textTitle       = nil
    self.scrollViewTab   = nil
    self.textTimeOpen = nil
    self.btnRecruitOne   = nil
    self.btnRecruitTen   = nil
    self.textBtn1        = nil
    self.textBtn2        = nil
    self.imgCostItem1    = nil
    self.textCost1       = nil
    self.imgCostItem2    = nil
    self.textCost2       = nil
    self.recruitOneFreeText = nil
    self.recruitOneFreeCountDownText = nil
    self.recruitOneFreeTimesText = nil

    self.heroCardContent = nil

    self.topBar = nil
    self.bottomBar = nil
    self.topBarPos = nil
    self.bottomBarPos = nil

    self.packageContent = nil
    self.packageNameText = nil
    self.packageDiscountTip = nil
    self.packageDiscountTipText = nil
    self.giftPackageItemScroll = nil
    self.payBtn = nil
    self.payBtnPriceText = nil

    self.luckyContent = nil
    self.lickyFill = nil
    self.luckyNum = nil
    self.luckyImage = nil

    self.itemBar = nil

    self.rateBtn = nil
end

local function DataDefine(self)
    self.heroSpineRequest = nil
    self.free_timer_callback = function()
        self:RefreshFreeCountdown()
    end
end

local function DataDestroy(self)
    self:DeleteTimer()
    if self.delayTimer ~= nil then
        self.delayTimer:Stop()
        self.delayTimer = nil
    end
    
    if self.arrowTime ~= nil then
        self.arrowTime:Stop()
        self.arrowTime = nil
    end

    if self.closeCallBack ~= nil then
        self.closeCallBack()
    end

    self.lotteryData = nil
end

local function OnEnable(self)
    base.OnEnable(self)
    --如果建筑气泡提示阵营招募 则写入flag
    DataCenter.LotteryDataManager:CheckCampRecruitFlag()
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function OnAddListener(self)
    base.OnAddListener(self)
    self:AddUIListener(EventId.HeroicRecruitmentData, self.OnHandleRecruitResponse)
    self:AddUIListener(EventId.RecruitCampChange, self.OnHandleCampSwitch)
    self:AddUIListener(EventId.UpdateGiftPackData, self.UpdateGiftPackage)
    self:AddUIListener(EventId.HeroLotteryInfoUpdate, self.OnDataUpdate)
    self:AddUIListener(EventId.RefreshItems,self.UpdateView)
    self:AddUIListener(EventId.CheckPubBubble,self.UpdateView)
    self:AddUIListener(EventId.HeroStationUpdate,self.OnDataUpdate)
    self:AddUIListener(EventId.UpdateGold, self.UpdateGoldSignal)
end

local function OnRemoveListener(self)
    self:RemoveUIListener(EventId.HeroicRecruitmentData, self.OnHandleRecruitResponse)
    self:RemoveUIListener(EventId.RecruitCampChange, self.OnHandleCampSwitch)
    self:RemoveUIListener(EventId.UpdateGiftPackData, self.UpdateGiftPackage)
    self:RemoveUIListener(EventId.HeroLotteryInfoUpdate, self.OnDataUpdate)
    self:RemoveUIListener(EventId.RefreshItems,self.UpdateView)
    self:RemoveUIListener(EventId.CheckPubBubble,self.UpdateView)
    self:RemoveUIListener(EventId.HeroStationUpdate,self.OnDataUpdate)
    self:RemoveUIListener(EventId.UpdateGold, self.UpdateGoldSignal)
    base.OnRemoveListener(self)
end

local function RefreshGoldNum(self)
    local gold = LuaEntry.Player.gold
    self.textGoldNum:SetText(string.GetFormattedSeperatorNum(gold))
end

local function OnOpen(self)
    self:GenerateTabs()
    --如果是点击气泡进来的 则跳转到相应的奖池
    local fromBubble,isArrow, selectIndex,closeCallBack = self:GetUserData() -- selectIndex改成传奖池id，因为奖池顺序面板的奖池数据是经过排序加工的
    self.isArrow = isArrow

    local idx = 1
    if selectIndex then
        if self.dataList ~= nil then
            for i, v in pairs(self.dataList) do
                if v.id == selectIndex then
                    idx = i
                    break
                end
            end
        end
    end
    if fromBubble then
        idx = DataCenter.LotteryDataManager:GetCurTipBubbleType()
    end
    self.closeCallBack = closeCallBack
    self:OnSwitchTab(idx)
    self:RefreshGold()
end

local function GenerateTabs(self)
    self.dataList = self.ctrl:GetNewLotteryList()
    local dataCount = table.count(self.dataList)
    
    self:ClearTabs()
    if dataCount <= 0 then
        return
    end

    self.scrollViewTab:SetTotalCount(dataCount)
    self.scrollViewTab:RefillCells(1)

    self.arrowTime = TimerManager:GetInstance():DelayInvoke(function()
        if self.isArrow then
            local isCur = self.currentTabIdx == self.isArrow
            local param = {}
            if self.tabs and next(self.tabs) then
                param.position = self.tabs[self.isArrow]:GetPosition()
                param.positionType = PositionType.Screen
                param.isPanel = false
                self.isArrow = nil
            end
            if isCur then
                param.position = self.btnRecruitOne.transform.position
            else
                param.isReversal = true
                param.YisReversal = true
            end
            if param.position ~= nil then
                DataCenter.ArrowManager:ShowArrow(param)
            end
        end
    end, 0.5)
end

local function ClearTabs(self)
    self.scrollViewTab:ClearCells()
    self.scrollViewTab:RemoveComponents(UITabCell)
    self.tabs = {}
end

local function OnCreateCell(self, itemObj, index)
    itemObj.name = tostring(index)
    local data = self.dataList[index]

    local tabCell = self.scrollViewTab:AddComponent(UITabCell, itemObj)
    tabCell:SetData(index, data, BindCallback(self, self.OnSwitchTab))
    self.tabs[index] = tabCell
end

local function OnDeleteCell(self,itemObj, index)
    self.scrollViewTab:RemoveComponent(itemObj.name, UITabCell)
    self.tabs[index] = nil
end

local function RefreshCellsRedPoint(self)
    if self.tabs ~= nil then
        for i, v in pairs(self.tabs) do
            v:UpdateRedPoint()
        end
    end
end

local function OnSwitchTab(self, idx, force)
    if not force and idx == self.currentTabIdx then
        return
    end
    if self.dataList == nil or table.count(self.dataList) == 0 then
        return
    end
    if idx == nil or idx == 0 or idx > table.count(self.dataList) then
        idx = 1
    end
    
    local lastTab = self.tabs[self.currentTabIdx]
    self.currentTabIdx = idx
    local curTab = self.tabs[self.currentTabIdx]

    if lastTab ~= nil then lastTab:UpdateSelect() end
    if curTab ~= nil then curTab:UpdateSelect() end
    self:DeleteTimer()
    self:UpdateView()
end

local function UpdatePityText(self)
    local lotteryData = DataCenter.LotteryDataManager:GetLotteryDataById(self.curLotteryId)

    if lotteryData ~= nil and (lotteryData.pityProType > 0 or not string.IsNullOrEmpty(lotteryData.pity_hero)) then
        local curNum = lotteryData.pityProProtectNum
        local maxNum = lotteryData:GetPityMaxNum()
        self.luckyNum:SetLocalText(150033, curNum, maxNum)
        local percent = Mathf.Clamp(curNum / maxNum, 0, 1)
        self.lickyFill:SetFillAmount(percent)
        self.luckyContent:SetActive(true)
    else
        self.luckyContent:SetActive(false)
    end
end

function UIHeroRecruitView:DeleteFreeCountdownTimer()
    self.prevCanFreeRecruitState = nil
    if self.freeCountdownTimer ~= nil then
        self.freeCountdownTimer:Stop()
        self.freeCountdownTimer = nil
    end
end

function UIHeroRecruitView:AddFreeCountdownTimer()
    if self.freeCountdownTimer == nil then
        self.freeCountdownTimer = TimerManager:GetInstance():GetTimer(1, self.free_timer_callback, self, false, false, false)
        self.freeCountdownTimer:Start()
    end
end

function UIHeroRecruitView:RefreshFreeCountdown()
    local canFreeRecruit = self.lotteryData:CanFreeRecruit()

    if canFreeRecruit ~= self.prevCanFreeRecruitState then
        if canFreeRecruit then
            self.recruitOneFreeText:SetActive(true)
            self.recruitOneFreeCountDownText:SetActive(false)
            self.recruitOneFreeTimesText:SetActive(false)
            self.icon_go1:SetActive(false)
            self.textCost1:SetActive(false)
        else
            self.recruitOneFreeText:SetActive(false)
            self.recruitOneFreeCountDownText:SetActive(true)
            self.recruitOneFreeTimesText:SetActive(false)
            self.icon_go1:SetActive(true)
            self.textCost1:SetActive(true)
        end
    end

    self.prevCanFreeRecruitState = canFreeRecruit

    if canFreeRecruit then
        self:DeleteFreeCountdownTimer()
        return true
    else
        local now = UITimeManager:GetInstance():GetServerSeconds()
        self.recruitOneFreeCountDownText:SetLocalText(GameDialogDefine.BAUBLE_SHOP_FREE_IN_WHIT, 
                UITimeManager:GetInstance():SecondToFmtString(self.lotteryData.nextFreeTime - now))

        return false
    end
end

local function UpdateView(self)
    self:CloseBarAni()
    self:ResetBarPos()
    self:UpdateHeroView()
end

local function UpdateHeroView(self)
    self.heroCardContent:SetActive(true)
    
    self.curLotteryId = self.dataList[self.currentTabIdx].id
    self.lotteryData = DataCenter.LotteryDataManager:GetLotteryDataById(self.curLotteryId)

    --self:UpdateBg()
    self:UpdateTopItemBar()
    self:UpdatePityText()
    self:UpdateGiftPackageInfo()

    self:UpdateBottomButtons()

    self:RefreshCellsRedPoint()
end

local function UpdateBg(self)
    if self.lotteryData == nil then
        return
    end
    local vec = string.split(self.lotteryData.picture, "|")
    if table.count(vec) == 2 then
        local path = string.format(CampRecruitBgPath, vec[1])
        local heroPath = vec[2]
        self.imgBg:LoadSprite(path)

        self.heroSpine:SetActive(true)

        if self.heroSpineRequest ~= nil then
            self.heroSpineRequest:Destroy()
            self.heroSpineRequest = nil
        end

        local request = ResourceManager:InstantiateAsync(heroPath)
        self.heroSpineRequest = request
        request:completed('+',function()
            if request.isError or request.gameObject == nil then
                self.heroSpineRequest = nil
                return
            end

            request.gameObject:SetActive(true)

            local spineScale = 1
            local spinePos = {0,0}
            if not table.IsNullOrEmpty(self.lotteryData.spineParam) and table.count(self.lotteryData.spineParam) >= 3 then
                spineScale = self.lotteryData.spineParam[1]
                spinePos = {self.lotteryData.spineParam[2],self.lotteryData.spineParam[3]}
            end


            self.heroSpine.rectTransform:Set_localScale(spineScale, spineScale, 1)
            self.heroSpine.rectTransform:Set_anchoredPosition(spinePos[1],spinePos[2], 0)

            local rectTransform = request.gameObject:GetComponent(typeof(CS.UnityEngine.RectTransform))
            if rectTransform ~= nil then
                rectTransform:SetParent(self.heroSpine.transform)
                rectTransform:Set_localScale(1, 1, 1)
                rectTransform:Set_anchoredPosition(0, 0)
            end
        end)
    elseif table.count(vec) == 1 then
        local path = string.format(CampRecruitBgPath, vec[1])
        self.imgBg:LoadSprite(path)
    end
end

---更新顶部道具条
local function UpdateTopItemBar(self)
    local costItems = self.lotteryData:GetCostItems()
    if #costItems > 0 then
        self.itemBar:SetActive(true)
        self.itemBar:SetData(costItems[1].itemId)
    else
        self.itemBar:SetActive(false)
    end
end

local function UpdateBottomButtons(self)
    local now = UITimeManager:GetInstance():GetServerTime()

    if self.lotteryData == nil or (self.lotteryData:IsShowTime() and (self.lotteryData.startTime > now or self.lotteryData.endTime < now))  then
        self.btnRecruitOne:SetActive(false)
        self.btnRecruitTen:SetActive(false)
        return
    end

    local supportFreeRecruit = self.lotteryData:IsSupportFreeRecruit()

    local needUpdator = false
    if supportFreeRecruit then
        needUpdator = not self:RefreshFreeCountdown()
    else
        self.recruitOneFreeText:SetActive(false)
        self.recruitOneFreeCountDownText:SetActive(false)
        self.recruitOneFreeTimesText:SetActive(false)
        self.icon_go1:SetActive(true)
        self.textCost1:SetActive(true)
    end

    if needUpdator then
        self:AddFreeCountdownTimer()
    else
        self:DeleteFreeCountdownTimer()
    end

    self.btnRecruitOne:SetActive(true)
    local showTenFlag = true
    self.btnRecruitTen:SetActive(showTenFlag)
    if not showTenFlag then
        self.btnRecruitOne.transform.localPosition = Vector3.New(btnOnePos.x + 200, btnOnePos.y, 0)
    else
        self.btnRecruitOne.transform.localPosition = btnOnePos
    end

    if self.canClick==false then
        self.btnRecruitOneImg:SetMaterial(self.gray)
        self.btnRecruitTenImg:SetMaterial(self.gray)
    else
        self.btnRecruitOneImg:SetMaterial(nil)
        self.btnRecruitTenImg:SetMaterial(nil)
    end

    local costItems = self.lotteryData:GetCostItems()

    self.imgCostItem1:LoadSprite(string.format(LoadPath.ItemPath, DataCenter.ItemTemplateManager:GetItemTemplate(costItems[1].itemId).icon))
    if DataCenter.ItemData:GetItemCount(costItems[1].itemId) < costItems[1].itemNum then
        self.textCost1:SetText(string.format(TextColorStr, TextColorRed, string.GetFormattedSeperatorNum(costItems[1].itemNum)))
    else
        self.textCost1:SetText(costItems[1].itemNum)
    end

    if #costItems >= 2 then
        self.imgCostItem2:LoadSprite(string.format(LoadPath.ItemPath, DataCenter.ItemTemplateManager:GetItemTemplate(costItems[2].itemId).icon))
        local str = ""
        local have = DataCenter.ItemData:GetItemCount(costItems[2].itemId)
        local cost = costItems[2].itemNum
        if have < cost then
            str = string.format(TextColorStr, TextColorRed, string.GetFormattedSeperatorNum(cost))
        else
            str = string.GetFormattedSeperatorNum(cost)
        end
        self.textCost2:SetText(str)
        self.textBtn2:SetLocalText(450113, cost)
    end

    if self.lotteryData:CanFreeRecruit() then
        self.btnRecruitOneRedPoint:SetActive(true)
    else
        self.btnRecruitOneRedPoint:SetActive(false)
    end

    if self.lotteryData:CanMultiRecruit() then
        self.btnRecruitTenRedPoint:SetActive(true)
    else
        self.btnRecruitTenRedPoint:SetActive(false)
    end
end

local function UpdateGiftPackage(self)
    self:UpdateView()
end

local function UpdateGiftPackageInfo(self)
    local lotteryData = DataCenter.LotteryDataManager:GetLotteryDataById(self.curLotteryId)
    self.costItems = lotteryData:GetCostItems()
    self.itemId = self.costItems[1].itemId
    self.packageData = self.ctrl:GePackageInfo(self.itemId)
    self.packageContent:SetActive(self.packageData)

    if self.packageData then
        self.packageNameText:SetText(self.packageData:getNameText())
        if self.packageData:hasPercent() then
            self.packageDiscountTip:SetActive(true)
            self.packageDiscountTipText:SetText(string.format("%s%%", self.packageData:getPercent()))
        else
            self.packageDiscountTip:SetActive(false)
            self.packageDiscountTipText:SetText("")
        end
        self:ShowGiftPackageCells()
        self.payBtnPriceText:SetText(self.packageData:getPriceText())
        self.payBtnPriceText:SetColor(WhiteColor)
    end
end

function UIHeroRecruitView:ShowGiftPackageCells()
    self:ClearPackageScroll()
    self:GetGiftPackageDataList()
    local count = table.count(self.gift_list)
    if count > 0 then
        self.giftPackageItemScroll:SetTotalCount(count)
        self.giftPackageItemScroll:RefillCells()
    end
end
function UIHeroRecruitView:GetGiftPackageDataList()
    self.gift_list = {}
    if self.packageData ~= nil then
        self.gift_list = self.packageData:GetRewardList()
    end
end

local function ClearPackageScroll(self)
    self.giftPackageItemScroll:ClearCells()--清循环列表数据
    self.giftPackageItemScroll:RemoveComponents(UICommonItem)--清循环列表gameObject
end

local function OnPackageCreateCell(self,itemObj, index)
    itemObj.name =  tostring(index)
    local cellItem = self.giftPackageItemScroll:AddComponent(UICommonItem, itemObj)
    cellItem:ReInit(self.gift_list[index])
end

local function OnPackageDeleteCell(self,itemObj, index)
    self.giftPackageItemScroll:RemoveComponent(itemObj.name, UICommonItem)
end

local function OnPayBtnClick(self)
    if self.packageData then
        DataCenter.PayManager:CallPayment(self.packageData, "GoldExchangeView", "")
    end
end

local function DeleteTimer(self)
    self:DeleteFreeCountdownTimer()
end

local function Update(self)
    if self.textTimeOpen == nil then
        return
    end
    local now = UITimeManager:GetInstance():GetServerTime()
    if self.lotteryData ~= nil and self.lotteryData.startTime > now  and self.lotteryData.time_type ~= LotteryTimeType.LotteryTimeType_Expert then
        local leftTime = math.max(0, self.lotteryData.startTime - now)
        self.textTimeOpen:SetLocalText(302011,  UITimeManager:GetInstance():MilliSecondToFmtString(leftTime))
    else
        self.textTimeOpen:SetText('')
    end
end

local function OnBtnInfoClick(self)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroRecruitTip, {anim = true, isBlur = true}, self.curLotteryId)
end

local function OnBtnChangeCampClick(self)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroRecruitChangeCamp, self.curLotteryId)
end

local function OnBtnRecruitOneClick(self)
    if self.canClick==false then
        return
    end
    
    if self.lotteryData == nil then
        return
    end

    -- 防止连点
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if curTime < sendMsgTime + 1000 then
        return
    end
    sendMsgTime = curTime
    SoundUtil.PlayEffect(SoundAssets.Music_Effect_GetHero_One)
    local supportFreeRecruit = self.lotteryData:IsSupportFreeRecruit()
    local canFreeRecruit = self.lotteryData:CanFreeRecruit()
    local costItems = self.lotteryData:GetCostItems()
    local itemId = costItems[1].itemId
    local targetNum = costItems[1].itemNum
    if supportFreeRecruit and canFreeRecruit then
        self.canClick = false
        self.btnRecruitOneImg:SetMaterial(self.gray)
        self.btnRecruitTenImg:SetMaterial(self.gray)
        DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.ClickHeroRecruit, SaveGuideDoneValue)
        SFSNetwork.SendMessage(MsgDefines.LotteryHeroCard, self.curLotteryId, 0, 1,itemId)
    else
        local own = DataCenter.ItemData:GetItemCount(itemId)
        if own < targetNum then
            local lackTab = {}
            local param = {}
            param.type = ResLackType.Item
            param.id = tonumber(self.itemId)
            param.targetNum = targetNum
            table.insert(lackTab, param)
            GoToResLack.GoToItemResLackList(lackTab)
        else
            self.canClick = false
            self.btnRecruitOneImg:SetMaterial(self.gray)
            self.btnRecruitTenImg:SetMaterial(self.gray)
            DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.ClickHeroRecruit, SaveGuideDoneValue)
            SFSNetwork.SendMessage(MsgDefines.LotteryHeroCard, self.curLotteryId, 0, 0, itemId, 0)
        end
    end
end

local function OnBtnRecruitTenClick(self)
    if self.canClick==false then
        return
    end

    if self.lotteryData == nil then
        return
    end

    -- 防止连点(或者界面开启过程中被点击)
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if curTime < sendMsgTime + 1000 then
        return
    end
    sendMsgTime = curTime
    SoundUtil.PlayEffect(SoundAssets.Music_Effect_GetHero_Ten)
    local costItems = self.lotteryData:GetCostItems()
    local itemId = costItems[2].itemId
    local targetNum = costItems[2].itemNum

    local own = DataCenter.ItemData:GetItemCount(itemId)
    if own < targetNum then
        local lackTab = {}
        local param = {}
        param.type = ResLackType.Item
        param.id = tonumber(self.itemId)
        param.targetNum = targetNum
        table.insert(lackTab, param)
        GoToResLack.GoToItemResLackList(lackTab)
    else
        self.canClick = false
        self.btnRecruitOneImg:SetMaterial(self.gray)
        self.btnRecruitTenImg:SetMaterial(self.gray)
        DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.ClickHeroRecruit, SaveGuideDoneValue)
        if targetNum < 10 then
            SFSNetwork.SendMessage(MsgDefines.LotteryHeroCard, self.curLotteryId, 0, 0, itemId, targetNum)
        else
            SFSNetwork.SendMessage(MsgDefines.LotteryHeroCard, self.curLotteryId, 1, 0, itemId, 0)
        end
    end
end

---处理招募响应
local function OnHandleRecruitResponse(self, message)
    if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIHeroRecruitRewardNew)==false then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroRecruitRewardNew, self.curLotteryId, message)
    end
    self.canClick = true
    local curTime = UITimeManager:GetInstance():GetServerTime()
    sendMsgTime = curTime
    self:UpdateView()
end

---切换阵营后 左侧lotteryId发生变化 重新生成并刷新右侧view
local function OnHandleCampSwitch(self, lotteryId)
    self:GenerateTabs()

    local idx = self.currentTabIdx
    for k, v in pairs(self.dataList) do
        if v.id == lotteryId then
            idx = k
            break
        end
    end
    
    self:OnSwitchTab(idx, true)
end

local function OnDataUpdate(self)
    local allData = self.ctrl:GetNewLotteryList()
    local isChange = false
    if self.dataList == nil or allData == nil or table.count(self.dataList) ~= table.count(allData) then
        isChange = true
    else
        local index = 1
        local total = table.count(self.dataList)
        while index <= total do
            if allData[index].id ~= self.dataList[index].id then
                isChange = true
                break
            else
                if allData[index].dailyFree ~= self.dataList[index].dailyFree then
                    isChange = true
                    break
                end
                if allData[index].nextFreeTime ~= self.dataList[index].nextFreeTime then
                    isChange = true
                    break
                end
            end
            index = index + 1
        end
    end
    if isChange then
        self:OnOpen()
    end
end

local function ClosePanel(self)
    if self.closeCallBack ~= nil then
        self.closeCallBack()
    end
    self.ctrl.CloseSelf()
end

local function ResetBarPos(self)
    self.topBar:SetPosition(self.topBarPos:GetPosition())
    self.bottomBar:SetPosition(self.bottomBarPos:GetPosition())
end

local function CloseBarAni(self)
    if self.barAniSeq ~= nil then
        self.barAniSeq:Kill()
        self.barAniSeq = nil
    end
end

local function OnRateBtnClick(self)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroRecruitTip, {anim = true, isBlur = true}, self.curLotteryId)
end

local function OnLuckyBtnClick(self)
    local param = UIHeroTipsView.Param.New()
    param.title = Localization:GetString("154023")
    local lotteryData = DataCenter.LotteryDataManager:GetLotteryDataById(self.curLotteryId)
    if lotteryData and not string.IsNullOrEmpty(lotteryData.pity_hero) then
        local heroName = ""
        local vec = string.split(lotteryData.pity_hero, ";")
        if table.count(vec) > 0 then
            local vec1 = string.split(vec[1], ",")
            for k, v in ipairs(vec1) do
                local tmpName = GetTableData(HeroUtils.GetHeroXmlName(), tonumber(v), "name")
                if k > 1 then
                    heroName = heroName..", "
                end
                heroName = heroName..Localization:GetString(tmpName)
            end

        end
        param.content = Localization:GetString("154025", heroName)
    else
        param.content = Localization:GetString("154024")
    end
    param.dir = UIHeroTipsView.Direction.LEFT
    param.defWidth = 300
    param.pivot = 0.5
    param.position = self.luckyImage.transform.position + Vector3.New(-40, 0, 0)
    param.bindObject = self.gameObject
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTips, { anim = false }, param)
end

local function OnItemBarClick(self)
    local targetNum = 0
    local item = DataCenter.ItemData:GetItemById(tostring(self.itemId))
    local count = item and item.count or 0
    for i ,v in pairs(self.costItems) do
        if count < v.itemNum then
            targetNum = v.itemNum
            break
        end
    end
    local max = table.count(self.costItems)
    if targetNum == 0 then
        targetNum = self.costItems[max].itemNum
    end
    local lackTab = {}
    local param = {}
    param.type = ResLackType.Item
    param.id = tonumber(self.itemId )
    param.targetNum = targetNum
    table.insert(lackTab, param)
    GoToResLack.GoToItemResLackList(lackTab)
end

function UIHeroRecruitView:OnGoldBtnClick()
end

function UIHeroRecruitView:RefreshGold()
    self.gold_num_text:SetText(string.GetFormattedSeperatorNum(LuaEntry.Player.gold))
end

function UIHeroRecruitView:UpdateGoldSignal()
    self:RefreshGold()
end


UIHeroRecruitView.OnCreate= OnCreate
UIHeroRecruitView.OnDestroy = OnDestroy
UIHeroRecruitView.OnEnable = OnEnable
UIHeroRecruitView.OnDisable = OnDisable
UIHeroRecruitView.OnAddListener = OnAddListener
UIHeroRecruitView.OnRemoveListener = OnRemoveListener
UIHeroRecruitView.ComponentDefine = ComponentDefine
UIHeroRecruitView.ComponentDestroy = ComponentDestroy
UIHeroRecruitView.DataDefine = DataDefine
UIHeroRecruitView.DataDestroy = DataDestroy
UIHeroRecruitView.RefreshGoldNum = RefreshGoldNum

UIHeroRecruitView.OnOpen = OnOpen
UIHeroRecruitView.GenerateTabs = GenerateTabs
UIHeroRecruitView.ClearTabs = ClearTabs
UIHeroRecruitView.OnCreateCell = OnCreateCell
UIHeroRecruitView.OnDeleteCell = OnDeleteCell
UIHeroRecruitView.RefreshCellsRedPoint = RefreshCellsRedPoint
UIHeroRecruitView.OnSwitchTab = OnSwitchTab
UIHeroRecruitView.OnDataUpdate = OnDataUpdate
UIHeroRecruitView.UpdateView = UpdateView
UIHeroRecruitView.UpdateBg = UpdateBg
UIHeroRecruitView.UpdateTopItemBar = UpdateTopItemBar
UIHeroRecruitView.UpdateBottomButtons = UpdateBottomButtons
UIHeroRecruitView.UpdateGiftPackage = UpdateGiftPackage
UIHeroRecruitView.UpdateGiftPackageInfo = UpdateGiftPackageInfo
UIHeroRecruitView.DeleteTimer = DeleteTimer

UIHeroRecruitView.OnBtnInfoClick = OnBtnInfoClick
UIHeroRecruitView.OnBtnChangeCampClick = OnBtnChangeCampClick
UIHeroRecruitView.OnBtnRecruitOneClick = OnBtnRecruitOneClick
UIHeroRecruitView.OnBtnRecruitTenClick = OnBtnRecruitTenClick

UIHeroRecruitView.OnHandleRecruitResponse = OnHandleRecruitResponse
UIHeroRecruitView.OnHandleCampSwitch = OnHandleCampSwitch
UIHeroRecruitView.Update = Update

UIHeroRecruitView.UpdatePityText = UpdatePityText
UIHeroRecruitView.ClosePanel = ClosePanel
UIHeroRecruitView.UpdateHeroView = UpdateHeroView

UIHeroRecruitView.ResetBarPos = ResetBarPos
UIHeroRecruitView.CloseBarAni = CloseBarAni
UIHeroRecruitView.ClearPackageScroll = ClearPackageScroll
UIHeroRecruitView.OnPackageCreateCell = OnPackageCreateCell
UIHeroRecruitView.OnPackageDeleteCell = OnPackageDeleteCell
UIHeroRecruitView.OnPayBtnClick = OnPayBtnClick
UIHeroRecruitView.OnRateBtnClick = OnRateBtnClick
UIHeroRecruitView.OnLuckyBtnClick = OnLuckyBtnClick
UIHeroRecruitView.OnItemBarClick = OnItemBarClick

return UIHeroRecruitView
