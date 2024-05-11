---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2023/3/24 11:11
---

local UICrossWormItemList = BaseClass("UICrossWormItemList", UIBaseView)
local base = UIBaseView
local UICommonItemChange = require "UI.UICommonItem.UICommonItemChange"

local return_path = "UICommonMiniPopUpTitle/panel"
local close_path = "UICommonMiniPopUpTitle/Bg_mid/CloseBtn"
local title_path = "UICommonMiniPopUpTitle/Bg_mid/titleText"
local desc_path = "Desc"
local reward_list_path = "RewardList"
local reward_path = "RewardList/Reward%s"
local reward_icon_path = "RewardList/Reward%s/RewardIcon%s"
local reward_count_path = "RewardList/Reward%s/RewardCount%s"
local empty_path = "Empty"
local scroll_view_path = "ScrollView"

local RewardCount = 4

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
    self.title_text = self:AddComponent(UITextMeshProUGUIEx, title_path)
    self.title_text:SetLocalText(143652)
    self.desc_text = self:AddComponent(UIText, desc_path)
    self.desc_text:SetLocalText(143651)
    self.reward_list_go = self:AddComponent(UIBaseContainer, reward_list_path)
    self.reward_goes = {}
    self.reward_icon_images = {}
    self.reward_count_texts = {}
    for i = 1, RewardCount do
        self.reward_goes[i] = self:AddComponent(UIBaseContainer, string.format(reward_path, i))
        self.reward_icon_images[i] = self:AddComponent(UIImage, string.format(reward_icon_path, i, i))
        self.reward_count_texts[i] = self:AddComponent(UIText, string.format(reward_count_path, i, i))
    end
    self.empty_text = self:AddComponent(UIText, empty_path)
    self.empty_text:SetLocalText(140042)
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
    self.list = {}
end

local function DataDestroy(self)
    self.list = {}
end

local function OnAddListener(self)
    base.OnAddListener(self)
end

local function OnRemoveListener(self)
    base.OnRemoveListener(self)
end

local function ReInit(self)
    local rewardList, previewList = self:GetUserData()
    self:ShowCells()

    if not table.IsNullOrEmpty(previewList) then
        self.desc_text:SetActive(false)
        self.reward_list_go:SetActive(true)
        for i = 1, RewardCount do
            self.reward_icon_images[i]:LoadSprite(previewList[i].icon)
            self.reward_count_texts[i]:SetText(string.GetFormattedStr(previewList[i].count))
        end
    else
        self.desc_text:SetActive(true)
        self.reward_list_go:SetActive(false)
    end
end

function UICrossWormItemList:ShowCells()
    self:ClearScroll()
    self:GetDataList()
    local count = table.count(self.list)
    if count > 0 then
        self.empty_text:SetActive(false)
        self.scroll_view:SetActive(true)
        self.scroll_view:SetTotalCount(count)
        self.scroll_view:RefillCells()
    else
        self.scroll_view:SetActive(false)
        self.empty_text:SetActive(true)
    end
end

function UICrossWormItemList:ClearScroll()
    self.scroll_view:ClearCells()--清循环列表数据
    self.scroll_view:RemoveComponents(UICommonItemChange)--清循环列表gameObject
end

function UICrossWormItemList:OnCellMoveIn(itemObj, index)
    itemObj.name = tostring(index)
    local item = self.scroll_view:AddComponent(UICommonItemChange, itemObj)
    item:ReInit(self.list[index])
end

function UICrossWormItemList:OnCellMoveOut(itemObj, index)
    self.scroll_view:RemoveComponent(itemObj.name, UICommonItemChange)
end

function UICrossWormItemList:GetDataList()
    local rewardList, previewList = self:GetUserData()
    self.list = rewardList
end

UICrossWormItemList.OnCreate = OnCreate
UICrossWormItemList.OnDestroy = OnDestroy
UICrossWormItemList.OnEnable = OnEnable
UICrossWormItemList.OnDisable = OnDisable
UICrossWormItemList.ComponentDefine = ComponentDefine
UICrossWormItemList.ComponentDestroy = ComponentDestroy
UICrossWormItemList.DataDefine = DataDefine
UICrossWormItemList.DataDestroy = DataDestroy
UICrossWormItemList.OnAddListener = OnAddListener
UICrossWormItemList.OnRemoveListener = OnRemoveListener
UICrossWormItemList.ReInit = ReInit

return UICrossWormItemList