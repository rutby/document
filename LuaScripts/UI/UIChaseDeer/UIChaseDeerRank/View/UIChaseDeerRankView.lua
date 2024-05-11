---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2023/8/3 12:06
---

local UIChaseDeerRank = BaseClass("UIChaseDeerRank", UIBaseView)
local base = UIBaseView
local UIChaseDeerRankItem = require "UI.UIChaseDeer.UIChaseDeerRank.Component.UIChaseDeerRankItem"

local return_path = "UICommonPopUpTitle/panel"
local close_path = "UICommonPopUpTitle/bg_mid/CloseBtn"
local title_path = "UICommonPopUpTitle/bg_mid/titleText"
local self_path = "Self"
local rank_desc_path = "Head/RankDesc"
local name_desc_path = "Head/NameDesc"
local score_desc_path = "Head/ScoreDesc"
local scroll_view_path = "ScrollView"

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
    self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
    self.title_text = self:AddComponent(UIText, title_path)
    self.title_text:SetLocalText(375063)
    self.self_item = self:AddComponent(UIChaseDeerRankItem, self_path)
    self.rank_desc_text = self:AddComponent(UIText, rank_desc_path)
    self.rank_desc_text:SetLocalText(302043)
    self.name_desc_text = self:AddComponent(UIText, name_desc_path)
    self.name_desc_text:SetLocalText(390288)
    self.score_desc_text = self:AddComponent(UIText, score_desc_path)
    self.score_desc_text:SetLocalText(302042)
    self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
        self:OnCellMoveIn(itemObj, index)
    end)
    self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
        self:OnCellMoveOut(itemObj, index)
    end)
end

local function ComponentDestroy(self)

end

local function DataDefine(self)
    self.dataList = {}
    self.items = {}
end

local function DataDestroy(self)

end

local function OnAddListener(self)
    base.OnAddListener(self)
    self:AddUIListener(EventId.GetRankRefresh, self.OnGetRank)
end

local function OnRemoveListener(self)
    self:RemoveUIListener(EventId.GetRankRefresh, self.OnGetRank)
    base.OnRemoveListener(self)
end

local function OnCellMoveIn(self, itemObj, index)
    itemObj.name = tostring(index)
    local data = self.dataList[index]
    data.rank = index
    local item = self.scroll_view:AddComponent(UIChaseDeerRankItem, itemObj)
    item:SetData(data)
    self.items[index] = item
end

local function OnCellMoveOut(self, itemObj, index)
    self.scroll_view:RemoveComponent(itemObj.name, UIChaseDeerRankItem)
    self.items[index] = nil
end

local function ShowScroll(self)
    local count = #self.dataList
    if count > 0 then
        self.scroll_view:SetActive(true)
        self.scroll_view:SetTotalCount(count)
        self.scroll_view:RefillCells()
    else
        self.scroll_view:SetActive(false)
    end
end

local function ReInit(self)
    SFSNetwork.SendMessage(MsgDefines.GetRank, RankType.AllianceSeasonForce)
end

local function Refresh(self)
    
end

local function OnGetRank(self, message)
    local allianceData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
    local selfData = {}
    selfData.uid = allianceData.uid
    selfData.leader = allianceData.leaderName
    selfData.country = allianceData.country
    selfData.srcServer = allianceData.createServer
    selfData.curMember = allianceData.curMember
    selfData.maxMember = allianceData.maxMember
    selfData.alliancename = allianceData.allianceName
    selfData.icon = allianceData.icon
    selfData.force = message["selfForce"] or 0
    selfData.abbr = allianceData.abbr
    selfData.nums = 0
    selfData.rank = message["selfRanking"] or 0
    self.self_item:SetData(selfData)
    
    if message["allianceRanking"] then
        self.dataList = message["allianceRanking"]
        self:ShowScroll()
    end
end

UIChaseDeerRank.OnCreate = OnCreate
UIChaseDeerRank.OnDestroy = OnDestroy
UIChaseDeerRank.OnEnable = OnEnable
UIChaseDeerRank.OnDisable = OnDisable
UIChaseDeerRank.ComponentDefine = ComponentDefine
UIChaseDeerRank.ComponentDestroy = ComponentDestroy
UIChaseDeerRank.DataDefine = DataDefine
UIChaseDeerRank.DataDestroy = DataDestroy
UIChaseDeerRank.OnAddListener = OnAddListener
UIChaseDeerRank.OnRemoveListener = OnRemoveListener

UIChaseDeerRank.OnCellMoveIn = OnCellMoveIn
UIChaseDeerRank.OnCellMoveOut = OnCellMoveOut
UIChaseDeerRank.ShowScroll = ShowScroll

UIChaseDeerRank.ReInit = ReInit
UIChaseDeerRank.Refresh = Refresh

UIChaseDeerRank.OnGetRank = OnGetRank

return UIChaseDeerRank