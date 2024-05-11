---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2023/8/3 15:10
---

local UIEdenKill = BaseClass("UIEdenKill", UIBaseContainer)
local base = UIBaseContainer
local UIEdenKillRank = require "UI.UIEdenKill.UIEdenKillRank"
local UIEdenKillRule = require "UI.UIEdenKill.UIEdenKillRule"
local UIEdenKillReward = require "UI.UIEdenKill.UIEdenKillReward"
local Localization = CS.GameEntry.Localization

local title_path = "Root/Title"
local info_path = "Root/Title/Info"
local date_path = "Root/Date"
local tab_path = "Root/Tab%s"
local tab_on_text_path = "Root/Tab%s/TabTextOn%s"
local tab_off_text_path = "Root/Tab%s/TabTextOff%s"
local rank_path = "Root/UIEdenKillRank"
local rule_path = "Root/UIEdenKillRule"
local reward_path = "Root/UIEdenKillReward"

local TabCount = 3

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
    self.tab_btns = {}
    self.tab_on_texts = {}
    self.tab_off_texts = {}
    for i = 1, TabCount do
        self.tab_btns[i] = self:AddComponent(UIButton, string.format(tab_path, i))
        self.tab_btns[i]:SetOnClick(function()
            self:OnTabClick(i)
        end)
        self.tab_on_texts[i] = self:AddComponent(UIText, string.format(tab_on_text_path, i, i))
        self.tab_off_texts[i] = self:AddComponent(UIText, string.format(tab_off_text_path, i, i))
    end
    self.tab_on_texts[1]:SetLocalText(361055)
    self.tab_off_texts[1]:SetLocalText(361055)
    self.tab_on_texts[2]:SetLocalText(373160)
    self.tab_off_texts[2]:SetLocalText(373160)
    self.tab_on_texts[3]:SetLocalText(372615)
    self.tab_off_texts[3]:SetLocalText(372615)
    self.rank = self:AddComponent(UIEdenKillRank, rank_path)
    self.rule = self:AddComponent(UIEdenKillRule, rule_path)
    self.reward = self:AddComponent(UIEdenKillReward, reward_path)
end

local function ComponentDestroy(self)
    
end

local function DataDefine(self)
    self.tabIndex = 0
end

local function DataDestroy(self)
    
end

local function OnAddListener(self)
    base.OnAddListener(self)
end

local function OnRemoveListener(self)
    base.OnRemoveListener(self)
end

local function SetData(self, actId)
    self.actId = actId
    self.actData = DataCenter.ActivityListDataManager:GetActivityDataById(actId)
    self.title_text:SetLocalText(self.actData.name)
    local startDay = UITimeManager:GetInstance():TimeStampToDayForLocal(self.actData.startTime + 1000)
    local endDay = UITimeManager:GetInstance():TimeStampToDayForLocal(self.actData.endTime - 1000)
    self.date_text:SetText(startDay .. " - " .. endDay)
    self.tabIndex = 0
    self:OnTabClick(1)
end

local function OnTabClick(self, i)
    if self.tabIndex == i then
        return
    end
    self.tabIndex = i
    for j = 1, TabCount do
        self.tab_btns[j]:LoadSprite(string.format(LoadPath.CommonNewPath, i == j and "Common_btn_tab_open" or "Common_btn_tab_close"))
        self.tab_on_texts[j]:SetActive(i == j)
        self.tab_off_texts[j]:SetActive(i ~= j)
    end
    self.rank:SetActive(i == 1)
    self.rule:SetActive(i == 2)
    self.reward:SetActive(i == 3)
    if i == 1 then
        self.rank:Refresh(self.actId)
    elseif i == 2 then
        self.rule:Refresh(self.actId)
    elseif i == 3 then
        self.reward:Refresh(self.actId)
    end
end

local function OnInfoClick(self)
    UIUtil.ShowIntro(Localization:GetString("100239"), "", Localization:GetString(self.actData.story))
end

UIEdenKill.OnCreate = OnCreate
UIEdenKill.OnDestroy = OnDestroy
UIEdenKill.OnEnable = OnEnable
UIEdenKill.OnDisable = OnDisable
UIEdenKill.ComponentDefine = ComponentDefine
UIEdenKill.ComponentDestroy = ComponentDestroy
UIEdenKill.DataDefine = DataDefine
UIEdenKill.DataDestroy = DataDestroy
UIEdenKill.OnAddListener = OnAddListener
UIEdenKill.OnRemoveListener = OnRemoveListener

UIEdenKill.SetData = SetData
UIEdenKill.OnTabClick = OnTabClick
UIEdenKill.OnInfoClick = OnInfoClick

return UIEdenKill