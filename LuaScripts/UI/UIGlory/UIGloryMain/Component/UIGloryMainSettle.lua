---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2023/2/27 20:34
---

local UIGloryMainSettle = BaseClass("UIGloryMainSettle", UIBaseContainer)
local base = UIBaseContainer
local AllianceFlagItem = require "UI.UIAlliance.UIAllianceFlag.Component.AllianceFlagItem"
local Localization = CS.GameEntry.Localization

local title_path = "Title"
local champion_path = "Champion"
local alliance_flag_path = "Bottom/AllianceFlag"
local head_path = "Bottom/UIPlayerHead/HeadIcon"
local head_fg_path = "Bottom/UIPlayerHead/Foreground"
local alliance_name_path = "Bottom/AllianceName"
local leader_desc_path = "Bottom/LeaderDesc"
local leader_name_path = "Bottom/LeaderName"
local go_btn_path = "Bottom/Go"
local go_text_path = "Bottom/Go/GoText"

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

local function ComponentDefine(self)
    self.title_text = self:AddComponent(UIText, title_path)
    self.title_text:SetLocalText(132032)
    self.champion_text = self:AddComponent(UIText, champion_path)
    self.champion_text:SetLocalText(302053)
    self.alliance_flag = self:AddComponent(AllianceFlagItem, alliance_flag_path)
    self.head = self:AddComponent(UIPlayerHead, head_path)
    self.head_fg_image = self:AddComponent(UIImage, head_fg_path)
    self.alliance_name_text = self:AddComponent(UIText, alliance_name_path)
    self.leader_desc_text = self:AddComponent(UIText, leader_desc_path)
    self.leader_desc_text:SetLocalText(302336)
    self.leader_name_text = self:AddComponent(UIText, leader_name_path)
    self.go_btn = self:AddComponent(UIButton, go_btn_path)
    self.go_btn:SetOnClick(function()
        self:OnGoClick()
    end)
    self.go_text = self:AddComponent(UIText, go_text_path)
    self.go_text:SetLocalText(110300)
end

local function ComponentDestroy(self)
    self.title_text = nil
    self.champion_text = nil
    self.alliance_flag = nil
    self.head = nil
    self.head_fg_image = nil
    self.alliance_name_text = nil
    self.leader_desc_text = nil
    self.leader_name_text = nil
    self.go_btn = nil
    self.go_text = nil
end

local function DataDefine(self)
    self.seasonReward = nil
end

local function DataDestroy(self)
    self.seasonReward = nil
end

local function OnEnable(self)
    base.OnEnable(self)
    self:ReInit()
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function OnAddListener(self)
    base.OnAddListener(self)
    self:AddUIListener(EventId.GloryGetWarData, self.OnGloryGetWarData)
    self:AddUIListener(EventId.GloryGetAct, self.OnGloryGetAct)
end

local function OnRemoveListener(self)
    self:RemoveUIListener(EventId.GloryGetWarData, self.OnGloryGetWarData)
    self:RemoveUIListener(EventId.GloryGetAct, self.OnGloryGetAct)
    base.OnRemoveListener(self)
end

local function ReInit(self)
    self:Refresh()
end

local function Refresh(self)
    self.seasonReward = DataCenter.DesertDataManager:GetSelfAllianceSeasonReward()
    self.go_btn:SetActive(self.seasonReward ~= nil)
    local activityData = DataCenter.GloryManager:GetActivityData()
    local champion = activityData.champion
    if champion then
        local leader = champion.leader
        if leader then
            self.alliance_flag:SetData(champion.icon)
            self.head:SetData(leader.uid, leader.pic, leader.picVer)
            local headFrame = DataCenter.DecorationDataManager:GetHeadFrame(leader.headSkinId, leader.headSkinET)
            if headFrame then
                self.head_fg_image:SetActive(true)
                self.head_fg_image:LoadSprite(headFrame)
            else
                self.head_fg_image:SetActive(false)
            end
            self.alliance_name_text:SetText(UIUtil.GetAllianceWholeName(leader.serverId, champion.abbr, champion.allianceName))
            self.leader_name_text:SetText(leader.name)
        end
    end
end

local function OnGoClick(self)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UISeasonAllianceReward)
end

local function OnGloryGetWarData(self)
    self:Refresh()
end

local function OnGloryGetAct(self)
    self:Refresh()
end

UIGloryMainSettle.OnCreate= OnCreate
UIGloryMainSettle.OnDestroy = OnDestroy
UIGloryMainSettle.ComponentDefine = ComponentDefine
UIGloryMainSettle.ComponentDestroy = ComponentDestroy
UIGloryMainSettle.DataDefine = DataDefine
UIGloryMainSettle.DataDestroy = DataDestroy
UIGloryMainSettle.OnEnable = OnEnable
UIGloryMainSettle.OnDisable = OnDisable
UIGloryMainSettle.OnAddListener = OnAddListener
UIGloryMainSettle.OnRemoveListener = OnRemoveListener

UIGloryMainSettle.ReInit = ReInit
UIGloryMainSettle.Refresh = Refresh

UIGloryMainSettle.OnGoClick = OnGoClick

UIGloryMainSettle.OnGloryGetWarData = OnGloryGetWarData
UIGloryMainSettle.OnGloryGetAct = OnGloryGetAct

return UIGloryMainSettle