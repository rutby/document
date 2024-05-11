---
--- 设置推送通知界面
--- Created by shimin.
--- DateTime: 2020/9/22 11:28
---
local UISettingNoticeCell = require "UI.UISetting.UISettingNotice.Component.UISettingNoticeCell"
local UISettingNoticeView = BaseClass("UISettingNoticeView",UIBaseView)
local base = UIBaseView

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
    self.list = {}
end

local function DataDestroy(self)
    self.list = nil
end

local function OnEnable(self)
    base.OnEnable(self)
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function ReInit(self)
    self.txt_title:SetLocalText(310004) 
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
    self.list = self:GetShowList()
    local tempCount = table.count(self.list)
    if tempCount > 0 then
        self.scroll_view:SetTotalCount(tempCount)
        self.scroll_view:RefillCells()
    end
end

local function OnCellMoveIn(self,itemObj, index)
    local tempType = self.list[index]
    itemObj.name = tempType
    local cellItem = self.scroll_view:AddComponent(UISettingNoticeCell, itemObj)
    local param = UISettingNoticeCell.Param.New()
    param.noticeType = tempType
    cellItem:ReInit(param)
end


local function OnCellMoveOut(self,itemObj, index)
    self.scroll_view:RemoveComponent(itemObj.name, UISettingNoticeCell)
end

local function ClearScroll(self)
    self.scroll_view:ClearCells()--清循环列表数据
    self.scroll_view:RemoveComponents(UISettingNoticeCell)--清循环列表gameObject
end

local function GetShowList(self)
    local list = {}
    for k,v in ipairs(SettingNoticeTypeSort) do
        table.insert(list,v)
    end
    return list
end

UISettingNoticeView.OnCreate= OnCreate
UISettingNoticeView.OnDestroy = OnDestroy
UISettingNoticeView.OnEnable = OnEnable
UISettingNoticeView.OnDisable = OnDisable
UISettingNoticeView.OnAddListener = OnAddListener
UISettingNoticeView.OnRemoveListener = OnRemoveListener
UISettingNoticeView.ComponentDefine = ComponentDefine
UISettingNoticeView.ComponentDestroy = ComponentDestroy
UISettingNoticeView.DataDefine = DataDefine
UISettingNoticeView.DataDestroy = DataDestroy
UISettingNoticeView.ReInit = ReInit
UISettingNoticeView.SetAllCellsDestroy = SetAllCellsDestroy
UISettingNoticeView.ShowCells = ShowCells
UISettingNoticeView.OnCellMoveIn = OnCellMoveIn
UISettingNoticeView.OnCellMoveOut = OnCellMoveOut
UISettingNoticeView.ClearScroll = ClearScroll
UISettingNoticeView.GetShowList = GetShowList

return UISettingNoticeView