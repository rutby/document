---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2022/6/27 20:46
---

local TalentGroupInfo = BaseClass('TalentGroupInfo', UIBaseContainer)
local TalentGroupInfoCell = require "UI.UITalent.UITalentInfo.Component.TalentGroupInfoCell"
local base = UIBaseContainer
local UIGray = CS.UIGray
local bg_path = "GroupInfo_bg"
local scroll_view_path = "GroupInfo_bg/GroupInfo_scroll_bg/ScrollView"
local scroll_bg = "GroupInfo_bg/GroupInfo_scroll_bg"
local left_arrow_path = "GroupInfo_bg/LeftArrow"
local right_arrow_path = "GroupInfo_bg/RightArrow"
local Screen = CS.UnityEngine.Screen
local CellH = 91
local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
end

local function OnDestroy(self)
    self:ComponentDestroy()
    base.OnDestroy(self)
end

local function ComponentDefine(self)
    self.close_btn = self:AddComponent(UIButton, "")
    self.close_btn:SetOnClick(function()
        self:OnClick()
    end)
    self.scrollView = self:AddComponent(UIScrollView, scroll_view_path)
    self.scrollView:SetOnItemMoveIn(function(itemObj, curIndex)
        self:OnItemMoveIn(itemObj, curIndex)
    end)
    self.scrollView:SetOnItemMoveOut(function(itemObj, curIndex)
        self:OnItemMoveOut(itemObj, curIndex)
    end)
    self.left_arrow = self:AddComponent(UIImage, left_arrow_path)
    self.right_arrow = self:AddComponent(UIImage, right_arrow_path)
    self.bg = self:AddComponent(UIBaseContainer, bg_path)
    self.scroll_bg = self:AddComponent(UIBaseContainer, scroll_bg)
end

local function ComponentDestroy(self)
    self:ClearScroll()
end

local function SetGroupId(self, groupId, index, total, pos, cellW)
    self.groupId = groupId
    self.dataList = self.view.ctrl:GetGroupPanelData(self.groupId)
    self.index = index
    self.pos = pos
    self.cellW = cellW
    self.total = total
    self:RefreshList()
end

local function RefreshList(self)
    local scrollFixH = 55
    local totalCount = #self.dataList
    
    local showCount = math.max(2, math.min(totalCount, 3.5))
    local scrollTotalH = scrollFixH + CellH * showCount
    local rect = self.scroll_bg.rectTransform.sizeDelta
    self.scroll_bg.rectTransform:Set_sizeDelta(rect.x, scrollTotalH)
    
    self:ClearScroll()
    self.scrollView:SetTotalCount(totalCount)
    self.scrollView:RefillCells()
    local rect = self.scroll_bg.rectTransform
    local w = rect.sizeDelta.x
    local h = rect.sizeDelta.y
    local s = Screen.height / 750
    
    if self.index < self.total / 2 then
        self.left_arrow:SetActive(true)
        self.right_arrow:SetActive(false)
        self.bg.transform.position = Vector3.New(self.pos.x + (self.cellW / 2 + w / 2) * s, self.pos.y, 0)
    else
        self.left_arrow:SetActive(false)
        self.right_arrow:SetActive(true)
        self.bg.transform.position = Vector3.New(self.pos.x - (self.cellW / 2 + w / 2) * s, self.pos.y, 0)
    end
    self.scroll_bg.transform.position = self.bg.transform.position
    local pos = self.scroll_bg.transform.position
    if pos.y / s - h / 2 <= 60 then
        self.scroll_bg.transform.position = Vector3.New(pos.x, pos.y + h * s / 2 - 50, 0)
    end
    if pos.y / s + h / 2 >= 750 then
        self.scroll_bg.transform.position = Vector3.New(pos.x, pos.y - h * s / 2 + 50, 0)
    end
end

local function OnItemMoveIn(self, itemObj, curIndex)
    itemObj.name = tostring(curIndex)
    local cellItem = self.scrollView:AddComponent(TalentGroupInfoCell, itemObj)
    cellItem:SetData(self.dataList[curIndex])
end

local function OnItemMoveOut(self, itemObj, curIndex)
    self.scrollView:RemoveComponents(itemObj.name, TalentGroupInfoCell)
end

local function ClearScroll(self)
    self.scrollView:ClearCells()
    self.scrollView:RemoveComponents(TalentGroupInfoCell)
end


local function OnClick(self)
    self.view:HideGroupInfo()
end

TalentGroupInfo.OnCreate= OnCreate
TalentGroupInfo.OnDestroy = OnDestroy
TalentGroupInfo.ComponentDefine = ComponentDefine
TalentGroupInfo.ComponentDestroy = ComponentDestroy
TalentGroupInfo.SetGroupId = SetGroupId
TalentGroupInfo.OnClick = OnClick
TalentGroupInfo.OnItemMoveIn = OnItemMoveIn
TalentGroupInfo.OnItemMoveOut = OnItemMoveOut
TalentGroupInfo.ClearScroll = ClearScroll
TalentGroupInfo.RefreshList = RefreshList

return TalentGroupInfo