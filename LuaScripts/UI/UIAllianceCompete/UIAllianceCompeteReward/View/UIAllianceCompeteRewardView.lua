---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2021/8/23 22:01
---

local UIAllianceCompeteRewardView = BaseClass("UIAllianceCompeteRewardView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local AllianceCompetePerReward = require "UI.UIAllianceCompete.UIAllianceCompeteReward.Component.AllianceCompetePerReward"

local title_path = "UICommonMidPopUpTitle/bg_mid/titleText"
local content_path = "ScrollView/Viewport/Content"
local closeBtn_path = "UICommonMidPopUpTitle/bg_mid/CloseBtn"
local dailyReward_path = "ScrollView/Viewport/Content/DailyRewards"
local weeklyReward_path = "ScrollView/Viewport/Content/WeeklyRewards"
local maskBtn_path = "UICommonMidPopUpTitle/panel"


local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()

    self:ShowRewards()
end

local function OnDestroy(self)
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

local function OnEnable(self)
    
end

local function OnDisable(self)
    
end

local function ComponentDefine(self)
    self.closeBtnN = self:AddComponent(UIButton, closeBtn_path)
    self.closeBtnN:SetOnClick(function()  
        self.ctrl:CloseSelf()
    end)
    self.maskBtnN = self:AddComponent(UIButton, maskBtn_path)
    self.maskBtnN:SetOnClick(function()  
        self.ctrl:CloseSelf()
    end)
    self.titleTxtN = self:AddComponent(UITextMeshProUGUIEx, title_path)
    self.contentN = self:AddComponent(UIBaseContainer, content_path)
    self.dailyRewardsN = self:AddComponent(AllianceCompetePerReward, dailyReward_path)
    self.weeklyRewardsN = self:AddComponent(AllianceCompetePerReward, weeklyReward_path)
end

local function ComponentDestroy(self)
    self.closeBtnN = nil
    self.titleTxtN = nil
    self.contentN = nil
end

local function DataDefine(self)
    
end

local function DataDestroy(self)
    
end

local function OnAddListener(self)
    self:AddUIListener(EventId.AllianceCompeteRewardsReposition, self.RepositionAll)
end

local function OnRemoveListener(self)
    self:RemoveUIListener(EventId.AllianceCompeteRewardsReposition, self.RepositionAll)
end


local function ShowRewards(self)
    self.allianceInfo = DataCenter.ActivityListDataManager:GetActivityDataById(EnumActivity.AllianceCompete.ActId)
    if self.allianceInfo == nil then
        return
    end
    self.eventInfo = self.allianceInfo:GetEventInfo()
    if not self.eventInfo then
        return
    end

    self.titleTxtN:SetLocalText(361012) 

    self:ShowDailyRewards()
    self:ShowWeeklyRewards()
    self:RepositionAll()
end

local function ShowDailyRewards(self)
    local strTip = Localization:GetString("361020", self.eventInfo.minDayScore)
    self.dailyRewardsN:ShowRewards(Localization:GetString("361052"), strTip, self.eventInfo.winReward)
end

local function ShowWeeklyRewards(self)
    local strTip = Localization:GetString("361071", self.eventInfo.minWeekScore)
    self.weeklyRewardsN:ShowRewards(Localization:GetString("361053"), strTip, self.eventInfo.winWeekReward)
end

local function RepositionAll(self)
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.contentN.rectTransform)
end


UIAllianceCompeteRewardView.OnCreate = OnCreate
UIAllianceCompeteRewardView.OnDestroy = OnDestroy
UIAllianceCompeteRewardView.OnEnable = OnEnable
UIAllianceCompeteRewardView.OnDisable = OnDisable
UIAllianceCompeteRewardView.ComponentDefine = ComponentDefine
UIAllianceCompeteRewardView.ComponentDestroy = ComponentDestroy
UIAllianceCompeteRewardView.DataDefine = DataDefine
UIAllianceCompeteRewardView.DataDestroy = DataDestroy
UIAllianceCompeteRewardView.OnAddListener = OnAddListener
UIAllianceCompeteRewardView.OnRemoveListener = OnRemoveListener

UIAllianceCompeteRewardView.ShowRewards = ShowRewards
UIAllianceCompeteRewardView.ShowDailyRewards = ShowDailyRewards
UIAllianceCompeteRewardView.ShowWeeklyRewards = ShowWeeklyRewards
UIAllianceCompeteRewardView.RepositionAll = RepositionAll

return UIAllianceCompeteRewardView