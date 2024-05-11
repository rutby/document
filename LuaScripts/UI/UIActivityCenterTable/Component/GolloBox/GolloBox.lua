---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2023/5/30 17:32
---

local GolloBox = BaseClass("GolloBox", UIBaseView)
local base = UIBaseView
local GolloBoxJump = require "UI.UIActivityCenterTable.Component.GolloBox.GolloBoxJump"
local GolloBoxUse = require "UI.UIActivityCenterTable.Component.GolloBox.GolloBoxUse"
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray

local title_path = "Panel/Title"
local info_path = "Panel/Title/Info"
local date_path = "Panel/Date"
local time_path = "Panel/Time"
local tip_path = "Panel/Time/Tip"
local jump_path = "Panel/Jumps/Jump%s"
local have_desc_path = "Panel/HaveDesc"
local have_path = "Panel/Have"
local use_btn_path = "Panel/Use"
local use_text_path = "Panel/Use/UseText"
local sell_btn_path = "Panel/Sell"
local sell_text_path = "Panel/Sell/SellText"
local use_path = "GolloBoxUse"

local JUMP_COUNT = 4

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
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function ComponentDefine(self)
    self.title_text = self:AddComponent(UIText, title_path)
    self.info_btn = self:AddComponent(UIButton, info_path)
    self.info_btn:SetOnClick(function()
        self:OnInfoClick()
    end)
    self.date_text = self:AddComponent(UIText, date_path)
    self.time_text = self:AddComponent(UIText, time_path)
    self.tip_text = self:AddComponent(UIText, tip_path)
    self.jumps = {}
    for i = 1, JUMP_COUNT do
        self.jumps[i] = self:AddComponent(GolloBoxJump, string.format(jump_path, i))
    end
    self.have_desc_text = self:AddComponent(UIText, have_desc_path)
    self.have_desc_text:SetLocalText(100100)
    self.have_text = self:AddComponent(UIText, have_path)
    self.use_btn = self:AddComponent(UIButton, use_btn_path)
    self.use_btn:SetOnClick(function()
        self:OnUseClick()
    end)
    self.use_text = self:AddComponent(UIText, use_text_path)
    self.use_text:SetLocalText(110046)
    self.sell_btn = self:AddComponent(UIButton, sell_btn_path)
    self.sell_btn:SetOnClick(function()
        self:OnSellClick()
    end)
    self.sell_text = self:AddComponent(UIText, sell_text_path)
    self.sell_text:SetLocalText(110081)
    self.use = self:AddComponent(GolloBoxUse, use_path)
end

local function ComponentDestroy(self)

end

local function DataDefine(self)
    self.timer = TimerManager:GetInstance():GetTimer(1, self.TimerAction, self, false, false, false)
    self.timer:Start()
end

local function DataDestroy(self)
    if self.timer then
        self.timer:Stop()
        self.timer = nil
    end
end

local function OnAddListener(self)
    base.OnAddListener(self)
end

local function OnRemoveListener(self)
    base.OnRemoveListener(self)
end

local function GetDataListInternal(self)
    local dataList = {}
    
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local isEnd = curTime > self.actData.endTime
    local curs, maxes = {}, {}
    local para1s = string.split(self.actData.para1, "|")
    for _, para in ipairs(para1s) do
        local spls = string.split(para, ";")
        if #spls == 2 then
            local group = tonumber(spls[1]) or 0
            local cur = 0
            local key = GolloBoxItemId .. "_" .. group
            local info = DataCenter.ActivityListDataManager:GetRewardControlInfo(key)
            if info then
                cur = info:GetCount()
            end
            table.insert(curs, cur)

            local max = tonumber(spls[2]) or 0
            table.insert(maxes, max)
        end
    end
    
    -- 采集资源
    table.insert(dataList, {
        name = Localization:GetString("121242"),
        desc = Localization:GetString("372961", curs[2], maxes[2]),
        onClick = function()
            GoToUtil.GotoWorldResource(14)
        end,
        isEnd = isEnd,
        cur = curs[2],
        max = maxes[2],
    })
    
    -- 占领地块
    table.insert(dataList, {
        name = Localization:GetString("140090"),
        desc = Localization:GetString("372963", curs[3], maxes[3]),
        onClick = function()
            GoToUtil.GoSeasonDesertMaxLv("")
        end,
        isEnd = isEnd,
        cur = curs[3],
        max = maxes[3],
    })
    
    -- 击败敌军
    table.insert(dataList, {
        name = Localization:GetString("370030"),
        desc = Localization:GetString("372964", curs[4], maxes[4]),
        onClick = function()
            GoToUtil.GotoOpenView(UIWindowNames.UISearch, UISearchType.Monster, DataCenter.MonsterManager:GetCurCanAttackMaxLevel())
        end,
        isEnd = isEnd,
        cur = curs[4],
        max = maxes[4],
    })
    
    return dataList
