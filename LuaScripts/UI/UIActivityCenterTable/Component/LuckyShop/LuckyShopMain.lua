---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2023/1/10 10:57
---

local LuckyShopMain = BaseClass("LuckyShopMain", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local LuckyShopItem = require "UI.UIActivityCenterTable.Component.LuckyShop.LuckyShopItem"
local UIMainResourceProgress = require "UI.UIActivityCenterTable.Component.ResourceProgressItem"
local time_path = "Root/TitleBg/Txt_Remaining"
local intro_btn_path = "Root/TitleBg/Txt_ActName/Intro/IntroImage"
local name_path = "Root/TitleBg/Txt_ActName"
local des_path = "Root/TitleBg/Txt_ActDes"

local btn_refresh_path = "Root/right/Btn_Refresh"
local btn_refresh_text_path = "Root/right/Btn_Refresh/Txt_Refresh"

local btn_refresh_free_path = "Root/right/Btn_Free_Refresh"
local btn_refresh_free_text_path = "Root/right/Btn_Free_Refresh/Txt_Free_Refresh"

local btn_add_path = "Root/right/addBg/Btn_Add"
local btn_add_item_icon_path = "Root/right/addBg/Item_Icon"
local item_num_path = "Root/right/addBg/Txt_Item_Num"
--
local discount_bg_path = "Root/right/DisCount_Off_BG"

local refresh_time_text_title = "Root/right/RefreshTime_Left_Text"

local discount_text_path = "Root/right/offBg/DisCount_Text"
local scroll_view_path = "Root/ScrollView"
local discount_off_bg_path = "Root/right/offBg"

local resource_path = "UIMainTopResourceCell"

local function OnCreate(self)
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

local function OnDestroy(self)
    self:DelCountDownTimer()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

local function ComponentDefine(self)
    self.time = self:AddComponent(UIText, time_path)
    self.nameText = self:AddComponent(UIText, name_path)
    self.desText = self:AddComponent(UIText, des_path)

    self.infoBtnN = self:AddComponent(UIButton, intro_btn_path)
    self.infoBtnN:SetOnClick(function()
        self:OnClickInfoBtn()
    end)

    self.refreshBtn = self:AddComponent(UIButton, btn_refresh_path)
    self.refreshBtnText = self:AddComponent(UIText, btn_refresh_text_path)
    self.refreshBtnText:SetLocalText(320590)
    self.refreshBtn:SetOnClick(function()
        self:OnClickRefreshBtn()
    end)

    self.refreshFreeBtn = self:AddComponent(UIButton, btn_refresh_free_path)
    self.refreshFreeBtnText = self:AddComponent(UIText, btn_refresh_free_text_path)
    self.refreshFreeBtnText:SetLocalText(320589)
    self.refreshFreeBtn:SetOnClick(function()
        self:OnClickRefreshFreeBtn()
    end)
    self.refreshFreeBtn:SetActive(false)
    self.addBtn = self:AddComponent(UIButton, btn_add_path)
    self.addBtn:SetOnClick(function()
        self:OnClickAddBtn()
    end)
    self.itemIcon = self:AddComponent(UIImage, btn_add_item_icon_path)
    self.itemNum = self:AddComponent(UIText, item_num_path)


    self.discountBG = self:AddComponent(UIImage, discount_bg_path)
    self.discountText = self:AddComponent(UIText, discount_text_path)
    self.discount_off_bg = self:AddComponent(UIBaseContainer, discount_off_bg_path)
    self.refreshTimeText = self:AddComponent(UIText, refresh_time_text_title)
    self.CountDownTimerAction = function()
        self:RefreshRemainTime()
    end
    --self.allItems = {}
    --for i = 1, 12 do
    --    local cName = "Root/Content/UILuckyShopCell_"..i
    --    local item = self:AddComponent(LuckyShopItem, cName)
    --    table.insert(self.allItems, item)
    --end
    self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
    self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
        self:OnCreateCell(itemObj, index)
    end)
    self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
        self:OnDeleteCell(itemObj, index)
    end)

    self.gold = self:AddComponent(UIMainResourceProgress, resource_path)
    local template = DataCenter.ResourceTemplateManager:GetResourceTemplate(ResourceType.Gold)
    local param = {}
    if template then
        param.iconName = string.format(LoadPath.CommonPath, template.icon)
        param.resourceType = ResourceType.Gold
        self.gold:ReInit(param)
    end
