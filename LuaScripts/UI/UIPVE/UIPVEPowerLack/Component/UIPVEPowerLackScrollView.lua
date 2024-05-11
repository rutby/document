---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2022/11/10 12:00
---

local UIPVEPowerLackScrollView = BaseClass("UIPVEPowerLackScrollView", UIBaseContainer)
local base = UIBaseContainer
local UIPVEPowerLackItem = require "UI.UIPVE.UIPVEPowerLack.Component.UIPVEPowerLackItem"

local scroll_view_path = ""
local content_path = "Viewport/Content"

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

local function ComponentDefine(self)
    self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
    self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
        self:OnCreateItem(itemObj, index)
    end)
    self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
        self:OnDeleteItem(itemObj, index)
    end)
    self.content_go = self:AddComponent(UIBaseContainer, content_path)
end

local function ComponentDestroy(self)
    self.scroll_view = nil
    self.content_go = nil
end

local function DataDefine(self)
    self.lackType = PvePowerLackType.None
    self.tips = {}
    self.heroUuidList = {}
    self.dataList = {}
    self.itemDict = {}
end

local function DataDestroy(self)
    self.lackType = nil
    self.tips = nil
    self.heroUuidList = nil
    self.dataList = nil
    self.itemDict = nil
end

local function OnEnable(self)
    base.OnEnable(self)
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function OnAddListener(self)
    base.OnAddListener(self)
end

local function OnRemoveListener(self)
    base.OnRemoveListener(self)
end

local function OnCreateItem(self, itemObj, index)
    local data = self.dataList[index]
    itemObj.name = tostring(data.tip)
    local item = self.scroll_view:AddComponent(UIPVEPowerLackItem, itemObj)
    item:SetData(data)
    self.itemDict[index] = item
end

local function OnDeleteItem(self, itemObj, index)
    self.scroll_view:RemoveComponent(itemObj.name, UIPVEPowerLackItem)
    self.itemDict[index] = nil
end

local function ShowScroll(self)
    self.scroll_view:SetTotalCount(#self.dataList)
    if #self.dataList > 0 then
        self.scroll_view:RefillCells()
        self.scroll_view.unity_scroll_view.m_ContentConstraintCount = 4
        self.scroll_view.gameObject:SetActive(true)
        self.scroll_view:ScrollToCell(1, 1000)
    end
end

local function ClearScroll(self)
    self.scroll_view:ClearItems()
    self.scroll_view:RemoveComponents(UIPVEPowerLackItem)
end

local function RefreshView(self)
    -- 倍增门走这里
    local tips = PvePowerLackShowTips[PvePowerLackType.Fail]
    local heroUuids = DataCenter.LWBattleManager.logic:GetHeroUuids()
    self:SetData(PvePowerLackType.Fail, tips, false, nil, heroUuids)
end

local function SetData(self, lackType, tips, showBg, closeFunc, heroUuids)
    self.lackType = lackType
    self.tips = tips
    self.showBg = showBg
    self.closeFunc = closeFunc
    self.heroUuidList = {}
    
    if heroUuids then
        self.heroUuidList = heroUuids
    else
        local heroDataBackup = PveActorMgr:GetInstance():GetHeroDataBackup() or {}
        for heroUuid, _ in pairs(heroDataBackup) do
            table.insert(self.heroUuidList, heroUuid)
        end
    end
    
    self.dataList = self:GetDataList()
    self:ShowScroll()
end

local function GetItemClickFunc(self, data)
    local param = {}
    param.lackType = data.lackType
    param.tip = data.tip
    param.template = data.template
    param.heroUuidList = self.heroUuidList
    param.closeFunc = self.closeFunc
    return PveUtil.GetPowerLackTipClickFunc(param)
end

local function GetDataList(self)
    local dataList = {}

    local function TryAddTip(tip)
        local templates = DataCenter.ResLackManager:GetTemplatesByTip(math.abs(tip))
        for _, template in ipairs(templates) do
            if template.type == 11 and template:CheckMainLevel() then
                local data = {}
                data.lackType = self.lackType
                data.tip = tip
                data.template = template
                data.showBg = self.showBg
                data.showBtn = tip ~= PvePowerLackTipType.HeroChange
                data.onClick = self:GetItemClickFunc(data)
                if data.onClick then
                    table.insert(dataList, data)
                end
                break
            end
        end
    end

    for _, tip in ipairs(self.tips) do
        TryAddTip(tip)
    end
    -- 无法提升时，前往主线
    if #dataList == 0 then
        TryAddTip(PvePowerLackTipType.MainQuest)
    end

    local levelId = DataCenter.BattleLevel.levelId or 0
    if #dataList > 0 then
        -- 根据 order 排序
        table.sort(dataList, function(a, b)
            local bestA = table.hasvalue(a.template.pveList, levelId)
            local bestB = table.hasvalue(b.template.pveList, levelId)
            if bestA and not bestB then
                return true
            elseif not bestA and bestB then
                return false
            else
                return a.template:GetOverallOrder() < b.template:GetOverallOrder()
            end
        end)
        -- 同 group 只显示一个
        local list = {}
        local groups = {}
        for _, data in ipairs(dataList) do
            if data.template.group == 0 or groups[data.template.group] == nil then
                groups[data.template.group] = true
                table.insert(list, data)
            end
        end
        dataList = list
        -- 推荐第一个
        dataList[1].recommended = true
    end

    return dataList
end

local function HasTip(self, tips)
    for k, v in ipairs(self.dataList) do
        if v.tip == tips then
            return true
        end
    end
    return false
end

local function FadeIn(self)
    
end

UIPVEPowerLackScrollView.OnCreate = OnCreate
UIPVEPowerLackScrollView.OnDestroy = OnDestroy
UIPVEPowerLackScrollView.ComponentDefine = ComponentDefine
UIPVEPowerLackScrollView.ComponentDestroy = ComponentDestroy
UIPVEPowerLackScrollView.DataDefine = DataDefine
UIPVEPowerLackScrollView.DataDestroy = DataDestroy
UIPVEPowerLackScrollView.OnEnable = OnEnable
UIPVEPowerLackScrollView.OnDisable = OnDisable
UIPVEPowerLackScrollView.OnAddListener = OnAddListener
UIPVEPowerLackScrollView.OnRemoveListener = OnRemoveListener

UIPVEPowerLackScrollView.OnCreateItem = OnCreateItem
UIPVEPowerLackScrollView.OnDeleteItem = OnDeleteItem
UIPVEPowerLackScrollView.ShowScroll = ShowScroll
UIPVEPowerLackScrollView.ClearScroll = ClearScroll

UIPVEPowerLackScrollView.RefreshView = RefreshView
UIPVEPowerLackScrollView.SetData = SetData
UIPVEPowerLackScrollView.GetItemClickFunc = GetItemClickFunc
UIPVEPowerLackScrollView.GetDataList = GetDataList
UIPVEPowerLackScrollView.HasTip = HasTip
UIPVEPowerLackScrollView.FadeIn = FadeIn

return UIPVEPowerLackScrollView