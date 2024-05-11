---
--- 邮件屏蔽界面
--- Created by shimin.
--- DateTime: 2020/9/27 18:01
---
local UISettingBlockCell = require "UI.UISetting.UISettingBlock.Component.UISettingBlockCell"
local UISettingBlockView = BaseClass("UISettingBlockView",UIBaseView)
local base = UIBaseView

local txt_title_path ="UICommonMidPopUpTitle/bg_mid/titleText"
local close_btn_path = "UICommonMidPopUpTitle/bg_mid/CloseBtn"
local goback_btn_path = "UICommonMidPopUpTitle/Btn_GoBack"
local return_btn_path = "UICommonMidPopUpTitle/panel"
local layout_path = "layout"
local scroll_view_path = "layout/ScrollView"
local des_txt_path = "layout/desText"


--创建
local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
end

-- 销毁
local function OnDestroy(self)
    self:SetAllCellsDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

local function ComponentDefine(self)
    self.txt_title = self:AddComponent(UITextMeshProUGUIEx, txt_title_path)
    self.txt_title:SetLocalText(280013)
    self.close_btn = self:AddComponent(UIButton, close_btn_path)
    self.goback_btn = self:AddComponent(UIButton, goback_btn_path)
    self.return_btn = self:AddComponent(UIButton, return_btn_path)
    self.des_txt = self:AddComponent(UITextMeshProUGUIEx, des_txt_path)
    self.layout = self:AddComponent(UIBaseContainer, layout_path)
    self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
    self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
        self:OnCellMoveIn(itemObj, index)
    end)
    self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
        self:OnCellMoveOut(itemObj, index)
    end)

    self.close_btn:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)
    self.goback_btn:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)
    self.return_btn:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)
end

local function ComponentDestroy(self)
    self.txt_title = nil
    self.close_btn = nil
    self.return_btn = nil
    self.scroll_view = nil
end


local function DataDefine(self)
    self.list = {}
    ChatManager2:GetInstance().Net:SendSFSMessage(ChatMsgDefines.GetChatBlockList)
end

local function DataDestroy(self)
    self.list = nil
    self.cells = nil
    self.selectIndex = nil
    self.dragTime = nil
    self.maxNum = nil
    self.maxStr = nil
end

local function OnEnable(self)
    base.OnEnable(self)
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function OnAddListener(self)
    base.OnAddListener(self)
    self:AddUIListener(EventId.OnGetBlockList, self.ShowCells)
end

local function OnRemoveListener(self)
    base.OnRemoveListener(self)
    self:RemoveUIListener(EventId.OnGetBlockList, self.ShowCells)
end

-- 表现销毁
local function SetAllCellsDestroy(self)
    self:ClearScroll()
end

local function ShowCells(self)
    self:ClearScroll()
	local restrict = ChatManager2:GetInstance().Restrict
	local list = restrict:GetShieldInfoList()
	self.list = list
    local tempCount = #list
    if tempCount > 0 then
        self.scroll_view:SetTotalCount(tempCount)
        self.scroll_view:RefillCells()
        self.des_txt:SetText("")
    else
        self.des_txt:SetLocalText(290048)
    end
end

local function OnCellMoveIn(self,itemObj, index)
    itemObj.name = NameCount
    NameCount = NameCount + 1
    local cellItem = self.scroll_view:AddComponent(UISettingBlockCell, itemObj)
    cellItem:ReInit(self.list[index])
    cellItem:SetActive(true)
end


local function OnCellMoveOut(self,itemObj, index)
    self.scroll_view:RemoveComponent(itemObj.name, UISettingBlockCell)
end

local function ClearScroll(self)
    self.scroll_view:ClearCells()--清循环列表数据
    self.scroll_view:RemoveComponents(UISettingBlockCell)--清循环列表gameObject
end


UISettingBlockView.OnCreate= OnCreate
UISettingBlockView.OnDestroy = OnDestroy
UISettingBlockView.OnEnable = OnEnable
UISettingBlockView.OnDisable = OnDisable
UISettingBlockView.OnAddListener = OnAddListener
UISettingBlockView.OnRemoveListener = OnRemoveListener
UISettingBlockView.ComponentDefine = ComponentDefine
UISettingBlockView.ComponentDestroy = ComponentDestroy
UISettingBlockView.DataDefine = DataDefine
UISettingBlockView.DataDestroy = DataDestroy
UISettingBlockView.SetAllCellsDestroy = SetAllCellsDestroy
UISettingBlockView.ShowCells = ShowCells
UISettingBlockView.OnCellMoveIn = OnCellMoveIn
UISettingBlockView.OnCellMoveOut = OnCellMoveOut
UISettingBlockView.ClearScroll = ClearScroll

return UISettingBlockView