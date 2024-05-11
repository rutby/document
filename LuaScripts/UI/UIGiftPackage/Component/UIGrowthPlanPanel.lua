---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2022/2/14 15:46
---

local UIGrowthPlan = BaseClass("UIGrowthPlan", UIBaseContainer)
local base = UIBaseContainer
local UIGrowthPlanItem = require "UI.UIGiftPackage.Component.UIGrowthPlanItem"
local UIGiftPackagePoint = require "UI.UIGiftPackage.Component.UIGiftPackagePoint"
local Localization = CS.GameEntry.Localization

local title_path = "Root/TitleBg/Title"
local subtitle_path = "Root/TitleBg/Subtitle"
local buy_btn_path = "Root/BuyBtn"
local buy_text_path = "Root/BuyBtn/BuyText"
local scroll_view_path = "Root/ScrollView"
local infoBtn_path = "Root/TitleBg/Intro"
local point_path = "Root/BuyBtn/UIGiftPackagePoint"

local GetRewardType =
{
    None = -1,
    Normal = 0,
    Special = 1,
}

local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
end

local function OnDestroy(self)
    self:ClearScroll()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

local function OnEnable(self)
    base.OnEnable(self)

    if self.inited then
        self:ScrollToAvailableIndex()
    end
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function ComponentDefine(self)
    self.title_text = self:AddComponent(UITextMeshProUGUIEx, title_path)
    self.subtitle_text = self:AddComponent(UITextMeshProUGUIEx, subtitle_path)
    self.buy_btn = self:AddComponent(UIButton, buy_btn_path)
    self.buy_btn:SetOnClick(function()
        self:OnBuyClick()
    end)
    self.buy_text = self:AddComponent(UITextMeshProUGUIEx, buy_text_path)
    self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
    self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
        self:OnCreateCell(itemObj, index)
    end)
    self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
        self:OnDeleteCell(itemObj, index)
    end)
    self.point_rect = self:AddComponent(UIGiftPackagePoint,point_path)
    self.infoBtn = self:AddComponent(UIButton, infoBtn_path)
    self.infoBtn:SetOnClick(function()
        self:OnClickInfoBtn()
    end)
end

local function ComponentDestroy(self)
    self.title_text = nil
    self.subtitle_text = nil
    self.buy_btn = nil
    self.buy_text = nil
    self.buy_desc_text = nil
    self.scroll_view = nil
    self.point_rect = nil
end

local function DataDefine(self)
    self.view = nil
    self.packId = nil
    self.pack = nil
    self.specialUnlocked = nil -- 是否已经付费解锁下层奖励
    self.dataList = {}
    self.itemList = {}
    self.curLevel = 0
    self.curIndex = 0
    self.inited = false
end

local function DataDestroy(self)
    self.view = nil
    self.packId = nil
    self.pack = nil
    self.specialUnlocked = nil
    self.dataList = nil
    self.itemList = nil
    self.curLevel = nil
    self.curIndex = nil
    self.inited = nil
end

local function OnAddListener(self)
    base.OnAddListener(self)
    self:AddUIListener(EventId.GrowthPlanGetInfo, self.OnGetInfo)
    self:AddUIListener(EventId.GrowthPlanGetReward, self.OnGetReward)
end

local function OnRemoveListener(self)
    base.OnRemoveListener(self)
    self:RemoveUIListener(EventId.GrowthPlanGetInfo, self.OnGetInfo)
    self:RemoveUIListener(EventId.GrowthPlanGetReward, self.OnGetReward)
end

local function ShowCells(self)
    local count = #self.dataList
    if count > 0 then
        self.scroll_view:SetTotalCount(count)
        self.scroll_view:RefillCells()
    end
end

local function ClearScroll(self)
    self.cells = {}
    self.scroll_view:ClearCells()
    self.scroll_view:RemoveComponents(UIGrowthPlanItem)
end