end

local function ComponentDestroy(self)
    self:ClearScroll()
    if self.flipSequence1 then
        self.flipSequence1:Pause()
        self.flipSequence1:Kill()
        self.flipSequence1 = nil
    end
    if self.discount_off_bg then
        DOTween.Kill(self.discount_off_bg.transform)
    end
    self.discount_off_bg = nil
    self.time = nil
    self.nameText = nil
    self.desText = nil
    self.infoBtnN = nil
    self.refreshBtn = nil
    self.refreshBtnText = nil
    self.refreshFreeBtn = nil
    self.refreshFreeBtnText = nil
    self.addBtn = nil
    self.itemIcon = nil
    self.itemNum = nil
    self.discountBG = nil
    self.discountText = nil
    self.discountOffText = nil
    self.refreshTimeText = nil
    self.refreshTimeText = nil
    --self.allItems = {}
end

local function DataDefine(self)
    self.activityId = nil
    self.activityData = nil
    self.dataList = {}
end

local function DataDestroy(self)
    self.activityId = nil
    self.activityData = nil
    self.dataList = {}
end

local function OnAddListener(self)
    base.OnAddListener(self)
    self:AddUIListener(EventId.LuckShopDataUpdate, self.RefreshAll)
    self:AddUIListener(EventId.LuckShopRefresh, self.ShowRefreshEffect)
    self:AddUIListener(EventId.OnPackageInfoUpdated, self.RefreshAll)
end

local function OnRemoveListener(self)
    self:RemoveUIListener(EventId.LuckShopRefresh, self.ShowRefreshEffect)
    self:RemoveUIListener(EventId.LuckShopDataUpdate, self.RefreshAll)
    self:RemoveUIListener(EventId.OnPackageInfoUpdated, self.RefreshAll)

    base.OnRemoveListener(self)
end

local function SetData(self, activityId)
    self.activityId = activityId
    if not self.activityId then
        return
    end
    self.activityData = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
    self:RefreshAll()
    DataCenter.LuckyShopManager:SetIsNew()
end

local function RefreshAll(self)
    self.nameText:SetText(Localization:GetString(self.activityData.name))
    self.desText:SetLocalText(320587)
    --local startT = UITimeManager:GetInstance():TimeStampToDayForLocal(self.activityData.startTime)
    --local endT = UITimeManager:GetInstance():TimeStampToDayForLocal(self.activityData.endTime)
    --self.activityTimeN:SetText(startT .. "-" .. endT)
    self:AddCountDownTimer()
    self:RefreshRemainTime()

    self:ShowCells()
    self:ShowItem()
    self:ShowDisCount()
    self.gold:Refresh()
end

local function ShowItem(self)
    local data = DataCenter.LuckyShopManager:GetShopInfo()
    if data == nil then
        return
    end
    self.itemIcon:LoadSprite(DataCenter.ItemTemplateManager:GetIconPath(data.refreshGoodsId))
    local count = DataCenter.ItemData:GetItemCount(data.refreshGoodsId)
    self.itemNum:SetText(count.."/1")
end

local function ShowDisCount(self)
    local data = DataCenter.LuckyShopManager:GetShopInfo()
    if data == nil then
        return
    end
    if data.shopArr == nil or table.count(data.shopArr)  == 0 then
        self.discountText:SetText("")
        self.discountBG:SetActive(true)
    else
        self.discountBG:SetActive(false)
        if Localization:GetLanguage() == Language.ChineseSimplified or Localization:GetLanguage() == Language.ChineseTraditional then
            self.discountText:SetLocalText(320593, (100 - data.discount) / 10)
        else
            self.discountText:SetLocalText(320594, data.discount)
        end
    end
