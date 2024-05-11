--[[
    礼包Panel
--]]

local GiftPackagePagePanel = BaseClass("GiftPackagePagePanel", UIBaseView)
local base = UIBaseView
local GoldExchangeNormalLuaView = require "UI.UIGiftPackage.Component.GoldExchangeNormalLuaView"

local scroll_view_path = "ScrollView"

local function OnCreate(self)
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

local function OnDestroy(self)
    self:ClearScroll()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

local function ComponentDefine(self)
    self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
    self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
        self:OnCreateCell(itemObj, index)
    end)
    self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
        self:OnDeleteCell(itemObj, index)
    end)
end

local function ComponentDestroy(self)

end

local function DataDefine(self)
    self.dataList = {}
    self.itemList = {}
    self.param = {}
    self.targetPackageIndex = nil
    self.targetPackageId = nil
    if self.timer ~= nil then
        self.timer:Stop()
    end
    self.timer = TimerManager:GetInstance():GetTimer(1, self.TimerAction, self, false, false, false)
    self.timer:Start()
end

local function DataDestroy(self)
    self.dataList = nil
    self.itemList = nil
    self.param = nil
    self.targetPackageIndex = nil
    self.targetPackageId = nil
    if self.timer ~= nil then
        self.timer:Stop()
        self.timer = nil
    end
end

local function OnEnable(self)
    base.OnEnable(self)
end

local function OnDisable(self)
    for _, item in pairs(self.itemList) do
        if item.isAd then
            item.adInited = false
        end
    end
    base.OnDisable(self)
end

local function OnAddListener(self)
    base.OnAddListener(self)
    self:AddUIListener(EventId.WatchAdReceive, self.RefreshAdItem)
    self:AddUIListener(EventId.WatchAdFail, self.RefreshAdItem)
end

local function OnRemoveListener(self)
    self:RemoveUIListener(EventId.WatchAdReceive, self.RefreshAdItem)
    self:RemoveUIListener(EventId.WatchAdFail, self.RefreshAdItem)
    base.OnRemoveListener(self)
end

local function OnCreateCell(self, itemObj, index)
    local data = self.dataList[index]
    local item
    if data.isAd then
        itemObj.name = "Ad"
        item = self.scroll_view:AddComponent(GoldExchangeNormalLuaView, itemObj)
        item:ShowAd(false)
    else
        local id = data:getID()
        itemObj.name = id
        local needArrow = (self.targetPackageId == id)
        item = self.scroll_view:AddComponent(GoldExchangeNormalLuaView, itemObj)
        item:ReInit({ info = data })
    end
    self.itemList[index] = item
end

local function OnDeleteCell(self, itemObj, index)
    self.itemList[index] = nil
    self.scroll_view:RemoveComponent(itemObj.name, GoldExchangeNormalLuaView)
end

local function ShowScroll(self)
    local count = #self.dataList
    if count > 0 then
        self.scroll_view:SetTotalCount(count)
        self.scroll_view:RefillCells()
        TimerManager:GetInstance():DelayInvoke(function()
            for _, itemComp in pairs(self.itemList) do
                if itemComp and itemComp.param and itemComp.param.info then
                    if itemComp.param.info:getID() == self.targetPackageId then
                        itemComp:ShowArrow()
                        break
                    end
                end
            end
            self.targetPackageId = nil
        end, 0.5)
    else
        self:ClearScroll()
    end
end

local function RefreshScroll(self)
    local oldCount = #self.dataList
    self:SetDataList()
    local count = #self.dataList
    if oldCount == count then
        for i, item in pairs(self.itemList) do
            local data = self.dataList[i]
            if not data.isAd then
                item:ReInit({ info = data })
            end
        end
    else
        self:ShowScroll()
    end
end

local function ClearScroll(self)
    self.itemList = {}
    self.scroll_view:ClearCells()
    self.scroll_view:RemoveComponents(GoldExchangeNormalLuaView)
end

local function TimerAction(self)
    for _, item in pairs(self.itemList) do
        item:TimerAction()
    end
end

