---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2022/12/30 19:06
---

local UIChooseCarView = BaseClass("UIChooseCarView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UICommonItem = require "UI.UICommonItem.UICommonItem"
local UIChooseCarItem = require "UI.UIChooseCar.Component.UIChooseCarItem"
local UIHeroTipView = require "UI.UIHero2.UIHeroTip.View.UIHeroTipView"
local UIGray = CS.UIGray

local panel_path = "UICommonMidPopUpTitle/panel"
local close_path = "UICommonMidPopUpTitle/bg_mid/CloseBtn"
local title_path = "UICommonMidPopUpTitle/bg_mid/titleText"
local name_path = "Name"
local desc_path = "Desc"
local item_path = "Item"
local info_path = "Info"
local scroll_view_path = "ScrollView"
local select_btn_path = "Select"
local select_text_path = "Select/SelectText"

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

local function ComponentDefine(self)
    self.panel_btn = self:AddComponent(UIButton, panel_path)
    self.panel_btn:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)
    self.close_btn = self:AddComponent(UIButton, close_path)
    self.close_btn:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)
    self.title_text = self:AddComponent(UITextMeshProUGUIEx, title_path)
    self.name_text = self:AddComponent(UIText, name_path)
    self.desc_text = self:AddComponent(UIText, desc_path)
    self.item = self:AddComponent(UICommonItem, item_path)
    self.info_btn = self:AddComponent(UIButton, info_path)
    self.info_btn:SetOnClick(function()
        self:OnInfoClick()
    end)
    self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
    self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
        self:OnCellMoveIn(itemObj, index)
    end)
    self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
        self:OnCellMoveOut(itemObj, index)
    end)
    self.select_btn = self:AddComponent(UIButton, select_btn_path)
    self.select_btn:SetOnClick(function()
        self:OnSelectClick()
    end)
    self.select_text = self:AddComponent(UIText, select_text_path)
end

local function ComponentDestroy(self)
    self.panel_btn = nil
    self.close_btn = nil
    self.title_text = nil
    self.name_text = nil
    self.desc_text = nil
    self.item = nil
    self.scroll_view = nil
    self.select_btn = nil
    self.select_text = nil
end

local function DataDefine(self)
    self.param = nil
    self.selectIndex = 1
    self.items = {}
end

local function DataDestroy(self)
    self.param = nil
    self.selectIndex = nil
    self.items = nil
end

local function OnEnable(self)
    base.OnEnable(self)
    self:ReInit()
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function OnCellMoveIn(self, itemObj, index)
    itemObj.name = tostring(index)
    local item = self.scroll_view:AddComponent(UIChooseCarItem, itemObj)
    item:SetIndex(index)
    item:SetOnClick(function()
        self:OnItemClick(index)
    end)
    item:SetSelected(index == self.selectIndex)
    self.items[index] = item
end

local function OnCellMoveOut(self, itemObj, index)
    self.scroll_view:RemoveComponent(itemObj.name, UIChooseCarItem)
    self.items[index] = nil
end

local function ShowCells(self)
    self:ClearScroll()
    local count = FormationMaxNum
    if count > 0 then
        self.scroll_view:SetTotalCount(count)
        self.scroll_view:RefillCells()
    end
end

local function ClearScroll(self)
    self.scroll_view:ClearCells()
    self.scroll_view:RemoveComponents(UIChooseCarItem)
end

local function ReInit(self)
    self.param = self:GetUserData()
    self.title_text:SetText(self.param.titleText)
    self.name_text:SetText(self.param.nameText)
    self.desc_text:SetText(self.param.descText)
    self.select_text:SetText(self.param.btnText)
    self.info_btn:SetActive(self.param.infoText ~= nil)
    self:ShowCells()
    self:RefreshSelectBtn()
    
    local itemParam = {}
    itemParam.rewardType = RewardType.GOODS
    itemParam.itemId = tonumber(self.param.itemId)
    self.item:ReInit(itemParam)
end

local function RefreshSelectBtn(self)
    local gray = (self.param.condition ~= nil and not self.param.condition(self.selectIndex))
    UIGray.SetGray(self.select_btn.transform, gray, true)
end

local function OnItemClick(self, index)
    self.selectIndex = index
    for i, item in pairs(self.items) do
        item:SetSelected(i == self.selectIndex)
    end
    self:RefreshSelectBtn()
end

local function OnInfoClick(self)
    local param = UIHeroTipView.Param.New()
    param.content = self.param.infoText
    param.dir = UIHeroTipView.Direction.RIGHT
    param.defWidth = 350
    param.pivot = 0.5
    param.position = self.info_btn.transform.position + Vector3.New(35, 0, 0)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, { anim = false }, param)
end

local function OnSelectClick(self)
    if self.param.condition ~= nil and not self.param.condition(self.selectIndex) then
        if self.param.conditionTipText then
            UIUtil.ShowTips(self.param.conditionTipText)
        end
        return
    end
    if self.selectIndex ~= nil and self.param.callback ~= nil then
        self.param.callback(self.selectIndex)
        self.ctrl:CloseSelf()
    end
end

UIChooseCarView.OnCreate = OnCreate
UIChooseCarView.OnDestroy = OnDestroy
UIChooseCarView.ComponentDefine = ComponentDefine
UIChooseCarView.ComponentDestroy = ComponentDestroy
UIChooseCarView.DataDefine = DataDefine
UIChooseCarView.DataDestroy = DataDestroy
UIChooseCarView.OnEnable = OnEnable
UIChooseCarView.OnDisable = OnDisable

UIChooseCarView.OnCellMoveIn = OnCellMoveIn
UIChooseCarView.OnCellMoveOut = OnCellMoveOut
UIChooseCarView.ShowCells = ShowCells
UIChooseCarView.ClearScroll = ClearScroll

UIChooseCarView.ReInit = ReInit
UIChooseCarView.RefreshSelectBtn = RefreshSelectBtn
UIChooseCarView.OnItemClick = OnItemClick
UIChooseCarView.OnInfoClick = OnInfoClick
UIChooseCarView.OnSelectClick = OnSelectClick

return UIChooseCarView