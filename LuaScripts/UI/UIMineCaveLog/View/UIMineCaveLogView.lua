---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2021/9/15 16:38
---

local base = UIBaseView--Variable
local UIMineCaveLogView = BaseClass("UIMineCaveLogView", base)--Variable
local Localization = CS.GameEntry.Localization
local MineCaveLogNewItem = require "UI.UIMineCaveLog.Component.MineCaveLogNewItem"

local panel_path ="UICommonPopUpTitle/panel"
local title_path = "UICommonPopUpTitle/bg_mid/titleText"
local closeBtn_path = "UICommonPopUpTitle/bg_mid/CloseBtn"
local svLogs_path = "ImgBg/ScrollView"
local emptyTip_path = "ImgBg/TxtEmpty"
local content_path = "ImgBg/ScrollView/Viewport/Content"

local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
    self:RefreshAll()
    DataCenter.MineCaveManager:ResetGetPlunderLogTime()
end

local function OnDestroy(self)
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

local function ComponentDefine(self)
    self.titleN = self:AddComponent(UITextMeshProUGUIEx, title_path)
    self.titleN:SetLocalText(390264)
    self.panel = self:AddComponent(UIButton,panel_path)
    self.panel:SetOnClick(function()
        self:OnClickCloseBtn()
    end)
    self.closeBtnN = self:AddComponent(UIButton, closeBtn_path)
    self.closeBtnN:SetOnClick(function()
        self:OnClickCloseBtn()
    end)
    self.svLogsN = self:AddComponent(UIScrollView, svLogs_path)
    self.svLogsN:SetOnItemMoveIn(function(itemObj, index)
        self:OnItemMoveIn(itemObj, index)
    end)
    self.svLogsN:SetOnItemMoveOut(function(itemObj, index)
        self:OnItemMoveOut(itemObj, index)
    end)
    self.emptyTipN = self:AddComponent(UITextMeshProUGUIEx, emptyTip_path)
    self.emptyTipN:SetLocalText(302233)
    self.contentN = self:AddComponent(UIBaseContainer, content_path)
end

local function ComponentDestroy(self)
    self.titleN = nil
    self.closeBtnN = nil
    self.svLogsN = nil
    self.emptyTipN = nil
end

local function DataDefine(self)
    self.plunderLogList = {}
    self.logItemsDic = {}
    self.curDetailIndex = nil--当前显示详细信息的条目
end

local function DataDestroy(self)
    self.plunderLogList = nil
    self.logItemsDic = nil
    self.curDetailIndex = nil
end

--  [[
local function OnAddListener(self)
    base.OnAddListener(self)
    --self:AddUIListener(EventId.OnRecvMineCavePlunderLog, self.RefreshAll)
end

local function OnRemoveListener(self)
    --self:RemoveUIListener(EventId.OnRecvMineCavePlunderLog, self.RefreshAll)
    base.OnRemoveListener(self)
end
--]]


local function RefreshAll(self)
    self.plunderLogList = DataCenter.MineCaveManager:GetPlunderList()
    if not self.plunderLogList or #self.plunderLogList == 0 then
        self.emptyTipN:SetActive(true)
        self.svLogsN:SetActive(false)
    else
        self.emptyTipN:SetActive(false)
        self.svLogsN:SetActive(true)
        self.svLogsN:SetTotalCount(#self.plunderLogList)
        self.svLogsN:RefillCells()
        TimerManager:GetInstance():DelayInvoke(function()
            CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.contentN.rectTransform)
        end, 0.4)
    end
end

local function OnItemMoveIn(self, itemObj, index)
    itemObj.name = tostring(index)
    local cellItem = self.svLogsN:AddComponent(MineCaveLogNewItem, itemObj)
    local logInfo = self.plunderLogList[index]
    local param = {}
    param.callback = function(targetIndex)
        self:JumpToIndex(targetIndex)
    end
    param.index = index
    param.isShowDetail = index == self.curDetailIndex
    cellItem:SetItem(logInfo, param)
    self.logItemsDic[index] = cellItem
end

local function JumpToIndex(self, targetIndex)
    if self.curDetailIndex and self.logItemsDic[self.curDetailIndex] then
        self.logItemsDic[self.curDetailIndex]:ShowDetailByExternal(false)
    end
    if not self.curDetailIndex or targetIndex ~= self.curDetailIndex then
        self.logItemsDic[targetIndex]:ShowDetailByExternal(true)
        self.svLogsN:ScrollToCell(targetIndex, 1000)
        self.curDetailIndex = targetIndex
    else
        self.curDetailIndex = nil
        TimerManager:GetInstance():DelayInvoke(function()
            self.svLogsN:StopMovement()
        end, 0.1)
    end
end

local function OnItemMoveOut(self, itemObj, index)
    self.logItemsDic[index] = nil
    self.svLogsN:RemoveComponent(itemObj.name, MineCaveLogNewItem)
end

local function ClearScroll(self)
    self.svLogsN:ClearCells()
    self.svLogsN:RemoveComponents(MineCaveLogNewItem)
end

local function OnClickCloseBtn(self)
    self.ctrl:CloseSelf()
end


UIMineCaveLogView.OnCreate = OnCreate 
UIMineCaveLogView.OnDestroy = OnDestroy
UIMineCaveLogView.OnAddListener = OnAddListener
UIMineCaveLogView.OnRemoveListener = OnRemoveListener
UIMineCaveLogView.ComponentDefine = ComponentDefine
UIMineCaveLogView.ComponentDestroy = ComponentDestroy
UIMineCaveLogView.DataDefine = DataDefine
UIMineCaveLogView.DataDestroy = DataDestroy

UIMineCaveLogView.RefreshAll = RefreshAll
UIMineCaveLogView.ClearScroll = ClearScroll
UIMineCaveLogView.OnItemMoveIn = OnItemMoveIn
UIMineCaveLogView.OnItemMoveOut = OnItemMoveOut
UIMineCaveLogView.OnClickCloseBtn = OnClickCloseBtn
UIMineCaveLogView.JumpToIndex = JumpToIndex

return UIMineCaveLogView