end

local function SetData(self, actId)
    self.actData = DataCenter.ActivityListDataManager:GetActivityDataById(actId)
    
    self.title_text:SetLocalText(self.actData.name)
    
    local startDay = UITimeManager:GetInstance():TimeStampToDayForLocal(self.actData.startTime + 1000)
    local endDay = UITimeManager:GetInstance():TimeStampToDayForLocal(self.actData.endTime - 1000)
    self.date_text:SetText(startDay .. " - " .. endDay)
    
    local curTime = UITimeManager:GetInstance():GetServerTime()
    self.tip_text:SetLocalText(self.actData.desc_info)
    self.tip_text:SetActive(curTime > self.actData.endTime)
    
    self:Refresh()
    self:TimerAction()
end

local function Refresh(self)
    local count = 0
    self.have_text:SetText(count)
    if count > 0 then
      
        UIGray.SetGray(self.use_btn.transform, false, true)
        UIGray.SetGray(self.sell_btn.transform, false, true)
    else
      
        UIGray.SetGray(self.use_btn.transform, true, true)
        UIGray.SetGray(self.sell_btn.transform, true, true)
    end
    
    local dataList = self:GetDataListInternal()
    for i = 1, JUMP_COUNT do
        self.jumps[i]:SetData(dataList[i])
    end
    self.use:Hide()
end

local function TimerAction(self)
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local restTime = self.actData.endTime - curTime
    if restTime < 0 then
        restTime = self.actData.extraEndTime - curTime
    end
    if restTime < 0 then
        self.time_text:SetActive(false)
    else
        self.time_text:SetActive(true)
        self.time_text:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(restTime))
    end
end

local function OnInfoClick(self)
    UIUtil.ShowIntro(Localization:GetString(self.actData.name), Localization:GetString("100239"), Localization:GetString(self.actData.story))
end

local function OnUseClick(self)
    local count = 0
    if count > 0 then
        self.use:Refresh()
        self.use:Show()
    else
        UIUtil.ShowTipsId(120021)
    end
end

local function OnSellClick(self)
    local count = 0
    if count > 0 then
    else
        UIUtil.ShowTipsId(120021)
    end
end

GolloBox.OnCreate = OnCreate
GolloBox.OnDestroy = OnDestroy
GolloBox.OnEnable = OnEnable
GolloBox.OnDisable = OnDisable
GolloBox.ComponentDefine = ComponentDefine
GolloBox.ComponentDestroy = ComponentDestroy
GolloBox.DataDefine = DataDefine
GolloBox.DataDestroy = DataDestroy
GolloBox.OnAddListener = OnAddListener
GolloBox.OnRemoveListener = OnRemoveListener

GolloBox.OnCellMoveIn = OnCellMoveIn
GolloBox.OnCellMoveOut = OnCellMoveOut
GolloBox.ShowScroll = ShowScroll
GolloBox.ClearScroll = ClearScroll

GolloBox.GetDataListInternal = GetDataListInternal
GolloBox.SetData = SetData
GolloBox.Refresh = Refresh
GolloBox.TimerAction = TimerAction
GolloBox.OnInfoClick = OnInfoClick
GolloBox.OnUseClick = OnUseClick
GolloBox.OnSellClick = OnSellClick

return GolloBox