end

local function GetListData(self)
    self.dataList = {}
    if not self.activityData then
        return
    end
    local data = DataCenter.LuckyShopManager:GetShopInfo()
    if data == nil then
        return
    end
    for k, v in ipairs(data.shopArr) do
        local para = {}
        para.isNull = false
        para.id = v.id
        para.goodsId = v.goodsId
        para.goodsNum = v.goodsNum
        para.costType = v.costType
        para.costId = v.costId
        para.order = v.order
        para.isBuy = v:IsBuy()
        para.index = k
        para.costNum = v.costNum
        para.originalPrice = math.ceil(v.costNum * 100 / (100 - data.discount))
        para.activityId = self.activityId
        table.insert(self.dataList, para)
    end
    local count = table.count(self.dataList)
    local activity = DataCenter.LuckyShopManager:GetActivity()
    local max = 8
    if activity then
        max = toInt(activity.para3) - 1
    end
        
    for i = count, max do
        local para = {}
        para.isNull = true
        para.index = i + 1
        table.insert(self.dataList, para)
    end
end

local function ShowCells(self)
    local needAllRefresh = false
    if self.dataList == nil or table.count(self.dataList) == 0 then
        needAllRefresh = true
    end
    self:GetListData()

    if needAllRefresh then
        self:ClearScroll()
        local count = table.count(self.dataList)
        self.scroll_view:SetTotalCount(count)
        self.scroll_view:RefillCells()
    else
        local allComp = self.scroll_view:GetComponents(LuckyShopItem)
        for k, v in ipairs(allComp) do
            local index = v.data.index
            if self.dataList[index] ~= nil then
                v:SetData(self.dataList[index])
            end
        end
    end
end

local function AddCountDownTimer(self)
    if self.countDownTimer == nil then
        self.countDownTimer = TimerManager:GetInstance():GetTimer(1, self.CountDownTimerAction , self, false,false,false)
    end
    self.countDownTimer:Start()
end

local function RefreshRemainTime(self)
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local remainTime = self.activityData.endTime - curTime
    if remainTime > 0 then
        self.time:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
    else
        self.time:SetText("")
        --self:DelCountDownTimer()
    end
    local data = DataCenter.LuckyShopManager:GetShopInfo()
    if data ~= nil then
        local refreshRemainTime = data.refreshTime - curTime
        if refreshRemainTime > 0 then
            self.refreshTimeText:SetLocalText(302012, UITimeManager:GetInstance():MilliSecondToFmtString(refreshRemainTime))
        else
            if data.shopArr == nil or table.count(data.shopArr)  == 0 then
                local activity = DataCenter.LuckyShopManager:GetActivity()
                if activity ~= nil then
                    self.refreshTimeText:SetLocalText(320588, activity.para2)
                end
            else
                self.refreshTimeText:SetText("")
            end
            --self:DelCountDownTimer()
        end
    end
end

local function DelCountDownTimer(self)
    if self.countDownTimer ~= nil then
        self.countDownTimer:Stop()
        self.countDownTimer = nil
    end
end

local function OnClickInfoBtn(self)
    if self.activityData and self.activityData.story then
        UIUtil.ShowIntro(Localization:GetString(self.activityData.name), Localization:GetString("100239"), Localization:GetString("320592"))
    end
end

local function OnClickAddBtn(self)
    local data = DataCenter.LuckyShopManager:GetShopInfo()
    if data == nil or data.refreshGoodsId == 0 then
        return
    end
    
    local lackTab = {}
    local param = {}
    param.type = ResLackType.Item
    param.id = data.refreshGoodsId
    param.targetNum = 1
    table.insert(lackTab, param)
    GoToResLack.GoToItemResLackList(lackTab)
end

