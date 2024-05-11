---
--- 任务界面
--- Created by zzl.
--- DateTime:
---

local base = UIBaseView--Variable
local UIFirstPayView = BaseClass("UIFirstPayView", base)--Variable
local Localization = CS.GameEntry.Localization
local ActivityOverviewMain = require "UI.UIActivityOverview.Component.ActivityOverviewMain"

local title_path = "safeArea/Txt_Title"
local closeBtn_path = "safeArea/closeBtn"
local closeBgBtn_path = "safeArea/closeBg"
local overviewPanel_path = "safeArea/ActivityOverview"
local time_path = "safeArea/time"

local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
    self:RefreshAll()
end

local function OnDestroy(self)
    DataCenter.DailyActivityManager:ResetNewStatus()
    EventManager:GetInstance():Broadcast(EventId.RefreshActivityRedDot)
    self:DelTimer()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

local function ComponentDefine(self)
    self.titleN = self:AddComponent(UIText, title_path)
    self.titleN:SetLocalText(372217)
    self.closeBtnN = self:AddComponent(UIButton, closeBtn_path)
    self.closeBtnN:SetOnClick(function()
        self:OnClickCloseBtn()
    end)
    self.closeBgBtnN = self:AddComponent(UIButton, closeBgBtn_path)
    self.closeBgBtnN:SetOnClick(function()
        self:OnClickCloseBtn()
    end)
    self.activityOverviewPanelN = self:AddComponent(ActivityOverviewMain, overviewPanel_path)
    self.timeN = self:AddComponent(UIText, time_path)
end

local function ComponentDestroy(self)
    self.titleN = nil
    self.closeBtnN = nil
    self.activityOverviewPanelN = nil
end

local function DataDefine(self)
    self.endTime = nil
end

local function DataDestroy(self)
    self.endTime = nil
end

local function RefreshAll(self)
    self.endTime = UITimeManager:GetInstance():GetNextDayMs()
    self:AddTimer()
    self:SetRemainTime()
    local arrowType = self:GetUserData()
    self.activityOverviewPanelN:ReInit(arrowType)
end

local function OnClickCloseBtn(self)
    self.ctrl:CloseSelf()
end


local function AddTimer(self)
    self.TimerAction = function()
        self:SetRemainTime()
    end

    if self.timer == nil then
        self.timer = TimerManager:GetInstance():GetTimer(1, self.TimerAction , self, false,false,false)
    end
    self.timer:Start()
end

local function SetRemainTime(self)
    local curTime = UITimeManager:GetInstance():GetServerTime()
    --local remainTime = self.endTime - curTime
    if self.endTime > curTime then
        self.timeN:SetText(Localization:GetString("302335") .. " " .. UITimeManager:GetInstance():TimeStampToTimeForServerSimple(curTime))
        --self.timeN:SetText(Localization:GetString("170000") .. " " .. UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
    else
        self:DelTimer()
        self:RefreshAll()
    end
end

local function DelTimer(self)
    if self.timer ~= nil then
        self.timer:Stop()
        self.timer = nil
    end
end


UIFirstPayView.OnCreate = OnCreate
UIFirstPayView.OnDestroy = OnDestroy
UIFirstPayView.ComponentDefine = ComponentDefine
UIFirstPayView.ComponentDestroy = ComponentDestroy
UIFirstPayView.DataDefine = DataDefine
UIFirstPayView.DataDestroy = DataDestroy

UIFirstPayView.RefreshAll = RefreshAll
UIFirstPayView.AddTimer = AddTimer
UIFirstPayView.SetRemainTime = SetRemainTime
UIFirstPayView.DelTimer = DelTimer
UIFirstPayView.OnClickCloseBtn = OnClickCloseBtn

return UIFirstPayView