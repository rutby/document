---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2023/3/1 11:44
---

local UIGloryPeriod = BaseClass("UIGloryPeriod", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

local return_path = "UICommonMiniPopUpTitle/panel"
local close_path = "UICommonMiniPopUpTitle/Bg_mid/CloseBtn"
local title_path = "UICommonMiniPopUpTitle/Bg_mid/titleText"
local icon_path = "Icon"
local time_path = "Time"
local not_open_path = "NotOpen"
local scroll_view_path = "ScrollView"
local bottom_desc_path = "BottomDesc"
local go_btn_path = "Go"
local go_text_path = "Go/GoText"
local left_path = "Left"
local right_path = "Right"

local PeriodList = { GloryPeriod.Prepare, GloryPeriod.Start, GloryPeriod.Settle }

local function OnCreate(self)
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

local function OnDestroy(self)
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

local function OnEnable(self)
    base.OnEnable(self)
    self:ReInit()
end

local function OnDisable(self)
    if self.timer then
        self.timer:Stop()
        self.timer = nil
    end
    base.OnDisable(self)
end

local function ComponentDefine(self)
    self.return_btn = self:AddComponent(UIButton, return_path)
    self.return_btn:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)
    self.close_btn = self:AddComponent(UIButton, close_path)
    self.close_btn:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)
    self.title_text = self:AddComponent(UITextMeshProUGUIEx, title_path)
    self.icon_image = self:AddComponent(UIImage, icon_path)
    self.time_text = self:AddComponent(UIText, time_path)
    self.not_open_text = self:AddComponent(UIText, not_open_path)
    self.not_open_text:SetLocalText(302109)
    self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
    self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
        self:OnCreateCell(itemObj, index)
    end)
    self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
        self:OnDeleteCell(itemObj, index)
    end)
    self.bottom_desc_text = self:AddComponent(UIText, bottom_desc_path)
    self.go_btn = self:AddComponent(UIButton, go_btn_path)
    self.go_btn:SetOnClick(function()
        self:OnGoClick()
    end)
    self.go_text = self:AddComponent(UIText, go_text_path)
    self.go_text:SetLocalText(302798)
    self.left_btn = self:AddComponent(UIButton, left_path)
    self.left_btn:SetOnClick(function()
        self:OnLeftClick()
    end)
    self.right_btn = self:AddComponent(UIButton, right_path)
    self.right_btn:SetOnClick(function()
        self:OnRightClick()
    end)
end

local function ComponentDestroy(self)
    self.return_btn = nil
    self.close_btn = nil
    self.title_text = nil
    self.icon_image = nil
    self.time_text = nil
    self.not_open_text = nil
    self.scroll_view = nil
    self.bottom_desc_text = nil
    self.go_btn = nil
    self.go_text = nil
    self.left_btn = nil
    self.right_btn = nil
end

local function DataDefine(self)
    self.timer = nil
    self.pagePeriod = GloryPeriod.None
    self.period = GloryPeriod.None
    self.switchTime = nil
    self.descList = {}
end

local function DataDestroy(self)
    if self.timer then
        self.timer:Stop()
        self.timer = nil
    end
    self.period = nil
    self.switchTime = nil
    self.descList = nil
end

local function OnAddListener(self)
    base.OnAddListener(self)
end

local function OnRemoveListener(self)
    base.OnRemoveListener(self)
end

local function OnCreateCell(self, itemObj, index)
    itemObj.name = tostring(index)
    local text = self.scroll_view:AddComponent(UIText, itemObj)
    text:SetLocalText(self.descList[index])
end

local function OnDeleteCell(self, itemObj, index)
    self.scroll_view:RemoveComponent(itemObj.name, UIText)
end

local function ShowScroll(self)
    local count = #self.descList
    if count > 0 then
        self.scroll_view:SetTotalCount(count)
        self.scroll_view:RefillCells()
    end
end

local function ReInit(self)
    self.pagePeriod = self:GetUserData()
    self:Refresh()
end