local function ReInit(self,param)
    self.param = param
    self:SetDataList()
    self:ShowScroll()
end

local function SetDataList(self)
    local panelType = self.param.welfareTagType
    if panelType == WelfareTagType.PackStore then
        self.dataList = GiftPackageData.GenerateDataByType(self.param.showMainType, self.param.showSubType)
        if self.param.targetPackageId then
            self.targetPackageIndex = self:GetPackageIndexById(self.dataList, self.param.targetPackageId)
            self.targetPackageId = self.param.targetPackageId
        elseif self.param.targetShowType then
            self.targetPackageIndex = self:GetTargetPackageIndex(self.dataList, self.param.targetShowType)
            self.targetPackageId = self.dataList[self.targetPackageIndex]:getID()
        end
    elseif panelType == WelfareTagType.PremiumPack then
        self.dataList = GiftPackageData.getPremiumPacks()
    else
        self.dataList = {}
    end
    -- 这个地方暂时处理一下如果有指定的礼包Id,则将指定礼包id放在最前面
    local goldExchangeId = self.param.goldExchangeId or ""
    if (not string.IsNullOrEmpty(goldExchangeId)) then
        local index = 1
        local exchangeItem = nil
        for key, eItem in pairs(self.dataList) do
            local exchangeId = eItem:getID()
            if (goldExchangeId == exchangeId) then
                index = key
                exchangeItem = eItem
                break
            end
        end
        if (index ~= 1) then
            local firstItem = self.dataList[1]
            self.dataList[1] = exchangeItem
            self.dataList[index] = firstItem
        end
    end
    if DataCenter.WatchAdManager:Enabled() and
       DataCenter.WatchAdManager:GetDataByLocation(WatchAdLocation.GiftPackage) ~= nil then
        -- 广告
        local data = {}
        data.isAd = true
        table.insert(self.dataList, 1, data)
    end
end

local function GetTargetPackageIndex(self, tempList, tempType)
    if string.IsNullOrEmpty(tempType) or #tempList == 0 then
        return
    end 
    local kvArr = string.split(tempType, ";")
    mainType, subType = kvArr[1], kvArr[2]
    for i, v in ipairs(tempList) do
        if v:isContainShowType(mainType, subType) then
            return i
        end
    end
    return 1
end

local function GetPackageIndexById(self, tempList, packId)
    if string.IsNullOrEmpty(packId) or #tempList == 0 then
        return
    end
    for i, v in ipairs(tempList) do
        if v:getID() == packId then
            return i
        end
    end
end

local function RefreshAdItem(self)
    for _, item in pairs(self.itemList) do
        if item.isAd then
            item:ShowAd(true)
        end
    end
end

GiftPackagePagePanel.OnCreate = OnCreate
GiftPackagePagePanel.OnDestroy = OnDestroy
GiftPackagePagePanel.ComponentDefine = ComponentDefine
GiftPackagePagePanel.ComponentDestroy = ComponentDestroy
GiftPackagePagePanel.DataDefine = DataDefine
GiftPackagePagePanel.DataDestroy = DataDestroy
GiftPackagePagePanel.OnEnable = OnEnable
GiftPackagePagePanel.OnDisable = OnDisable
GiftPackagePagePanel.OnAddListener = OnAddListener
GiftPackagePagePanel.OnRemoveListener = OnRemoveListener

GiftPackagePagePanel.OnCreateCell = OnCreateCell
GiftPackagePagePanel.OnDeleteCell = OnDeleteCell
GiftPackagePagePanel.ShowScroll = ShowScroll
GiftPackagePagePanel.RefreshScroll = RefreshScroll
GiftPackagePagePanel.ClearScroll = ClearScroll

GiftPackagePagePanel.TimerAction = TimerAction
GiftPackagePagePanel.ReInit = ReInit
GiftPackagePagePanel.SetDataList = SetDataList
GiftPackagePagePanel.GetTargetPackageIndex = GetTargetPackageIndex
GiftPackagePagePanel.GetPackageIndexById = GetPackageIndexById
GiftPackagePagePanel.RefreshAdItem = RefreshAdItem

return GiftPackagePagePanel