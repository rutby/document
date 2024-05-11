---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2023/9/1 17:22
---

local UIStoryRank = BaseClass("UIStoryRank", UIBaseView)
local base = UIBaseView
local UIStoryRankItem = require "UI.UIStory.UIStoryRank.Component.UIStoryRankItem"

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
    self.title_text = self:AddComponent(UITextMeshProUGUIEx, title_path)
    self.title_text:SetLocalText(140213)
    self.self_item = self:AddComponent(UIStoryRankItem, self_path)
    self.rank_desc_text = self:AddComponent(UITextMeshProUGUIEx, rank_desc_path)
    self.rank_desc_text:SetLocalText(302043)
    self.name_desc_text = self:AddComponent(UITextMeshProUGUIEx, name_desc_path)
    self.name_desc_text:SetLocalText(320763)
    self.score_desc_text = self:AddComponent(UITextMeshProUGUIEx, score_desc_path)
    self.score_desc_text:SetLocalText(140214)
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
    self:AddUIListener(EventId.StoryGetRank, self.Refresh)
end

local function OnRemoveListener(self)
    self:RemoveUIListener(EventId.StoryGetRank, self.Refresh)
    base.OnRemoveListener(self)
end

local function OnCellMoveIn(self, itemObj, index)
    itemObj.name = tostring(index)
    local item = self.scroll_view:AddComponent(UIStoryRankItem, itemObj)
    item:SetData(self.dataList[index])
    self.items[index] = item
end

local function OnCellMoveOut(self, itemObj, index)
    self.scroll_view:RemoveComponent(itemObj.name, UIStoryRankItem)
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
    DataCenter.StoryManager:SendGetRank()
end

local function Refresh(self)
    local allianceData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()

    local selfData = {}
    selfData.uid = LuaEntry.Player.uid
    selfData.serverId = LuaEntry.Player:GetSelfServerId()
    selfData.rank = DataCenter.StoryManager.selfRank or 0
    selfData.score = DataCenter.StoryManager.selfScore or 0
    selfData.power = LuaEntry.Player.power
    selfData.name = LuaEntry.Player.name
    selfData.pic = LuaEntry.Player.pic
    selfData.picVer = LuaEntry.Player.picVer
    selfData.headSkinId = LuaEntry.Player.headSkinId
    selfData.headSkinET = LuaEntry.Player.headSkinET
    selfData.abbr = allianceData and allianceData.abbr
    selfData.allianceName = allianceData and allianceData.allianceName
    selfData.country = LuaEntry.Player.countryFlag
    self.self_item:SetData(selfData)

    self.dataList = DataCenter.StoryManager.rankList or {}
    self:ShowScroll()
end

UIStoryRank.OnCreate = OnCreate
UIStoryRank.OnDestroy = OnDestroy
UIStoryRank.OnEnable = OnEnable
UIStoryRank.OnDisable = OnDisable
UIStoryRank.ComponentDefine = ComponentDefine
UIStoryRank.ComponentDestroy = ComponentDestroy
UIStoryRank.DataDefine = DataDefine
UIStoryRank.DataDestroy = DataDestroy
UIStoryRank.OnAddListener = OnAddListener
UIStoryRank.OnRemoveListener = OnRemoveListener

UIStoryRank.OnCellMoveIn = OnCellMoveIn
UIStoryRank.OnCellMoveOut = OnCellMoveOut
UIStoryRank.ShowScroll = ShowScroll

UIStoryRank.ReInit = ReInit
UIStoryRank.Refresh = Refresh

return UIStoryRank