local function Refresh(self)
    self.period, self.switchTime = DataCenter.GloryManager:GetPeriod()
    
    self.title_text:SetText(DataCenter.GloryManager:GetPeriodName(self.pagePeriod))
    self.icon_image:LoadSprite(string.format(LoadPath.UIGlory, "gloryleague_period_" .. self.pagePeriod))
    
    local bottomText = DataCenter.GloryManager:GetGroupServerIdDesc()
    if self.pagePeriod == GloryPeriod.Prepare or self.pagePeriod == GloryPeriod.Start then
        bottomText = DataCenter.GloryManager:GetOpenWeekDayDesc(self.pagePeriod) .. "\n" .. bottomText
    end
    self.bottom_desc_text:SetText(bottomText)
    
    local useTimer = false
    if self.pagePeriod == self.period then
        if self.pagePeriod == GloryPeriod.Prepare or self.pagePeriod == GloryPeriod.Start then
            self.time_text:SetActive(true)
            self.not_open_text:SetActive(false)
            useTimer = true
        else
            self.time_text:SetActive(false)
            self.not_open_text:SetActive(false)
        end
    else
        self.time_text:SetActive(false)
        self.not_open_text:SetActive(true)
    end

    if useTimer and self.timer == nil then
        self.timer = TimerManager:GetInstance():GetTimer(1, self.TimerAction, self, false, false, false)
        self.timer:Start()
        self:TimerAction()
    elseif not useTimer and self.timer ~= nil then
        self.timer:Stop()
        self.timer = nil
    end

    local serverId = LuaEntry.Player:GetSelfServerId()
    local season = DataCenter.SeasonDataManager:GetSeason() or 0
    local template = DataCenter.SeasonGroupManager:GetTemplate(season, serverId)
    if template then
        local index = table.indexof(PeriodList, self.pagePeriod)
        self.descList = template.stageDis[index] or {}
        self:ShowScroll()
    end
end

local function TimerAction(self)
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if self.switchTime >= curTime then
        local restTime = math.floor(self.switchTime - curTime)
        local restTimeStr = CS.GameEntry.Timer:MilliSecondToFmtString(restTime)
        self.time_text:SetText(restTimeStr)
    else
        self.timer:Stop()
        self.timer = nil
        self:Refresh()
    end
end

local function OnGoClick(self)
    self.ctrl:CloseSelf()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIGloryGroup)
end

local function OnLeftClick(self)
    local index = table.indexof(PeriodList, self.pagePeriod)
    index = (index - 2) % #PeriodList + 1
    self.pagePeriod = PeriodList[index]
    self:Refresh()
end

local function OnRightClick(self)
    local index = table.indexof(PeriodList, self.pagePeriod)
    index = index % #PeriodList + 1
    self.pagePeriod = PeriodList[index]
    self:Refresh()
end

UIGloryPeriod.OnCreate = OnCreate
UIGloryPeriod.OnDestroy = OnDestroy
UIGloryPeriod.OnEnable = OnEnable
UIGloryPeriod.OnDisable = OnDisable
UIGloryPeriod.ComponentDefine = ComponentDefine
UIGloryPeriod.ComponentDestroy = ComponentDestroy
UIGloryPeriod.DataDefine = DataDefine
UIGloryPeriod.DataDestroy = DataDestroy
UIGloryPeriod.OnAddListener = OnAddListener
UIGloryPeriod.OnRemoveListener = OnRemoveListener

UIGloryPeriod.OnCreateCell = OnCreateCell
UIGloryPeriod.OnDeleteCell = OnDeleteCell
UIGloryPeriod.ShowScroll = ShowScroll

UIGloryPeriod.ReInit = ReInit
UIGloryPeriod.Refresh = Refresh
UIGloryPeriod.TimerAction = TimerAction
UIGloryPeriod.OnGoClick = OnGoClick
UIGloryPeriod.OnLeftClick = OnLeftClick
UIGloryPeriod.OnRightClick = OnRightClick

return UIGloryPeriod