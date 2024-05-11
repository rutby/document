---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2023/11/2 17:33
---

local UIVitaSegment = BaseClass("UIVitaSegment", UIBaseView)
local base = UIBaseView
local UIVitaSegmentItem = require "UI.UIVita.UIVitaSegment.Component.UIVitaSegmentItem"
local Localization = CS.GameEntry.Localization

local close_path = "BgBtn"
local title_path = "Bg/Title"
local time_path = "Bg/TimeBg/Time"
local cur_item_path = "Bg/CurItem"
local scroll_view_path = "Bg/ScrollView"

local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
end

local function OnDestroy(self)
    self:DataDestroy()
    self:ComponentDestroy()
    base.OnDestroy(self)
end

local function OnEnable(self)
    base.OnEnable(self)
    self:ReInit()
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function ComponentDefine(self)
    self.close_btn = self:AddComponent(UIButton, close_path)
    self.close_btn:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)
    self.title_text = self:AddComponent(UITextMeshProUGUIEx, title_path)
    self.title_text:SetLocalText(430199)
    self.time_text = self:AddComponent(UITextMeshProUGUIEx, time_path)
    self.cur_item = self:AddComponent(UIVitaSegmentItem, cur_item_path)
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
    self.timer = TimerManager:GetInstance():GetTimer(VitaDefines.RefreshInterval, self.TimerAction, self, false, false, false)
    self.timer:Start()
    self:TimerAction()
end

local function DataDestroy(self)
    if self.timer then
        self.timer:Stop()
        self.timer = nil
    end
end

local function OnAddListener(self)
    base.OnAddListener(self)
    self:AddUIListener(EventId.VitaDayNightChange, self.OnDayNightChange)
end

local function OnRemoveListener(self)
    self:RemoveUIListener(EventId.VitaDayNightChange, self.OnDayNightChange)
    base.OnRemoveListener(self)
end

local function OnCreateCell(self, itemObj, index)
    itemObj.name = tostring(index)
    local item = self.scroll_view:AddComponent(UIVitaSegmentItem, itemObj)
    item:SetData(self.dayNightList[index])
end

local function OnDeleteCell(self, itemObj, index)
    self.scroll_view:RemoveComponent(itemObj.name, UIVitaSegmentItem)
end

local function ShowScroll(self)
    local count = #self.dayNightList
    if count > 0 then
        self.scroll_view:SetActive(true)
        self.scroll_view:SetTotalCount(count)
        self.scroll_view:RefillCells()
    else
        self.scroll_view:SetActive(false)
    end
end

local function ReInit(self)
    self:Refresh()
end

local function Refresh(self)
    self.dayNightList = {}
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local curDayNight = DataCenter.VitaManager:GetDayNight(curTime)
    self.cur_item:SetData(curDayNight)
    local dayNight = VitaUtil.GetNextDayNight(curDayNight)
    while dayNight ~= curDayNight do
        table.insert(self.dayNightList, dayNight)
        dayNight = VitaUtil.GetNextDayNight(dayNight)
    end
    self:ShowScroll()
    self:TimerAction()
end

local function TimerAction(self)
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local vitaTime = VitaUtil.RealTimeToVita(curTime)
    self.time_text:SetText(VitaUtil.VitaTimeToStringHM(vitaTime))
end

local function OnDayNightChange(self)
    self:Refresh()
end

UIVitaSegment.OnCreate = OnCreate
UIVitaSegment.OnDestroy = OnDestroy
UIVitaSegment.OnEnable = OnEnable
UIVitaSegment.OnDisable = OnDisable
UIVitaSegment.ComponentDefine = ComponentDefine
UIVitaSegment.ComponentDestroy = ComponentDestroy
UIVitaSegment.DataDefine = DataDefine
UIVitaSegment.DataDestroy = DataDestroy
UIVitaSegment.OnAddListener = OnAddListener
UIVitaSegment.OnRemoveListener = OnRemoveListener

UIVitaSegment.OnCreateCell = OnCreateCell
UIVitaSegment.OnDeleteCell = OnDeleteCell
UIVitaSegment.ShowScroll = ShowScroll

UIVitaSegment.ReInit = ReInit
UIVitaSegment.Refresh = Refresh
UIVitaSegment.TimerAction = TimerAction

UIVitaSegment.OnDayNightChange = OnDayNightChange

return UIVitaSegment