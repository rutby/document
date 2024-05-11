--[[
    钻石购买界面
--]]
local GainDiamondCell = require "UI.UIGiftPackage.Component.GainDiamondCell"

local UIGainDiamonds = BaseClass("UIGainDiamonds", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

local scroll_view_path = "DiamondList"
local tip_des_path = "TipBg/TipDes"
local tip_double_path = "TipBg/TipDouble"

-- 创建
local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
end

-- 销毁
local function OnDestroy(self)
    self:ClearScroll()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

-- 显示
local function OnEnable(self)
    base.OnEnable(self)
end

-- 隐藏
local function OnDisable(self)
    self:ClearScroll()
    base.OnDisable(self)
end

local function OnAddListener(self)
    base.OnAddListener(self)
    self:AddUIListener(EventId.GOLDEXCHANGE_LIST_CHANGE, self.ShowAllCells)
end


local function OnRemoveListener(self)
    base.OnRemoveListener(self)
    self:RemoveUIListener(EventId.GOLDEXCHANGE_LIST_CHANGE, self.ShowAllCells)
end

--控件的定义
local function ComponentDefine(self)
    self.tip_des = self:AddComponent(UIText, tip_des_path)
    self.tip_double = self:AddComponent(UIText, tip_double_path)
    self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
    self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
        self:OnCreateCell(itemObj, index)
    end)
    self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
        self:OnDeleteCell(itemObj, index)
    end)
end

--控件的销毁
local function ComponentDestroy(self)
    self.tip_des = nil
    self.tip_double = nil
    self.scroll_view = nil
end

--变量的定义
local function DataDefine(self)
    self.dataList = {}
    self.iconNameList = {}
    self.tipDoubleText = nil
    self.tipDesText = nil
end

--变量的销毁
local function DataDestroy(self)
    self.dataList = nil
    self.iconNameList = nil
    self.tipDoubleText = nil
    self.tipDesText = nil
end

-- 全部刷新
local function ReInit(self)
    self:ShowAllCells()
    self:SetTipDesText(Localization:GetString("320000"))
    self:SetTipDoubleText(Localization:GetString("320103"))
end

local function SetDataList(self)
    self.dataList,self.iconNameList = self.view.ctrl:GetDiamondList()
end

local function ClearScroll(self)
    self.scroll_view:ClearCells()--清循环列表数据
    self.scroll_view:RemoveComponents(GainDiamondCell)--清循环列表gameObject
end


local function ShowAllCells(self)
    self:SetDataList()

    self:ClearScroll()
    self.scroll_view:SetTotalCount(#self.dataList)
    self.scroll_view:RefillCells()
end

local function OnCreateCell(self,itemObj, index)
    itemObj.name = tostring(index)
    local cellItem = self.scroll_view:AddComponent(GainDiamondCell, itemObj)
    cellItem:ReInit(self.dataList[index],tonumber(self.iconNameList[self.dataList[index].dollar]))
end


local function OnDeleteCell(self,itemObj, index)
    self.scroll_view:RemoveComponent(itemObj.name, GainDiamondCell)
end

local function SetTipDesText(self,value)
    if self.tipDesText ~= value then
        self.tipDesText = value
        self.tip_des:SetText(value)
    end
end

local function SetTipDoubleText(self,value)
    if self.tipDoubleText ~= value then
        self.tipDoubleText = value
        self.tip_double:SetText(value)
    end
end

UIGainDiamonds.OnCreate = OnCreate
UIGainDiamonds.OnDestroy = OnDestroy
UIGainDiamonds.OnCreateCell = OnCreateCell
UIGainDiamonds.OnDeleteCell = OnDeleteCell
UIGainDiamonds.OnDisable = OnDisable
UIGainDiamonds.ReInit = ReInit
UIGainDiamonds.ComponentDefine = ComponentDefine
UIGainDiamonds.DataDefine = DataDefine
UIGainDiamonds.ComponentDestroy = ComponentDestroy
UIGainDiamonds.DataDestroy = DataDestroy
UIGainDiamonds.OnEnable = OnEnable
UIGainDiamonds.OnAddListener = OnAddListener
UIGainDiamonds.OnRemoveListener = OnRemoveListener

UIGainDiamonds.SetDataList = SetDataList
UIGainDiamonds.ClearScroll = ClearScroll
UIGainDiamonds.ShowAllCells = ShowAllCells
UIGainDiamonds.SetTipDesText = SetTipDesText
UIGainDiamonds.SetTipDoubleText = SetTipDoubleText

return UIGainDiamonds