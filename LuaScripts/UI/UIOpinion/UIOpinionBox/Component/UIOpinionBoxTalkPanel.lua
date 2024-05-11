---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2023/11/6 16:55
---

local UIOpinionBoxTalkPanel = BaseClass("UIOpinionBoxTalkPanel", UIBaseContainer)
local base = UIBaseContainer
local UIOpinionBoxTalkItem = require "UI.UIOpinion.UIOpinionBox.Component.UIOpinionBoxTalkItem"

local scroll_view_path = "ScrollView"

local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
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
    self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
        self:OnCreateCell(itemObj, index)
    end)
    self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
        self:OnDeleteCell(itemObj, index)
    end)
end

local function ComponentDestroy(self)
    
end

local function DataDefine(self)
    self.items = {}
end

local function DataDestroy(self)
    
end

local function OnAddListener(self)
    base.OnAddListener(self)
end

local function OnRemoveListener(self)
    base.OnRemoveListener(self)
end

local function OnCreateCell(self, itemObj, index)
    itemObj.name = tostring(index)
    local item = self.scroll_view:AddComponent(UIOpinionBoxTalkItem, itemObj)
    item:SetData(self.data.opinions[index])
    self.items[index] = item
end

local function OnDeleteCell(self, itemObj, index)
    self.scroll_view:RemoveComponent(itemObj.name, UIOpinionBoxTalkItem)
    self.items[index] = nil
end

local function ShowScroll(self)
    local count = #self.data.opinions
    if count > 0 then
        self.scroll_view:SetActive(true)
        self.scroll_view:SetTotalCount(count)
        self.scroll_view:RefillCells()
    else
        self.scroll_view:SetActive(false)
    end
end

local function Refresh(self)
    self.data = DataCenter.OpinionManager:GetData()
    self:ShowScroll()
end

UIOpinionBoxTalkPanel.OnCreate = OnCreate
UIOpinionBoxTalkPanel.OnDestroy = OnDestroy
UIOpinionBoxTalkPanel.OnEnable = OnEnable
UIOpinionBoxTalkPanel.OnDisable = OnDisable
UIOpinionBoxTalkPanel.ComponentDefine = ComponentDefine
UIOpinionBoxTalkPanel.ComponentDestroy = ComponentDestroy
UIOpinionBoxTalkPanel.DataDefine = DataDefine
UIOpinionBoxTalkPanel.DataDestroy = DataDestroy
UIOpinionBoxTalkPanel.OnAddListener = OnAddListener
UIOpinionBoxTalkPanel.OnRemoveListener = OnRemoveListener

UIOpinionBoxTalkPanel.OnCreateCell = OnCreateCell
UIOpinionBoxTalkPanel.OnDeleteCell = OnDeleteCell
UIOpinionBoxTalkPanel.ShowScroll = ShowScroll

UIOpinionBoxTalkPanel.Refresh = Refresh

return UIOpinionBoxTalkPanel