---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by mac.
--- DateTime: 8/2/21 3:40 PM
---
---任务页面
local ActivityOverviewMain = BaseClass("ActivityOverviewMain", UIBaseContainer)
local base = UIBaseContainer

local ActivityOverviewItem = require "UI.UIActivityOverview.Component.ActivityOverviewItem"

local content_path = "ScrollView/Content"
local svList_path = "ScrollView"
local animMask_path = "animMask"

-- 创建
local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
end

-- 销毁
local function OnDestroy(self)
    if self.delayTime then
        self.delayTime:Stop()
        self.delayTime = nil
    end
    self:SetAllCellDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

-- 显示
local function OnEnable(self)
    base.OnEnable(self)
    DataCenter.DailyActivityManager:UpdateActViewHistory(10)
end

-- 隐藏
local function OnDisable(self)
    if self.delayTime then
        self.delayTime:Stop()
        self.delayTime = nil
    end
    base.OnDisable(self)
end

--控件的定义
local function ComponentDefine(self)
    self.listGO = {}
    self.contentN = self:AddComponent(HorizontalInfinityScrollView, content_path)
    self.svListN = self:AddComponent(UIBaseContainer, svList_path)
    self.animMask = self:AddComponent(UIBaseContainer, animMask_path)
    self.animMask:SetActive(true)
    
    self.playingAnim = true
    TimerManager:GetInstance():DelayInvoke(function()
        self.playingAnim = false
        self.animMask:SetActive(false)
    end, 0.4)
end

--控件的销毁
local function ComponentDestroy(self)
    self.contentN = nil
    self.svListN = nil
end

--变量的定义
local function DataDefine(self)
    self.actOverviewList = {}
    self.playingAnim = true
end

--变量的销毁
local function DataDestroy(self)
    self.actOverviewList = nil
    self.playingAnim = nil
end

local function OnInitScroll(self,go,index)
    local item = self.svListN:AddComponent(ActivityOverviewItem, go)
    self.listGO[go] = item
end

local function OnUpdateScroll(self,go,index)
    local tempSummary = self.actOverviewList[index + 1]
    local cellItem = self.listGO[go]
    local animIndex = self.playingAnim and index or nil
    cellItem:ReInit(tempSummary, animIndex)
end

local function OnDestroyScrollItem(self,go, index)
    
end

local function SetAllCellDestroy(self)
    self.svListN:RemoveComponents(ActivityOverviewItem)
    self.contentN:DestroyChildNode()
end

-- 全部刷新
local function ReInit(self,arrowType)
    self:SetAllCellDestroy()
    local bindFunc1 = BindCallback(self, self.OnInitScroll)
    local bindFunc2 = BindCallback(self, self.OnUpdateScroll)
    local bindFunc3 = BindCallback(self, self.OnDestroyScrollItem)
    self.contentN:Init(bindFunc1,bindFunc2, bindFunc3)
    local tempList = DataCenter.DailyActivityManager:GetActivityOverviewList()
    self.actOverviewList = {}
    for i, v in ipairs(tempList) do
        table.insert(self.actOverviewList, v)
    end
    local tempCount = table.count(self.actOverviewList)
    self.contentN:SetItemCount(tempCount)
    local moveToIndex = self:GetTargetIndex(arrowType)
    self.contentN:MoveItemByIndex(moveToIndex - 1)
    if moveToIndex == 1 then
        if arrowType and arrowType ~= 0 then
            self.delayTime = TimerManager:GetInstance():DelayInvoke(function()
                if self.listGO and next(self.listGO) then
                    for i ,v in pairs(self.listGO) do
                        local pos = v:CheckTypeObj(arrowType)
                        if pos then
                            local scaleFactor = UIManager:GetInstance():GetScaleFactor()
                            local param = {}
                            param.position = pos
                            param.position.x = param.position.x + 70 * scaleFactor   --自己的宽高
                            --param.position.y = param.position.y + 110 * scaleFactor
                            param.arrowType = ArrowType.Normal
                            param.positionType = PositionType.Screen
                            --param.isPanel = false
                            param.isReversal = true
                            param.YisReversal = true
                            DataCenter.ArrowManager:ShowArrow(param)
                            break
                        end
                    end
                end
            end, 1.2)
        end
    end
end

local function GetTargetIndex(self, arrowType)
    local moveToIndex = 1
    if arrowType ~= nil and arrowType ~= 0 then
        for i, v in ipairs(self.actOverviewList) do
            if v.type == arrowType then
                moveToIndex = i
                break
            end
        end
    else
        local hasNew, newList = DataCenter.DailyActivityManager:GetOverviewNewStatus()
        if hasNew then
            for i, v in ipairs(self.actOverviewList) do
                if v.id == newList[1].id then
                    moveToIndex = i
                    break
                end
            end
        end
    end

    --local tempAr = self.svListN.rectTransform.rect.width / self.svListN.rectTransform.rect.height
    --local tempNum = math.modf(tempAr / 1.8 * 4) - 1
    return moveToIndex
end


local function OnAddListener(self)
    base.OnAddListener(self)
    --self:AddUIListener(EventId.OnQuestRedCountChanged, self.ReInit)
end


local function OnRemoveListener(self)
    --self:RemoveUIListener(EventId.OnQuestRedCountChanged, self.ReInit)
    base.OnRemoveListener(self)
end

ActivityOverviewMain.OnCreate = OnCreate
ActivityOverviewMain.OnDestroy = OnDestroy
ActivityOverviewMain.OnEnable = OnEnable
ActivityOverviewMain.OnDisable = OnDisable
ActivityOverviewMain.ComponentDefine = ComponentDefine
ActivityOverviewMain.ComponentDestroy = ComponentDestroy
ActivityOverviewMain.DataDefine = DataDefine
ActivityOverviewMain.DataDestroy = DataDestroy
ActivityOverviewMain.ReInit = ReInit
ActivityOverviewMain.GetTargetIndex = GetTargetIndex
ActivityOverviewMain.OnAddListener = OnAddListener
ActivityOverviewMain.OnRemoveListener = OnRemoveListener
ActivityOverviewMain.SetAllCellDestroy = SetAllCellDestroy
ActivityOverviewMain.OnInitScroll = OnInitScroll
ActivityOverviewMain.OnDestroyScrollItem = OnDestroyScrollItem
ActivityOverviewMain.OnUpdateScroll =OnUpdateScroll
return ActivityOverviewMain