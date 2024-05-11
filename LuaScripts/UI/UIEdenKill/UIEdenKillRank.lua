---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2023/8/3 15:28
---

local UIEdenKillRank = BaseClass("UIEdenKillRank", UIBaseContainer)
local base = UIBaseContainer
local UIEdenKillRankItem = require "UI.UIEdenKill.UIEdenKillRankItem"

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
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function ComponentDefine(self)
    self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
    self.self_item = self:AddComponent(UIEdenKillRankItem, self_path)
    self.rank_desc_text = self:AddComponent(UIText, rank_desc_path)
    self.rank_desc_text:SetLocalText(302043)
    self.name_desc_text = self:AddComponent(UIText, name_desc_path)
    self.name_desc_text:SetLocalText(320763)
    self.score_desc_text = self:AddComponent(UIText, score_desc_path)
    self.score_desc_text:SetLocalText(375047)
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
    self:AddUIListener(EventId.EdenKillGetRank, self.OnGetRank)
end

local function OnRemoveListener(self)
    self:RemoveUIListener(EventId.EdenKillGetRank, self.OnGetRank)
    base.OnRemoveListener(self)
end

local function OnCellMoveIn(self, itemObj, index)
    itemObj.name = tostring(index)
    local item = self.scroll_view:AddComponent(UIEdenKillRankItem, itemObj)
    item:SetData(self.dataList[index])
    self.items[index] = item
end

local function OnCellMoveOut(self, itemObj, index)
    self.scroll_view:RemoveComponent(itemObj.name, UIEdenKillRankItem)
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

local function Refresh(self, actId)
    self.actId = actId
    SFSNetwork.SendMessage(MsgDefines.GetEdenKillActivityRank, actId)
end

local function OnGetRank(self, message)
    if message["activityId"] == tonumber(self.actId) then
        local selfData = {}
        selfData.uid = LuaEntry.Player.uid
        selfData.serverId = LuaEntry.Player:GetSelfServerId()
        selfData.rank = message["selfRank"] or 0
        selfData.score = message["selfScore"] or 0
        selfData.power = LuaEntry.Player.power
        selfData.name = LuaEntry.Player.name
        selfData.pic = LuaEntry.Player.pic
        selfData.picVer = LuaEntry.Player.picVer
        selfData.headSkinId = LuaEntry.Player.headSkinId
        selfData.headSkinET = LuaEntry.Player.headSkinET
        selfData.abbr = allianceData and allianceData.abbr
        selfData.allianceName = allianceData and allianceData.allianceName
        self.self_item:SetData(selfData)
        
        self.dataList = message["rankList"]
        self:ShowScroll()
    end
end

UIEdenKillRank.OnCreate = OnCreate
UIEdenKillRank.OnDestroy = OnDestroy
UIEdenKillRank.OnEnable = OnEnable
UIEdenKillRank.OnDisable = OnDisable
UIEdenKillRank.ComponentDefine = ComponentDefine
UIEdenKillRank.ComponentDestroy = ComponentDestroy
UIEdenKillRank.DataDefine = DataDefine
UIEdenKillRank.DataDestroy = DataDestroy
UIEdenKillRank.OnAddListener = OnAddListener
UIEdenKillRank.OnRemoveListener = OnRemoveListener

UIEdenKillRank.OnCellMoveIn = OnCellMoveIn
UIEdenKillRank.OnCellMoveOut = OnCellMoveOut
UIEdenKillRank.ShowScroll = ShowScroll

UIEdenKillRank.Refresh = Refresh
UIEdenKillRank.OnGetRank = OnGetRank

return UIEdenKillRank