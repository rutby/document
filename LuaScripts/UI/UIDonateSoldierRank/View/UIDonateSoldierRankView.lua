---
--- 荣耀之战宣战记录
--- Created by shimin.
--- DateTime: 2023/3/2 17:33
---

local UIDonateSoldierRankView = BaseClass("UIDonateSoldierRankView", UIBaseView)
local base = UIBaseView
local UIBlackKnightRankPersonal = require "UI.UIDonateSoldierRank.Component.UIDonateSoldierRankPersonal"

local RankType = 
{
    SelfRank = 1,--己方排行
    EnemyRank = 2,--敌方排行
}

local title_text_path = "UICommonPopUpTitle/bg_mid/titleText"
local return_btn_path = "UICommonPopUpTitle/panel"
local close_btn_path = "UICommonPopUpTitle/bg_mid/CloseBtn"
local toggle_path = "Tab/Toggle%s"
local personal_go_path = "personal_go"

function UIDonateSoldierRankView:OnCreate()
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
    self:ReInit()
end

function UIDonateSoldierRankView:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIDonateSoldierRankView:OnEnable()
    base.OnEnable(self)
end

function UIDonateSoldierRankView:OnDisable()
    base.OnDisable(self)
end

function UIDonateSoldierRankView:ComponentDefine()
    self.title_text = self:AddComponent(UIText, title_text_path)
    self.return_btn = self:AddComponent(UIButton, return_btn_path)
    self.return_btn:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)
    self.close_btn = self:AddComponent(UIButton, close_btn_path)
    self.close_btn:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)
    self.personal_go = self:AddComponent(UIBlackKnightRankPersonal, personal_go_path)
    self.toggle = {}
    for k,v in pairs(RankType) do
        local toggle = self:AddComponent(UIToggle, string.format(toggle_path, v))
        if toggle ~= nil then
            toggle:SetOnValueChanged(function(tf)
                if self.isDataBack == false then
                    return
                end
                if tf then
                    self:ToggleControlBorS(v)
                end
            end)
            toggle.choose = toggle:AddComponent(UIBaseContainer, "Choose")
            toggle.choose:SetActive(false)
            toggle.unSelectName = toggle:AddComponent(UIText, "unselectName")
            toggle.selectName = toggle:AddComponent(UIText, "Choose/selectName")
            self.toggle[v] = toggle
        end
    end
end

function UIDonateSoldierRankView:ComponentDestroy()
  
end

function UIDonateSoldierRankView:DataDefine()
    self.rankType = RankType.SelfRank
    self.isDataBack = false
end

function UIDonateSoldierRankView:DataDestroy()
    self.rankType = RankType.SelfRank
end

function UIDonateSoldierRankView:OnAddListener()
    base.OnAddListener(self)
    self:AddUIListener(EventId.UIDonateSoldierRankDataUpdate, self.OnRankListDataReturn)
end

function UIDonateSoldierRankView:OnRemoveListener()
    self:RemoveUIListener(EventId.UIDonateSoldierRankDataUpdate, self.OnRankListDataReturn)
    base.OnRemoveListener(self)
end

function UIDonateSoldierRankView:ReInit()
    self.title_text:SetLocalText(372775)
    for k,v in pairs(self.toggle) do
        if k == RankType.SelfRank then
            --己方联盟
            v.selectName:SetLocalText(372811) --本盟详情
            v.unSelectName:SetLocalText(372811)
        elseif k == RankType.EnemyRank then
            --敌方联盟
            v.selectName:SetLocalText(372812)
            v.unSelectName:SetLocalText(372812) --敌方详情
        end
    end
    self.rankType = RankType.SelfRank
    if self.toggle[self.rankType] ~= nil then
        self.toggle[self.rankType]:SetIsOn(true)
        self:SetToggleChoose(self.rankType, true)
    end
    self:SendMsg()
end

function UIDonateSoldierRankView:OnRankListDataReturn()
    self.isDataBack = true
    self:Refresh()
end

function UIDonateSoldierRankView:ToggleControlBorS(rankType)
    if  self.rankType ~= rankType then
        self:SetToggleChoose(self.rankType, false)
        self.rankType = rankType
        self:SetToggleChoose(self.rankType, true)
        self:SendMsg()
    end
end

function UIDonateSoldierRankView:Refresh()
    if self.isDataBack == false then
        return
    end

    self.personal_go:Refresh(self.rankType)
end

function UIDonateSoldierRankView:SetToggleChoose(rank, choose)
    local toggle = self.toggle[rank]
    if toggle ~= nil and toggle.choose ~= nil then
        toggle.choose:SetActive(choose)
    end
end

function UIDonateSoldierRankView:SendMsg()
    self.isDataBack = false
    DataCenter.ActivityDonateSoldierManager:OnSendGetDonateSoldierRankMsg(self.rankType)
end

return UIDonateSoldierRankView