local function OnClickRefreshBtn(self)
    local data = DataCenter.LuckyShopManager:GetShopInfo()
    if data == nil then
        return
    end
    local count = DataCenter.ItemData:GetItemCount(data.refreshGoodsId)
    if count <= 0 then
        self:OnClickAddBtn()
    else
        if not DataCenter.LuckyShopManager:IsAllItemBuy() then
            local needShow = DataCenter.SecondConfirmManager:GetTodayCanShowSecondConfirm(TodayNoSecondConfirmType.LuckyShopRefresh)
            if needShow then
                UIUtil.ShowSecondMessage("", Localization:GetString("320591"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
                    DataCenter.LuckyShopManager:RefreshShop(self.activityId)
                end, function(needSellConfirm)
                    DataCenter.SecondConfirmManager:SetTodayNoShowSecondConfirm(TodayNoSecondConfirmType.LuckyShopRefresh, not needSellConfirm)
                end, nil,function()
                end,nil,Localization:GetString(GameDialogDefine.TODAY_NO_SHOW), nil, nil, nil)
            else
                DataCenter.LuckyShopManager:RefreshShop(self.activityId)
            end
            return
        end
        DataCenter.LuckyShopManager:RefreshShop(self.activityId)
    end
end

local function OnClickRefreshFreeBtn(self)
    local data = DataCenter.LuckyShopManager:GetShopInfo()
    if data == nil then
        return
    end
    local count = DataCenter.ItemData:GetItemCount(data.refreshGoodsId)
    if count <= 0 then
        self:OnClickAddBtn()
    end
end

local function OnCreateCell(self,itemObj, index)
    itemObj.name = tostring(index)
    local cellItem = self.scroll_view:AddComponent(LuckyShopItem, itemObj)
    local data =  self.dataList[index]
    cellItem:SetData(data)
end

local function OnDeleteCell(self,itemObj, index)
    self.scroll_view:RemoveComponent(itemObj.name, LuckyShopItem)
end

local function ClearScroll(self)
    self.scroll_view:ClearCells()
    self.scroll_view:RemoveComponents(LuckyShopItem)
end

local function ShowRefreshEffect(self)
    DOTween.Kill(self.discount_off_bg.transform)
    local sequence = CS.DG.Tweening.DOTween.Sequence()
    self.flipSequence1 = sequence
    sequence:Append(self.discount_off_bg.transform:DOScale(2, 0.2))
    sequence:Append(self.discount_off_bg.transform:DOScale(1, 0.2))
end

LuckyShopMain.ShowRefreshEffect = ShowRefreshEffect
LuckyShopMain.OnCreateCell = OnCreateCell
LuckyShopMain.OnDeleteCell = OnDeleteCell
LuckyShopMain.ClearScroll = ClearScroll
LuckyShopMain.OnCreate = OnCreate
LuckyShopMain.OnDestroy = OnDestroy
LuckyShopMain.ComponentDefine = ComponentDefine
LuckyShopMain.ComponentDestroy = ComponentDestroy
LuckyShopMain.DataDefine = DataDefine
LuckyShopMain.DataDestroy = DataDestroy
LuckyShopMain.OnAddListener = OnAddListener
LuckyShopMain.OnRemoveListener = OnRemoveListener
LuckyShopMain.OnClickRefreshBtn = OnClickRefreshBtn
LuckyShopMain.OnClickRefreshFreeBtn = OnClickRefreshFreeBtn
LuckyShopMain.SetData = SetData
LuckyShopMain.RefreshAll = RefreshAll
LuckyShopMain.ShowCells = ShowCells
LuckyShopMain.AddCountDownTimer = AddCountDownTimer
LuckyShopMain.RefreshRemainTime = RefreshRemainTime
LuckyShopMain.DelCountDownTimer = DelCountDownTimer
LuckyShopMain.GetListData = GetListData
LuckyShopMain.OnClickAddBtn = OnClickAddBtn
LuckyShopMain.OnClickInfoBtn = OnClickInfoBtn
LuckyShopMain.ShowItem = ShowItem
LuckyShopMain.ShowDisCount = ShowDisCount


return LuckyShopMain