local function OnCreateCell(self, itemObj, index)
    itemObj.name = tostring(index)
    local item = self.scroll_view:AddComponent(UIGrowthPlanItem, itemObj)

    -- data
    local data = self.dataList[index]
    data.isFirst = (index == 1)
    data.isLast = (index == #self.dataList)
    if index == 1 then
        data.pro = self.curLevel / data.needLevel
        data.showBallLeft = true
        data.lastNeedLevel = 0
        if self.curLevel < data.needLevel then
            self.curIndex = index
        end
    else
        local lastData = self.dataList[index - 1]
        data.pro = (self.curLevel - lastData.needLevel) / (data.needLevel - lastData.needLevel)
        data.showBallLeft = self.curLevel >= lastData.needLevel
        data.lastNeedLevel = lastData.needLevel
        if self.curLevel < data.needLevel and self.curLevel >= lastData.needLevel then
            self.curIndex = index
        end
    end
    data.showBallRight = self.curLevel >= data.needLevel

    item:SetData(data, self)
    item:SetOnClick(function()
        self:OnCellClick(index)
    end)
    self.itemList[index] = item
end

local function OnDeleteCell(self, itemObj, index)
    self.itemList[index] = nil
    self.scroll_view:RemoveComponent(itemObj.name, UIGrowthPlanItem)
end

local function ReInit(self, view, packId)
    self.inited = true
    self.view = view
    self.packId = packId
    self.pack = GiftPackageData.get(packId)
    self.specialUnlocked = nil
    if self.pack == nil then
        return
    end

    self.title_text:SetLocalText(tonumber(self.pack:getName()))
    self.buy_text:SetText(DataCenter.PayManager:GetDollarText(self.pack:getPrice(), self.pack:getProductID()))

    local cacheDict = WelfareController.getWelfareCache(WelfareMessageKey.GrowthPlanInfo) or {}
    if cacheDict[packId] then
        self:OnGetInfo(cacheDict[packId])
    else
        SFSNetwork.SendMessage(MsgDefines.GrowthPlanGetInfo, packId)
    end

    --积分
    self.point_rect:RefreshPoint(self.pack)

    Setting:SetPrivateString(SettingKeys.GROWTH_PLAN_VISITED .. packId, "1")
    EventManager:GetInstance():Broadcast(EventId.RefreshWelfareRedDot)
end

local function ScrollToAvailableIndex(self)
    local toIndex = 0
    
    -- 有未领取的
    for index, data in ipairs(self.dataList) do
        if self.curLevel >= data.needLevel then
            if data.specialState == 0 then
                toIndex = index
                break
            end
        end
    end

    --toIndex = toIndex - SHOW_COUNT // 2 + 1
    --toIndex = Mathf.Clamp(toIndex, 1, #self.dataList - SHOW_COUNT + 1)
    --local pos = (toIndex - 1) / #self.dataList
    --self.scroll_view:SetVerticalNormalizedPosition(pos)
    --if toIndex > 1 then
    --    TimerManager:GetInstance():DelayInvoke(function()
    --        if self.scroll_view then
    --            self.scroll_view:ScrollToCell(toIndex, 1500)
    --        end
    --    end, 0.1)
    --end
end

local function OnGetInfo(self, message)
    local packId = message["exchangeId"]
    if self.packId ~= packId then
        return
    end
    
    local specialUnlocked = (message.unlockSpecialReward == 1)
    self.specialUnlocked = specialUnlocked
    self.dataList = message.stageInfo
    self.curLevel = DataCenter.BuildManager.MainLv
    local diamond = 0
    for _, data in ipairs(self.dataList) do
        if not table.IsNullOrEmpty(data.specialReward) then
            for _, reward in ipairs(data.specialReward) do
                if reward.type == RewardType.GOLD then
                    diamond = diamond + reward.value
                end
            end
        end
    end
    
    if tonumber(self.pack:getDescription()) and self.pack:getPercent() then
        self.subtitle_text:SetLocalText(tonumber(self.pack:getDescription()), self.pack:getPercent() .. "%", diamond)
    end
    self.buy_btn:SetActive(not self.specialUnlocked)
    self:ShowCells()
    self:ScrollToAvailableIndex()

    local canReceiveCount = self:GetCanReceiveCount()
    Setting:SetPrivateInt(SettingKeys.GROWTH_PLAN_VISITED_RED .. self.packId, canReceiveCount)
    EventManager:GetInstance():Broadcast(EventId.RefreshWelfareRedDot)
end

local function GetCanReceiveCount(self)
    local canReceiveCount = 0
    
    for index, data in ipairs(self.dataList) do
        if self.curLevel >= data.needLevel then
            if data.specialState == 0 then
                canReceiveCount = canReceiveCount + 1
            end
        end
    end
    
    return canReceiveCount
end

local function OnGetReward(self, message)
    local packId = message["exchangeId"]
    if self.packId ~= packId then
        return
    end
    
    for index, data in ipairs(self.dataList) do
        if data.id == message.id then
            if message.type == GetRewardType.Special then
                data.specialState = 1
            end
            self.itemList[index]:SetData(self.dataList[index], self)
            break
        end
    end
end

local function OnCellClick(self, index)
    local data = self.dataList[index]
    local rewardType = GetRewardType.None

    if self.curLevel >= data.needLevel then
        if data.specialState == 0 then
            if self.specialUnlocked then
                rewardType = GetRewardType.Special
            end
        end
    end

    if rewardType == GetRewardType.Normal or rewardType == GetRewardType.Special then
        local param =
        {
            packId = self.packId,
            id = data.id,
            type = rewardType
        }
        SFSNetwork.SendMessage(MsgDefines.GrowthPlanGetReward, param)
    else
        local param = {}
        param.pack = self.pack
        local totalCount = 0
        for i = 1,#self.dataList do
            local curData = self.dataList[i]
            if self.curLevel >= curData.needLevel then
                local count = 0
                if type(curData.specialReward[1].value) == "table" then
                    count = tonumber(curData.specialReward[1].value.num)
                elseif type(curData.specialReward[1].value) == "number" then
                    count = tonumber(curData.specialReward[1].value)
                end
                totalCount = totalCount + count
            end
        end
        param.count = totalCount
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIGrowthPlanBuyPanel,{anim = true,isBlur = true}, param)
    end
end

-- 付费解锁下层奖励
local function OnBuyClick(self)
    if self.specialUnlocked then
        return
    end
    
    self.view.ctrl:BuyGift(self.pack)
end

local function OnClickInfoBtn()
    --UIUtil.ShowIntro(Localization:GetString("320429"), Localization:GetString("100239"),Localization:GetString("320432",maxLv))
    local name = GetTableData(DataCenter.BuildTemplateManager:GetTableName(), 400030,"name")
    UIUtil.ShowIntro(Localization:GetString("470065"), "",Localization:GetString("470066", Localization:GetString(name)))
end

UIGrowthPlan.OnCreate = OnCreate
UIGrowthPlan.OnDestroy = OnDestroy
UIGrowthPlan.OnEnable = OnEnable
UIGrowthPlan.OnDisable = OnDisable
UIGrowthPlan.ComponentDefine = ComponentDefine
UIGrowthPlan.ComponentDestroy = ComponentDestroy
UIGrowthPlan.DataDefine = DataDefine
UIGrowthPlan.DataDestroy = DataDestroy
UIGrowthPlan.OnAddListener = OnAddListener
UIGrowthPlan.OnRemoveListener = OnRemoveListener

UIGrowthPlan.ShowCells = ShowCells
UIGrowthPlan.ClearScroll = ClearScroll
UIGrowthPlan.OnCreateCell = OnCreateCell
UIGrowthPlan.OnDeleteCell = OnDeleteCell

UIGrowthPlan.ReInit = ReInit
UIGrowthPlan.ScrollToAvailableIndex = ScrollToAvailableIndex
UIGrowthPlan.OnGetInfo = OnGetInfo
UIGrowthPlan.OnGetReward = OnGetReward
UIGrowthPlan.OnCellClick = OnCellClick
UIGrowthPlan.OnBuyClick = OnBuyClick
UIGrowthPlan.OnClickInfoBtn = OnClickInfoBtn
UIGrowthPlan.GetCanReceiveCount = GetCanReceiveCount

return UIGrowthPlan