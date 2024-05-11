---
--- 荣耀之战宣战记录
--- Created by shimin.
--- DateTime: 2023/3/2 17:33
---

local UIGloryAllianceDeclareRecordView = BaseClass("UIGloryAllianceDeclareRecordView", UIBaseView)
local base = UIBaseView
local UIGloryAllianceDeclareRecordCell = require "UI.UIGlory.UIGloryAllianceDeclareRecord.Component.UIGloryAllianceDeclareRecordCell"

local title_text_path = "UICommonPopUpTitle/bg_mid/titleText"
local return_btn_path = "UICommonPopUpTitle/panel"
local close_btn_path = "UICommonPopUpTitle/bg_mid/CloseBtn"
local toggle_path = "ToggleGroup/Toggle%s"
local scroll_view_path = "ScrollView"
local empty_text_path = "empty_text"

function UIGloryAllianceDeclareRecordView:OnCreate()
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
    self:ReInit()
end

function UIGloryAllianceDeclareRecordView:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIGloryAllianceDeclareRecordView:OnEnable()
    base.OnEnable(self)
end

function UIGloryAllianceDeclareRecordView:OnDisable()
    base.OnDisable(self)
end

function UIGloryAllianceDeclareRecordView:ComponentDefine()
    self.title_text = self:AddComponent(UIText, title_text_path)
    self.return_btn = self:AddComponent(UIButton, return_btn_path)
    self.return_btn:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)
    self.close_btn = self:AddComponent(UIButton, close_btn_path)
    self.close_btn:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)
    self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
    self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
        self:OnCellMoveIn(itemObj, index)
    end)
    self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
        self:OnCellMoveOut(itemObj, index)
    end)
    self.toggle = {}
    for k,v in pairs(DeclareRecordType) do
        local toggle = self:AddComponent(UIToggle, string.format(toggle_path, v))
        if toggle ~= nil then
            toggle:SetOnValueChanged(function(tf)
                if tf then
                    self:ToggleControlBorS(v)
                end
            end)
            toggle.showName = toggle:AddComponent(UIText, "Txt_ListToggle")
            self.toggle[v] = toggle
        end
    end
    self.empty_text = self:AddComponent(UIText, empty_text_path)
end

function UIGloryAllianceDeclareRecordView:ComponentDestroy()
  
end

function UIGloryAllianceDeclareRecordView:DataDefine()
    self.list = {}
    self.declareRecordType = DeclareRecordType.Alliance
    self.page = 0
end

function UIGloryAllianceDeclareRecordView:DataDestroy()
    self.list = {}
    self.declareRecordType = DeclareRecordType.Alliance
    self.page = 0
end

function UIGloryAllianceDeclareRecordView:OnAddListener()
    base.OnAddListener(self)
    self:AddUIListener(EventId.GloryGetMyHistory, self.GloryGetMyHistorySignal)
    self:AddUIListener(EventId.GloryGetHistory, self.GloryGetHistorySignal)
end

function UIGloryAllianceDeclareRecordView:OnRemoveListener()
    self:RemoveUIListener(EventId.GloryGetMyHistory, self.GloryGetMyHistorySignal)
    self:RemoveUIListener(EventId.GloryGetHistory, self.GloryGetHistorySignal)
    base.OnRemoveListener(self)
end

function UIGloryAllianceDeclareRecordView:ReInit()
    self.title_text:SetLocalText(GameDialogDefine.DECLARE_RECORD)
    self.empty_text:SetLocalText(GameDialogDefine.RANK_EMPTY_DES)
    for k,v in pairs(self.toggle) do
        if k == DeclareRecordType.Alliance then
            v.showName:SetLocalText(GameDialogDefine.ALLIANCE_RECORD)
        elseif k == DeclareRecordType.ServerZone then
            v.showName:SetLocalText(GameDialogDefine.SERVER_ZONE_RECORD)
        end
        self:SetToggleTabSelect(k, false)
    end
    self.declareRecordType = DeclareRecordType.Alliance
    if self.toggle[self.declareRecordType] ~= nil then
        self.toggle[self.declareRecordType]:SetIsOn(true)
    end
    self:SetToggleTabSelect(self.declareRecordType, true)
    self:ToggleControlBorS(DeclareRecordType.Alliance)
end

function UIGloryAllianceDeclareRecordView:ShowCells()
    self:ClearScroll()
    self:GetDataList()
    local count = table.count(self.list)
    if count > 0 then
        self.empty_text:SetActive(false)
        self.scroll_view:SetTotalCount(count)
        self.scroll_view:RefillCells()
    else
        self.empty_text:SetActive(true)
    end
end

function UIGloryAllianceDeclareRecordView:ClearScroll()
    self.scroll_view:ClearCells()--清循环列表数据
    self.scroll_view:RemoveComponents(UIGloryAllianceDeclareRecordCell)--清循环列表gameObject
end

function UIGloryAllianceDeclareRecordView:OnCellMoveIn(itemObj, index)
    itemObj.name = tostring(index)
    local item = self.scroll_view:AddComponent(UIGloryAllianceDeclareRecordCell, itemObj)
    item:ReInit(self.list[index], self.declareRecordType)
    if self.declareRecordType == DeclareRecordType.ServerZone and index == #self.list then
        DataCenter.GloryManager:SendGetHistory(self.page + 1)
    end
end

function UIGloryAllianceDeclareRecordView:OnCellMoveOut(itemObj, index)
    self.scroll_view:RemoveComponent(itemObj.name, UIGloryAllianceDeclareRecordCell)
end

function UIGloryAllianceDeclareRecordView:GetDataList()
    self.list = {}
    if self.declareRecordType == DeclareRecordType.ServerZone then
        self.list = DataCenter.GloryManager:GetHistoryList()
    else
        self.list = DataCenter.GloryManager:GetMyHistoryList()
    end
end

function UIGloryAllianceDeclareRecordView:GloryGetMyHistorySignal()
    if self.declareRecordType == DeclareRecordType.Alliance then
        self:ShowCells()
    end
end

function UIGloryAllianceDeclareRecordView:GloryGetHistorySignal()
    if self.declareRecordType == DeclareRecordType.ServerZone then
        self.page = self.page + 1
        self:ShowCells()
    end
end

function UIGloryAllianceDeclareRecordView:ToggleControlBorS(declareRecordType)
    if self.declareRecordType ~= declareRecordType then
        self:SetToggleTabSelect(self.declareRecordType, false)
    end
    self.declareRecordType = declareRecordType
    self:SetToggleTabSelect(self.declareRecordType, true)
    if self.declareRecordType == DeclareRecordType.Alliance then
        DataCenter.GloryManager:SendGetMyHistory()
    elseif self.declareRecordType == DeclareRecordType.ServerZone then
        self.page = 0
        DataCenter.GloryManager:SendGetHistory(self.page + 1)
    end
    self:ShowCells()
end

function UIGloryAllianceDeclareRecordView:SetToggleTabSelect(tabType, isSelect)
    if self.toggle[tabType] ~= nil then
        local nameText =  self.toggle[tabType].showName
        if nameText ~= nil then
            if isSelect then
                nameText:SetColor(TabSelectColor)
                nameTextShadow:AllEnable(true)
                nameTextShadow:SetAllColor(TabSelectShadow)
                nameText:SetAnchoredPosition(TabSelectHeightVec)
            else
                nameText:SetColor(TabUnSelectColor)
                nameTextShadow:AllEnable(false)
                nameText:SetAnchoredPosition(TabUnSelectHeightVec)
            end
        end
    end
end


return UIGloryAllianceDeclareRecordView