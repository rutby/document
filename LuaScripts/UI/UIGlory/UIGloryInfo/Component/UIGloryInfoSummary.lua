---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2023/2/28 20:32
---

local UIGloryInfoSummary = BaseClass("UIGloryInfoSummary", UIBaseContainer)
local base = UIBaseContainer
local UIGloryInfoSummaryItem = require "UI.UIGlory.UIGloryInfo.Component.UIGloryInfoSummaryItem"
local AllianceFlagItem = require "UI.UIAlliance.UIAllianceFlag.Component.AllianceFlagItem"
local Localization = CS.GameEntry.Localization

local desc_path = "Head/Desc"
local scroll_view_path = "ScrollView"
local left_desc_path = "Top/LeftDesc"
local left_alliance_name_path = "Top/LeftAllianceName"
local left_alliance_flag_path = "Top/LeftAllianceFlag"
local right_desc_path = "Top/RightDesc"
local right_alliance_name_path = "Top/RightAllianceName"
local right_alliance_flag_path = "Top/RightAllianceFlag"

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
    self.desc_text = self:AddComponent(UIText, desc_path)
    self.desc_text:SetLocalText(302826)
    self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
    self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
        self:OnCreateCell(itemObj, index)
    end)
    self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
        self:OnDeleteCell(itemObj, index)
    end)
    self.left_desc_text = self:AddComponent(UIText, left_desc_path)
    self.left_alliance_name_text = self:AddComponent(UIText, left_alliance_name_path)
    self.left_alliance_flag = self:AddComponent(AllianceFlagItem, left_alliance_flag_path)
    self.right_desc_text = self:AddComponent(UIText, right_desc_path)
    self.right_alliance_name_text = self:AddComponent(UIText, right_alliance_name_path)
    self.right_alliance_flag = self:AddComponent(AllianceFlagItem, right_alliance_flag_path)
end

local function ComponentDestroy(self)
    self.desc_text = nil
    self.scroll_view = nil
    self.left_desc_text = nil
    self.left_alliance_name_text = nil
    self.left_alliance_flag = nil
    self.right_desc_text = nil
    self.right_alliance_name_text = nil
    self.right_alliance_flag = nil
end

local function DataDefine(self)
    self.dataList = {}
end

local function DataDestroy(self)
    self.dataList = nil
end

local function OnEnable(self)
    base.OnEnable(self)
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function OnAddListener(self)
    base.OnAddListener(self)
end

local function OnRemoveListener(self)
    base.OnRemoveListener(self)
end

local function OnCreateCell(self, itemObj, index)
    itemObj.name = tostring(index)
    local item = self.scroll_view:AddComponent(UIGloryInfoSummaryItem, itemObj)
    item:SetData(self.dataList[index])
end

local function OnDeleteCell(self, itemObj, index)
    self.scroll_view:RemoveComponent(itemObj.name, UIGloryInfoSummaryItem)
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
    self.view:ShowEmpty(count == 0)
end

local function ReInit(self)
    self:Refresh()
end

local function Refresh(self)
    local actData = DataCenter.GloryManager:GetActData()
    local myData = actData:GetMyData()
    local opponentData = actData:GetOpponentData()
    
    self.left_desc_text:SetText(myData.attack == 1 and Localization:GetString("302824") or Localization:GetString("302825"))
    self.left_alliance_name_text:SetText(UIUtil.GetAllianceWholeName(myData.serverId, myData.abbr, myData.alName))
    self.left_alliance_flag:SetData(myData.alIcon)
    self.right_desc_text:SetText(opponentData.attack == 1 and Localization:GetString("302824") or Localization:GetString("302825"))
    self.right_alliance_name_text:SetText(UIUtil.GetAllianceWholeName(opponentData.serverId, opponentData.abbr, opponentData.alName))
    self.right_alliance_flag:SetData(opponentData.alIcon)
    
    self.dataList = self:GetDataListInternal()
    self:ShowScroll()
end

local function GetDataListInternal(self)
    local dataList = {}

    local actData = DataCenter.GloryManager:GetActData()
    local myData = actData:GetMyData()
    local opponentData = actData:GetOpponentData()
    
    table.insert(dataList, {
        descText = Localization:GetString("302827"),
        leftText = myData.fightMember,
        rightText = opponentData.fightMember,
    })
    
    table.insert(dataList, {
        descText = Localization:GetString("302828"),
        leftText = myData.crashtc,
        rightText = opponentData.crashtc,
    })
    
    table.insert(dataList, {
        descText = Localization:GetString("302829"),
        leftText = myData.crashwb,
        rightText = opponentData.crashwb,
    })
    
    table.insert(dataList, {
        descText = Localization:GetString("302830"),
        leftText = myData.occupy,
        rightText = opponentData.occupy,
    })
    
    table.insert(dataList, {
        descText = Localization:GetString("302831"),
        leftText = myData.placeAssemble,
        rightText = opponentData.placeAssemble,
    })
    
    return dataList
end

UIGloryInfoSummary.OnCreate= OnCreate
UIGloryInfoSummary.OnDestroy = OnDestroy
UIGloryInfoSummary.ComponentDefine = ComponentDefine
UIGloryInfoSummary.ComponentDestroy = ComponentDestroy
UIGloryInfoSummary.DataDefine = DataDefine
UIGloryInfoSummary.DataDestroy = DataDestroy
UIGloryInfoSummary.OnEnable = OnEnable
UIGloryInfoSummary.OnDisable = OnDisable
UIGloryInfoSummary.OnAddListener = OnAddListener
UIGloryInfoSummary.OnRemoveListener = OnRemoveListener

UIGloryInfoSummary.OnCreateCell = OnCreateCell
UIGloryInfoSummary.OnDeleteCell = OnDeleteCell
UIGloryInfoSummary.ShowScroll = ShowScroll

UIGloryInfoSummary.ReInit = ReInit
UIGloryInfoSummary.Refresh = Refresh
UIGloryInfoSummary.GetDataListInternal = GetDataListInternal

return UIGloryInfoSummary