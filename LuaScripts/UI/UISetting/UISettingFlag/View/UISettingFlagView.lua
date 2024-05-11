---
--- 设置国旗界面
--- Created by shimin.
--- DateTime: 2020/9/25 19:01
---
local UISettingFlagCell = require "UI.UISetting.UISettingFlag.Component.UISettingFlagCell"
local UISettingFlagView = BaseClass("UISettingFlagView",UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

local txt_title_path ="ImgBg/TxtTitle"
local close_btn_path = "ImgBg/BtnClose"
local return_btn_path = "Panel"
local scroll_view_path = "ImgBg/ScrollView"

--创建
local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
    self:ReInit()
end

-- 销毁
local function OnDestroy(self)
    self:SetAllCellsDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

local function ComponentDefine(self)
    self.txt_title = self:AddComponent(UIText, txt_title_path)
    self.close_btn = self:AddComponent(UIButton, close_btn_path)
    self.return_btn = self:AddComponent(UIButton, return_btn_path)
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
end

local function DataDestroy(self)
end

local function OnEnable(self)
    base.OnEnable(self)
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function ReInit(self)
    self.txt_title:SetLocalText(390065) 
    self:ShowCells()
end

-- 表现销毁
local function SetAllCellsDestroy(self)
    self:ClearScroll()
end

local function OnAddListener(self)
    base.OnAddListener(self)
end

local function OnRemoveListener(self)
    base.OnRemoveListener(self)
end

local function ShowCells(self)
    self:ClearScroll()
    local tempCount = table.count(CountryCode)
    if tempCount > 0 then
        self.scroll_view:SetTotalCount(tempCount)
        self.scroll_view:RefillCells()
    end
end

local function OnCellMoveIn(self,itemObj, index)
    local tempType = CountryCode[index]
    itemObj.name = tempType
    local cellItem = self.scroll_view:AddComponent(UISettingFlagCell, itemObj)
    local param = UISettingFlagCell.Param.New()
    param.name = tempType
    cellItem:ReInit(param)
end


local function OnCellMoveOut(self,itemObj, index)
    self.scroll_view:RemoveComponent(itemObj.name, UISettingFlagCell)
end

local function ClearScroll(self)
    self.scroll_view:ClearCells()--清循环列表数据
    self.scroll_view:RemoveComponents(UISettingFlagCell)--清循环列表gameObject
end

UISettingFlagView.OnCreate= OnCreate
UISettingFlagView.OnDestroy = OnDestroy
UISettingFlagView.OnEnable = OnEnable
UISettingFlagView.OnDisable = OnDisable
UISettingFlagView.OnAddListener = OnAddListener
UISettingFlagView.OnRemoveListener = OnRemoveListener
UISettingFlagView.ComponentDefine = ComponentDefine
UISettingFlagView.ComponentDestroy = ComponentDestroy
UISettingFlagView.DataDefine = DataDefine
UISettingFlagView.DataDestroy = DataDestroy
UISettingFlagView.ReInit = ReInit
UISettingFlagView.SetAllCellsDestroy = SetAllCellsDestroy
UISettingFlagView.ShowCells = ShowCells
UISettingFlagView.OnCellMoveIn = OnCellMoveIn
UISettingFlagView.OnCellMoveOut = OnCellMoveOut
UISettingFlagView.ClearScroll = ClearScroll

return UISettingFlagView