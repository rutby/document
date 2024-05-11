---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2023/8/3 15:54
---

local UIEdenKillRule = BaseClass("UIEdenKillRule", UIBaseContainer)
local base = UIBaseContainer
local UIEdenKillRuleItem = require "UI.UIEdenKill.UIEdenKillRuleItem"

local desc_path = "Desc"
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
    self.desc_text = self:AddComponent(UIText, desc_path)
    self.desc_text:SetLocalText(375048)
    self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
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
    self.inited = false
    self.dataList = {}
end

local function DataDestroy(self)

end

local function OnAddListener(self)
    base.OnAddListener(self)
end

local function OnRemoveListener(self)
    base.OnRemoveListener(self)
end

local function OnCellMoveIn(self, itemObj, index)
    itemObj.name = tostring(index)
    local item = self.scroll_view:AddComponent(UIEdenKillRuleItem, itemObj)
    item:SetData(self.dataList[index])
end

local function OnCellMoveOut(self, itemObj, index)
    self.scroll_view:RemoveComponent(itemObj.name, UIEdenKillRuleItem)
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
    if self.inited then
        return
    end
    self.inited = true
    self.actId = actId
    self.dataList = {}
    local k1 = LuaEntry.DataConfig:TryGetStr("eden_rank_config", "k1")
    local strs = string.split(k1, "|")
    for i, str in ipairs(strs) do
        local spls = string.split(str, ";")
        local data = {}
        data.index = i
        data.left = tonumber(spls[1])
        data.right = tonumber(spls[2])
        table.insert(self.dataList, data)
    end
    self:ShowScroll()
end

UIEdenKillRule.OnCreate = OnCreate
UIEdenKillRule.OnDestroy = OnDestroy
UIEdenKillRule.OnEnable = OnEnable
UIEdenKillRule.OnDisable = OnDisable
UIEdenKillRule.ComponentDefine = ComponentDefine
UIEdenKillRule.ComponentDestroy = ComponentDestroy
UIEdenKillRule.DataDefine = DataDefine
UIEdenKillRule.DataDestroy = DataDestroy
UIEdenKillRule.OnAddListener = OnAddListener
UIEdenKillRule.OnRemoveListener = OnRemoveListener

UIEdenKillRule.OnCellMoveIn = OnCellMoveIn
UIEdenKillRule.OnCellMoveOut = OnCellMoveOut
UIEdenKillRule.ShowScroll = ShowScroll

UIEdenKillRule.Refresh = Refresh

return UIEdenKillRule